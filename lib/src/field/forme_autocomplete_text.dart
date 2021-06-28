import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'package:forme/src/widget/forme_mounted_value_notifier.dart';

class FormeAutocompleteText<T extends Object>
    extends ValueField<T, FormeAutocompleteTextModel<T>> {
  FormeAutocompleteText({
    required String name,
    required AutocompleteOptionsBuilder<T> optionsBuilder,
    InputDecoration? decoration,
    FormeAutocompleteTextModel<T>? model,
    FormeValueChanged<T, FormeAutocompleteTextModel<T>>? onValueChanged,
    FormFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    T? initialValue,
    FormFieldSetter<T>? onSaved,
    bool readOnly = false,
    FormeErrorChanged<
            FormeValueFieldController<T, FormeAutocompleteTextModel<T>>>?
        onErrorChanged,
    FormeFocusChanged<
            FormeValueFieldController<T, FormeAutocompleteTextModel<T>>>?
        onFocusChanged,
    FormeFieldInitialed<
            FormeValueFieldController<T, FormeAutocompleteTextModel<T>>>?
        onInitialed,
    Key? key,
    FormeDecoratorBuilder<T>? decoratorBuilder,
    int? maxLines = 1,
    Duration? asyncValidatorDebounce,
    FormeFieldValidator<T>? asyncValidator,
  }) : super(
          asyncValidator: asyncValidator,
          asyncValidatorDebounce: asyncValidatorDebounce,
          onInitialed: onInitialed,
          decoratorBuilder: decoratorBuilder,
          onFocusChanged: onFocusChanged,
          onErrorChanged: onErrorChanged,
          key: key,
          readOnly: readOnly,
          name: name,
          onValueChanged: onValueChanged,
          onSaved: onSaved,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue,
          validator: validator,
          model: (model ?? FormeAutocompleteTextModel())
              .copyWith(FormeAutocompleteTextModel(
                  optionsBuilder: optionsBuilder,
                  textFieldModel: FormeTextFieldModel(
                    decoration: decoration,
                    maxLines: maxLines,
                  ))),
          builder: (baseState) {
            _FormeAutocompleteTextState<T> state =
                baseState as _FormeAutocompleteTextState<T>;
            return Autocomplete<T>(
                optionsBuilder: readOnly
                    ? (v) => Iterable<T>.empty()
                    : state.model.optionsBuilder!,
                onSelected: readOnly
                    ? null
                    : (T value) {
                        state.didChange(value);
                        state.requestFocus();
                      },
                displayStringForOption: state.displayStringForOption,
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  state.textEditingController = textEditingController;
                  state.effecitiveFocusNode = focusNode;
                  return OrientationBuilder(builder: (context, o) {
                    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                      state.fieldViewWidgetNotifier.value =
                          (context.findRenderObject() as RenderBox).size.width;
                    });
                    return FormeTextFieldWidget(
                        textEditingController: textEditingController,
                        focusNode: focusNode,
                        errorText: state.errorText,
                        model: FormeTextFieldModel(
                          onSubmitted: state.readOnly
                              ? null
                              : (v) {
                                  onFieldSubmitted();
                                  if (state.model.textFieldModel?.onSubmitted !=
                                      null)
                                    state.model.textFieldModel!.onSubmitted!(v);
                                },
                          readOnly: state.readOnly,
                        ).copyWith(state.model.textFieldModel ??
                            FormeTextFieldModel()));
                  });
                },
                optionsViewBuilder: (
                  BuildContext context,
                  AutocompleteOnSelected<T> onSelected,
                  Iterable<T> options,
                ) {
                  return ValueListenableBuilder2<double?, int>(
                      state.fieldViewWidgetNotifier,
                      state.rebuildOptionsViewNotifier,
                      builder: (context, width, gen, _child) {
                    return (state.model.optionsViewBuilder ??
                            state.defaultOptionsViewBuilder)(
                        context, onSelected, options, width);
                  });
                });
          },
        );

  @override
  _FormeAutocompleteTextState<T> createState() => _FormeAutocompleteTextState();
}

class _FormeAutocompleteTextState<T extends Object>
    extends ValueFieldState<T, FormeAutocompleteTextModel<T>> {
  TextEditingController? textEditingController;
  FocusNode? _effecitiveFocusNode;

  bool focusWhenUnFocused = false;

  late final FormeMountedValueNotifier<double?> fieldViewWidgetNotifier =
      FormeMountedValueNotifier(null, this);
  late final FormeMountedValueNotifier<int> rebuildOptionsViewNotifier =
      FormeMountedValueNotifier(0, this);

  AutocompleteOptionToString<T> get displayStringForOption =>
      model.displayStringForOption ?? RawAutocomplete.defaultStringForOption;

  set effecitiveFocusNode(FocusNode focusNode) {
    if (_effecitiveFocusNode != focusNode) {
      _effecitiveFocusNode = focusNode;
      _effecitiveFocusNode!.addListener(() {
        if (!_effecitiveFocusNode!.hasFocus && focusWhenUnFocused) {
          focusWhenUnFocused = false;
          _effecitiveFocusNode!.requestFocus();
        }
        if (widget.onFocusChanged != null) {
          if (widget.onFocusChanged != null)
            widget.onFocusChanged!(controller, _effecitiveFocusNode!.hasFocus);
        }
      });
    }
  }

  Widget defaultOptionsViewBuilder(
    BuildContext context,
    AutocompleteOnSelected<T> onSelected,
    Iterable<T> options,
    double? width,
  ) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: SizedBox(
          height: model.optionsViewHeight ?? 200,
          width: width,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final T option = options.elementAt(index);
              return InkWell(
                onTap: () {
                  onSelected(option);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(displayStringForOption(option)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void requestFocus() {
    _effecitiveFocusNode?.requestFocus();
  }

  @override
  void unfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) {
    _effecitiveFocusNode?.unfocus(disposition: disposition);
  }

  @override
  void afterInitiation() {
    super.afterInitiation();
    if (initialValue != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        textEditingController?.text = displayStringForOption(initialValue!);
      });
    }
  }

  @override
  void didChange(T? newValue) {
    super.didChange(newValue);
    if (newValue == null && value == null) onValueChanged(null);
  }

  @override
  void onValueChanged(T? value) {
    String? text;
    if (value == null) {
      text = '';
    } else {
      text = displayStringForOption(value);
    }
    if (textEditingController?.text != text) {
      textEditingController?.text = text;
    }
  }

  @override
  void dispose() {
    fieldViewWidgetNotifier.dispose();
    rebuildOptionsViewNotifier.dispose();
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    textEditingController?.text = '';
  }

  void rebuildOptionsView() {
    rebuildOptionsViewNotifier.value = rebuildOptionsViewNotifier.value + 1;
  }

  @override
  FormeAutocompleteTextModel<T> beforeSetModel(
      FormeAutocompleteTextModel<T> old,
      FormeAutocompleteTextModel<T> current) {
    if (current.optionsBuilder == null)
      current = current.copyWith(
          FormeAutocompleteTextModel<T>(optionsBuilder: old.optionsBuilder));
    return current;
  }

  @override
  void afterUpdateModel(FormeAutocompleteTextModel<T> old,
      FormeAutocompleteTextModel<T> current) {
    if ((current.optionsViewHeight != old.optionsViewHeight &&
            current.optionsViewHeight != null) ||
        current.optionsViewBuilder != null ||
        current.displayStringForOption != null) {
      rebuildOptionsView();
    }
    if (current.displayStringForOption != null && value != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        String selectionString = current.displayStringForOption!(value!);
        textEditingController?.value = TextEditingValue(
          selection: TextSelection.collapsed(offset: selectionString.length),
          text: selectionString,
        );
      });
    }

    if (current.optionsBuilder != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        focusWhenUnFocused = true;
        unfocus();
      });
    }
  }
}

class FormeAutocompleteTextModel<T extends Object> extends FormeModel {
  final AutocompleteOptionToString<T>? displayStringForOption;
  final AutocompleteOptionsBuilder<T>? optionsBuilder;

  /// width param is width of widget which returned by fieldViewBuilder
  final Widget Function(
    BuildContext context,
    AutocompleteOnSelected<T> onSelected,
    Iterable<T> options,
    double? width,
  )? optionsViewBuilder;
  final FormeTextFieldModel? textFieldModel;
  final double? optionsViewHeight;
  FormeAutocompleteTextModel({
    this.optionsBuilder,
    this.displayStringForOption,
    this.optionsViewBuilder,
    this.textFieldModel,
    this.optionsViewHeight,
  });

  @override
  FormeAutocompleteTextModel<T> copyWith(FormeModel oldModel) {
    FormeAutocompleteTextModel<T> old =
        oldModel as FormeAutocompleteTextModel<T>;
    return FormeAutocompleteTextModel<T>(
      optionsBuilder: optionsBuilder ?? old.optionsBuilder,
      displayStringForOption:
          displayStringForOption ?? old.displayStringForOption,
      optionsViewBuilder: optionsViewBuilder ?? old.optionsViewBuilder,
      textFieldModel:
          FormeTextFieldModel.copy(old.textFieldModel, textFieldModel),
      optionsViewHeight: optionsViewHeight ?? old.optionsViewHeight,
    );
  }
}
