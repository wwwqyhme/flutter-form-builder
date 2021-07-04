import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:forme/forme.dart';
import 'forme_controller.dart';

import 'forme_core.dart';

///used to compare two values
typedef FormeValueComparator<T> = bool Function(T oldValue, T newValue);

class FormeFieldListener<K extends FormeFieldController> {
  /// called after [FormeController] or [FormeFieldController] initialed
  ///
  /// valueListenable will not listen [FormeField.initialValue] , you can do
  /// that in this method
  ///
  /// **try to get another field's controller in this method will cause an error**
  final FormeFieldInitialed<K>? onInitialed;
  final FormeFocusChanged<K>? onFocusChanged;
  FormeFieldListener({this.onInitialed, this.onFocusChanged});
}

class FormeValueFieldListener<T, K extends FormeValueFieldController>
    extends FormeFieldListener<K> {
  final Duration asyncValidatorDebounce;
  final AutovalidateMode autovalidateMode;
  final FormeValueChanged<T, K>? onValueChanged;

  /// used to listen field's validate errorText changed
  ///
  /// triggerer when:
  ///
  /// 1. if autovalidatemode is not disabled, **in this case, will triggered after current frame completed**
  /// 2. after called [validate] method
  ///
  /// **errorText will be null if field's errorText from nonnull to null**
  final FormeErrorChanged<K>? onErrorChanged;
  final FormeValidator<T, K>? onValidate;

  /// used to perform an async validate
  ///
  /// if you specific both asyncValidator and validator , asyncValidator will only worked after validator validate success
  final FormeAsyncValidator<T, K>? onAsyncValidate;
  final FormeFieldSetter<T, K>? onSaved;

  FormeValueFieldListener({
    FormeFieldInitialed<K>? onInitialed,
    FormeFocusChanged<K>? onFocusChanged,
    this.onValueChanged,
    this.onErrorChanged,
    this.onAsyncValidate,
    this.onValidate,
    this.onSaved,
    AutovalidateMode? autovalidateMode,
    Duration? asyncValidatorDebounce,
  })  : this.autovalidateMode = autovalidateMode ?? AutovalidateMode.disabled,
        this.asyncValidatorDebounce =
            asyncValidatorDebounce ?? Duration(milliseconds: 500),
        super(
          onInitialed: onInitialed,
          onFocusChanged: onFocusChanged,
        );
}

typedef FormeFieldInitialed<K extends FormeFieldController> = void Function(
    K field);

/// triggered when form field's value changed
typedef FormeValueChanged<T, K extends FormeValueFieldController> = void
    Function(K, T newValue);

/// triggered when form field's focus changed
typedef FormeFocusChanged<K extends FormeFieldController> = void Function(
  K field,
  bool hasFocus,
);

/// listen field errorText change
typedef FormeErrorChanged<K extends FormeValueFieldController> = void Function(
    K field, FormeValidateError? error);

typedef FormeAsyncValidator<T, K extends FormeValueFieldController>
    = Future<String?> Function(K field, T value);
typedef FormeValidator<T, K extends FormeValueFieldController> = String?
    Function(K field, T value);
typedef FormeFieldSetter<T, K extends FormeValueFieldController> = void
    Function(K field, T value);

abstract class FormeDecoratorBuilder<T> {
  Widget build(
    FormeValueFieldController<T, FormeModel> controller,
    Widget child,
  );
}

typedef FormeFieldWidgetBuilder<
        T extends AbstractFieldState<StatefulField<E, FormeFieldController<E>>,
            E, FormeFieldController<E>>,
        E extends FormeModel>
    = Widget Function(T state);

mixin StatefulField<E extends FormeModel, K extends FormeFieldController<E>>
    on StatefulWidget {
  /// field's name
  ///
  /// used to control field
  String get name;

  /// model is a configuration for model
  E get model;

  /// whether field should be readOnly or not
  bool get readOnly;

  FormeFieldListener<K>? get listener;
}

abstract class BaseCommonField<E extends FormeModel,
        K extends FormeFieldController<E>> extends StatefulWidget
    with StatefulField<E, K> {
  final String name;
  final FormeFieldWidgetBuilder<BaseCommonFieldState<E, K>, E> builder;
  final E model;
  final bool readOnly;
  final FormeFieldListener<K>? listener;
  BaseCommonField({
    Key? key,
    required this.name,
    required this.builder,
    required this.model,
    this.readOnly = false,
    this.listener,
  }) : super(key: key);

  @override
  BaseCommonFieldState<E, K> createState();
}

/// if you want to create a stateful form field, but don't want to return a value,you can use this field
class CommonField<E extends FormeModel>
    extends BaseCommonField<E, FormeFieldController<E>> {
  CommonField({
    Key? key,
    required String name,
    required FormeFieldWidgetBuilder<CommonFieldState<E>, E> builder,
    required E model,
    bool readOnly = false,
    FormeFieldListener<FormeFieldController<E>>? listener,
  }) : super(
          key: key,
          name: name,
          builder: (state) {
            return builder(state as CommonFieldState<E>);
          },
          model: model,
          readOnly: readOnly,
          listener: listener,
        );

  @override
  CommonFieldState<E> createState() => CommonFieldState();
}

abstract class BaseValueField<T, E extends FormeModel,
        K extends FormeValueFieldController<T, E>> extends StatefulWidget
    with StatefulField<E, K> {
  final String name;
  final E model;
  final bool readOnly;

  /// used to build a decorator
  ///
  /// **decorator is a part of field widget**
  final FormeDecoratorBuilder<T>? decoratorBuilder;

  final FormeFieldWidgetBuilder<BaseValueFieldState<T, E, K>, E> builder;
  final bool enabled;
  final T initialValue;
  final FormeValueFieldListener<T, K>? listener;

  /// comparator is used to compare value changed
  final FormeValueComparator<T> comparator;
  BaseValueField({
    Key? key,
    FormeValueComparator? comparator,
    required this.name,
    required this.builder,
    this.enabled = true,
    required this.model,
    this.readOnly = false,
    this.decoratorBuilder,
    required this.initialValue,
    this.listener,
  })  : this.comparator = comparator ?? _comparator(),
        super(key: key);

  @override
  BaseValueFieldState<T, E, K> createState();

  static FormeValueComparator _comparator() {
    return (a, b) => FormeUtils.compare(a, b);
  }
}

class ValueField<T, E extends FormeModel>
    extends BaseValueField<T, E, FormeValueFieldController<T, E>> {
  ValueField({
    Key? key,
    required String name,
    required E model,
    bool readOnly = false,
    FormeDecoratorBuilder<T>? decoratorBuilder,
    required FormeFieldWidgetBuilder<ValueFieldState<T, E>, E> builder,
    bool enabled = true,
    required T initialValue,
    FormeValueFieldListener<T, FormeValueFieldController<T, E>>? listener,
  }) : super(
          decoratorBuilder: decoratorBuilder,
          key: key,
          name: name,
          listener: listener,
          readOnly: readOnly,
          enabled: enabled,
          builder: (state) => builder(state as ValueFieldState<T, E>),
          initialValue: initialValue,
          model: model,
        );

  @override
  ValueFieldState<T, E> createState() => ValueFieldState();
}
