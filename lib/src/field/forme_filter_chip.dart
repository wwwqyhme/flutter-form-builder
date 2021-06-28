import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

class FormeChipItem<T extends Object> {
  final Widget label;
  final Widget? avatar;
  final T data;
  final EdgeInsets? labelPadding;
  final EdgeInsets padding;
  final bool readOnly;
  final bool visible;
  final String? tooltip;
  final TextStyle? labelStyle;
  final double? pressElevation;
  final Color? disabledColor;
  final Color? selectedColor;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final Color? backgroundColor;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? materialTapTargetSize;
  final double? elevation;
  final Color? shadowColor;
  final Color? selectedShadowColor;
  final bool? showCheckmark;
  final Color? checkmarkColor;
  final CircleBorder? avatarBorder;

  FormeChipItem({
    required this.label,
    this.avatar,
    required this.data,
    EdgeInsets? padding,
    this.readOnly = false,
    this.visible = true,
    this.labelPadding,
    this.tooltip,
    this.labelStyle,
    this.avatarBorder,
    this.backgroundColor,
    this.checkmarkColor,
    this.showCheckmark,
    this.shadowColor,
    this.disabledColor,
    this.selectedColor,
    this.selectedShadowColor,
    this.visualDensity,
    this.elevation,
    this.pressElevation,
    this.materialTapTargetSize,
    this.shape,
    this.side,
  }) : this.padding = padding ?? EdgeInsets.symmetric(horizontal: 10);
}

class FormeFilterChip<T extends Object>
    extends ValueField<List<T>, FormeFilterChipModel<T>> {
  FormeFilterChip({
    List<T>? initialValue,
    AutovalidateMode? autovalidateMode,
    FormFieldValidator<List<T>>? validator,
    FormeValueChanged<List<T>, FormeFilterChipModel<T>>? onValueChanged,
    FormFieldSetter<List<T>>? onSaved,
    required String name,
    bool readOnly = false,
    required List<FormeChipItem<T>>? items,
    FormeFilterChipModel<T>? model,
    FormeErrorChanged<
            FormeValueFieldController<List<T>, FormeFilterChipModel<T>>>?
        onErrorChanged,
    FormeFocusChanged<
            FormeValueFieldController<List<T>, FormeFilterChipModel<T>>>?
        onFocusChanged,
    FormeFieldInitialed<
            FormeValueFieldController<List<T>, FormeFilterChipModel<T>>>?
        onInitialed,
    Key? key,
    FormeDecoratorBuilder<List<T>>? decoratorBuilder,
    InputDecoration? decoration,
    Duration? asyncValidatorDebounce,
    FormeFieldValidator<List<T>>? asyncValidator,
  }) : super(
          asyncValidator: asyncValidator,
          asyncValidatorDebounce: asyncValidatorDebounce,
          onInitialed: onInitialed,
          nullValueReplacement: [],
          decoratorBuilder: decoratorBuilder ??
              (decoration == null
                  ? null
                  : FormeInputDecoratorBuilder(decoration: decoration)),
          key: key,
          onFocusChanged: onFocusChanged,
          model: (model ?? FormeFilterChipModel<T>())
              .copyWith(FormeFilterChipModel<T>(items: items)),
          readOnly: readOnly,
          name: name,
          validator: validator,
          onValueChanged: onValueChanged,
          onSaved: onSaved,
          autovalidateMode: autovalidateMode,
          initialValue: initialValue,
          onErrorChanged: onErrorChanged,
          builder: (state) {
            bool readOnly = state.readOnly;
            FormeFilterChipModel<T> model = state.model;
            List<FormeChipItem<T>> items = model.items!;
            int? count = model.count;
            ChipThemeData chipThemeData =
                model.chipThemeData ?? ChipTheme.of(state.context);

            List<Widget> chips = [];
            for (FormeChipItem<T> item in items) {
              bool isReadOnly = readOnly || item.readOnly;
              FilterChip chip = FilterChip(
                selected: state.value!.contains(item.data),
                label: item.label,
                avatar: item.avatar,
                padding: item.padding,
                pressElevation: item.pressElevation,
                tooltip: item.tooltip,
                materialTapTargetSize: item.materialTapTargetSize,
                avatarBorder: item.avatarBorder ?? const CircleBorder(),
                backgroundColor: item.backgroundColor,
                checkmarkColor: item.checkmarkColor,
                showCheckmark: item.showCheckmark,
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
                        List<T> value = List.of(state.value!);
                        if (selected) {
                          if (count != null && value.length >= count) {
                            if (state.model.exceedCallback != null) {
                              state.model.exceedCallback!();
                            }
                            return;
                          }
                          state.didChange(value..add(item.data));
                        } else {
                          state.didChange(value..remove(item.data));
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
                child: ChipTheme(
                  data: chipThemeData,
                  child: chipWidget,
                ),
                focusNode: state.focusNode);
          },
        );

  @override
  _FormeFilterChipState<T> createState() => _FormeFilterChipState();
}

class _FormeFilterChipState<T extends Object>
    extends ValueFieldState<List<T>, FormeFilterChipModel<T>> {
  @override
  void afterUpdateModel(
      FormeFilterChipModel<T> old, FormeFilterChipModel<T> current) {
    List<T> value = super.value!;
    if (value.isEmpty) return;
    if (current.items != null) {
      List<T> items = List.of(value);
      Iterable<T> datas = current.items!.map((e) => e.data);
      bool removed = false;
      items.removeWhere((element) {
        if (!datas.contains(element)) {
          removed = true;
          return true;
        }
        return false;
      });
      if (removed) setValue(items);
    }
    if (current.count != null && current.count! < value.length) {
      List<T> items = List.of(value);
      setValue(items.sublist(0, current.count!));
    }
  }

  @override
  FormeFilterChipModel<T> beforeSetModel(
      FormeFilterChipModel<T> old, FormeFilterChipModel<T> current) {
    if (current.items == null) {
      current = current.copyWith(FormeFilterChipModel<T>(items: old.items));
    }
    return current;
  }
}

class FormeFilterChipModel<T extends Object> extends FormeModel {
  final List<FormeChipItem<T>>? items;
  final int? count;
  final ChipThemeData? chipThemeData;
  final FormeWrapRenderData? wrapRenderData;
  final VoidCallback? exceedCallback;

  FormeFilterChipModel({
    this.items,
    this.count,
    this.chipThemeData,
    this.wrapRenderData,
    this.exceedCallback,
  });
  FormeFilterChipModel<T> copyWith(FormeModel oldModel) {
    FormeFilterChipModel<T> old = oldModel as FormeFilterChipModel<T>;
    return FormeFilterChipModel<T>(
      items: items ?? old.items,
      count: count ?? old.count,
      chipThemeData:
          FormeRenderUtils.copyChipThemeData(old.chipThemeData, chipThemeData),
      wrapRenderData:
          FormeWrapRenderData.copy(old.wrapRenderData, wrapRenderData),
      exceedCallback: exceedCallback ?? old.exceedCallback,
    );
  }
}
