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

typedef FormeAsyncValidator<T> = Future<String?> Function(T value);
typedef FormeValidator<T> = String? Function(T value);
typedef FormeFieldSetter<T> = void Function(T value);
typedef FormeValueFieldFocusChanged<T, E extends FormeModel> = void Function(
  FormeValueFieldController<T, E> field,
  bool hasFocus,
);
typedef FormeValueFieldInitialed<T, E extends FormeModel> = void Function(
    FormeValueFieldController<T, E> field);

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

  FormeFocusChanged<E>? get onFocusChanged;

  FormeFieldInitialed<E>? get onInitialed;
}

/// if you want to create a stateful form field, but don't want to return a value,you can use this field
class CommonField<E extends FormeModel> extends StatefulWidget
    with StatefulField<CommonFieldState<E>, E> {
  final String name;
  final FieldContentBuilder<CommonFieldState<E>> builder;
  final E model;
  final bool readOnly;
  final FormeFocusChanged<E>? onFocusChanged;
  final FormeFieldInitialed<E>? onInitialed;
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

class ValueField<T, E extends FormeModel> extends StatefulWidget
    with StatefulField<ValueFieldState<T, E>, E> {
  final String name;

  /// **if you want to get current field error in value changed, you should call [WidgetsBinding.instance.addPostFrameCallback]**
  final FormeValueChanged<T, E>? onValueChanged;
  final E model;
  final bool readOnly;

  /// used to listen focus changed
  final FormeFocusChanged<E>? onFocusChanged;

  /// used to listen field's validate errorText changed
  ///
  /// triggerer when:
  ///
  /// 1. if autovalidatemode is not disabled, **in this case, will triggered after current frame completed**
  /// 2. after called [validate] method
  ///
  /// **errorText will be null if field's errorText from nonnull to null**
  final FormeErrorChanged<T, E>? onErrorChanged;

  /// used to build a decorator
  ///
  /// **decorator is a part of field widget**
  final FormeDecoratorBuilder<T>? decoratorBuilder;

  /// called after [FormeController] or [FormeFieldController] initialed
  ///
  /// valueListenable will not listen [FormeField.initialValue] , you can do
  /// that in this method
  ///
  /// **try to get another field's controller in this method will cause an error**
  final FormeFieldInitialed<E>? onInitialed;

  /// used to perform an async validate
  ///
  /// if you specific both asyncValidator and validator , asyncValidator will only worked after validator validate success
  final FormeAsyncValidator<T>? asyncValidator;
  final FormeAsyncValidateConfiguration asyncValidateConfiguration;

  final FieldContentBuilder<ValueFieldState<T, E>> builder;
  final FormeValidator<T>? validator;
  final bool enabled;
  final FormeFieldSetter<T>? onSaved;
  final AutovalidateMode? autovalidateMode;
  final T initialValue;
  ValueField({
    Key? key,
    this.onValueChanged,
    this.validator,
    this.asyncValidator,
    FormeAsyncValidateConfiguration? asyncValidateConfiguration,
    required this.name,
    required this.builder,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.enabled = true,
    this.onSaved,
    required this.model,
    this.readOnly = false,
    this.onErrorChanged,
    this.decoratorBuilder,
    FormeValueFieldFocusChanged<T, E>? onFocusChanged,
    FormeValueFieldInitialed<T, E>? onInitialed,
    required this.initialValue,
  })  : this.onFocusChanged = _convertFormeFocusChanged(onFocusChanged),
        this.onInitialed = _convertFormeFieldInitialed(onInitialed),
        this.asyncValidateConfiguration =
            asyncValidateConfiguration ?? FormeAsyncValidateConfiguration(),
        super(key: key);
  @override
  ValueFieldState<T, E> createState() => ValueFieldState();

  static FormeFocusChanged<E>?
      _convertFormeFocusChanged<T, E extends FormeModel>(
          FormeValueFieldFocusChanged<T, E>? listener) {
    if (listener == null) return null;
    return (v, focus) => listener(v as FormeValueFieldController<T, E>, focus);
  }

  static FormeFieldInitialed<E>?
      _convertFormeFieldInitialed<T, E extends FormeModel>(
          FormeValueFieldInitialed<T, E>? listener) {
    if (listener == null) return null;
    return (v) => listener(v as FormeValueFieldController<T, E>);
  }
}

enum FormeAsyncValidateMode {
  /// after performing an async validation , will not perform async validate again unless field's value changed
  onFieldValueChanged,

  /// after performing an async validation , will not perform async validate again unless forme's value changed
  ///
  /// you can specific names via  [FormeAsyncValidateConfiguration.names]
  onFormeValueChanged,
}

class FormeAsyncValidateConfiguration {
  final FormeAsyncValidateMode? mode;
  final Duration debounce;
  final Set<String> names;

  FormeAsyncValidateConfiguration({
    this.mode = FormeAsyncValidateMode.onFieldValueChanged,
    Duration? debounce,
    this.names = const {},
  }) : this.debounce = debounce ?? Duration.zero;
}
