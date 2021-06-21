import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'package:forme/src/widget/forme_mounted_value_notifier.dart';
import 'package:forme/src/widget/widgets.dart';

import 'forme_autocomplete_async_text.dart';
import 'forme_text_field.dart';

typedef AutocompleteAsyncOptionsBuilder<T extends Object> = Future<Iterable<T>>
    Function(TextEditingValue textEditingValue);

typedef AutocompleteOptionsViewDecoratorBuilder = Widget Function(
    BuildContext context,
    Widget child,
    double? width,
    VoidCallback closeOptionsView);

class FormeRawAutocomplete<T extends Object> extends StatefulWidget {
  final FormeAsyncAutocompleteTextModel<T> model;
  final bool readOnly;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final bool multi;
  final T? initialValue;
  final ValueChanged<T> onSelected;
  final bool Function(T option) isSelected;
  final ValueNotifier<int> removeOverlayNotifier;

  FormeRawAutocomplete({
    Key? key,
    required this.model,
    required this.readOnly,
    required this.textEditingController,
    required this.focusNode,
    this.multi = false,
    this.initialValue,
    required this.onSelected,
    required this.isSelected,
    required this.removeOverlayNotifier,
  }) : super(key: key);

  @override
  _FormeRowAutoCompleteState<T> createState() => _FormeRowAutoCompleteState();
}

class _FormeRowAutoCompleteState<T extends Object>
    extends State<FormeRawAutocomplete<T>> {
  FormeAsyncAutocompleteTextModel<T> get model =>
      FormeAsyncAutocompleteTextModel<T>()
          .copyWith(widget.model)
          .copyWith(defaultModel);
  AutocompleteOptionToString<T> get displayStringForOption =>
      model.displayStringForOption ?? RawAutocomplete.defaultStringForOption;
  late final FormeMountedValueNotifier<int> optionsNotifier =
      FormeMountedValueNotifier(0, this);
  late final FormeMountedValueNotifier<double?> fieldViewWidgetNotifier =
      FormeMountedValueNotifier(null, this);
  final ValueNotifier<bool> optionsLoadingNotifier = ValueNotifier(false);
  final GlobalKey _fieldKey = GlobalKey();
  final LayerLink _optionsLayerLink = LayerLink();
  _Options<T>? options;
  Timer? timer;
  OverlayEntry? _floatingOptions;
  late String oldText;
  int gen = 0;
  T? _selection;

  bool get queryWhenEmpty => model.queryWhenEmpty ?? false;

  void loadOptions(int currentGen) {
    if (currentGen < gen) return;
    markLoading();
    model.optionsBuilder!(widget.textEditingController.value).then((value) {
      if (currentGen == gen) options = _Options(hasError: false, datas: value);
    }).catchError((e) {
      if (currentGen == gen) options = _Options(hasError: true, error: e);
    }).whenComplete(() {
      if (currentGen == gen && mounted) optionsLoadingNotifier.value = false;
    });
  }

  void markLoading() {
    if (optionsLoadingNotifier.value) {
      if (_floatingOptions == null) {
        updateOverlay();
      }
    } else {
      optionsLoadingNotifier.value = true;
    }
  }

  @override
  void initState() {
    super.initState();
    oldText = widget.textEditingController.text;
    if (!widget.readOnly) {
      widget.focusNode.addListener(onFocusChange);
      widget.textEditingController.addListener(onTextChange);
      optionsLoadingNotifier.addListener(onLoadingChange);
      widget.removeOverlayNotifier.addListener(removeOverlay);
    }

    if (widget.initialValue != null) selection = widget.initialValue!;
  }

  void onLoadingChange() {
    updateOverlay();
  }

  void onTextChange() {
    String text = widget.textEditingController.text;
    if (text == oldText) return;
    oldText = text;
    if (text == '' && !queryWhenEmpty) {
      removeOverlay();
    } else {
      markLoading();
      int gen = ++this.gen;
      timer?.cancel();
      timer = Timer(model.loadOptionsTimerDuration!, () => loadOptions(gen));
    }
  }

  void onFocusChange() {
    if (widget.focusNode.hasFocus) {
      if (!widget.multi) {
        String text = widget.textEditingController.text;
        if (text == oldText) return;
      }
      if (widget.textEditingController.text == '' && !queryWhenEmpty) {
        removeOverlay();
        return;
      }
      loadOptions(++gen);
    } else {
      removeOverlay();
    }
  }

  @override
  void didUpdateWidget(FormeRawAutocomplete<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool handleQueryWhenEmptyChange =
        oldWidget.model.queryWhenEmpty != widget.model.queryWhenEmpty &&
            widget.textEditingController.text == '';

    if (oldWidget.model != widget.model) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        if (widget.focusNode.hasFocus) {
          updateOptionsView();
          if (oldWidget.model.optionsBuilder != widget.model.optionsBuilder ||
              (handleQueryWhenEmptyChange && queryWhenEmpty)) {
            loadOptions(++gen);
          }
        }

        if (!widget.multi &&
            _selection != null &&
            model.displayStringForOption !=
                oldWidget.model.displayStringForOption &&
            widget.textEditingController.text ==
                (oldWidget.model.displayStringForOption ??
                    RawAutocomplete.defaultStringForOption)(_selection!)) {
          oldText = model.displayStringForOption!(_selection!);
          widget.textEditingController.value = TextEditingValue(
            selection: TextSelection.collapsed(offset: oldText.length),
            text: oldText,
          );
        }
      });
    }

    if (widget.readOnly) {
      widget.focusNode.removeListener(onFocusChange);
      widget.textEditingController.removeListener(onTextChange);
      optionsLoadingNotifier.removeListener(onLoadingChange);
      widget.removeOverlayNotifier.removeListener(removeOverlay);
    } else {
      widget.focusNode.addListener(onFocusChange);
      widget.textEditingController.addListener(onTextChange);
      optionsLoadingNotifier.addListener(onLoadingChange);
      widget.removeOverlayNotifier.addListener(removeOverlay);
    }

    if (widget.readOnly || (handleQueryWhenEmptyChange && !queryWhenEmpty)) {
      removeOverlay();
    }
  }

  void removeOverlay() {
    gen++;
    _floatingOptions?.remove();
    _floatingOptions = null;
  }

  void updateOptionsView() {
    optionsNotifier.value++;
  }

  set selection(T selection) {
    if (!widget.multi) {
      _selection = selection;
      oldText = model.displayStringForOption!(selection);
      widget.textEditingController.value = TextEditingValue(
        selection: TextSelection.collapsed(offset: oldText.length),
        text: oldText,
      );
      removeOverlay();
    }
  }

  void updateOverlay() {
    _floatingOptions?.remove();
    _floatingOptions = OverlayEntry(
      builder: (BuildContext context) {
        return CompositedTransformFollower(
          link: _optionsLayerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomLeft,
          child: ValueListenableBuilder2<double?, int>(
              fieldViewWidgetNotifier, optionsNotifier,
              builder: (context, width, gen, _child) {
            Widget child;
            if (optionsLoadingNotifier.value) {
              child = model.loadingOptionBuilder!(context);
            } else {
              if (options!.hasError)
                child = model.errorBuilder!(context, options!.error);
              else {
                Iterable<T> datas = options!.datas!;
                if (datas.isEmpty)
                  child = model.emptyOptionBuilder!(context);
                else {
                  child = model.optionsViewBuilder!(context, (v) {
                    widget.onSelected(v);
                    updateOptionsView();
                    selection = v;
                  }, datas);
                }
              }
            }
            return model.optionsViewDecoratorBuilder!(
                context, child, width, removeOverlay);
          }),
        );
      },
    );
    Overlay.of(context, rootOverlay: true)!.insert(_floatingOptions!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _fieldKey,
      child: CompositedTransformTarget(
        link: _optionsLayerLink,
        child: OrientationBuilder(builder: (context, o) {
          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            fieldViewWidgetNotifier.value =
                (context.findRenderObject() as RenderBox).size.width;
          });
          FormeTextFieldWidget textFieldWidget = FormeTextFieldWidget(
              textEditingController: widget.textEditingController,
              focusNode: widget.focusNode,
              model: FormeTextFieldModel(
                onChanged: (v) {
                  if (model.textFieldModel?.onChanged != null)
                    model.textFieldModel!.onChanged!(v);
                },
                onSubmitted: widget.readOnly
                    ? null
                    : (v) {
                        if (model.textFieldModel?.onSubmitted != null)
                          model.textFieldModel!.onSubmitted!(v);
                      },
                readOnly: widget.readOnly,
              ).copyWith(model.textFieldModel ?? FormeTextFieldModel()));
          return textFieldWidget;
        }),
      ),
    );
  }

  @override
  void dispose() {
    widget.removeOverlayNotifier.removeListener(removeOverlay);
    optionsNotifier.dispose();
    fieldViewWidgetNotifier.dispose();
    optionsLoadingNotifier.dispose();
    super.dispose();
  }

  late final FormeAsyncAutocompleteTextModel<T> defaultModel =
      FormeAsyncAutocompleteTextModel<T>(
          optionsViewHeight: 200,
          loadingOptionBuilder: (context) => Container(
                height: model.optionsViewHeight!,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
          displayStringForOption: RawAutocomplete.defaultStringForOption,
          loadOptionsTimerDuration: const Duration(milliseconds: 500),
          errorBuilder: (context, error) => const SizedBox(),
          emptyOptionBuilder: (context) => const SizedBox(),
          optionsViewBuilder: (context, onSelected, options) => SizedBox(
                height: model.optionsViewHeight!,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final T option = options.elementAt(index);
                    bool isSelected = widget.isSelected(option);
                    ThemeData themeData = Theme.of(context);
                    return InkWell(
                      onTap: () {
                        onSelected(option);
                      },
                      child: model.optionBuilder == null
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                displayStringForOption(option),
                                style: TextStyle(
                                    color: isSelected
                                        ? themeData.disabledColor
                                        : null),
                              ),
                            )
                          : model.optionBuilder!(context, option, isSelected),
                    );
                  },
                ),
              ),
          optionsViewDecoratorBuilder:
              (context, child, double? width, VoidCallback closeOptionsView) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: removeOverlay,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Icon(Icons.clear),
                          ),
                        ),
                      ),
                      child
                    ],
                  ),
                  width: width,
                ),
              ),
            );
          });
}

class _Options<T> {
  final Iterable<T>? datas;
  final dynamic error;
  final bool hasError;

  const _Options({
    this.datas,
    this.error,
    required this.hasError,
  });
}
