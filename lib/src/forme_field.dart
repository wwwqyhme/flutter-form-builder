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

typedef FormeSimpleFieldInitialed<E extends FormeModel> = void Function(
    FormeFieldController<E> field);
typedef FormeSimpleValueFieldInitialed<T, E extends FormeModel> = void Function(
    FormeValueFieldController<T, E> field);
typedef FormeSimpleValueChanged<T, E extends FormeModel> = void Function(
    FormeValueFieldController<T, E> field, T newValue);
typedef FormeSimpleErrorChanged<T, E extends FormeModel> = void Function(
    FormeValueFieldController<T, E> field, FormeValidateError? error);
typedef FormeSimpleValueFieldFocusChanged<T, E extends FormeModel> = void
    Function(
  FormeValueFieldController<T, E> field,
  bool hasFocus,
);
typedef FormeSimpleFieldFocusChanged<E extends FormeModel> = void Function(
  FormeFieldController<E> field,
  bool hasFocus,
);

mixin StatefulField<T extends AbstractFieldState<StatefulWidget, E, K>,
    E extends FormeModel, K extends FormeFieldController<E>> on StatefulWidget {
  /// field's name
  ///
  /// used to control field
  String get name;

  @override
  T createState();

  E get model;

  bool get readOnly;

  FormeFocusChanged<K>? get onFocusChanged;

  FormeFieldInitialed<K>? get onInitialed;
}

abstract class BaseCommonField<E extends FormeModel,
        K extends FormeFieldController<E>> extends StatefulWidget
    with StatefulField<BaseCommonFieldState<E, K>, E, K> {
  final String name;
  final Widget Function(BaseCommonFieldState<E, K>) builder;
  final E model;
  final bool readOnly;
  final FormeFocusChanged<FormeFieldController<E>>? onFocusChanged;
  final FormeFieldInitialed<FormeFieldController<E>>? onInitialed;
  const BaseCommonField({
    Key? key,
    required this.name,
    required this.builder,
    required this.model,
    this.readOnly = false,
    this.onFocusChanged,
    this.onInitialed,
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
    required Widget Function(CommonFieldState<E>) builder,
    required E model,
    bool readOnly = false,
    FormeSimpleFieldFocusChanged<E>? onFocusChanged,
    FormeSimpleFieldInitialed<E>? onInitialed,
  }) : super(
          key: key,
          name: name,
          builder: (state) {
            return builder(state as CommonFieldState<E>);
          },
          model: model,
          readOnly: readOnly,
          onFocusChanged: onFocusChanged,
          onInitialed: onInitialed,
        );

  @override
  CommonFieldState<E> createState() => CommonFieldState();
}

abstract class BaseValueField<T, E extends FormeModel,
        K extends FormeValueFieldController<T, E>> extends StatefulWidget
    with StatefulField<BaseValueFieldState<T, E, K>, E, K> {
  final String name;

  /// **if you want to get current field error in value changed, you should call [WidgetsBinding.instance.addPostFrameCallback]**
  final FormeValueChanged<T, K>? onValueChanged;
  final E model;
  final bool readOnly;

  /// used to listen focus changed
  final FormeFocusChanged<K>? onFocusChanged;

  /// used to listen field's validate errorText changed
  ///
  /// triggerer when:
  ///
  /// 1. if autovalidatemode is not disabled, **in this case, will triggered after current frame completed**
  /// 2. after called [validate] method
  ///
  /// **errorText will be null if field's errorText from nonnull to null**
  final FormeErrorChanged<K>? onErrorChanged;

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
  final FormeFieldInitialed<K>? onInitialed;

  /// used to perform an async validate
  ///
  /// if you specific both asyncValidator and validator , asyncValidator will only worked after validator validate success
  final FormeAsyncValidator<T>? asyncValidator;
  final FormeAsyncValidateConfiguration asyncValidateConfiguration;

  final Widget Function(BaseValueFieldState<T, E, K>) builder;
  final FormeValidator<T>? validator;
  final bool enabled;
  final FormeFieldSetter<T>? onSaved;
  final AutovalidateMode? autovalidateMode;
  final T initialValue;
  BaseValueField({
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
    required this.initialValue,
    this.onFocusChanged,
    this.onInitialed,
  })  : this.asyncValidateConfiguration =
            asyncValidateConfiguration ?? FormeAsyncValidateConfiguration(),
        super(key: key);

  @override
  BaseValueFieldState<T, E, K> createState();
}

class ValueField<T, E extends FormeModel>
    extends BaseValueField<T, E, FormeValueFieldController<T, E>> {
  ValueField({
    Key? key,
    required String name,
    FormeSimpleValueChanged<T, E>? onValueChanged,
    required E model,
    bool readOnly = false,
    FormeSimpleValueFieldFocusChanged<T, E>? onFocusChanged,
    FormeSimpleErrorChanged<T, E>? onErrorChanged,
    FormeDecoratorBuilder<T>? decoratorBuilder,
    FormeSimpleValueFieldInitialed<T, E>? onInitialed,
    FormeAsyncValidator<T>? asyncValidator,
    FormeAsyncValidateConfiguration? asyncValidateConfiguration,
    required Widget Function(ValueFieldState<T, E>) builder,
    FormeValidator<T>? validator,
    bool enabled = true,
    FormeFieldSetter<T>? onSaved,
    AutovalidateMode? autovalidateMode,
    required T initialValue,
  }) : super(
          decoratorBuilder: decoratorBuilder,
          key: key,
          name: name,
          onErrorChanged: onErrorChanged,
          onValueChanged: onValueChanged,
          onFocusChanged: onFocusChanged,
          onSaved: onSaved,
          onInitialed: onInitialed,
          readOnly: readOnly,
          autovalidateMode: autovalidateMode,
          asyncValidateConfiguration: asyncValidateConfiguration,
          asyncValidator: asyncValidator,
          validator: validator,
          enabled: enabled,
          builder: (state) {
            return builder(state as ValueFieldState<T, E>);
          },
          initialValue: initialValue,
          model: model,
        );

  @override
  ValueFieldState<T, E> createState() => ValueFieldState();
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
