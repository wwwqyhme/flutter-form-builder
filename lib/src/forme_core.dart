import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:forme/forme.dart';
import 'package:forme/src/widget/forme_mounted_value_notifier.dart';

/// form key is a global key
class FormeKey extends LabeledGlobalKey<State> implements FormeController {
  FormeKey({String? debugLabel}) : super(debugLabel);

  /// whether formKey is initialized
  bool get initialized {
    State? state = currentState;
    if (state == null || state is! _FormeState) return false;
    return true;
  }

  /// get form controller , throw an error if there's no form controller
  FormeController get _currentController {
    State? currentState = super.currentState;
    if (currentState == null) {
      throw 'current state is null,did you put this key on Forme?';
    }
    if (currentState is! _FormeState) {
      throw 'curren state is not a state of Forme , did you put this key on Forme?';
    }
    return currentState.controller;
  }

  static T getFieldByContext<T extends FormeFieldController>(
      BuildContext context) {
    return _InheritedFormeFieldController.of(context) as T;
  }

  static T getValueFieldByContext<T extends FormeValueFieldController>(
      BuildContext context) {
    return _InheritedFormeFieldController.of(context) as T;
  }

  @override
  Map<String, dynamic> get data => _currentController.data;

  @override
  bool get readOnly => _currentController.readOnly;

  @override
  Map<FormeValueFieldController, String> get errors =>
      _currentController.errors;

  @override
  T field<T extends FormeFieldController>(String name) =>
      _currentController.field<T>(name);

  @override
  bool hasField(String name) => _currentController.hasField(name);

  @override
  Future<FormeValidateSnapshot> validate(
          {bool quietly = false, Set<String> names = const {}}) =>
      _currentController.validate(quietly: quietly, names: names);

  @override
  void reset() => _currentController.reset();

  @override
  void save() => _currentController.save();

  @override
  T valueField<T extends FormeValueFieldController>(String name) =>
      _currentController.valueField<T>(name);

  @override
  set data(Map<String, dynamic> data) => _currentController.data = data;

  @override
  set readOnly(bool readOnly) => _currentController.readOnly = readOnly;

  static FormeController of(BuildContext context) {
    return _FormScope.of(context).formeController;
  }

  @override
  bool get quietlyValidate => _currentController.quietlyValidate;

  @override
  set quietlyValidate(bool quietlyValidate) =>
      _currentController.quietlyValidate = quietlyValidate;

  @override
  bool get isValueChanged => _currentController.isValueChanged;

  @override
  List<FormeFieldController<FormeModel>> get controllers =>
      _currentController.controllers;
}

/// build your form !
class Forme extends StatefulWidget {
  /// whether form should be readOnly;
  ///
  /// default false
  final bool readOnly;

  /// listen form value changed
  ///
  /// this listener will be always triggered when field'value changed
  final FormeValueChanged? onValueChanged;

  /// listen form focus changed
  final FormeFocusChanged? onFocusChanged;

  /// form content
  final Widget child;

  /// map initial value
  ///
  /// **this property can be overwritten by field's initialValue**
  final Map<String, dynamic> initialValue;

  /// used to listen field's validate error changed
  final FormeValueChanged? onErrorChanged;

  final WillPopCallback? onWillPop;

  /// if this flag is true , will not display default error when perform a valiate
  ///
  /// [FormeValueFieldController.errorText] will return null
  final bool quietlyValidate;

  /// autovalidateMode
  ///
  /// if mode is [AutovalidateMode.onUserInteraction] , will validate and rebuild all fields which has a validator
  /// after field was interacted by user
  /// **if user changed field's value manually via [FormeValueFieldController.value] or changed field's model via [FormeFieldController.model] or [FormeFieldController.updateModel] ,
  /// will also be regarded as interacted by user**
  ///
  /// if mode is [AutovalidateMode.always] , will revalidated all value fields after called reset
  final AutovalidateMode autovalidateMode;

  final bool autovalidateByOrder;

  Forme({
    FormeKey? key,
    this.readOnly = false,
    this.onValueChanged,
    required this.child,
    this.initialValue = const {},
    this.onErrorChanged,
    this.onWillPop,
    this.quietlyValidate = false,
    this.onFocusChanged,
    AutovalidateMode? autovalidateMode,
    this.autovalidateByOrder = false,
  })  : this.autovalidateMode = autovalidateMode ?? AutovalidateMode.disabled,
        super(key: key);

  @override
  _FormeState createState() => _FormeState();
}

class _FormeState extends State<Forme> {
  final List<AbstractFieldState> states = [];
  late final _FormeController controller;

  Map<String, dynamic> get initialValue => widget.initialValue;
  AutovalidateMode get autovalidateMode => widget.autovalidateMode;

  bool? _readOnly;
  bool? _quietlyValidate;

  int gen = 0;

  bool get readOnly => _readOnly ?? widget.readOnly;

  set readOnly(bool readOnly) {
    if (_readOnly != readOnly) {
      setState(() {
        gen++;
        _readOnly = readOnly;
      });
      states.forEach((element) {
        element._readOnlyNotifier.value = readOnly;
      });
    }
  }

  bool get quietlyValidate => _quietlyValidate ?? widget.quietlyValidate;

  set quietlyValidate(bool quietlyValidate) {
    if (_quietlyValidate != quietlyValidate) {
      setState(() {
        gen++;
        _quietlyValidate = quietlyValidate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller = _FormeController(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void reset() {
    valueFieldStates.forEach((element) {
      element.reset();
    });
    if (widget.autovalidateMode == AutovalidateMode.always) _validateForm();
  }

  _validateForm() {
    if (widget.autovalidateByOrder) {
      List<BaseValueFieldState> valueFieldStates = this
          .valueFieldStates
          .where((element) => element._hasAnyValidator)
          .toList();
      valueFieldStates.sort((a, b) => a.order.compareTo(b.order));
      if (valueFieldStates.isEmpty) return;
      _validateByOrder(valueFieldStates);
    } else {
      valueFieldStates.forEach((element) {
        element._validate2(() {});
      });
    }
  }

  _validateByOrder(List<BaseValueFieldState> states, {int index = 0}) {
    int length = states.length;
    if (index >= length) return;
    BaseValueFieldState state = states[index];
    state._validate2(() {
      _validateByOrder(states, index: index + 1);
    });
  }

  void save() {
    valueFieldStates.forEach((element) {
      element.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: _InheritedFormScope(
        gen: gen,
        formScope: _FormScope(this),
        child: widget.child,
      ),
      onWillPop: widget.onWillPop,
    );
  }

  void registerField(AbstractFieldState state) {
    states.add(state);
    state._focusNotifier.addListener(() {
      if (widget.onFocusChanged != null)
        widget.onFocusChanged!(state.controller, state._focusNotifier.value);
    });
    if (state is BaseValueFieldState) {
      state._valueNotifier.addListener(() {
        if (widget.onValueChanged != null)
          widget.onValueChanged!(state.controller, state._valueNotifier.value);
      });
      state._errorNotifier.addListener(() {
        if (widget.onErrorChanged != null)
          widget.onErrorChanged!(state.controller, state._errorNotifier.value);
      });
      state._fieldDidChangedNotifier.addListener(() {
        bool needValidate = false;
        if (widget.autovalidateMode == AutovalidateMode.always) {
          needValidate = true;
        }
        if (widget.autovalidateMode == AutovalidateMode.onUserInteraction) {
          needValidate =
              valueFieldStates.any((element) => element._hasInteractedByUser);
        }
        if (needValidate) {
          _validateForm();
        }
      });
    }
  }

  void unregisterField(AbstractFieldState state) {
    states.remove(state);
  }

  Iterable<FormeValueFieldController> get valueFieldControllers =>
      valueFieldStates.map((e) => e.controller);

  Iterable<BaseValueFieldState> get valueFieldStates {
    return states
        .where((element) => element is BaseValueFieldState)
        .map((e) => e as BaseValueFieldState);
  }

  bool get isValueChanged {
    return valueFieldStates.any((element) => element.isValueChanged);
  }
}

class _InheritedFormScope extends InheritedWidget {
  final int gen;
  final _FormScope formScope;

  _InheritedFormScope({
    required this.gen,
    required this.formScope,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant _InheritedFormScope oldWidget) {
    return gen != oldWidget.gen;
  }
}

class _FormScope {
  final _FormeState state;

  _FormScope(this.state);

  FormeController get formeController => state.controller;
  bool get readOnly => state.readOnly;
  bool get quietlyValidate => state.quietlyValidate;
  dynamic getInitialValue(String name) => state.initialValue[name];
  bool hasInitialValue(String name) => state.initialValue.containsKey(name);
  int getOrder(AbstractFieldState field) => state.states.indexOf(field);

  bool get needValidate {
    if (state.autovalidateMode == AutovalidateMode.always) return true;
    if (state.autovalidateMode == AutovalidateMode.onUserInteraction)
      return state.valueFieldStates
          .any((element) => element._hasInteractedByUser);
    return false;
  }

  void registerField(AbstractFieldState state) {
    this.state.registerField(state);
  }

  void unregisterField(AbstractFieldState state) {
    this.state.unregisterField(state);
  }

  static _FormScope of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_InheritedFormScope>()!
      .formScope;
}

/// state for all stateful form field
///
/// if you want Forme control your custom stateful field,you can do as follows
///
/// 1. make your custom field extends StatefulWidget and with [StatefulField]
/// 2. make your custom state extends State and with [AbstractFieldState]
///
mixin AbstractFieldState<T extends StatefulField<E, K>, E extends FormeModel,
    K extends FormeFieldController<E>> on State<T> {
  bool _init = false;
  FocusNode? _focusNode;
  late _FormScope _formScope;
  E? _model;
  bool? _readOnly;

  late final FormeMountedValueNotifier<bool> _focusNotifier =
      FormeMountedValueNotifier(false, this);
  late final FormeMountedValueNotifier<bool> _readOnlyNotifier =
      FormeMountedValueNotifier(false, this);
  late final FormeMountedValueNotifier<E> _modelNotifier =
      FormeMountedValueNotifier(widget.model, this);
  late final K controller;

  String get name => widget.name;

  /// get current widget's focus node
  ///
  /// if there's no focus node,will create a new one
  FocusNode get focusNode {
    if (_focusNode == null) {
      _focusNode = FocusNode();
      _focusNode!.addListener(() {
        _focusNotifier.value = focusNode.hasFocus;
      });
    }
    return _focusNode ??= FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formScope = _FormScope.of(context);
    if (_init) return;
    _init = true;
    beforeInitiation();
    this.controller = createFormeFieldController();
    _formScope.registerField(this);
    afterInitiation();
    widget.listener?.onInitialed?.call(this.controller);
  }

  /// create a [FormeFieldController]
  ///
  /// override this method to create your own [FormeFieldController]
  ///
  /// **when you want to get [FormeFieldController], use [ValueFieldState.controller] rather than call this method!,
  /// this method should only called by [Forme]**
  @protected
  K createFormeFieldController();

  @override
  void dispose() {
    _focusNotifier.dispose();
    _modelNotifier.dispose();
    _readOnlyNotifier.dispose();
    _focusNode?.dispose();
    _formScope.unregisterField(this);
    super.dispose();
  }

  /// called after  FormeFieldController created
  ///
  /// this method is called in didChangeDependencies and will only called once in state's lifecycle
  @protected
  @mustCallSuper
  void afterInitiation() {
    _focusNotifier.addListener(() {
      onFocusChanged(focusNode.hasFocus);
      widget.listener?.onFocusChanged
          ?.call(this.controller, focusNode.hasFocus);
    });
  }

  /// called before  FormeFieldController created
  ///
  /// this method is called in didChangeDependencies and will only called once in state's lifecycle
  ///
  /// **init your resource in this method**
  @protected
  @mustCallSuper
  void beforeInitiation() {
    _readOnlyNotifier.value = readOnly;
  }

  /// used to do some logic after update model
  ///
  /// **this method will be called in [State.setState]**
  ///
  /// **this method will be called in [FormeFieldController.updateModel] and [FormeFieldController.model]**
  ///
  /// **this method will be also called in [updateModelInDidUpdateWidget] after 2.0.5**
  @protected
  void afterUpdateModel(E old, E current) {}

  /// used to set some required attribute before set model
  ///
  ///
  /// **this method will be executed before [State.setState]**
  ///
  /// **you should not update any [State] value in this method , do that in [afterUpdateModel]**
  ///
  @protected
  E beforeSetModel(E old, E current) => current;

  ///
  /// if model has been set via [FormeFieldController.model] or [FormeFieldController.updateModel]
  /// [old] is **current widget's model** , [current] is the model set by user
  /// otherwise [old] is oldWidget's model ,[current] is current widgets'model
  ///
  ///
  /// **default implementing is [afterUpdateModel] , override this method if can't fit your needs**
  @protected
  void updateModelInDidUpdateWidget(E old, E current) {
    afterUpdateModel(old, current);
  }

  /// override this method if you want to listen focus changed
  @protected
  void onFocusChanged(bool hasFocus) {}

  /// set model but do not [setState]
  ///
  /// **make sure call setState after this model**
  @protected
  setModel(E model) {
    this._model = model;
  }

  _updateModel(E _model) {
    if (_model != model) {
      setState(() {
        E old = model;
        this._model = _model.copyWith(model) as E;
        afterUpdateModel(old, _model);
      });
      _modelNotifier.value = this.model;
    }
  }

  _setModel(E _model) {
    if (_model != model) {
      E old = model;
      E handle = beforeSetModel(old, _model);
      setState(() {
        this._model = handle;
        afterUpdateModel(old, _model);
      });
      _modelNotifier.value = this.model;
    }
  }

  bool get readOnly => _formScope.readOnly || (_readOnly ?? widget.readOnly);
  set readOnly(bool readOnly) {
    if (readOnly != _readOnly) {
      setState(() {
        _readOnly = readOnly;
      });
      _readOnlyNotifier.value = readOnly;
    }
  }

  void requestFocus() {
    _focusNode?.requestFocus();
  }

  void unfocus({
    UnfocusDisposition disposition = UnfocusDisposition.scope,
  }) {
    _focusNode?.unfocus(disposition: disposition);
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_model == null) {
      updateModelInDidUpdateWidget(oldWidget.model, widget.model);
    } else {
      updateModelInDidUpdateWidget(widget.model, _model!);
    }
  }

  @protected
  FormeFieldController<E> defaultFormeFieldController() {
    return _FormeFieldController(this);
  }

  E get model => _model ?? widget.model;
}

/// this State is used for [CommonField]
abstract class BaseCommonFieldState<E extends FormeModel,
        K extends FormeFieldController<E>> extends State<BaseCommonField<E, K>>
    with AbstractFieldState<BaseCommonField<E, K>, E, K> {
  @override
  Widget build(BuildContext context) {
    return _InheritedFormeFieldController(controller, widget.builder(this));
  }
}

/// this State is only used for [ValueField]
abstract class BaseValueFieldState<T, E extends FormeModel,
        K extends FormeValueFieldController<T, E>>
    extends State<BaseValueField<T, E, K>>
    with AbstractFieldState<BaseValueField<T, E, K>, E, K> {
  late final FormeMountedValueNotifier<FormeValidateError?> _errorNotifier =
      FormeMountedValueNotifier(null, this);
  late final FormeMountedValueNotifier<FormeModel?> _decoratorNotifier =
      FormeMountedValueNotifier(null, this);
  late final FormeMountedValueNotifier<T> _valueNotifier;

  /// used to notify fieldDidChanged
  /// used by [Forme]
  final ValueNotifier<int> _fieldDidChangedNotifier = ValueNotifier(0);
  int get order => widget.order ?? _formScope.getOrder(this);

  T? _oldValue;
  FormeValidateError? _error;
  Timer? _asyncValidatorDebounce;
  bool _ignoreValidate = false;
  bool _hasInteractedByUser = false;
  int _validateGen = 0;
  late T _value;
  T get value => _value;
  T? get oldValue => _oldValue;
  VoidCallback? _validateValidCallback;
  bool _alwaysValidateOnNextBuild = false;

  bool get _hasValidator => widget.listener?.onValidate != null;
  bool get _hasAsyncValidator => widget.listener?.onAsyncValidate != null;
  bool get _hasAnyValidator => _hasValidator || _hasAsyncValidator;

  String? get errorText => _formScope.quietlyValidate ? null : _error?.text;

  /// get initialValue
  T get initialValue => _formScope.hasInitialValue(name)
      ? _formScope.getInitialValue(name)
      : widget.initialValue;

  /// **when you want to init something that relies on initialValue,
  /// you should do that in [beforeInitiation] rather than in this method**
  @override
  void initState() {
    super.initState();
  }

  @override
  void beforeInitiation() {
    super.beforeInitiation();
    _value = initialValue;
    _valueNotifier = FormeMountedValueNotifier(initialValue, this);
  }

  @override
  void afterInitiation() {
    super.afterInitiation();

    _decoratorNotifier.addListener(() {
      setState(() {});
    });

    _valueNotifier.addListener(() {
      _ignoreValidate = false;
      onValueChanged(_valueNotifier.value);
      widget.listener?.onValueChanged
          ?.call(this.controller, _valueNotifier.value);
    });

    _errorNotifier.addListener(() {
      onErrorChanged(_errorNotifier.value);
      widget.listener?.onErrorChanged
          ?.call(this.controller, _errorNotifier.value);
    });
  }

  @mustCallSuper
  void didChange(T newValue) {
    T oldValue = _value;
    if (!compare(oldValue, newValue)) {
      setState(() {
        _hasInteractedByUser = true;
        _value = newValue;
        _oldValue = oldValue;
      });
      _fieldChange();
      _valueNotifier.value = newValue;
    }
  }

  @override
  void didUpdateWidget(BaseValueField<T, E, K> oldWidget) {
    T oldValue = _value;
    super.didUpdateWidget(oldWidget);
    if (!compare(oldValue, _value)) {
      _oldValue = oldValue;
      _valueNotifier.value = _value;
    }
  }

  @mustCallSuper
  void reset() {
    T oldValue = _value;
    setState(() {
      _validateGen++;
      _error = null;
      _hasInteractedByUser = false;
      _ignoreValidate = false;
      _oldValue = oldValue;
      _value = initialValue;
      _validateValidCallback = null;
      _alwaysValidateOnNextBuild = false;
    });
    _fieldChange();
    if (!compare(oldValue, initialValue)) {
      _valueNotifier.value = initialValue;
    }
    _errorNotifier.value = null;
  }

  @protected
  void setValue(T value) {
    this._value = value;
  }

  @override
  void dispose() {
    _asyncValidatorDebounce?.cancel();
    _fieldDidChangedNotifier.dispose();
    _decoratorNotifier.dispose();
    _errorNotifier.dispose();
    _valueNotifier.dispose();
    super.dispose();
  }

  @protected
  bool compare(T a, T b) {
    return widget.comparator(a, b);
  }

  /// override this method if you want to listen value changed
  ///
  /// **if [ValueField] is nonnull , value will not be null**
  @protected
  void onValueChanged(T value) {}

  /// override this method if you want to listen error changed
  @protected
  void onErrorChanged(FormeValidateError? error) {}

  AutovalidateMode get autovalidateMode =>
      widget.listener?.autovalidateMode ?? AutovalidateMode.disabled;

  bool get needValidate =>
      _hasAnyValidator &&
      widget.enabled &&
      ((autovalidateMode == AutovalidateMode.always) ||
          (autovalidateMode == AutovalidateMode.onUserInteraction &&
              _hasInteractedByUser));

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    if (_alwaysValidateOnNextBuild || needValidate) {
      _alwaysValidateOnNextBuild = false;
      _validate();
    }

    Widget child = widget.builder(this);

    if (widget.decoratorBuilder != null) {
      child = widget.decoratorBuilder!.build(
        controller,
        child,
      );
    }

    return _InheritedFormeFieldController(this.controller, child);
  }

  @protected
  FormeValueFieldController<T, E> defaultFormeValueFieldController() {
    return _FormeValueFieldController(this, defaultFormeFieldController());
  }

  bool get isValueChanged => !compare(initialValue, this.value);

  void _validate2(VoidCallback onValid) {
    _asyncValidatorDebounce?.cancel();
    if (_ignoreValidate) {
      if (_error?.valid ?? false) onValid();
      return;
    }
    if (!_hasAnyValidator) return;
    setState(() {
      _alwaysValidateOnNextBuild = true;
      int gen = _validateGen + 1;
      _validateValidCallback = () {
        if (gen == _validateGen) {
          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            onValid();
          });
        }
      };
    });
  }

  void _validate() {
    _asyncValidatorDebounce?.cancel();
    if (_ignoreValidate || !_hasAnyValidator) return;
    int gen = ++_validateGen;

    void notifyError(FormeValidateError error) {
      _error = error;
      if (_error!.valid) {
        _validateValidCallback?.call();
      } else if (!error.validating) {
        _validateValidCallback = null;
      }
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _errorNotifier.value = _error;
      });
    }

    if (_hasValidator) {
      String? errorText = widget.listener!.onValidate!(controller, value);
      if (errorText != null || !_hasAsyncValidator) {
        notifyError(FormeValidateError(
            errorText,
            errorText == null
                ? FormeValidateState.valid
                : FormeValidateState.invalid));
        return;
      }
    }
    if (_hasAsyncValidator) {
      notifyError(FormeValidateError(null, FormeValidateState.validating));
      _asyncValidatorDebounce =
          Timer(widget.listener!.asyncValidatorDebounce, () {
        FormeValidateError? error;
        widget.listener!.onAsyncValidate!(controller, value).then((text) {
          error = FormeValidateError(
              text,
              text == null
                  ? FormeValidateState.valid
                  : FormeValidateState.invalid);
        }).whenComplete(() {
          if (mounted && gen == _validateGen) {
            setState(() {
              _error =
                  error ?? FormeValidateError(null, FormeValidateState.fail);
              _ignoreValidate = true;
            });
            if (_error!.valid) {
              _validateValidCallback?.call();
              _validateValidCallback = null;
            }
            _errorNotifier.value = _error;
          }
        });
      });
    }
  }

  @override
  _updateModel(E _model) {
    T oldValue = _value;
    bool valueChanged = !compare(oldValue, _value);
    if (valueChanged) _hasInteractedByUser = true;
    super._updateModel(_model);
    if (valueChanged) {
      _fieldChange();
      _oldValue = oldValue;
      _valueNotifier.value = _value;
    }
  }

  @override
  _setModel(E _model) {
    T oldValue = _value;
    bool valueChanged = !compare(oldValue, _value);
    if (valueChanged) _hasInteractedByUser = true;
    super._setModel(_model);
    if (valueChanged) {
      _fieldChange();
      _oldValue = oldValue;
      _valueNotifier.value = _value;
    }
  }

  void _fieldChange() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _fieldDidChangedNotifier.value++;
    });
  }

  Future<FormeFieldValidateSnapshot<T>> _performValidate(
      {bool quietly = false}) {
    T value = this.value;
    if (!_hasValidator) {
      return Future.delayed(Duration.zero,
          () => FormeFieldValidateSnapshot._(value, null, order, this));
    }
    int gen = quietly ? _validateGen : ++_validateGen;

    bool needNotify() {
      return !quietly && gen == _validateGen && mounted;
    }

    void notify(FormeValidateError error) {
      if (needNotify()) {
        setState(() {
          _error = error;
        });
        _errorNotifier.value = _error;
      }
    }

    if (_hasValidator) {
      String? errorText = widget.listener!.onValidate!(controller, value);
      if (errorText != null || !_hasAsyncValidator) {
        FormeValidateError error = FormeValidateError(
            errorText,
            errorText == null
                ? FormeValidateState.valid
                : FormeValidateState.invalid);
        notify(error);
        return Future.delayed(Duration.zero,
            () => FormeFieldValidateSnapshot._(value, error, order, this));
      }
    }

    if (_hasAsyncValidator) {
      if (!quietly) {
        notify(FormeValidateError(null, FormeValidateState.validating));
      }

      FormeValidateError? error;
      return widget.listener!.onAsyncValidate!(controller, value).then((text) {
        error = FormeValidateError(
            text,
            text == null
                ? FormeValidateState.valid
                : FormeValidateState.invalid);
        return FormeFieldValidateSnapshot._(value, error, order, this);
      }).whenComplete(() {
        error ??= FormeValidateError(null, FormeValidateState.fail);
        notify(error!);
      });
    }

    throw 'should not go here';
  }

  void save() {
    widget.listener?.onSaved?.call(controller, value);
  }
}

class _FormeDecoratorController extends FormeDecoratorController {
  final ValueNotifier<FormeModel?> notifier;

  _FormeDecoratorController(this.notifier);

  @override
  FormeModel? get currentModel => notifier.value;

  @override
  update(FormeModel model) => notifier.value == null
      ? notifier.value = model
      : notifier.value = model.copyWith(notifier.value!);

  @override
  set model(FormeModel model) => notifier.value = model;
}

class _ValueListenable<T> extends ValueListenable<T> {
  final ValueNotifier delegate;
  const _ValueListenable(this.delegate);
  @override
  void addListener(VoidCallback listener) => delegate.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      delegate.removeListener(listener);

  @override
  T get value => delegate.value;
}

class _FormeController extends FormeController {
  final _FormeState state;

  _FormeController(this.state);

  @override
  Map<String, dynamic> get data {
    Map<String, dynamic> map = {};
    state.valueFieldControllers.forEach((element) {
      String name = element.name;
      dynamic value = element.value;
      map[name] = value;
    });
    return map;
  }

  @override
  bool get quietlyValidate => state.quietlyValidate;
  @override
  bool get readOnly => state.readOnly;

  @override
  Map<FormeValueFieldController, String> get errors {
    Map<FormeValueFieldController, String> errorMap = {};
    for (FormeValueFieldController controller in state.valueFieldControllers) {
      String? errorText = controller.error?.text;
      if (errorText == null) continue;
      errorMap[controller] = errorText;
    }
    return errorMap;
  }

  @override
  T field<T extends FormeFieldController>(String name) {
    T? field = findFormeFieldController(name);
    if (field == null) throw 'no field can be found by name :$name';
    return field;
  }

  @override
  bool hasField(String name) =>
      state.states.any((element) => element.name == name);

  @override
  Future<FormeValidateSnapshot> validate(
      {bool quietly = false, Set<String> names = const {}}) {
    return Future.wait(
            state.valueFieldControllers
                .where((element) =>
                    names.isEmpty ? true : names.contains(element.name))
                .map((controller) => controller.validate(quietly: quietly)),
            eagerError: true)
        .then((value) {
      value.sort((a, b) => a._order.compareTo(b._order));
      return FormeValidateSnapshot._(value);
    });
  }

  @override
  void reset() => state.reset();

  @override
  void save() => state.save();

  @override
  T valueField<T extends FormeValueFieldController>(String name) =>
      field<T>(name);

  @override
  set data(Map<String, dynamic> data) => data.forEach((key, value) {
        valueField(key).value = value;
      });

  @override
  set quietlyValidate(bool quietlyValidate) =>
      state.quietlyValidate = quietlyValidate;

  @override
  set readOnly(bool readOnly) => state.readOnly = readOnly;

  T? findFormeFieldController<T extends FormeFieldController>(String name) {
    for (AbstractFieldState state in state.states) {
      if (state.name == name) return state.controller as T;
    }
  }

  @override
  bool get isValueChanged => state.isValueChanged;

  @override
  List<FormeFieldController<FormeModel>> get controllers =>
      state.states.map((e) => e.controller).toList();
}

class _FormeFieldController<E extends FormeModel>
    implements FormeFieldController<E> {
  final AbstractFieldState<StatefulField<E, FormeFieldController<E>>, E,
      FormeFieldController<E>> state;

  final ValueListenable<bool> focusListenable;
  final ValueListenable<bool> readOnlyListenable;
  final ValueListenable<E> modelListenable;
  _FormeFieldController(this.state)
      : this.focusListenable = _ValueListenable(state._focusNotifier),
        this.readOnlyListenable = _ValueListenable(state._readOnlyNotifier),
        this.modelListenable = _ValueListenable(state._modelNotifier);

  @override
  E get model => state.model;

  @override
  bool get readOnly => state.readOnly;

  @override
  Future<void> ensureVisible(
      {Duration? duration,
      Curve? curve,
      ScrollPositionAlignmentPolicy? alignmentPolicy,
      double? alignment}) {
    return Scrollable.ensureVisible(state.context,
        duration: duration ?? Duration.zero,
        curve: curve ?? Curves.ease,
        alignmentPolicy:
            alignmentPolicy ?? ScrollPositionAlignmentPolicy.explicit,
        alignment: alignment ?? 0);
  }

  @override
  FormeController get formeController => FormeKey.of(state.context);

  @override
  bool get hasFocus => state._focusNode?.hasFocus ?? false;

  @override
  String get name => state.name;

  @override
  void requestFocus() => state.requestFocus();

  @override
  void unfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) =>
      state.unfocus(disposition: disposition);

  @override
  void nextFocus() => state._focusNode?.nextFocus();

  @override
  void updateModel(E model) => state._updateModel(model);

  @override
  set model(E model) => state._setModel(model);

  @override
  set readOnly(bool readOnly) => state.readOnly = readOnly;
}

class _FormeValueFieldController<T, E extends FormeModel>
    extends FormeFieldControllerDelegate<E>
    implements FormeValueFieldController<T, E> {
  final BaseValueFieldState<T, E, FormeValueFieldController<T, E>> state;
  final FormeFieldController<E> delegate;
  final ValueListenable<FormeValidateError?> errorTextListenable;
  final ValueListenable<T> valueListenable;
  final _FormeDecoratorController decoratorController;

  _FormeValueFieldController(this.state, this.delegate)
      : this.errorTextListenable = _ValueListenable(state._errorNotifier),
        this.valueListenable = _ValueListenable<T>(state._valueNotifier),
        this.decoratorController =
            _FormeDecoratorController(state._decoratorNotifier);
  @override
  T get value => state.value;

  @override
  FormeValidateError? get error => state._error;

  @override
  void reset() => state.reset();

  @override
  Future<FormeFieldValidateSnapshot<T>> validate({bool quietly = false}) =>
      state._performValidate(quietly: quietly);

  @override
  set value(T value) => state.didChange(value);

  @override
  T? get oldValue => state.oldValue;

  @override
  bool get isValueChanged => state.isValueChanged;
}

/// share FormFieldController in sub tree
class _InheritedFormeFieldController extends InheritedWidget {
  final FormeFieldController controller;
  const _InheritedFormeFieldController(this.controller, Widget child)
      : super(child: child);
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static FormeFieldController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedFormeFieldController>()!
        .controller;
  }
}

/// used to hold  validate result and validated value
///
/// since value may be changed during async validation
class FormeFieldValidateSnapshot<T> {
  /// validated value , may not equals the field's value
  final T value;

  /// validate result , may not equals the field's current error if performed another validate during async validation
  ///
  /// **if field does not has any validator , error will be null**
  final FormeValidateError? error;

  final int _order;
  final BaseValueFieldState<T, FormeModel,
      FormeValueFieldController<T, FormeModel>> _state;

  FormeFieldValidateSnapshot._(
      this.value, this.error, this._order, this._state);

  /// whether form' value changed during validation
  bool get isValueChangedDuringValidation =>
      !_state.compare(value, _state.value);

  /// whether value changed after initialized
  ///
  /// **unlike [FormeValueFieldController.isValueChanged] , this method is compare snapshot value and initialValue**
  bool get isValueChanged => !_state.compare(value, _state.initialValue);

  /// whether field is invalid
  bool get invalid => error?.invalid ?? false;

  FormeValueFieldController<T, FormeModel> get controller => _state.controller;
}

class FormeValidateSnapshot {
  final List<FormeFieldValidateSnapshot> _snapshots;

  FormeValidateSnapshot._(this._snapshots);

  /// get first invalid field
  FormeFieldValidateSnapshot? get firstInvalidField {
    Iterable<FormeFieldValidateSnapshot> iterable = invalidFields;
    if (iterable.isNotEmpty) return iterable.first;
  }

  /// no validate error can be found in these fields
  bool get isValid => invalidFields.isEmpty;

  /// get all invalid fields
  Iterable<FormeFieldValidateSnapshot> get invalidFields =>
      _snapshots.where((element) => element.error?.invalid ?? false);

  /// get validated data
  ///
  /// **when you want to submit a form after all validation passed,
  /// you should use form data from this method rather than [FormeKey.data] due to
  /// form data may be changed during async validation**
  ///
  /// use [isValueChangedDuringValidation] to check whether form data changed during async validation
  Map<String, dynamic> get value => _snapshots
      .asMap()
      .map((key, value) => MapEntry(value.controller.name, value.value));

  /// whether form' value changed during validation
  bool get isValueChangedDuringValidation =>
      _snapshots.any((element) => element.isValueChangedDuringValidation);

  /// whether value changed after initialized
  ///
  /// **unlike [FormeController.isValueChanged] , this method is compare snapshot value and initialValue**
  bool get isValueChanged =>
      _snapshots.any((element) => element.isValueChanged);
}
