import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

class FormeRadioGroup<T extends Object>
    extends ValueField<T, FormeRadioGroupModel<T>> {
  FormeRadioGroup({
    FormeValueChanged<T, FormeRadioGroupModel<T>>? onValueChanged,
    FormFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    T? initialValue,
    FormFieldSetter<T>? onSaved,
    required String name,
    bool readOnly = false,
    required List<FormeListTileItem<T>>? items,
    FormeRadioGroupModel<T>? model,
    FormeErrorChanged<FormeValueFieldController<T, FormeRadioGroupModel<T>>>?
        onErrorChanged,
    FormeFocusChanged<FormeValueFieldController<T, FormeRadioGroupModel<T>>>?
        onFocusChanged,
    FormeFieldInitialed<FormeValueFieldController<T, FormeRadioGroupModel<T>>>?
        onInitialed,
    Key? key,
    FormeDecoratorBuilder<T>? decoratorBuilder,
    InputDecoration? decoration,
  }) : super(
            onInitialed: onInitialed,
            decoratorBuilder: decoratorBuilder ??
                (decoration == null
                    ? null
                    : FormeInputDecoratorBuilder(decoration: decoration)),
            onFocusChanged: onFocusChanged,
            onErrorChanged: onErrorChanged,
            key: key,
            model: (model ?? FormeRadioGroupModel<T>())
                .copyWith(FormeRadioGroupModel(items: items)),
            readOnly: readOnly,
            name: name,
            onValueChanged: onValueChanged,
            onSaved: onSaved,
            autovalidateMode: autovalidateMode,
            initialValue: initialValue,
            validator: validator,
            builder: (state) {
              bool readOnly = state.readOnly;
              int split = state.model.split ?? 2;
              List<FormeListTileItem<T>> items = state.model.items ?? [];

              FormeListTileRenderData? listTileRenderData =
                  state.model.listTileRenderData;
              FormeRadioRenderData? radioRenderData =
                  state.model.radioRenderData;

              List<Widget> wrapWidgets = [];

              void changeValue(T value) {
                state.didChange(value);
                state.requestFocus();
              }

              Widget createFormeListTileItem(
                  FormeListTileItem<T> item, bool selected, bool readOnly) {
                return RadioListTile<T>(
                  shape: radioRenderData?.shape,
                  tileColor: radioRenderData?.tileColor,
                  selectedTileColor: radioRenderData?.selectedTileColor,
                  activeColor: radioRenderData?.activeColor,
                  secondary: item.secondary,
                  subtitle: item.subtitle,
                  groupValue: state.value,
                  controlAffinity: item.controlAffinity,
                  contentPadding: item.padding,
                  dense: item.dense,
                  title: item.title,
                  value: item.data,
                  onChanged: readOnly ? null : (v) => changeValue(item.data),
                );
              }

              Widget createCommonItem(
                  FormeListTileItem<T> item, bool selected, bool readOnly) {
                return FormeRenderUtils.radio<T>(
                    item.data,
                    state.value,
                    readOnly || item.readOnly
                        ? null
                        : (v) => changeValue(item.data),
                    radioRenderData);
              }

              for (int i = 0; i < items.length; i++) {
                FormeListTileItem<T> item = items[i];
                bool isReadOnly = readOnly || item.readOnly;
                bool selected = state.value == item.data;
                if (split > 0) {
                  double factor = 1 / split;
                  if (factor == 1) {
                    wrapWidgets.add(
                        createFormeListTileItem(item, selected, isReadOnly));
                    continue;
                  }
                }

                Widget tileItem = createCommonItem(item, selected, readOnly);

                final Widget title = split == 0
                    ? item.title
                    : Flexible(
                        child: item.title,
                      );

                List<Widget> children;
                switch (item.controlAffinity) {
                  case ListTileControlAffinity.leading:
                    children = [tileItem, title];
                    break;
                  default:
                    children = [title, tileItem];
                    break;
                }

                Row tileItemRow = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: children,
                );

                Widget groupItemWidget = Padding(
                  padding: item.padding,
                  child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      onTap: isReadOnly
                          ? null
                          : () {
                              changeValue(item.data);
                            },
                      child: tileItemRow),
                );

                bool visible = item.visible;
                if (split <= 0) {
                  wrapWidgets.add(Visibility(
                    child: groupItemWidget,
                    visible: visible,
                  ));
                  if (visible && i < items.length - 1)
                    wrapWidgets.add(SizedBox(
                      width: 8.0,
                    ));
                } else {
                  double factor = item.ignoreSplit ? 1 : 1 / split;
                  wrapWidgets.add(Visibility(
                    child: FractionallySizedBox(
                      widthFactor: factor,
                      child: groupItemWidget,
                    ),
                    visible: visible,
                  ));
                }
              }

              Widget child = FormeRenderUtils.wrap(
                  state.model.wrapRenderData, wrapWidgets);
              if (split == 1) {
                child = FormeRenderUtils.mergeListTileTheme(
                    child, listTileRenderData);
              }

              return Focus(
                focusNode: state.focusNode,
                child: child,
              );
            });

  @override
  _FormeRadioGroupState<T> createState() => _FormeRadioGroupState();
}

class _FormeRadioGroupState<T extends Object>
    extends ValueFieldState<T, FormeRadioGroupModel<T>> {
  @override
  void afterUpdateModel(
      FormeRadioGroupModel<T> old, FormeRadioGroupModel<T> current) {
    if (value == null) return;
    if (current.items != null &&
        !current.items!.any((element) => element.data == value)) {
      setValue(null);
    }
  }

  @override
  FormeRadioGroupModel<T> beforeSetModel(
      FormeRadioGroupModel<T> old, FormeRadioGroupModel<T> current) {
    if (current.items == null) {
      current = current.copyWith(FormeRadioGroupModel<T>(items: old.items));
    }
    return current;
  }
}

class FormeRadioGroupModel<T extends Object> extends FormeModel {
  final int? split;
  final List<FormeListTileItem<T>>? items;
  final FormeListTileRenderData? listTileRenderData;
  final FormeRadioRenderData? radioRenderData;
  final FormeWrapRenderData? wrapRenderData;

  FormeRadioGroupModel({
    this.split,
    this.items,
    this.listTileRenderData,
    this.radioRenderData,
    this.wrapRenderData,
  });
  FormeRadioGroupModel<T> copyWith(FormeModel oldModel) {
    FormeRadioGroupModel<T> old = oldModel as FormeRadioGroupModel<T>;
    return FormeRadioGroupModel<T>(
      split: split ?? old.split,
      items: items ?? old.items,
      listTileRenderData: FormeListTileRenderData.copy(
          old.listTileRenderData, listTileRenderData),
      radioRenderData:
          FormeRadioRenderData.copy(old.radioRenderData, radioRenderData),
      wrapRenderData:
          FormeWrapRenderData.copy(old.wrapRenderData, wrapRenderData),
    );
  }
}
