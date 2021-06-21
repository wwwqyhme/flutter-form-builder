import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

typedef FormeFieldInitialed<T> = void Function(T field);

/// triggered when form field's value changed
typedef FormeValueChanged<T, E extends FormeModel> = void Function(
    FormeValueFieldController<T, E> field, T? newValue);

/// triggered when form field's focus changed
typedef FormeFocusChanged<T extends FormeFieldController> = void Function(
  FormeFieldController field,
  bool hasFocus,
);

/// listen field errorText change
typedef FormeErrorChanged<T extends FormeValueFieldController> = void Function(
    T field, FormeValidateError? error);

/// form key is a global key
class FormeKey extends LabeledGlobalKey<State> implements FormeController {
  FormeKey({String? debugLabel}) : super(debugLabel);

  final List<_LazyFormeFieldListenable> _listenables = [];

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
  Map<FormeValueFieldController, String> validate(
          {bool quietly = false, bool notify = true}) =>
      _currentController.validate(quietly: quietly, notify: notify);

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

  @override
  FormeFieldListenable fieldListenable(String name) =>
      _currentController.fieldListenable(name);

  /// create LazyFieldListenable
  ///
  /// no need to wrap in builder!
  LazyFormeFieldListenable lazyFieldListenable(String name) {
    State? currentState = super.currentState;
    if (currentState == null || currentState is! _FormeState) {
      Iterable<_LazyFormeFieldListenable> iterable =
          this._listenables.where((element) => element.name == name);
      if (iterable.isNotEmpty) return iterable.first;
      _LazyFormeFieldListenable listenable = _LazyFormeFieldListenable(name);
      _listenables.add(listenable);
      return listenable;
    }
    _LazyFormeFieldListenable listenable = _LazyFormeFieldListenable(name);
    listenable.listenable = currentState.controller.fieldListenable(name);
    return listenable;
  }

  static FormeController of(BuildContext context) {
    return _FormScope.of(context).formeController;
  }

  @override
  bool get quietlyValidate => _currentController.quietlyValidate;

  @override
  set quietlyValidate(bool quietlyValidate) =>
      _currentController.quietlyValidate = quietlyValidate;
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
  final FormeErrorChanged? onErrorChanged;

  final WillPopCallback? onWillPop;

  /// if this flag is true , will not display default error when perform a valiate
  ///
  /// [FormeValueFieldController.errorText] will return null
  final bool quietlyValidate;

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
  }) : super(key: key);

  @override
  _FormeState createState() => _FormeState();
}

class _FormeState extends State<Forme> {
  final List<AbstractFieldState> states = [];
  final List<_FormeFieldListenable> listenables = [];
  late final _FormeController controller;

  bool? _readOnly;
  bool? _quietlyValidate;

  @protected
  int gen = 0;

  bool get readOnly => _readOnly ?? widget.readOnly;

  set readOnly(bool readOnly) {
    if (_readOnly != readOnly) {
      setState(() {
        gen++;
        _readOnly = readOnly;
        states.forEach((element) {
          element._readOnlyNotifier.value = readOnly;
        });
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
    if (widget.key != null) {
      FormeKey key = widget.key as FormeKey;
      key._listenables.forEach((element) {
        _FormeFieldListenable listenable =
            _FormeFieldListenable(element.name, null);
        element.listenable = listenable;
        listenables.add(listenable);
      });
    }
    controller = _FormeController(this);
  }

  @override
  void dispose() {
    listenables.forEach((element) {
      element.dispose();
    });
    super.dispose();
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
    listenables
        .where((element) => element.name == state.name)
        .forEach((element) {
      element.whenAlive(state.controller);
    });
    state._focusNotifier.addListener(() {
      if (widget.onFocusChanged != null)
        widget.onFocusChanged!(state.controller, state._focusNotifier.value);
    });
    if (state is ValueFieldState) {
      state._valueNotifier.addListener(() {
        if (widget.onValueChanged != null)
          widget.onValueChanged!(state.controller, state._valueNotifier.value);
      });
      state._errorNotifier.addListener(() {
        if (widget.onErrorChanged != null)
          widget.onErrorChanged!(state.controller, state._errorNotifier.value);
      });
    }
  }

  void unregisterField(AbstractFieldState state) {
    states.remove(state);
    listenables
        .where((element) => element.name == state.name)
        .forEach((element) {
      element.whenDead(state.controller);
    });
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
  dynamic getInitialValue(String name) => state.widget.initialValue[name];

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
mixin AbstractFieldState<T extends StatefulWidget, E extends FormeModel>
    on State<T> {
  bool _init = false;
  FocusNode? _focusNode;
  late _FormScope _formScope;
  E? _model;
  bool? _readOnly;

  final ValueNotifier<bool> _focusNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _readOnlyNotifier = ValueNotifier(false);
  late final ValueNotifier<E> _modelNotifier = ValueNotifier(_field.model);
  late final FormeFieldController<E> controller;

  String get name => _field.name;

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
    if (_field.onInitialed != null) {
      _field.onInitialed!(this.controller);
    }
  }

  /// create a [FormeFieldController]
  ///
  /// override this method to create your own [FormeFieldController]
  ///
  /// **when you want to get [FormeFieldController], use [ValueFieldState.controller] rather than call this method!,
  /// this method should only called by [Forme]**
  @protected
  FormeFieldController<E> createFormeFieldController() {
    return _FormeFieldController(this);
  }

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
      if (_field.onFocusChanged != null)
        _field.onFocusChanged!(this.controller, focusNode.hasFocus);
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

  /// used to do some logic before update model
  ///
  /// **if returned value is [old],this method will not rebuild field**
  ///
  /// **if you want to change field's value in this method , you should call
  /// [FormField.setValue] rather than [FormFdidChange]**
  @protected
  E beforeUpdateModel(E old, E current) => current;

  /// used to do some logic after update model
  ///
  /// **this method will be called after [beforeUpdateModel] or [beforeSetModel]**
  @protected
  void afterUpdateModel(E old, E current) {}

  /// used to do some logic before set model
  ///
  /// **if returned value is [old],this method will not rebuild field**
  ///
  /// **if you want to change field's value in this method , you should call
  /// [FormField.setValue] rather than [FormFdidChange]**
  @protected
  E beforeSetModel(E old, E current) => current;

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
      E copy = beforeUpdateModel(model, _model);
      if (copy != model) {
        setState(() {
          this._model = copy.copyWith(model) as E;
        });
        _modelNotifier.value = this.model;
        afterUpdateModel(model, _model);
      }
    }
  }

  _setModel(E _model) {
    if (_model != model) {
      E copy = beforeSetModel(model, _model);
      if (copy != model) {
        setState(() {
          this._model = copy;
        });
        _modelNotifier.value = this.model;
        afterUpdateModel(model, _model);
      }
    }
  }

  bool get readOnly => _formScope.readOnly || (_readOnly ?? _field.readOnly);
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

  E get model => _model ?? _field.model;

  StatefulField<AbstractFieldState<T, E>, E> get _field =>
      widget as StatefulField<AbstractFieldState<T, E>, E>;
}

/// this State is only used for [ValueField]
class ValueFieldState<T extends Object, E extends FormeModel>
    extends FormFieldState<T> with AbstractFieldState<FormField<T>, E> {
  final ValueNotifier<FormeValidateError?> _errorNotifier = ValueNotifier(null);
  final ValueNotifier<FormeModel?> _decoratorNotifier = ValueNotifier(null);
  late final ValueNotifier<T?> _valueNotifier;

  T? _oldValue;

  @override
  FormeValueFieldController<T, E> get controller =>
      super.controller as FormeValueFieldController<T, E>;

  @override
  ValueField<T, E> get widget => super.widget as ValueField<T, E>;

  @protected
  FormeValueFieldController<T, E> createFormeFieldController() =>
      _FormeValueFieldController(this, super.createFormeFieldController());

  @override
  String? get errorText => _formScope.quietlyValidate ? null : super.errorText;

  /// copy super._hasInteractedByUser here to detect whether performed validate in builder
  bool _hasInteractedByUser = false;

  @override
  T? get value => replaceNullValue(super.value);

  /// get initialValue
  T? get initialValue =>
      widget.initialValue ?? _formScope.getInitialValue(widget.name);

  /// **when you want to init something that relies on initialValue,
  /// you should do that in [beforeInitiation] rather than in this method**
  @override
  void initState() {
    super.initState();
  }

  @override
  void beforeInitiation() {
    super.beforeInitiation();
    setValue(initialValue);
    _valueNotifier = ValueNotifier(initialValue);
  }

  @override
  void afterInitiation() {
    super.afterInitiation();

    _decoratorNotifier.addListener(() {
      setState(() {});
    });

    _valueNotifier.addListener(() {
      onValueChanged(replaceNullValue(_valueNotifier.value));
      if (widget.onValueChanged != null)
        widget.onValueChanged!(
            this.controller, replaceNullValue(_valueNotifier.value));
    });

    _errorNotifier.addListener(() {
      onErrorChanged(_errorNotifier.value);
      if (widget.onErrorChanged != null)
        widget.onErrorChanged!(this.controller, _errorNotifier.value);
    });
  }

  @override
  void didChange(T? newValue) {
    _hasInteractedByUser = true;
    T? oldValue = super.value;
    if (!compare(oldValue, newValue)) {
      super.didChange(newValue);
      _oldValue = replaceNullValue(oldValue);
      _valueNotifier.value = newValue;
    }
  }

  @override
  void reset() {
    T? oldValue = super.value;
    super.reset();
    _hasInteractedByUser = false;
    if (!compare(oldValue, initialValue)) {
      setValue(initialValue);
      _oldValue = replaceNullValue(oldValue);
      _valueNotifier.value = initialValue;
    }
    _errorNotifier.value = null;
  }

  @override
  void dispose() {
    _decoratorNotifier.dispose();
    _errorNotifier.dispose();
    _valueNotifier.dispose();
    super.dispose();
  }

  /// used to compare two values  determine whether changeValue
  ///
  /// default used [FormeUtils.compare]
  ///
  /// override this method if it don't fit your needs
  @protected
  bool compare(T? a, T? b) {
    return FormeUtils.compare(a, b);
  }

  /// override this method if you want to listen value changed
  ///
  /// **if [ValueField] is nonnull , value will not be null**
  @protected
  void onValueChanged(T? value) {}

  /// override this method if you want to listen error changed
  @protected
  void onErrorChanged(FormeValidateError? error) {}

  @override
  bool validate() => _performValidate(quietly: false) == null;

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    bool needValidate = widget.validator != null &&
        widget.enabled &&
        ((widget.autovalidateMode == AutovalidateMode.always) ||
            (widget.autovalidateMode == AutovalidateMode.onUserInteraction &&
                _hasInteractedByUser));

    Widget child = super.build(context);

    FormeValidateError error;
    if (needValidate &&
        ((error = FormeValidateError(super.errorText)) !=
            _errorNotifier.value)) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _errorNotifier.value = error;
      });
    }

    if (widget.decoratorBuilder != null) {
      child = widget.decoratorBuilder!.build(
        controller,
        child,
      );
    }

    return InheritedFormeFieldController(this.controller, child);
  }

  @protected
  T? replaceNullValue(T? value) {
    if (value == null && widget.nullValueReplacement != null)
      return widget.nullValueReplacement;
    return value;
  }

  @override
  _updateModel(E _model) {
    T? oldValue = super.value;
    super._updateModel(_model);
    if (!compare(oldValue, super.value)) {
      _oldValue = replaceNullValue(oldValue);
      _valueNotifier.value = super.value;
    }
  }

  @override
  _setModel(E _model) {
    T? oldValue = super.value;
    super._setModel(_model);
    if (!compare(oldValue, super.value)) {
      _oldValue = replaceNullValue(oldValue);
      _valueNotifier.value = super.value;
    }
  }

  String? _performValidate({bool quietly = false, bool notify = true}) {
    String? errorText;
    if (_formScope.quietlyValidate || quietly) {
      errorText =
          widget.validator == null ? null : widget.validator!(super.value);
    } else {
      super.validate();
      errorText = super.errorText;
    }
    if (notify) {
      _errorNotifier.value =
          widget.validator == null ? null : FormeValidateError(errorText);
    }
    return errorText;
  }
}

class _ValueFieldValueListenable<T> extends _ValueListenable<T> {
  final T nullValueReplacement;

  _ValueFieldValueListenable(ValueNotifier delegate, this.nullValueReplacement)
      : super(delegate);

  @override
  T get value => super.value == null ? nullValueReplacement : super.value;
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

class _FormeFieldListenable extends FormeFieldListenable {
  final String name;
  FormeFieldController? controller;

  final _ValueListenable<bool> focusListenable =
      _ValueListenable(ValueNotifier(false));
  final _ValueListenable<FormeValidateError?> errorTextListenable =
      _ValueListenable(ValueNotifier(null));
  final _ValueListenable valueListenable =
      _ValueListenable(ValueNotifier(null));
  final _ValueListenable<bool> readOnlyListenable =
      _ValueListenable(ValueNotifier(false));
  _ValueListenable<FormeModel>? _modelListenable;

  _FormeFieldListenable(this.name, FormeFieldController? controller) {
    if (controller != null) whenAlive(controller);
  }

  void whenAlive(FormeFieldController controller) {
    if (this.controller != null) {
      this.controller!.modelListenable.removeListener(listenModel);
      this.controller!.focusListenable.removeListener(listenFocus);
      this.controller!.readOnlyListenable.removeListener(listenReadOnly);
      if (this.controller is FormeValueFieldController) {
        (controller as FormeValueFieldController)
            .valueListenable
            .removeListener(listenValue);
        controller.errorTextListenable.removeListener(listenFormeValidateError);
      }
    }

    this.controller = controller;
    focusListenable.delegate.value = controller.focusListenable.value;
    controller.focusListenable.addListener(listenFocus);

    readOnlyListenable.delegate.value = controller.readOnlyListenable.value;
    controller.readOnlyListenable.addListener(listenReadOnly);

    if (_modelListenable == null) {
      _modelListenable =
          _ValueListenable(ValueNotifier(controller.modelListenable.value));
    } else {
      _modelListenable!.delegate.value = controller.modelListenable.value;
    }

    controller.modelListenable.addListener(listenModel);

    if (controller is! FormeValueFieldController) {
      return;
    }

    errorTextListenable.delegate.value = controller.errorTextListenable.value;
    controller.errorTextListenable.addListener(listenFormeValidateError);

    valueListenable.delegate.value = controller.valueListenable.value;
    controller.valueListenable.addListener(listenValue);
  }

  void whenDead(FormeFieldController controller) {
    if (this.controller == controller) {
      this.controller = null;
    }
  }

  void listenFocus() {
    if (controller != null)
      focusListenable.delegate.value = controller!.focusListenable.value;
  }

  void listenReadOnly() {
    if (controller != null)
      readOnlyListenable.delegate.value = controller!.readOnlyListenable.value;
  }

  void listenValue() {
    if (controller != null && controller is FormeValueFieldController)
      valueListenable.delegate.value =
          (controller as FormeValueFieldController).valueListenable.value;
  }

  void listenFormeValidateError() {
    if (controller != null && controller is FormeValueFieldController)
      errorTextListenable.delegate.value =
          (controller as FormeValueFieldController).errorTextListenable.value;
  }

  void listenModel() {
    if (controller != null)
      _modelListenable!.delegate.value = controller!.modelListenable.value;
  }

  void dispose() {
    _modelListenable?.delegate.dispose();
    errorTextListenable.delegate.dispose();
    focusListenable.delegate.dispose();
    valueListenable.delegate.dispose();
  }

  @override
  ValueListenable<FormeModel> get modelListenable => _modelListenable!;
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
    valueFieldControllers.forEach((element) {
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
  Map<FormeValueFieldController, String> get errors =>
      readErrors((e) => e.error?.text);

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
  Map<FormeValueFieldController<dynamic, FormeModel>, String> validate(
          {bool quietly = false, bool notify = true}) =>
      readErrors((e) => e.validate(quietly: quietly, notify: notify));

  @override
  void reset() => valueFieldControllers.forEach((element) {
        element.reset();
      });

  @override
  void save() => valueFieldStates.forEach((element) {
        element.save();
      });

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

  @override
  FormeFieldListenable fieldListenable(String name) {
    for (_FormeFieldListenable listenable in state.listenables) {
      if (listenable.name == name) return listenable;
    }
    _FormeFieldListenable newListenable =
        _FormeFieldListenable(name, findFormeFieldController(name));
    state.listenables.add(newListenable);
    return newListenable;
  }

  T? findFormeFieldController<T extends FormeFieldController>(String name) {
    for (AbstractFieldState state in state.states) {
      if (state.name == name) return state.controller as T;
    }
  }

  Iterable<FormeValueFieldController> get valueFieldControllers =>
      valueFieldStates.map((e) => e.controller);

  Iterable<ValueFieldState> get valueFieldStates {
    return state.states
        .where((element) => element is ValueFieldState)
        .map((e) => e as ValueFieldState);
  }

  Map<FormeValueFieldController, String> readErrors(
      String? f(FormeValueFieldController e)) {
    Map<FormeValueFieldController, String> errorMap = {};
    for (FormeValueFieldController controller in valueFieldControllers) {
      String? errorText = f(controller);
      if (errorText == null) continue;
      errorMap[controller] = errorText;
    }
    return errorMap;
  }
}

class _FormeFieldController<E extends FormeModel>
    implements FormeFieldController<E> {
  final AbstractFieldState<StatefulWidget, E> state;

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
  void updateModel(E model) => state._updateModel(model);

  @override
  set model(E model) => state._setModel(model);

  @override
  set readOnly(bool readOnly) => state.readOnly = readOnly;
}

class _FormeValueFieldController<T extends Object, E extends FormeModel>
    extends FormeFieldControllerDelegate<E>
    implements FormeValueFieldController<T, E> {
  final ValueFieldState<T, E> state;
  final FormeFieldController<E> delegate;
  final ValueListenable<FormeValidateError?> errorTextListenable;
  final ValueListenable<T?> valueListenable;
  final _FormeDecoratorController decoratorController;

  _FormeValueFieldController(this.state, this.delegate)
      : this.errorTextListenable = _ValueListenable(state._errorNotifier),
        this.valueListenable = _ValueFieldValueListenable(
            state._valueNotifier, state.widget.nullValueReplacement),
        this.decoratorController =
            _FormeDecoratorController(state._decoratorNotifier);
  @override
  T? get value => state.value;

  @override
  FormeValidateError? get error => errorTextListenable.value;

  @override
  void reset() => state.reset();

  @override
  String? validate({bool quietly = false, bool notify = true}) =>
      state._performValidate(quietly: quietly, notify: notify);

  @override
  set value(T? value) => state.didChange(value);

  @override
  void clearValue() => state.didChange(null);

  @override
  T? get oldValue => state._oldValue;
}

abstract class LazyFormeFieldListenable {
  ValueListenable<FormeValidateError?> get errorTextListenable;
  ValueListenable<bool> get focusListenable;
  ValueListenable get valueListenable;
  ValueListenable<bool> get readOnlyListenable;
}

class _LazyFormeFieldListenable extends LazyFormeFieldListenable {
  final String name;
  final _LazyValueListenable<FormeValidateError?> errorTextListenable =
      _LazyValueListenable<FormeValidateError?>(null);
  final _LazyValueListenable<bool> focusListenable =
      _LazyValueListenable<bool>(false);
  final _LazyValueListenable valueListenable = _LazyValueListenable(null);
  final _LazyValueListenable<bool> readOnlyListenable =
      _LazyValueListenable<bool>(false);

  _LazyFormeFieldListenable(this.name);

  set listenable(FormeFieldListenable listenable) {
    errorTextListenable.delegate = listenable.errorTextListenable;
    focusListenable.delegate = listenable.focusListenable;
    valueListenable.delegate = listenable.valueListenable;
    readOnlyListenable.delegate = listenable.readOnlyListenable;
  }
}

class _LazyValueListenable<T> extends ValueListenable<T> {
  final T _value;
  ValueListenable<T>? _delegate;

  set delegate(ValueListenable<T> delegate) {
    _delegate = delegate;
    listeners.removeWhere((element) {
      _delegate!.addListener(element);
      return true;
    });
  }

  _LazyValueListenable(this._value);

  List<VoidCallback> listeners = [];

  @override
  void addListener(listener) {
    if (_delegate != null) {
      _delegate!.addListener(listener);
      return;
    }
    listeners.add(listener);
  }

  @override
  void removeListener(listener) {
    if (_delegate != null) {
      _delegate!.removeListener(listener);
      return;
    }
    listeners.remove(listener);
  }

  @override
  T get value => _delegate == null ? _value : _delegate!.value;
}
