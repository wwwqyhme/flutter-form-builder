import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'package:forme/src/field/raw_autocomplete_async.dart';

class FormeAsnycAutocompleteText<T extends Object> extends BaseValueField<
    T?,
    FormeAsyncAutocompleteTextModel<T>,
    FormeAsyncAutocompleteTextController<T>> {
  FormeAsnycAutocompleteText({
    required String name,
    required AutocompleteAsyncOptionsBuilder<T> optionsBuilder,
    FormeAsyncAutocompleteTextModel<T>? model,
    T? initialValue,
    bool readOnly = false,
    Key? key,
    FormeDecoratorBuilder<T?>? decoratorBuilder,
    InputDecoration? decoration,
    int? maxLines = 1,
    FormeValueFieldListener<T, FormeAsyncAutocompleteTextController<T>>?
        listener,
    int? order,
    bool quietlyValidate = false,
  }) : super(
          quietlyValidate: quietlyValidate,
          order: order,
          listener: listener,
          decoratorBuilder: decoratorBuilder,
          key: key,
          readOnly: readOnly,
          name: name,
          initialValue: initialValue,
          model: (model ?? FormeAsyncAutocompleteTextModel())
              .copyWith(FormeAsyncAutocompleteTextModel(
            optionsBuilder: optionsBuilder,
            textFieldModel: FormeTextFieldModel(
              decoration: decoration,
              maxLines: maxLines,
            ),
          )),
          builder: (baseState) {
            _FormeAutocompleteTextState<T> state =
                baseState as _FormeAutocompleteTextState<T>;
            FormeAsyncAutocompleteTextModel<T> model =
                FormeAsyncAutocompleteTextModel<T>(
                        textFieldModel: FormeTextFieldModel(
                            decoration:
                                InputDecoration(errorText: state.errorText)))
                    .copyWith(state.model);
            return FormeRawAutocomplete<T>(
              model: model,
              readOnly: state.readOnly,
              removeOverlayNotifier: state.removeOverlayNotifier,
              textEditingController: state.textEditingController,
              focusNode: state.focusNode,
              initialValue: state.initialValue,
              onSelected: (v) {
                state.didChange(v);
                state.removeOverlayNotifier.value++;
              },
              isSelected: (v) => v == state.value,
            );
          },
        );

  @override
  _FormeAutocompleteTextState<T> createState() => _FormeAutocompleteTextState();
}

class _FormeAutocompleteTextState<T extends Object> extends BaseValueFieldState<
    T?,
    FormeAsyncAutocompleteTextModel<T>,
    FormeAsyncAutocompleteTextController<T>> {
  final TextEditingController textEditingController = TextEditingController();
  final ValueNotifier<int> removeOverlayNotifier = ValueNotifier(0);

  @override
  FormeAsyncAutocompleteTextModel<T> beforeSetModel(
      FormeAsyncAutocompleteTextModel<T> old,
      FormeAsyncAutocompleteTextModel<T> current) {
    if (current.optionsBuilder == null)
      current = current.copyWith(FormeAsyncAutocompleteTextModel<T>(
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
  FormeAsyncAutocompleteTextController<T> createFormeFieldController() {
    return FormeAsyncAutocompleteTextController._(
        this, defaultFormeValueFieldController());
  }
}

class FormeAsyncAutocompleteTextController<T extends Object>
    extends FormeValueFieldControllerDelegate<T?,
        FormeAsyncAutocompleteTextModel<T>> {
  final _FormeAutocompleteTextState _state;
  final FormeValueFieldController<T?, FormeAsyncAutocompleteTextModel<T>>
      delegate;
  FormeAsyncAutocompleteTextController._(this._state, this.delegate);

  TextEditingController get textEditingController =>
      _state.textEditingController;
}

///
/// **the context provided by builders can not used to get `FormeValueFieldController` ,
/// when you want to access `FormeValueField Controller`,
/// you can use `formeKey.valueField(String name)`**
class FormeAsyncAutocompleteTextModel<T extends Object> extends FormeModel {
  final AutocompleteOptionToString<T>? displayStringForOption;
  final AutocompleteAsyncOptionsBuilder<T>? optionsBuilder;
  final FormeTextFieldModel? textFieldModel;
  final WidgetBuilder? loadingOptionBuilder;
  final WidgetBuilder? emptyOptionBuilder;
  final AutocompleteOptionsViewBuilder<T>? optionsViewBuilder;
  final double? optionsViewHeight;
  final Duration? loadOptionsTimerDuration;
  final AutocompleteOptionsViewDecoratorBuilder? optionsViewDecoratorBuilder;
  final bool? queryWhenEmpty;
  final Widget Function(BuildContext context, dynamic error)? errorBuilder;
  final Widget Function(BuildContext context, T option, bool isSelected)?
      optionBuilder;
  const FormeAsyncAutocompleteTextModel({
    this.optionsBuilder,
    this.displayStringForOption,
    this.textFieldModel,
    this.loadingOptionBuilder,
    this.emptyOptionBuilder,
    this.optionsViewBuilder,
    this.optionsViewHeight,
    this.loadOptionsTimerDuration,
    this.optionsViewDecoratorBuilder,
    this.queryWhenEmpty,
    this.errorBuilder,
    this.optionBuilder,
  });

  @override
  FormeAsyncAutocompleteTextModel<T> copyWith(FormeModel oldModel) {
    FormeAsyncAutocompleteTextModel<T> old =
        oldModel as FormeAsyncAutocompleteTextModel<T>;
    return FormeAsyncAutocompleteTextModel<T>(
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
      optionBuilder: optionBuilder ?? old.optionBuilder,
    );
  }
}
