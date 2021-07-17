import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

class FormeChoiceChip<T extends Object>
    extends ValueField<T?, FormeChoiceChipModel<T>> {
  FormeChoiceChip({
    T? initialValue,
    required String name,
    bool readOnly = false,
    required List<FormeChipItem<T>>? items,
    FormeChoiceChipModel<T>? model,
    Key? key,
    FormeDecoratorBuilder<T?>? decoratorBuilder,
    InputDecoration? decoration,
    FormeValueFieldListener<T,
            FormeValueFieldController<T?, FormeChoiceChipModel<T>>>?
        listener,
    int? order,
  }) : super(
          order: order,
          listener: listener,
          key: key,
          decoratorBuilder: decoratorBuilder ??
              (decoration == null
                  ? null
                  : FormeInputDecoratorBuilder(decoration: decoration)),
          model: (model ?? FormeChoiceChipModel<T>())
              .copyWith(FormeChoiceChipModel<T>(
            items: items,
          )),
          readOnly: readOnly,
          name: name,
          initialValue: initialValue,
          builder: (state) {
            bool readOnly = state.readOnly;
            FormeChoiceChipModel<T> model = state.model;
            List<FormeChipItem<T>> items = model.items!;
            ChipThemeData chipThemeData =
                model.chipThemeData ?? ChipTheme.of(state.context);
            List<Widget> chips = [];
            for (FormeChipItem<T> item in items) {
              bool isReadOnly = readOnly || item.readOnly;
              ChoiceChip chip = ChoiceChip(
                selected: state.value == item.data,
                label: item.label,
                avatar: item.avatar,
                padding: item.padding,
                pressElevation: item.pressElevation,
                tooltip: item.tooltip ?? item.tooltip,
                materialTapTargetSize: item.materialTapTargetSize,
                avatarBorder: item.avatarBorder ?? const CircleBorder(),
                backgroundColor: item.backgroundColor,
                shadowColor: item.shadowColor,
                disabledColor: item.disabledColor,
                selectedColor: item.selectedColor,
                selectedShadowColor: item.selectedShadowColor,
                visualDensity: item.visualDensity,
                elevation: item.elevation,
                labelPadding: item.labelPadding,
                labelStyle: item.labelStyle,
                shape: item.shape,
                side: item.side,
                onSelected: isReadOnly
                    ? null
                    : (bool selected) {
                        if (state.value == item.data) {
                          state.didChange(null);
                        } else {
                          state.didChange(item.data);
                        }
                        state.requestFocus();
                      },
              );
              chips.add(Visibility(
                  child: Padding(
                    padding: item.padding,
                    child: chip,
                  ),
                  visible: item.visible));
            }

            Widget chipWidget =
                FormeRenderUtils.wrap(state.model.wrapRenderData, chips);
            return Focus(
              focusNode: state.focusNode,
              child: ChipTheme(
                data: chipThemeData,
                child: chipWidget,
              ),
            );
          },
        );

  @override
  _FormeChoiceChipState<T> createState() => _FormeChoiceChipState();
}

class _FormeChoiceChipState<T extends Object>
    extends ValueFieldState<T?, FormeChoiceChipModel<T>> {
  @override
  void afterUpdateModel(
      FormeChoiceChipModel<T> old, FormeChoiceChipModel<T> current) {
    if (value == null) return;
    if (current.items != null) {
      if (!current.items!.any((element) => element.data == value)) {
        setValue(null);
      }
    }
  }

  @override
  FormeChoiceChipModel<T> beforeSetModel(
      FormeChoiceChipModel<T> old, FormeChoiceChipModel<T> current) {
    if (current.items == null) {
      return current.copyWith(FormeChoiceChipModel(items: old.items));
    }
    return current;
  }
}

class FormeChoiceChipModel<T extends Object> extends FormeModel {
  final List<FormeChipItem<T>>? items;
  final ChipThemeData? chipThemeData;
  final FormeWrapRenderData? wrapRenderData;

  FormeChoiceChipModel({
    this.items,
    this.chipThemeData,
    this.wrapRenderData,
  });

  @override
  FormeChoiceChipModel<T> copyWith(FormeModel oldModel) {
    FormeChoiceChipModel<T> old = oldModel as FormeChoiceChipModel<T>;
    return FormeChoiceChipModel<T>(
      items: items ?? old.items,
      chipThemeData:
          FormeRenderUtils.copyChipThemeData(old.chipThemeData, chipThemeData),
      wrapRenderData:
          FormeWrapRenderData.copy(old.wrapRenderData, wrapRenderData),
    );
  }
}
