import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'forme_controller.dart';

import 'forme_core.dart';

abstract class FormeDecoratorBuilder<T> {
  Widget build(
    FormeValueFieldController<T, FormeModel> controller,
    Widget child,
  );
}

typedef FieldContentBuilder<T extends AbstractFieldState> = Widget Function(
    T state);

mixin StatefulField<T extends AbstractFieldState<StatefulWidget, E>,
    E extends FormeModel> on StatefulWidget {
  /// field's name
  ///
  /// used to control field
  String get name;

  @override
  T createState();

  E get model;

  bool get readOnly;

  FormeFocusChanged<FormeFieldController<E>>? get onFocusChanged;

  FormeFieldInitialed<FormeFieldController<E>>? get onInitialed;
}

/// if you want to create a stateful form field, but don't want to return a value,you can use this field
class CommonField<E extends FormeModel> extends StatefulWidget
    with StatefulField<CommonFieldState<E>, E> {
  final String name;
  final FieldContentBuilder<CommonFieldState<E>> builder;
  final E model;
  final bool readOnly;
  final FormeFocusChanged<FormeFieldController<E>>? onFocusChanged;
  final FormeFieldInitialed<FormeFieldController<E>>? onInitialed;
  const CommonField({
    Key? key,
    required this.name,
    required this.builder,
    required this.model,
    this.readOnly = false,
    this.onFocusChanged,
    this.onInitialed,
  }) : super(key: key);

  @override
  CommonFieldState<E> createState() => CommonFieldState();
}

/// base field used to return a value
///
/// if your return value is nonnull,use [ValueField]
class ValueField<T extends Object, E extends FormeModel> extends FormField<T>
    with StatefulField<ValueFieldState<T, E>, E> {
  final String name;

  /// **if you want to get current field error in value changed, you should call [WidgetsBinding.instance.addPostFrameCallback]**
  final FormeValueChanged<T, E>? onValueChanged;
  final E model;
  final bool readOnly;

  /// used to listen focus changed
  final FormeFocusChanged<FormeValueFieldController<T, E>>? onFocusChanged;

  /// used to listen field's validate errorText changed
  ///
  /// triggerer when:
  ///
  /// 1. if autovalidatemode is not disabled, **in this case, will triggered after current frame completed**
  /// 2. after called [validate] method
  ///
  /// **errorText will be null if field's errorText from nonnull to null**
  final FormeErrorChanged<FormeValueFieldController<T, E>>? onErrorChanged;

  /// used to build a decorator
  ///
  /// **decorator is a part of field widget**
  final FormeDecoratorBuilder<T>? decoratorBuilder;

  /// used to replace null value
  ///
  /// will effect
  ///
  ///   1. [FormeValueFieldController.value]
  ///   2. [ValueField.validator]
  ///   3. [ValueField.onSaved]
  ///   4. [FormeValueFieldController.valueListenable]
  ///   5. [ValueField.onValueChanged]
  ///   6. [Forme.onValueChanged]
  ///
  /// **should not setted by user**
  final T? nullValueReplacement;

  /// called after [FormeController] or [FormeFieldController] initialed
  ///
  /// valueListenable will not listen [FormeField.initialValue] , you can do
  /// that in this method
  ///
  /// **try to get another field's controller in this method will cause an error**
  final FormeFieldInitialed<FormeFieldController<E>>? onInitialed;

  ValueField({
    Key? key,
    this.onValueChanged,
    required this.name,
    required FieldContentBuilder<ValueFieldState<T, E>> builder,
    FormFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    T? initialValue,
    bool enabled = true,
    FormFieldSetter<T>? onSaved,
    required this.model,
    this.readOnly = false,
    this.onErrorChanged,
    this.decoratorBuilder,
    this.nullValueReplacement,
    FormeFocusChanged<FormeValueFieldController<T, E>>? onFocusChanged,
    FormeFieldInitialed<FormeValueFieldController<T, E>>? onInitialed,
  })  : this.onFocusChanged = _convertFormeFocusChanged(onFocusChanged),
        this.onInitialed = _convertFormeFieldInitialed(onInitialed),
        super(
            key: key,
            enabled: enabled,
            onSaved: onSaved,
            builder: (field) {
              ValueFieldState<T, E> state = field as ValueFieldState<T, E>;
              return builder(state);
            },
            validator: validator == null
                ? null
                : (v) {
                    if (v == null && nullValueReplacement != null) {
                      return validator(nullValueReplacement);
                    }
                    return validator(v);
                  },
            autovalidateMode: autovalidateMode,
            initialValue: initialValue);
  @override
  ValueFieldState<T, E> createState() => ValueFieldState();

  static FormeFocusChanged<FormeFieldController<E>>?
      _convertFormeFocusChanged<T, E extends FormeModel>(
          FormeFocusChanged<FormeValueFieldController<T, E>>? listener) {
    if (listener == null) return null;
    return (v, focus) => listener(v as FormeValueFieldController<T, E>, focus);
  }

  static FormeFieldInitialed<FormeFieldController<E>>?
      _convertFormeFieldInitialed<T, E extends FormeModel>(
          FormeFieldInitialed<FormeValueFieldController<T, E>>? listener) {
    if (listener == null) return null;
    return (v) => listener(v as FormeValueFieldController<T, E>);
  }
}
