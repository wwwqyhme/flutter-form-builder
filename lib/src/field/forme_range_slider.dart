import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:forme/forme.dart';

class FormRangeLabelRender {
  final FormeLabelRender startRender;
  final FormeLabelRender endRender;
  FormRangeLabelRender(this.startRender, this.endRender);
}

class FormeRangeSlider extends ValueField<RangeValues, FormeRangeSliderModel> {
  FormeRangeSlider({
    FormeValueChanged<RangeValues, FormeRangeSliderModel>? onValueChanged,
    FormFieldValidator<RangeValues>? validator,
    AutovalidateMode? autovalidateMode,
    RangeValues? initialValue,
    FormFieldSetter<RangeValues>? onSaved,
    required String name,
    bool readOnly = false,
    FormeRangeSliderModel? model,
    required double min,
    required double max,
    FormeErrorChanged<
            FormeValueFieldController<RangeValues, FormeRangeSliderModel>>?
        onErrorChanged,
    FormeFocusChanged<
            FormeValueFieldController<RangeValues, FormeRangeSliderModel>>?
        onFocusChanged,
    FormeFieldInitialed<
            FormeValueFieldController<RangeValues, FormeRangeSliderModel>>?
        onInitialed,
    Key? key,
    FormeDecoratorBuilder<RangeValues>? decoratorBuilder,
    InputDecoration? decoration,
    Duration? asyncValidatorDebounce,
    FormeFieldValidator<RangeValues>? asyncValidator,
  }) : super(
            asyncValidator: asyncValidator,
            asyncValidatorDebounce: asyncValidatorDebounce,
            nullValueReplacement: RangeValues(min, max),
            onInitialed: onInitialed,
            decoratorBuilder: decoratorBuilder ??
                (decoration == null
                    ? null
                    : FormeInputDecoratorBuilder(decoration: decoration)),
            onFocusChanged: onFocusChanged,
            onErrorChanged: onErrorChanged,
            key: key,
            model: (model ?? FormeRangeSliderModel())
                .copyWith(FormeRangeSliderModel(
              max: max,
              min: min,
            )),
            readOnly: readOnly,
            name: name,
            onValueChanged: onValueChanged,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: autovalidateMode,
            builder: (baseState) {
              _FormeRangeSliderState state =
                  baseState as _FormeRangeSliderState;
              bool readOnly = state.readOnly;
              double max = state.model.max!;
              double min = state.model.min!;
              int divisions = state.model.divisions ?? (max - min).floor();
              Color? activeColor = state.model.activeColor;
              Color? inactiveColor = state.model.inactiveColor;

              RangeValues rangeValues = state.value!;
              RangeLabels? sliderLabels;

              if (state.model.rangeLabelRender != null) {
                String start = state.model.rangeLabelRender!
                    .startRender(rangeValues.start);
                String end =
                    state.model.rangeLabelRender!.endRender(rangeValues.end);
                sliderLabels = RangeLabels(start, end);
              }

              SliderThemeData sliderThemeData =
                  state.model.sliderThemeData ?? SliderTheme.of(state.context);
              if (sliderThemeData.thumbShape == null)
                sliderThemeData = sliderThemeData.copyWith(
                    rangeThumbShape:
                        CustomRangeSliderThumbCircle(value: rangeValues));
              Widget slider = SliderTheme(
                data: sliderThemeData,
                child: RangeSlider(
                  values: rangeValues,
                  min: min,
                  max: max,
                  divisions: divisions,
                  labels: sliderLabels,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  onChangeStart: (v) {
                    state.requestFocus();
                    state.model.onChangeStart?.call(v);
                  },
                  onChangeEnd: (v) {
                    state.didChange(v);
                    state.model.onChangeEnd?.call(v);
                  },
                  semanticFormatterCallback:
                      state.model.semanticFormatterCallback,
                  onChanged: readOnly
                      ? null
                      : (RangeValues values) {
                          state.updateValue(values);
                          state.model.onChanged?.call(values);
                        },
                ),
              );

              return Focus(
                focusNode: state.focusNode,
                child: slider,
              );
            });

  @override
  _FormeRangeSliderState createState() => _FormeRangeSliderState();
}

class _FormeRangeSliderState
    extends ValueFieldState<RangeValues, FormeRangeSliderModel> {
  RangeValues? _value;

  updateValue(RangeValues value) {
    setState(() {
      _value = value;
    });
  }

  @override
  RangeValues? get value => _value ?? super.value!;

  @override
  void onValueChanged(RangeValues? value) {
    _value = null;
  }

  @override
  void afterUpdateModel(
      FormeRangeSliderModel old, FormeRangeSliderModel current) {
    RangeValues value = super.value!;
    if (current.min != null) {
      if (value.start < current.min!)
        setValue(RangeValues(current.min!, value.end));
      else if (value.end < current.min!)
        setValue(RangeValues(value.start, current.min!));
    }
    if (current.max != null) {
      if (value.end > current.max!)
        setValue(RangeValues(value.start, current.max!));
      else if (value.start > current.max!)
        setValue(RangeValues(current.max!, value.end));
    }
  }

  @override
  FormeRangeSliderModel beforeSetModel(
      FormeRangeSliderModel old, FormeRangeSliderModel current) {
    if (current.min == null) {
      current = current.copyWith(FormeRangeSliderModel(min: old.min));
    }
    if (current.max == null) {
      current = current.copyWith(FormeRangeSliderModel(max: old.max));
    }
    return current;
  }
}

class FormeRangeSliderModel extends FormeModel {
  final SemanticFormatterCallback? semanticFormatterCallback;
  final ValueChanged<RangeValues>? onChangeStart;
  final ValueChanged<RangeValues>? onChangeEnd;
  final ValueChanged<RangeValues>? onChanged;
  final double? max;
  final double? min;
  final int? divisions;
  final Color? activeColor;
  final Color? inactiveColor;
  final SliderThemeData? sliderThemeData;
  final MouseCursor? mouseCursor;
  final FormRangeLabelRender? rangeLabelRender;
  FormeRangeSliderModel({
    this.max,
    this.min,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    this.sliderThemeData,
    this.mouseCursor,
    this.onChangeEnd,
    this.onChangeStart,
    this.semanticFormatterCallback,
    this.rangeLabelRender,
    this.onChanged,
  });

  FormeRangeSliderModel copyWith(FormeModel oldModel) {
    FormeRangeSliderModel old = oldModel as FormeRangeSliderModel;
    return FormeRangeSliderModel(
      semanticFormatterCallback:
          semanticFormatterCallback ?? old.semanticFormatterCallback,
      onChangeStart: onChangeStart ?? old.onChangeStart,
      onChangeEnd: onChangeEnd ?? old.onChangeEnd,
      max: max ?? old.max,
      min: min ?? old.min,
      divisions: divisions ?? old.divisions,
      activeColor: activeColor ?? old.activeColor,
      inactiveColor: inactiveColor ?? old.inactiveColor,
      sliderThemeData: FormeRenderUtils.copySliderThemeData(
          old.sliderThemeData, sliderThemeData),
      mouseCursor: mouseCursor ?? old.mouseCursor,
      rangeLabelRender: rangeLabelRender ?? old.rangeLabelRender,
      onChanged: onChanged ?? old.onChanged,
    );
  }
}

class CustomRangeSliderThumbCircle extends RangeSliderThumbShape {
  final double enabledThumbRadius;
  final double elevation;
  final double pressedElevation;
  final RangeValues value;

  CustomRangeSliderThumbCircle(
      {this.enabledThumbRadius = 12,
      this.elevation = 1,
      this.pressedElevation = 6,
      required this.value});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    String value;
    Thumb _thumb = thumb ?? Thumb.start;
    switch (_thumb) {
      case Thumb.start:
        value = this.value.start.round().toString();
        break;
      case Thumb.end:
        value = this.value.end.round().toString();
        break;
    }

    final Canvas canvas = context.canvas;
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    final Color color = colorTween.evaluate(enableAnimation)!;

    final paint = Paint()
      ..color = color //Thumb Background Color
      ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
        style: new TextStyle(
          fontSize: enabledThumbRadius * .8,
          fontWeight: FontWeight.w700,
          color: Colors.white, //Text Color of Value on Thumb
        ),
        text: value);

    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawCircle(center, enabledThumbRadius * .9, paint);
    tp.paint(canvas, textCenter);
  }
}
