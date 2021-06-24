import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:forme/forme.dart';

/// used to build a textfield
///
/// this widget can be wrapped by a [FormeTextFieldOnTapProxyWidget] to avoid trigger [onTap] on textfield when you tap textfield's
/// prefix|suffix
class FormeTextFieldWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final String? errorText;
  final FormeTextFieldModel? model;

  FormeTextFieldWidget({
    required this.textEditingController,
    required this.focusNode,
    this.errorText,
    required this.model,
  });

  @override
  State<StatefulWidget> createState() => _FormeTextFieldWidgetState();
}

class _FormeTextFieldWidgetState extends State<FormeTextFieldWidget> {
  Size? suffixIconSize;
  Size? suffixSize;
  Size? prefixIconSize;
  Size? prefixSize;
  Size? size;

  double get suffixWidth =>
      (suffixIconSize?.width ?? 0) + (suffixSize?.width ?? 0);
  double get prefixWidth =>
      (prefixIconSize?.width ?? 0) + (prefixSize?.width ?? 0);

  FormeTextFieldModel? get model => widget.model;

  int counter = 0;
  bool update = false;

  int get count {
    int counter = 0;
    if (widget.model?.decoration?.suffix != null) counter++;
    if (widget.model?.decoration?.suffixIcon != null) counter++;
    if (widget.model?.decoration?.prefix != null) counter++;
    if (widget.model?.decoration?.prefixIcon != null) counter++;
    return counter;
  }

  bool get useProxy =>
      FormeTextFieldOnTapProxyWidget.isProxyOnTap(context) &&
      widget.model?.onTap != null &&
      count > 0;

  void increateCount() {
    if (++counter == count + 1 && update) {
      setState(() {});
    }
  }

  Widget? wrap(Widget? widget, String type) {
    if (widget == null) return null;
    return Builder(builder: (context) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        Size size = (context.findRenderObject() as RenderBox).size;
        if (type == 'suffixIcon' && this.suffixIconSize != size) {
          suffixIconSize = size;
          update = true;
        }
        if (type == 'suffix' && this.suffixSize != size) {
          suffixSize = size;
          update = true;
        }
        if (type == 'prefixIcon' && this.prefixIconSize != size) {
          prefixIconSize = size;
          update = true;
        }
        if (type == 'prefix' && this.prefixSize != size) {
          prefixSize = size;
          update = true;
        }
        increateCount();
      });
      return widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool useProxy = this.useProxy;
    InputDecoration? decoration =
        model?.decoration?.copyWith(errorText: widget.errorText);

    if (useProxy) {
      counter = 0;
      update = false;
      decoration = decoration?.copyWith(
        suffixIcon: wrap(model?.decoration?.suffixIcon, 'suffixIcon'),
        suffix: wrap(model?.decoration?.suffix, 'suffix'),
        prefixIcon: wrap(model?.decoration?.prefixIcon, 'prefixIcon'),
        prefix: wrap(model?.decoration?.prefix, 'prefix'),
      );
    }
    TextField textField = TextField(
      focusNode: widget.focusNode,
      controller: widget.textEditingController,
      decoration: decoration,
      obscureText: model?.obscureText ?? false,
      maxLines: model?.maxLines,
      minLines: model?.minLines,
      enabled: model?.enabled ?? true,
      readOnly: model?.readOnly ?? false,
      onTap: useProxy ? null : model?.onTap,
      onEditingComplete: model?.onEditingComplete,
      onSubmitted: model?.onSubmitted,
      onChanged: model?.onChanged,
      onAppPrivateCommand: model?.appPrivateCommandCallback,
      textInputAction: model?.textInputAction,
      textCapitalization: model?.textCapitalization ?? TextCapitalization.none,
      style: model?.style,
      strutStyle: model?.strutStyle,
      textAlign: model?.textAlign ?? TextAlign.start,
      textAlignVertical: model?.textAlignVertical,
      textDirection: model?.textDirection,
      showCursor: model?.showCursor,
      obscuringCharacter: model?.obscuringCharacter ?? '•',
      autocorrect: model?.autocorrect ?? true,
      smartDashesType: model?.smartDashesType,
      smartQuotesType: model?.smartQuotesType,
      enableSuggestions: model?.enableSuggestions ?? true,
      expands: model?.expands ?? false,
      cursorWidth: model?.cursorWidth ?? 2.0,
      cursorHeight: model?.cursorHeight,
      cursorRadius: model?.cursorRadius,
      cursorColor: model?.cursorColor,
      selectionHeightStyle: model?.selectionHeightStyle ?? BoxHeightStyle.tight,
      selectionWidthStyle: model?.selectionWidthStyle ?? BoxWidthStyle.tight,
      keyboardAppearance: model?.keyboardAppearance,
      scrollPadding: model?.scrollPadding ?? const EdgeInsets.all(20),
      dragStartBehavior: model?.dragStartBehavior ?? DragStartBehavior.start,
      mouseCursor: model?.mouseCursor,
      scrollPhysics: model?.scrollPhysics,
      autofillHints: model?.autofillHints,
      autofocus: model?.autofocus ?? false,
      toolbarOptions: model?.toolbarOptions,
      enableInteractiveSelection: model?.enableInteractiveSelection ?? true,
      buildCounter: model?.buildCounter,
      maxLengthEnforcement: model?.maxLengthEnforcement,
      inputFormatters: model?.inputFormatters,
      keyboardType: model?.keyboardType,
      maxLength: model?.maxLength,
      scrollController: model?.scrollController,
      selectionControls: model?.textSelectionControls,
    );

    if (useProxy) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        Size size = (context.findRenderObject() as RenderBox).size;
        if (this.size != size) {
          this.size = size;
          update = true;
        }
        increateCount();
      });
    }

    return useProxy
        ? Stack(
            children: [
              textField,
              Positioned(
                left: prefixWidth,
                right: suffixWidth,
                child: GestureDetector(
                  child: Container(
                    color: Colors.transparent,
                    height: size?.height,
                  ),
                  onTap: () {
                    model?.onTap!();
                  },
                ),
              )
            ],
          )
        : textField;
  }
}

/// **a temporarily solution!**
///
/// see https://github.com/flutter/flutter/issues/39376
///
/// a widget used to proxy onTap handler
///
/// **this widget is a relatively expensive ,avoid using it if possible**
///
/// in general, when tap a textfield's suffix icon or prefix icon , will alse trigger it's on tap handler
///
/// this widget will wrap textfield with a [Stack],and put a container on your textfield after calculated the size of prefix and suffix,
/// container will take up whole input space , when you tap a textfield, will trigger container's ontap actually
///
/// ```
///  Stack(
///   children:[
///      textField,
///       Positioned(
///         left: prefixWidth,
///         right: suffixWidth,
///         child: GestureDetector(
///           child: Container(
///             color: Colors.transparent,
///             height: size?.height,
///           ),
///           onTap: () {
///             model?.onTap!();
///          },
///        ),
///       )
///   ]
/// )
///
/// ```
///
/// see [FormeTextFieldWidget]
class FormeTextFieldOnTapProxyWidget extends InheritedWidget {
  FormeTextFieldOnTapProxyWidget({required Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static bool isProxyOnTap(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<
            FormeTextFieldOnTapProxyWidget>() !=
        null;
  }
}
