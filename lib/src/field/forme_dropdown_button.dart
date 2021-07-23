import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

class FormeDropdownButton<T extends Object>
    extends ValueField<T?, FormeDropdownButtonModel<T>> {
  FormeDropdownButton({
    required List<DropdownMenuItem<T>> items,
    T? initialValue,
    required String name,
    bool readOnly = false,
    FormeDropdownButtonModel<T>? model,
    Key? key,
    FormeDecoratorBuilder<T?>? decoratorBuilder,
    InputDecoration? decoration,
    FormeValueFieldListener<T?,
            FormeValueFieldController<T?, FormeDropdownButtonModel<T>>>?
        listener,
    int? order,
    bool quietlyValidate = false,
  }) : super(
          quietlyValidate: quietlyValidate,
          listener: listener,
          key: key,
          decoratorBuilder: decoratorBuilder ??
              (decoration == null
                  ? null
                  : FormeInputDecoratorBuilder(
                      decoration: decoration,
                      emptyChecker: (value) => value == null,
                      wrapper: (child) {
                        return DropdownButtonHideUnderline(child: child);
                      })),
          model: (model ?? FormeDropdownButtonModel<T>())
              .copyWith(FormeDropdownButtonModel<T>(
            items: items,
          )),
          readOnly: readOnly,
          name: name,
          initialValue: initialValue,
          builder: (state) {
            bool readOnly = state.readOnly;
            double iconSize = state.model.iconSize ?? 24;

            DropdownButton<T> dropdownButton = DropdownButton<T>(
              focusNode: state.focusNode,
              autofocus: state.model.autofocus ?? false,
              selectedItemBuilder: state.model.selectedItemBuilder,
              value: state.value,
              items: state.model.items!,
              onTap: state.model.onTap,
              icon: state.model.icon,
              iconSize: iconSize,
              iconEnabledColor: state.model.iconEnabledColor,
              iconDisabledColor: state.model.iconDisabledColor,
              hint: state.model.hint,
              disabledHint: state.model.disabledHint,
              elevation: state.model.elevation ?? 8,
              style: state.model.style,
              isDense: state.model.isDense ?? true,
              isExpanded: state.model.isExpanded ?? true,
              itemHeight: state.model.itemHeight ?? kMinInteractiveDimension,
              focusColor: state.model.focusColor,
              dropdownColor: state.model.dropdownColor,
              onChanged: readOnly
                  ? null
                  : (value) {
                      state.didChange(value);
                      state.requestFocus();
                    },
            );

            return dropdownButton;
          },
        );

  @override
  _FormDropdownButtonState<T> createState() => _FormDropdownButtonState();
}

class _FormDropdownButtonState<T extends Object>
    extends ValueFieldState<T?, FormeDropdownButtonModel<T>> {
  @override
  void afterUpdateModel(
      FormeDropdownButtonModel<T> old, FormeDropdownButtonModel<T> current) {
    if (value == null) return;
    if (current.items != null &&
        !current.items!.any((element) => element.value == value)) {
      setValue(null);
    }
  }

  @override
  FormeDropdownButtonModel<T> beforeSetModel(
      FormeDropdownButtonModel<T> old, FormeDropdownButtonModel<T> current) {
    if (current.items == null) {
      current = current.copyWith(FormeDropdownButtonModel<T>(items: old.items));
    }
    return current;
  }
}

class FormeDropdownButtonModel<T> extends FormeModel {
  final DropdownButtonBuilder? selectedItemBuilder;
  final VoidCallback? onTap;
  final bool? autofocus;
  final List<DropdownMenuItem<T>>? items;
  final Widget? hint;
  final Widget? disabledHint;
  final int? elevation;
  final TextStyle? style;
  final bool? isDense;
  final bool? isExpanded;
  final double? itemHeight;
  final Color? focusColor;
  final Color? dropdownColor;
  final double? iconSize;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  FormeDropdownButtonModel({
    this.items,
    this.hint,
    this.disabledHint,
    this.elevation,
    this.style,
    this.isDense,
    this.isExpanded,
    this.itemHeight,
    this.focusColor,
    this.dropdownColor,
    this.iconSize,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.autofocus,
    this.onTap,
    this.selectedItemBuilder,
  });
  FormeDropdownButtonModel<T> copyWith(FormeModel oldModel) {
    FormeDropdownButtonModel<T> old = oldModel as FormeDropdownButtonModel<T>;
    return FormeDropdownButtonModel<T>(
      selectedItemBuilder: selectedItemBuilder ?? old.selectedItemBuilder,
      onTap: onTap ?? old.onTap,
      autofocus: autofocus ?? old.autofocus,
      items: items ?? old.items,
      hint: hint ?? old.hint,
      disabledHint: disabledHint ?? old.disabledHint,
      elevation: elevation ?? old.elevation,
      style: style ?? old.style,
      isDense: isDense ?? old.isDense,
      isExpanded: isExpanded ?? old.isExpanded,
      itemHeight: itemHeight ?? old.itemHeight,
      focusColor: focusColor ?? old.focusColor,
      dropdownColor: dropdownColor ?? old.dropdownColor,
      iconSize: iconSize ?? old.iconSize,
      icon: icon ?? old.icon,
      iconDisabledColor: iconDisabledColor ?? old.iconDisabledColor,
      iconEnabledColor: iconEnabledColor ?? old.iconEnabledColor,
    );
  }
}
