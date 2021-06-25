import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'forme_render_data.dart';

class FormeRenderUtils {
  FormeRenderUtils._();

  static Future<T?> showFormeModalBottomSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    FormeBottomSheetRenderData? bottomSheetRenderData,
  }) {
    if (bottomSheetRenderData?.beforeOpen != null)
      bottomSheetRenderData!.beforeOpen!();
    return showModalBottomSheet<T>(
      transitionAnimationController:
          bottomSheetRenderData?.transitionAnimationController,
      elevation: bottomSheetRenderData?.elevation,
      isDismissible: bottomSheetRenderData?.isDismissible ?? true,
      enableDrag: bottomSheetRenderData?.enableDrag ?? true,
      barrierColor: bottomSheetRenderData?.barrierColor,
      useRootNavigator: bottomSheetRenderData?.useRootNavigator ?? false,
      routeSettings: bottomSheetRenderData?.routeSettings,
      isScrollControlled: bottomSheetRenderData?.isScrollControlled ?? true,
      shape: bottomSheetRenderData?.shape,
      backgroundColor: bottomSheetRenderData?.backgroundColor,
      context: context,
      builder: builder,
    ).whenComplete(() {
      if (bottomSheetRenderData?.afterClose != null)
        bottomSheetRenderData!.afterClose!();
    });
  }

  static SliderThemeData? copySliderThemeData(
      SliderThemeData? old, SliderThemeData? current) {
    if (old == null) return current;
    if (current == null) return old;
    return SliderThemeData(
      trackHeight: current.trackHeight ?? old.trackHeight,
      activeTrackColor: current.activeTrackColor ?? old.activeTrackColor,
      inactiveTrackColor: current.inactiveTrackColor ?? old.inactiveTrackColor,
      disabledActiveTrackColor:
          current.disabledActiveTrackColor ?? old.disabledActiveTrackColor,
      disabledInactiveTrackColor:
          current.disabledInactiveTrackColor ?? old.disabledInactiveTrackColor,
      activeTickMarkColor:
          current.activeTickMarkColor ?? old.activeTickMarkColor,
      inactiveTickMarkColor:
          current.inactiveTickMarkColor ?? old.inactiveTickMarkColor,
      disabledActiveTickMarkColor: current.disabledActiveTickMarkColor ??
          old.disabledActiveTickMarkColor,
      disabledInactiveTickMarkColor: current.disabledInactiveTickMarkColor ??
          old.disabledInactiveTickMarkColor,
      thumbColor: current.thumbColor ?? old.thumbColor,
      overlappingShapeStrokeColor: current.overlappingShapeStrokeColor ??
          old.overlappingShapeStrokeColor,
      disabledThumbColor: current.disabledThumbColor ?? old.disabledThumbColor,
      overlayColor: current.overlayColor ?? old.overlayColor,
      valueIndicatorColor:
          current.valueIndicatorColor ?? old.valueIndicatorColor,
      overlayShape: current.overlayShape ?? old.overlayShape,
      tickMarkShape: current.tickMarkShape ?? old.tickMarkShape,
      thumbShape: current.thumbShape ?? old.thumbShape,
      trackShape: current.trackShape ?? old.trackShape,
      valueIndicatorShape:
          current.valueIndicatorShape ?? old.valueIndicatorShape,
      rangeTickMarkShape: current.rangeTickMarkShape ?? old.rangeTickMarkShape,
      rangeThumbShape: current.rangeThumbShape ?? old.rangeThumbShape,
      rangeTrackShape: current.rangeTrackShape ?? old.rangeTrackShape,
      rangeValueIndicatorShape:
          current.rangeValueIndicatorShape ?? old.rangeValueIndicatorShape,
      showValueIndicator: current.showValueIndicator ?? old.showValueIndicator,
      valueIndicatorTextStyle:
          current.valueIndicatorTextStyle ?? old.valueIndicatorTextStyle,
      minThumbSeparation: current.minThumbSeparation ?? old.minThumbSeparation,
      thumbSelector: current.thumbSelector ?? old.thumbSelector,
    );
  }

  static InputDecoration? copyInputDecoration(
      InputDecoration? old, InputDecoration? current) {
    if (old == null) return current;
    if (current == null) return old;
    return InputDecoration(
      icon: current.icon ?? old.icon,
      labelText: current.labelText ?? old.labelText,
      labelStyle: current.labelStyle ?? old.labelStyle,
      helperText: current.helperText ?? old.helperText,
      helperStyle: current.helperStyle ?? old.helperStyle,
      helperMaxLines: current.helperMaxLines ?? old.helperMaxLines,
      hintText: current.hintText ?? old.hintText,
      hintStyle: current.hintStyle ?? old.hintStyle,
      hintTextDirection: current.hintTextDirection ?? old.hintTextDirection,
      hintMaxLines: current.hintMaxLines ?? old.hintMaxLines,
      errorText: current.errorText ?? old.errorText,
      errorStyle: current.errorStyle ?? old.errorStyle,
      errorMaxLines: current.errorMaxLines ?? old.errorMaxLines,
      floatingLabelBehavior:
          current.floatingLabelBehavior ?? old.floatingLabelBehavior,
      isCollapsed: current.isCollapsed,
      isDense: current.isDense ?? old.isDense,
      contentPadding: current.contentPadding ?? old.contentPadding,
      prefixIcon: current.prefixIcon ?? old.prefixIcon,
      prefix: current.prefix ?? old.prefix,
      prefixText: current.prefixText ?? old.prefixText,
      prefixIconConstraints:
          current.prefixIconConstraints ?? old.prefixIconConstraints,
      prefixStyle: current.prefixStyle ?? old.prefixStyle,
      suffixIcon: current.suffixIcon ?? old.suffixIcon,
      suffix: current.suffix ?? old.suffix,
      suffixText: current.suffixText ?? old.suffixText,
      suffixStyle: current.suffixStyle ?? old.suffixStyle,
      suffixIconConstraints:
          current.suffixIconConstraints ?? old.suffixIconConstraints,
      counter: current.counter ?? old.counter,
      counterText: current.counterText ?? old.counterText,
      counterStyle: current.counterStyle ?? old.counterStyle,
      filled: current.filled ?? old.filled,
      fillColor: current.fillColor ?? old.fillColor,
      focusColor: current.focusColor ?? old.focusColor,
      hoverColor: current.hoverColor ?? old.hoverColor,
      errorBorder: current.errorBorder ?? old.errorBorder,
      focusedBorder: current.focusedBorder ?? old.focusedBorder,
      focusedErrorBorder: current.focusedErrorBorder ?? old.focusedErrorBorder,
      disabledBorder: current.disabledBorder ?? old.disabledBorder,
      enabledBorder: current.enabledBorder ?? old.enabledBorder,
      border: current.border ?? old.border,
      enabled: current.enabled,
      semanticCounterText:
          current.semanticCounterText ?? old.semanticCounterText,
      alignLabelWithHint: current.alignLabelWithHint ?? old.alignLabelWithHint,
    );
  }

  static ChipThemeData? copyChipThemeData(
      ChipThemeData? old, ChipThemeData? current) {
    if (old == null) return current;
    if (current == null) return old;
    return ChipThemeData(
      backgroundColor: current.backgroundColor,
      deleteIconColor: current.deleteIconColor ?? old.deleteIconColor,
      disabledColor: current.disabledColor,
      selectedColor: current.selectedColor,
      secondarySelectedColor: current.secondarySelectedColor,
      shadowColor: current.shadowColor ?? old.shadowColor,
      selectedShadowColor:
          current.selectedShadowColor ?? old.selectedShadowColor,
      checkmarkColor: current.checkmarkColor ?? old.checkmarkColor,
      labelPadding: current.labelPadding ?? old.labelPadding,
      padding: current.padding,
      side: current.side ?? old.side,
      shape: current.shape ?? old.shape,
      labelStyle: current.labelStyle,
      secondaryLabelStyle: current.secondaryLabelStyle,
      brightness: current.brightness,
      elevation: current.elevation ?? old.elevation,
      pressElevation: current.pressElevation ?? old.pressElevation,
    );
  }

  static Wrap wrap(FormeWrapRenderData? wrapRenderData, List<Widget> children) {
    return Wrap(
      spacing: wrapRenderData?.spacing ?? 0.0,
      runSpacing: wrapRenderData?.runSpacing ?? 0.0,
      textDirection: wrapRenderData?.textDirection,
      crossAxisAlignment:
          wrapRenderData?.crossAxisAlignment ?? WrapCrossAlignment.start,
      verticalDirection:
          wrapRenderData?.verticalDirection ?? VerticalDirection.down,
      alignment: wrapRenderData?.alignment ?? WrapAlignment.start,
      direction: wrapRenderData?.direction ?? Axis.horizontal,
      runAlignment: wrapRenderData?.runAlignment ?? WrapAlignment.start,
      children: children,
    );
  }

  static Widget mergeListTileTheme(
      Widget child, FormeListTileRenderData? listTileRenderData) {
    return ListTileTheme.merge(
      child: child,
      dense: listTileRenderData?.dense,
      shape: listTileRenderData?.shape,
      style: listTileRenderData?.style,
      selectedColor: listTileRenderData?.selectedColor,
      iconColor: listTileRenderData?.iconColor,
      textColor: listTileRenderData?.textColor,
      contentPadding: listTileRenderData?.contentPadding,
      tileColor: listTileRenderData?.tileColor,
      selectedTileColor: listTileRenderData?.selectedTileColor,
      enableFeedback: listTileRenderData?.enableFeedback,
      horizontalTitleGap: listTileRenderData?.horizontalTitleGap,
      minVerticalPadding: listTileRenderData?.minVerticalPadding,
      minLeadingWidth: listTileRenderData?.minLeadingWidth,
    );
  }

  static Switch formeSwitch(bool value, ValueChanged<bool>? onChanged,
      FormeSwitchRenderData? switchRenderData,
      {FocusNode? focusNode}) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: switchRenderData?.activeColor,
      activeTrackColor: switchRenderData?.activeTrackColor,
      inactiveThumbColor: switchRenderData?.inactiveThumbColor,
      inactiveTrackColor: switchRenderData?.inactiveTrackColor,
      activeThumbImage: switchRenderData?.activeThumbImage,
      inactiveThumbImage: switchRenderData?.inactiveThumbImage,
      materialTapTargetSize: switchRenderData?.materialTapTargetSize,
      thumbColor: switchRenderData?.thumbColor,
      trackColor: switchRenderData?.trackColor,
      dragStartBehavior:
          switchRenderData?.dragStartBehavior ?? DragStartBehavior.start,
      focusColor: switchRenderData?.focusColor,
      hoverColor: switchRenderData?.hoverColor,
      overlayColor: switchRenderData?.overlayColor,
      splashRadius: switchRenderData?.splashRadius,
      onActiveThumbImageError: switchRenderData?.onActiveThumbImageError,
      onInactiveThumbImageError: switchRenderData?.onInactiveThumbImageError,
    );
  }

  static Checkbox checkbox(bool value, ValueChanged<bool?>? onChanged,
      FormeCheckboxRenderData? checkboxRenderData,
      {FocusNode? focusNode}) {
    return Checkbox(
      activeColor: checkboxRenderData?.activeColor,
      fillColor: checkboxRenderData?.fillColor,
      checkColor: checkboxRenderData?.checkColor,
      materialTapTargetSize: checkboxRenderData?.materialTapTargetSize,
      focusColor: checkboxRenderData?.focusColor,
      hoverColor: checkboxRenderData?.hoverColor,
      overlayColor: checkboxRenderData?.overlayColor,
      splashRadius: checkboxRenderData?.splashRadius,
      visualDensity: checkboxRenderData?.visualDensity,
      value: value,
      onChanged: onChanged,
    );
  }

  static Radio<T> radio<T>(T value, T? groupValue, ValueChanged<T?>? onChanged,
      FormeRadioRenderData? radioRenderData) {
    return Radio<T>(
      activeColor: radioRenderData?.activeColor,
      fillColor: radioRenderData?.fillColor,
      materialTapTargetSize: radioRenderData?.materialTapTargetSize,
      focusColor: radioRenderData?.focusColor,
      hoverColor: radioRenderData?.hoverColor,
      overlayColor: radioRenderData?.overlayColor,
      splashRadius: radioRenderData?.splashRadius,
      visualDensity: radioRenderData?.visualDensity,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
