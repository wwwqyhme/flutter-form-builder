import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FormeBottomSheetRenderData {
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Color? barrierColor;
  final bool? isScrollControlled;
  final bool? useRootNavigator;
  final bool? isDismissible;
  final bool? enableDrag;
  final RouteSettings? routeSettings;
  final AnimationController? transitionAnimationController;
  final VoidCallback? beforeOpen;
  final VoidCallback? afterClose;
  const FormeBottomSheetRenderData({
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.barrierColor,
    this.isScrollControlled,
    this.useRootNavigator,
    this.isDismissible,
    this.enableDrag,
    this.routeSettings,
    this.transitionAnimationController,
    this.beforeOpen,
    this.afterClose,
  });
  static FormeBottomSheetRenderData? copy(
      FormeBottomSheetRenderData? old, FormeBottomSheetRenderData? current) {
    if (old == null) return current;
    if (current == null) return old;
    return FormeBottomSheetRenderData(
      backgroundColor: current.backgroundColor ?? old.backgroundColor,
      elevation: current.elevation ?? old.elevation,
      shape: current.shape ?? old.shape,
      barrierColor: current.barrierColor ?? old.barrierColor,
      isScrollControlled: current.isScrollControlled ?? old.isScrollControlled,
      useRootNavigator: current.useRootNavigator ?? old.useRootNavigator,
      isDismissible: current.isDismissible ?? old.isDismissible,
      enableDrag: current.enableDrag ?? old.enableDrag,
      routeSettings: current.routeSettings ?? old.routeSettings,
      transitionAnimationController: current.transitionAnimationController ??
          old.transitionAnimationController,
      beforeOpen: current.beforeOpen ?? old.beforeOpen,
      afterClose: current.afterClose ?? old.afterClose,
    );
  }
}

class FormeCheckboxRenderData {
  final Color? activeColor;
  final MouseCursor? mouseCursor;
  final MaterialStateProperty<Color?>? fillColor;
  final Color? checkColor;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? materialTapTargetSize;
  final Color? tileColor;
  final Color? selectedTileColor;
  final ShapeBorder? shape;

  const FormeCheckboxRenderData({
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.materialTapTargetSize,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.visualDensity,
    this.tileColor,
    this.selectedTileColor,
    this.shape,
  });

  static FormeCheckboxRenderData? copy(
      FormeCheckboxRenderData? old, FormeCheckboxRenderData? current) {
    if (old == null) return current;
    if (current == null) return old;
    return FormeCheckboxRenderData(
      activeColor: current.activeColor ?? old.activeColor,
      mouseCursor: current.mouseCursor ?? old.mouseCursor,
      fillColor: current.fillColor ?? old.fillColor,
      checkColor: current.checkColor ?? old.checkColor,
      focusColor: current.focusColor ?? old.focusColor,
      hoverColor: current.hoverColor ?? old.hoverColor,
      overlayColor: current.overlayColor ?? old.overlayColor,
      splashRadius: current.splashRadius ?? old.splashRadius,
      visualDensity: current.visualDensity ?? old.visualDensity,
      materialTapTargetSize:
          current.materialTapTargetSize ?? old.materialTapTargetSize,
      tileColor: current.tileColor ?? old.tileColor,
      selectedTileColor: current.selectedTileColor ?? old.selectedTileColor,
      shape: current.shape ?? old.shape,
    );
  }
}

class FormeListTileRenderData {
  final bool? dense;
  final ShapeBorder? shape;
  final ListTileStyle? style;
  final Color? selectedColor;
  final Color? iconColor;
  final Color? textColor;
  final EdgeInsetsGeometry? contentPadding;
  final Color? tileColor;
  final Color? selectedTileColor;
  final bool? enableFeedback;
  final double? horizontalTitleGap;
  final double? minVerticalPadding;
  final double? minLeadingWidth;

  const FormeListTileRenderData({
    this.dense,
    this.shape,
    this.style,
    this.selectedColor,
    this.iconColor,
    this.textColor,
    this.contentPadding,
    this.tileColor,
    this.selectedTileColor,
    this.enableFeedback,
    this.horizontalTitleGap,
    this.minVerticalPadding,
    this.minLeadingWidth,
  });

  static FormeListTileRenderData? copy(
      FormeListTileRenderData? old, FormeListTileRenderData? current) {
    if (old == null) return current;
    if (current == null) return old;
    return FormeListTileRenderData(
      dense: current.dense ?? old.dense,
      shape: current.shape ?? old.shape,
      style: current.style ?? old.style,
      selectedColor: current.selectedColor ?? old.selectedColor,
      iconColor: current.iconColor ?? old.iconColor,
      textColor: current.textColor ?? old.textColor,
      contentPadding: current.contentPadding ?? old.contentPadding,
      tileColor: current.tileColor ?? old.tileColor,
      selectedTileColor: current.selectedTileColor ?? old.selectedTileColor,
      enableFeedback: current.enableFeedback ?? old.enableFeedback,
      horizontalTitleGap: current.horizontalTitleGap ?? old.horizontalTitleGap,
      minVerticalPadding: current.minVerticalPadding ?? old.minVerticalPadding,
      minLeadingWidth: current.minLeadingWidth ?? old.minLeadingWidth,
    );
  }
}

class FormeSwitchRenderData {
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final ImageProvider? imageProvider;
  final ImageProvider? activeThumbImage;
  final ImageProvider? inactiveThumbImage;
  final MaterialStateProperty<Color?>? thumbColor;
  final MaterialStateProperty<Color?>? trackColor;
  final DragStartBehavior? dragStartBehavior;
  final MaterialTapTargetSize? materialTapTargetSize;
  final MouseCursor? mouseCursor;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final ImageErrorListener? onActiveThumbImageError;
  final ImageErrorListener? onInactiveThumbImageError;
  final Color? tileColor;
  final ShapeBorder? shape;
  final Color? selectedTileColor;

  const FormeSwitchRenderData({
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.imageProvider,
    this.activeThumbImage,
    this.inactiveThumbImage,
    this.thumbColor,
    this.trackColor,
    this.dragStartBehavior,
    this.materialTapTargetSize,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.onActiveThumbImageError,
    this.onInactiveThumbImageError,
    this.tileColor,
    this.shape,
    this.selectedTileColor,
  });
  static FormeSwitchRenderData? copy(
      FormeSwitchRenderData? old, FormeSwitchRenderData? current) {
    if (old == null) return current;
    if (current == null) return old;
    return FormeSwitchRenderData(
      activeColor: current.activeColor ?? old.activeColor,
      activeTrackColor: current.activeTrackColor ?? old.activeTrackColor,
      inactiveThumbColor: current.inactiveThumbColor ?? old.inactiveThumbColor,
      inactiveTrackColor: current.inactiveTrackColor ?? old.inactiveTrackColor,
      imageProvider: current.imageProvider ?? old.imageProvider,
      activeThumbImage: current.activeThumbImage ?? old.activeThumbImage,
      inactiveThumbImage: current.inactiveThumbImage ?? old.inactiveThumbImage,
      thumbColor: current.thumbColor ?? old.thumbColor,
      trackColor: current.trackColor ?? old.trackColor,
      dragStartBehavior: current.dragStartBehavior ?? old.dragStartBehavior,
      materialTapTargetSize:
          current.materialTapTargetSize ?? old.materialTapTargetSize,
      mouseCursor: current.mouseCursor ?? old.mouseCursor,
      focusColor: current.focusColor ?? old.focusColor,
      hoverColor: current.hoverColor ?? old.hoverColor,
      overlayColor: current.overlayColor ?? old.overlayColor,
      splashRadius: current.splashRadius ?? old.splashRadius,
      onActiveThumbImageError:
          current.onActiveThumbImageError ?? old.onActiveThumbImageError,
      onInactiveThumbImageError:
          current.onInactiveThumbImageError ?? old.onInactiveThumbImageError,
      tileColor: current.tileColor ?? old.tileColor,
      shape: current.shape ?? old.shape,
      selectedTileColor: current.selectedTileColor ?? old.selectedTileColor,
    );
  }
}

class FormeRadioRenderData {
  final Color? activeColor;
  final MouseCursor? mouseCursor;
  final MaterialStateProperty<Color?>? fillColor;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? materialTapTargetSize;
  final Color? tileColor;
  final Color? selectedTileColor;
  final ShapeBorder? shape;

  const FormeRadioRenderData({
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.materialTapTargetSize,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.visualDensity,
    this.tileColor,
    this.selectedTileColor,
    this.shape,
  });
  static FormeRadioRenderData? copy(
      FormeRadioRenderData? old, FormeRadioRenderData? current) {
    if (old == null) return current;
    if (current == null) return old;
    return FormeRadioRenderData(
      activeColor: current.activeColor ?? old.activeColor,
      mouseCursor: current.mouseCursor ?? old.mouseCursor,
      fillColor: current.fillColor ?? old.fillColor,
      focusColor: current.focusColor ?? old.focusColor,
      hoverColor: current.hoverColor ?? old.hoverColor,
      overlayColor: current.overlayColor ?? old.overlayColor,
      splashRadius: current.splashRadius ?? old.splashRadius,
      visualDensity: current.visualDensity ?? old.visualDensity,
      materialTapTargetSize:
          current.materialTapTargetSize ?? old.materialTapTargetSize,
      tileColor: current.tileColor ?? old.tileColor,
      selectedTileColor: current.selectedTileColor ?? old.selectedTileColor,
      shape: current.shape ?? old.shape,
    );
  }
}

class FormeWrapRenderData {
  final Axis? direction;
  final WrapAlignment? alignment;
  final double? space;
  final WrapAlignment? runAlignment;
  final double? runSpacing;
  final double? spacing;
  final WrapCrossAlignment? crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection? verticalDirection;

  const FormeWrapRenderData({
    this.direction,
    this.alignment,
    this.space,
    this.runAlignment,
    this.runSpacing,
    this.crossAxisAlignment,
    this.textDirection,
    this.verticalDirection,
    this.spacing,
  });
  static FormeWrapRenderData? copy(
      FormeWrapRenderData? old, FormeWrapRenderData? current) {
    if (old == null) return current;
    if (current == null) return old;
    return FormeWrapRenderData(
      direction: current.direction ?? old.direction,
      alignment: current.alignment ?? old.alignment,
      space: current.space ?? old.space,
      runAlignment: current.runAlignment ?? old.runAlignment,
      runSpacing: current.runSpacing ?? old.runSpacing,
      spacing: current.spacing ?? old.spacing,
      crossAxisAlignment: current.crossAxisAlignment ?? old.crossAxisAlignment,
      textDirection: current.textDirection ?? old.textDirection,
      verticalDirection: current.verticalDirection ?? old.verticalDirection,
    );
  }
}
