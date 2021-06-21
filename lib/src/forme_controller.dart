import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:forme/forme.dart';

/// base form controller
///
/// you can access a form controller by [FormeKey] or [FormeKey.of]
abstract class FormeController {
  /// whether form has a name field
  bool hasField(String name);

  /// whether form is readonly
  bool get readOnly;

  /// set form readOnly|editable
  set readOnly(bool readOnly);

  /// find [FormeFieldController] by name
  T field<T extends FormeFieldController>(String name);

  /// find [FormeValueFieldController] by name
  T valueField<T extends FormeValueFieldController>(String name);

  /// notifiers of form field's focus|errorText|value
  ///
  ///
  /// **unlike [FormeFieldController]'s notifier , this controller's notifier will auto find last alived [FormeFieldController] by name,
  /// in another words , this controller's lifestyle is same as form,but [FormeFieldController]'s lifecycle is same as field,
  /// so it's safe to use this controller out of form field**
  ///
  /// **do not use this notifier out of forme**
  ///
  /// see [FormeInputDecorator]
  FormeFieldListenable fieldListenable(String name);

  /// get form data
  Map<String, dynamic> get data;

  /// get error msg after [validate]
  Map<FormeValueFieldController, String> get errors;

  /// perform a validate
  ///
  /// if [Forme.quietlyValidate] is true, this method will not display default error
  ///
  /// **if [quietly] is true , this method will not update and display error though [Forme.quietlyValidate] is false**
  ///
  /// key is [FormeValueFieldController]
  /// value is errorMsg
  Map<FormeValueFieldController, String> validate(
      {bool quietly = false, bool notify});

  /// set forme data
  set data(Map<String, dynamic> data);

  /// reset form
  ///
  /// **only reset all value fields**
  void reset();

  /// save all form fields
  ///
  /// form field's onSaved will be  called
  void save();

  /// whether validate is quietly
  bool get quietlyValidate;

  /// set validate quietly
  ///
  /// **call this method (if Forme's quietlyValidate is false) if you want to display error by a custom way**
  set quietlyValidate(bool quietlyValidate);
}

/// used to control form field
abstract class FormeFieldController<E extends FormeModel> {
  /// get forme controller
  FormeController get formeController;

  ///get field's name
  String get name;

  /// whether field is readOnly;
  bool get readOnly;

  /// set readOnly
  set readOnly(bool readOnly);

  // whether field is focused
  bool get hasFocus;

  /// request focus
  ///
  /// if current field don't have a focusNode or focusNode is unfocusable,this method will no effect
  void requestFocus();

  /// unfocus
  ///
  /// if current field don't have a focusNode or focusNode is unfocusable,this method will no effect
  void unfocus({
    UnfocusDisposition disposition = UnfocusDisposition.scope,
  });

  /// set state model on field
  ///
  /// directly set model will lose old model
  /// if you want to inherit old model, you can use  update model
  ///
  /// [model] is provided by your custom [AbstractFieldState],
  /// if you no need a model,you can use [EmptyStateModel]
  ///
  /// model is a property variable of [AbstractFieldState],used to provide
  /// data that determine how to render a field , you can
  /// rebuild field easily via call this method and
  /// avoid build whole form
  ///
  /// **model's all properties should be nullable**
  ///
  /// **the model's runtimetype must be  a child or same as  your custom [AbstractFieldState]'s generic model type**
  set model(E model);

  /// get current state model;
  E get model;

  /// update a model
  ///
  /// you needn't to call `model.copyWith(oldModel)` manually ,
  /// when you want to update something,just create a new model with the attributes
  /// you want to update,Forme will auto copy old model's attributes to new model
  ///
  /// ```
  /// FormeFieldController<FormeTextFieldModel> m;
  /// // update field's labelText to '123'
  /// m.update(FormeTextFieldModel(inputDecoration:InputDecoration(labelText:'123')));
  /// // update field's labelText size to 20, you won't lose labelText!
  /// m.update(FormeTextFieldModel(inputDecoration:InputDecoration(labelStyle:TextStyle(fontSize:20))));
  /// ```
  ///
  /// **update a null value will not work! if you update some attributes to null,use [set model] instead**
  void updateModel(E model);

  /// make current field visible in viewport
  Future<void> ensureVisible(
      {Duration? duration,
      Curve? curve,
      ScrollPositionAlignmentPolicy? alignmentPolicy,
      double? alignment});

  /// focus listenable
  ///
  /// it's lifecycle is same as field
  ///
  /// **do not use this notifier out of field,in this case , use [FormeController.fieldListenable] instead**
  ValueListenable<bool> get focusListenable;

  /// readOnly listenable
  ///
  /// useful update children items when readOnly state changes,
  ///  eg [FormeCupertinoSegmentedControl]
  ///
  /// will trigger when [Forme] or field's readOnly state changed
  ValueListenable<bool> get readOnlyListenable;

  /// model listenable
  ValueListenable<E> get modelListenable;

  static T of<T extends FormeFieldController>(BuildContext context) {
    return InheritedFormeFieldController.of(context) as T;
  }
}

abstract class FormeValueFieldController<T, E extends FormeModel>
    extends FormeFieldController<E> {
  /// get current value of valuefield
  T? get value;

  /// set field value
  set value(T? value);

  /// validate field , return errorText
  ///
  /// if [quietly] ,will not rebuild field and update and display error Text
  ///
  /// if [notify] , will trigger error listenable
  String? validate({bool quietly = false, bool notify = true});

  /// reset field
  void reset();

  /// get error
  ///
  /// error is null means this field has not validated yet
  ///
  /// if error is not null and [FormeValidateError.text] is null ,means field is valid
  ///
  /// if error is not null and [FormeValidateError.text] is not null ,means is invalid
  FormeValidateError? get error;

  /// get forme decorator controller
  FormeDecoratorController get decoratorController;

  /// get error listenable
  ///
  /// it's useful when you want to display error by your custom way!
  ///
  /// this notifier is used for [ValueListenableBuilder]
  ///
  /// **do not use this notifier out of field,in this case , use [FormeController.fieldListenable] instead**
  ValueListenable<FormeValidateError?> get errorTextListenable;

  /// get value listenable
  ///
  /// same as widget's onChanged , but it is more useful
  /// when you want to build a widget relies on field's value change
  ///
  /// eg: if you want to build a clear icon on textfield , but don't want to display it
  /// when textfield's value is empty ,you can do like this :
  ///
  /// ``` dart
  ///  return ValueListenableBuilder<String?>(
  ///         valueListenable:formeKey.valueField(name).valueListenable,
  ///         builder: (context, a, b) {
  ///           return a == null || a.length == 0
  ///               ? SizedBox()
  ///               : IconButton(icon:Icon(Icons.clear),onPressed:(){
  ///                 formeKey.valueField(name).value = '';
  ///               });
  ///         });
  /// ```
  ///
  /// this notifier is used for [ValueListenableBuilder]
  ///
  /// **do not use this notifier out of field,in this case , use [FormeController.fieldListenable] instead**
  ValueListenable<T?> get valueListenable;

  static T of<T extends FormeValueFieldController>(BuildContext context) {
    return InheritedFormeFieldController.of(context) as T;
  }

  /// clear value
  ///
  /// when field has multi widgets need to clear value (eg: [FormeAsyncAutocompleteText]) , use this method rather than
  /// call `value = null` directly
  ///
  /// @since 2.0.3
  void clearValue();

  /// get old field value
  ///
  /// **after field's value changed , when you need to get old field's value,
  /// you can use this method**
  T? get oldValue;
}

/// used to get field's listenable
///
/// unlike [FormeFieldController]'s listenable , this listenable's lifecycle is same as [Forme] and no need to care about widget order.
///
/// when field's type changed,(eg: from [FormeSingleCheckbox] to [FormeSingleSwitch]) , this listenable still works,
/// but [valueListenable] doesn't support generic type due to field's type may be changed at runtime
///
/// typically used with [ValueListenableBuilder]
///
/// **should not be used out of [Forme]**
abstract class FormeFieldListenable {
  /// get focuslistenable
  ValueListenable<bool> get focusListenable;

  /// get errorTextListenable
  ///
  /// if current field is not a [ValueField] ,this listenable will not be triggered always unless its type changed to  [ValueField]
  ValueListenable<FormeValidateError?> get errorTextListenable;

  /// get valueListenable
  ///
  /// if current field is not a [ValueField] ,this listenable will not be triggered always unless its type changed to  [ValueField]
  ValueListenable get valueListenable;

  /// get valueListenable
  ValueListenable<bool> get readOnlyListenable;

  /// get model listenable
  ValueListenable<FormeModel> get modelListenable;
}

/// used to control decorator's model
/// see  [ValueField.decoratorBuilder]
abstract class FormeDecoratorController {
  /// get current decorator model
  ///
  /// always return null if you don't update or set a decorator model yet
  FormeModel? get currentModel;

  /// update decorator model
  ///
  /// the model type is determined by type of FormeDecorator
  ///
  /// eg: [FormeInputDecorator]'s model type is [FormeInputDecoratorModel]
  update(FormeModel model);

  /// set decorator model
  ///
  /// the model type is determined by type of FormeDecorator
  ///
  /// eg: [FormeInputDecorator]'s model type is [FormeInputDecoratorModel]
  set model(FormeModel model);
}

abstract class FormeFieldControllerDelegate<E extends FormeModel>
    implements FormeFieldController<E> {
  FormeFieldController<E> get delegate;
  @override
  FormeController get formeController => delegate.formeController;
  @override
  E get model => delegate.model;
  @override
  set model(E model) => delegate.model = model;
  @override
  bool get readOnly => delegate.readOnly;
  @override
  set readOnly(bool readOnly) => delegate.readOnly = readOnly;
  @override
  ValueListenable<bool> get readOnlyListenable => delegate.readOnlyListenable;
  @override
  Future<void> ensureVisible(
          {Duration? duration,
          Curve? curve,
          ScrollPositionAlignmentPolicy? alignmentPolicy,
          double? alignment}) =>
      delegate.ensureVisible(
        duration: duration,
        curve: curve,
        alignmentPolicy: alignmentPolicy,
        alignment: alignment,
      );
  @override
  void requestFocus() => delegate.requestFocus();
  @override
  void unfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) =>
      delegate.unfocus(disposition: disposition);
  @override
  bool get hasFocus => delegate.hasFocus;
  @override
  String get name => delegate.name;
  @override
  void updateModel(E model) => delegate.updateModel(model);
  @override
  ValueListenable<bool> get focusListenable => delegate.focusListenable;
  @override
  ValueListenable<E> get modelListenable => delegate.modelListenable;
}

abstract class FormeValueFieldControllerDelegate<T, E extends FormeModel>
    extends FormeFieldControllerDelegate<E>
    implements FormeValueFieldController<T, E> {
  FormeValueFieldController<T, E> get delegate;

  @override
  T? get value => delegate.value;
  @override
  set value(T? value) => delegate.value = value;
  @override
  String? validate({bool quietly = false, bool notify = true}) =>
      delegate.validate(quietly: quietly, notify: notify);
  @override
  void reset() => delegate.reset();
  @override
  FormeValidateError? get error => delegate.error;
  @override
  FormeDecoratorController get decoratorController =>
      delegate.decoratorController;
  @override
  ValueListenable<FormeValidateError?> get errorTextListenable =>
      delegate.errorTextListenable;
  @override
  ValueListenable<T?> get valueListenable => delegate.valueListenable;
  @override
  void clearValue() => delegate.clearValue();
  @override
  T? get oldValue => delegate.oldValue;
}

/// forme validate error
///
/// if error is null , means not perform a validate yet (or reset)
///
/// if error is not null and text is null , means field is valid
///
/// if error is not null and text is not null , means field is not valid
class FormeValidateError {
  final String? text;
  bool get hasError => text != null;
  const FormeValidateError(this.text);

  @override
  int get hashCode => text.hashCode;
  @override
  bool operator ==(Object o) => o is FormeValidateError && o.text == text;
}

/// used to update a field
///
/// ```
/// FormeTextField(name:'text');
///
/// formeKey.field('text').updateModel(FormeTextFieldModel(decoration:InputDecoration('labelText':'New LabelText')))
/// ```
@immutable
abstract class FormeModel {
  const FormeModel();
  FormeModel copyWith(FormeModel old);
}

class EmptyStateModel extends FormeModel {
  EmptyStateModel._();
  static final EmptyStateModel model = EmptyStateModel._();
  factory EmptyStateModel() => model;

  @override
  FormeModel copyWith(FormeModel old) {
    return EmptyStateModel();
  }
}

/// share FormFieldController in sub tree
class InheritedFormeFieldController extends InheritedWidget {
  final FormeFieldController controller;
  const InheritedFormeFieldController(this.controller, Widget child)
      : super(child: child);
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static FormeFieldController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFormeFieldController>()!
        .controller;
  }

  static FormeFieldController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFormeFieldController>()
        ?.controller;
  }
}
