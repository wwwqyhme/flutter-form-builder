import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

import 'raw_autocomplete_async.dart';

class FormeAsnycAutocompleteChip<T extends Object> extends BaseValueField<
    List<T>,
    FormeAsyncAutocompleteChipModel<T>,
    FormeAsyncAutocompleteChipController<T>> {
  FormeAsnycAutocompleteChip({
    required String name,
    required AutocompleteAsyncOptionsBuilder<T> optionsBuilder,
    FormeAsyncAutocompleteChipModel<T>? model,
    List<T>? initialValue,
    bool readOnly = false,
    Key? key,
    FormeDecoratorBuilder<List<T>>? decoratorBuilder,
    InputDecoration? decoration,
    FormeValueFieldListener<List<T>, FormeAsyncAutocompleteChipController<T>>?
        listener,
  }) : super(
          listener: listener,
          decoratorBuilder: decoratorBuilder,
          key: key,
          readOnly: readOnly,
          name: name,
          initialValue: initialValue ?? [],
          model: (model ?? FormeAsyncAutocompleteChipModel())
              .copyWith(FormeAsyncAutocompleteChipModel(
                  optionsBuilder: optionsBuilder,
                  textFieldModel: FormeTextFieldModel(
                    decoration: decoration,
                    maxLines: 1,
                  ))),
          builder: (baseState) {
            _FormeAutocompleteTextState<T> state =
                baseState as _FormeAutocompleteTextState<T>;
            FormeAsyncAutocompleteChipModel<T> model =
                FormeAsyncAutocompleteChipModel<T>(
                        textFieldModel: FormeTextFieldModel(
                            decoration:
                                InputDecoration(errorText: state.errorText)))
                    .copyWith(state.model);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormeRawAutocomplete<T>(
                  model: model,
                  readOnly: state.readOnly,
                  removeOverlayNotifier: state.removeOverlayNotifier,
                  textEditingController: state.textEditingController,
                  focusNode: state.focusNode,
                  multi: true,
                  onSelected: (value) {
                    List<T> values = List.of(state.value);
                    if (values.remove(value)) {
                      state.didChange(values);
                    } else {
                      if (state.model.max != null &&
                          values.length >= state.model.max!) {
                        state.model.exceedCallback?.call();
                        return;
                      }
                      state.didChange(values..add(value));
                    }
                  },
                  isSelected: (v) => state.value.contains(v),
                ),
                FormeRenderUtils.wrap(
                    state.model.wrapRenderData,
                    state.value
                        .map((e) => (state.model.chipBuilder ??
                                state.defaultChipBuilder)(state.context, e, () {
                              state.didChange(List.of(state.value)..remove(e));
                              state.unfocus();
                            }))
                        .toList()),
              ],
            );
          },
        );

  @override
  _FormeAutocompleteTextState<T> createState() => _FormeAutocompleteTextState();
}

class _FormeAutocompleteTextState<T extends Object> extends BaseValueFieldState<
    List<T>,
    FormeAsyncAutocompleteChipModel<T>,
    FormeAsyncAutocompleteChipController<T>> {
  final TextEditingController textEditingController = TextEditingController();
  final ValueNotifier<int> removeOverlayNotifier = ValueNotifier(0);
  Widget defaultChipBuilder(
      BuildContext context, T value, VoidCallback onDeleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InputChip(
        label: Text(model.displayStringForOption == null
            ? value.toString()
            : model.displayStringForOption!(value)),
        isEnabled: true,
        onDeleted: onDeleted,
      ),
    );
  }

  @override
  void afterUpdateModel(FormeAsyncAutocompleteChipModel<T> old,
      FormeAsyncAutocompleteChipModel<T> current) {
    if (current.max != null && current.max! < value.length) {
      List<T> items = List.of(value);
      setValue(items.sublist(0, current.max));
    }
  }

  @override
  FormeAsyncAutocompleteChipModel<T> beforeSetModel(
      FormeAsyncAutocompleteChipModel<T> old,
      FormeAsyncAutocompleteChipModel<T> current) {
    if (current.optionsBuilder == null)
      current = current.copyWith(FormeAsyncAutocompleteChipModel<T>(
          optionsBuilder: old.optionsBuilder));
    return current;
  }

  @override
  void dispose() {
    removeOverlayNotifier.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  FormeAsyncAutocompleteChipController<T> createFormeFieldController() {
    return FormeAsyncAutocompleteChipController._(
        this, defaultFormeValueFieldController());
  }
}

class FormeAsyncAutocompleteChipController<T extends Object>
    extends FormeValueFieldControllerDelegate<List<T>,
        FormeAsyncAutocompleteChipModel<T>> {
  final _FormeAutocompleteTextState _state;
  final FormeValueFieldController<List<T>, FormeAsyncAutocompleteChipModel<T>>
      delegate;
  FormeAsyncAutocompleteChipController._(this._state, this.delegate);

  TextEditingController get textEditingController =>
      _state.textEditingController;
}

class FormeAsyncAutocompleteChipModel<T extends Object>
    extends FormeAsyncAutocompleteTextModel<T> {
  final Widget Function(BuildContext context, T value, VoidCallback onDeleted)?
      chipBuilder;
  final FormeWrapRenderData? wrapRenderData;
  final int? max;
  final VoidCallback? exceedCallback;
  const FormeAsyncAutocompleteChipModel({
    AutocompleteOptionToString<T>? displayStringForOption,
    AutocompleteAsyncOptionsBuilder<T>? optionsBuilder,
    FormeTextFieldModel? textFieldModel,
    WidgetBuilder? loadingOptionBuilder,
    WidgetBuilder? emptyOptionBuilder,
    AutocompleteOptionsViewBuilder<T>? optionsViewBuilder,
    double? optionsViewHeight,
    Duration? loadOptionsTimerDuration,
    AutocompleteOptionsViewDecoratorBuilder? optionsViewDecoratorBuilder,
    bool? queryWhenEmpty,
    Widget Function(BuildContext context, dynamic error)? errorBuilder,
    Widget Function(BuildContext context, T option, bool isSelected)?
        optionBuilder,
    this.chipBuilder,
    this.wrapRenderData,
    this.max,
    this.exceedCallback,
  }) : super(
          displayStringForOption: displayStringForOption,
          optionsBuilder: optionsBuilder,
          optionsViewBuilder: optionsViewBuilder,
          optionsViewDecoratorBuilder: optionsViewDecoratorBuilder,
          optionsViewHeight: optionsViewHeight,
          loadOptionsTimerDuration: loadOptionsTimerDuration,
          emptyOptionBuilder: emptyOptionBuilder,
          loadingOptionBuilder: loadingOptionBuilder,
          errorBuilder: errorBuilder,
          textFieldModel: textFieldModel,
          queryWhenEmpty: queryWhenEmpty,
          optionBuilder: optionBuilder,
        );

  @override
  FormeAsyncAutocompleteChipModel<T> copyWith(FormeModel oldModel) {
    FormeAsyncAutocompleteChipModel<T> old =
        oldModel as FormeAsyncAutocompleteChipModel<T>;
    return FormeAsyncAutocompleteChipModel<T>(
      optionsBuilder: optionsBuilder ?? old.optionsBuilder,
      displayStringForOption:
          displayStringForOption ?? old.displayStringForOption,
      textFieldModel:
          FormeTextFieldModel.copy(old.textFieldModel, textFieldModel),
      loadingOptionBuilder: loadingOptionBuilder ?? old.loadingOptionBuilder,
      emptyOptionBuilder: emptyOptionBuilder ?? old.emptyOptionBuilder,
      optionsViewBuilder: optionsViewBuilder ?? old.optionsViewBuilder,
      optionsViewHeight: optionsViewHeight ?? old.optionsViewHeight,
      loadOptionsTimerDuration:
          loadOptionsTimerDuration ?? old.loadOptionsTimerDuration,
      optionsViewDecoratorBuilder:
          optionsViewDecoratorBuilder ?? old.optionsViewDecoratorBuilder,
      queryWhenEmpty: queryWhenEmpty ?? old.queryWhenEmpty,
      errorBuilder: errorBuilder ?? old.errorBuilder,
      chipBuilder: chipBuilder ?? old.chipBuilder,
      optionBuilder: optionBuilder ?? old.optionBuilder,
      wrapRenderData: wrapRenderData ?? old.wrapRenderData,
      exceedCallback: exceedCallback ?? old.exceedCallback,
      max: max ?? old.max,
    );
  }
}
