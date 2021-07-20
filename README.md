[![CodeFactor](https://www.codefactor.io/repository/github/wwwqyhme/forme/badge)](https://img.shields.io/codefactor/grade/github/wwwqyhme/forme)
![license](https://img.shields.io/github/license/wwwqyhme/forme)
[![stars](https://img.shields.io/github/stars/wwwqyhme/forme?style=social)](https://github.com/wwwqyhme/forme)
[![PUB](https://img.shields.io/pub/v/forme?include_prereleases)](https://pub.dev/packages/forme)

## demo(web)

material_fields  
[https://wwwqyhme.github.io/forme/](https://wwwqyhme.github.io/forme/)

cupertino_fields  
[https://wwwqyhme.github.io/forme_cupertino/](https://wwwqyhme.github.io/forme_cupertino/)

## Screenshot

![screenshot](https://raw.githubusercontent.com/wwwqyhme/forme/main/forme_2.5.0_screenshot.gif)

## migrate from 2.1.x to 2.5.0

1. remove `onValueChanged`,`onErrorChanged`,`onFocusChanged`,`onInitialed`,`validator`,`autovalidateMode` on `Field` , they are moved to `FormeFieldListener` , `validator` is renamed to `onValidate` 
2. support `onAsyncValidate` and `asyncValidatorDebounce` on `FormeValueFieldListener` to support async validate
3. `validator` is renamed to `onValidate`
4. `onValidate` accept two params , the first is current controller , second is current value
5. remove `fieldListenable` from `FormeFieldController`
6. remove `lazyFieldListenable` from `FormeKey`
7. `ValueField` is not a `FormField` any more
8. you can create a nonnull or nullable `ValueField` by `ValueField`'s generic type , eg:`ValueField<String>` is nonnull , but `ValueField<String?>` is nullable
9. remove `clearValue` from `FormeValueFieldController`
10. support `comparator` on `ValueField` , which used to compare values before update field's value
11. support `autovalidateMode` on `Forme`

## Simple Usage

### add dependency

```
flutter pub add forme
```

### create forme

``` dart
FormeKey key = FormeKey();// formekey is a global key , also  used to control form
Widget child = formContent;
Widget forme = Forme(
	key:key,
	child:child,
)
```

## Forme Attributes

| Attribute |  Required  | Type | Description  |
| --- | --- | --- | --- |
| key | false | `FormeKey` | a global key, also used to control form |
| child | true | `Widget` | form content widget|
| readOnly | false | `bool` | whether form should be readOnly,default is `false` |
| onValueChanged | false | `FormeValueChanged` | listen form field's value change |
| initialValue | false | `Map<String,dynamic>` | initialValue , **will override FormField's initialValue** |
| onErrorChanged  | false | `FormeErrorChanged` | listen form field's errorText change  |
|onWillPop | false | `WillPopCallback` | Signature for a callback that verifies that it's OK to call Navigator.pop |
| quietlyValidate | false | `bool` | if this attribute is true , will not display default error text|
| onFocusChanged | false | `FormeFocusChanged` | listen form field's focus change |
| autovalidateMode| false | `AutovalidateMode` | auto validate form mode |
| autovalidateByOrder | false | `bool` | whether auto validate form by order |

## Forme Fields

### field type

```
-StatefulField
	- ValueField
	- CommonField
```

### attributes supported by all stateful fields

| Attribute |  Required  | Type | Description  |
| --- | --- | --- | --- |
| name | true | `String` | field's id,**should be unique in form** |
| builder | true | `FieldContentBuilder` | build field content|
| readOnly | false | `bool` | whether field should be readOnly,default is `false` |
| model | true | `FormeModel` | `FormeModel` used to provide widget render data |
| listener | false | `FormeFieldListener` |  user to listen `onInitialed`,`onFocusChanged`|


### attributes supported by all value fields

| Attribute |  Required  | Type | Description  |
| --- | --- | --- | --- |
| decoratorBuilder | false | `FormeDecoratorBuilder` | used to decorate a field |
| listener | false | `FormeValueFieldListenable` |  user to listen `onValueChanged`,`onErrorChanged`,`onValidate`,`onAsyncValidate`,`onSaved`|
| order | false | int | field order |

### currently supported fields

| Name | Return Value | Nullable|
| ---| ---| --- |
| FormeTextField|  string | false |
| FormeDateTimeField|  DateTime | true |
| FormeNumberField|  num | true |
| FormeTimeField | TimeOfDay | true | 
| FormeDateRangeField | DateTimeRange | true | 
| FormeSlider|  double | false |
| FormeRangeSlider|  RangeValues | false|
| FormeFilterChip|  List&lt; T&gt; | false |
| FormeChoiceChip|  T | true |
| FormeSingleCheckbox| bool | false |
| FormeSingleSwitch| bool | false |
| FormeDropdownButton | T | true | 
| FormeListTile|  List&lt; T&gt; | false |
| FormeRadioGroup|  T | true |
| FormeAsnycAutocompleteChip | List&lt;T&gt; | false |
| FormeAsnycAutocompleteText | T | true |
| FormeAutocompleteText | T | true |

## fields from other packages

1. [forme_cupertino_fields](https://pub.dev/packages/forme_cupertino_fields) cupertino style fields

## Forme Model

you can update a widget easily with `FormeModel`

eg: if you want to update labelText of a FormeTextField, you can do this :

``` Dart
FormeFieldController controller = formKey.field(fieldName);
controller.update(FormeTextFieldModel(decoration:InputDecoration(labelText:'New Label')));
```

if you want to update items of FormeDropdownButton:

``` Dart
controller.updateModel(FormeDropdownButtonModel<String>(
	icon: SizedBox(
	width: 14,
	height: 14,
	child: CircularProgressIndicator(),
)));
Future<List<DropdownMenuItem<String>>> future =
	Future.delayed(Duration(seconds: 2), () {
	return FormeUtils.toDropdownMenuItems(
		['java', 'dart', 'c#', 'python', 'flutter']);
	});
future.then((value) {
controller.updateModel(FormeDropdownButtonModel<String>(
	icon: Icon(Icons.arrow_drop_down), items: value));
});
```

**update model will auto copywith old model's attribute**


## Custom way display error text

if default error text display can not fit your needs , you can implementing a custom error display via `ValueField`'s `onErrorChanged` or `FormeValueFieldController`'s  `errorTextListenable`

**don't forget to set Forme's quieltyValidate attribute to true**

### via onErrorChanged

`onErrorChanged` will triggered whenever errorText of field changes , it is suitable when you want to update a stateful field according to error state of field 

eg: change border color when error state changes

``` Dart
FormeTextField(
	validator: validator,
	onErrorChanged: (m, a) {
		InputBorder border = OutlineInputBorder(
				borderRadius: BorderRadius.circular(30.0),
				borderSide: BorderSide(color: a == null ? Colors.green : Colors.red, width: 1));
		m.updateModel(FormeTextFieldModel(
			decoration: InputDecoration(
				focusedBorder: border, enabledBorder: border)));
	},
),
```

### via errorTextListenable

`errorTextListenable` is more convenient than `onErrorChanged` sometimes.

eg: when your want to display an valid or invalid suffix icon according to error state of field, in `onErrorChanged` , update model will rebuild whole field,
but with `errorTextListenable`, you can only rebuild the suffix icon, below is an example to do this:

``` dart
suffixicon: Builder(
	builder: (context) {
		FormeValueFieldController<String, FormeModel>
			controller = FormeFieldController.of(context);
		return ValueListenableBuilder<FormeValidateError?>(
			valueListenable: controller.errorTextListenable,
			child: const IconButton(
				onPressed: null,
				icon: const Icon(
				Icons.check,
				color: Colors.green,
				)),
			builder: (context, errorText, child) {
			if (errorText == null)
				return SizedBox();
			else
				return errorText.isPresent
					? const IconButton(
						onPressed: null,
						icon: const Icon(
						Icons.error,
						color: Colors.red,
						))
					: child!;
			});
	},
),
```

## listenable

there are five listenables in field 

1. focusListenable  
2. readOnlyListenable
3. errorTextListenable
4. valueListenable
5. modelListenable

### get listenable 

you can get focusListenable and readOnlyListenable from `FormeFieldController`,
get valueListenable and errorTextListenable from `FormeValueFieldController`

``` Dart
FormeTextField(
	decoratorBuilder:FormeDecoratorBuilder(),//decorator is a part of field 
	mode:FormeTextFieldModel(
		decoration:InputDecoration(
			suffixIcon: Builder(builder: (context) {
				FormeFieldController controller = FormeFieldController.of(context);
				return ValueListenable<bool>(valueListenable:controller.		valueListenable,builder:(context,focus,child){
					if(focus) return Icon(Icons.clear);
					return SizedBox();
				})
			}),
		),
	),
)
```


## validate

### sync validate

**sync validate is supported by FormeValidates**	

| Validator Name |  Support Type  | When Valid |  When Invalid  |
| --- | --- | --- | --- |
| `notNull` | `dynamic` | value is not null | value is null |
| `size` | `Iterable` `Map` `String` | 1. value is null 2. max & min is null  3. String's length or Collection's size  is in [min,max] | String's length or Collection's size is not in [min,max] |
| `min` | `num` | 1. value is null  2. value is bigger than min | value is smaller than min |
| `max` | `num` | 1. value is null  2. value is smaller than max |  value is bigger than max |
| `notEmpty` | `Iterable` `Map` `String` | 1. value is not null 2. String's length or Collection's size  is bigger than zero | 1. value is null 2. String's length or Collection's size  is  zero |
| `notBlank` | `String` | 1. value is null 2. value.trim()'s length is not null |  value'length is zero after trimed |
| `positive` | `num` | 1. value is null 2. value is bigger than zero |  value  is smaller than or equals zero |
| `positiveOrZero` | `num` | 1. value is null 2. value is bigger than or equals zero |  value  is smaller than zero |
| `negative` | `num` | 1. value null 2. value is smaller than zero |  value  is bigger than or equals zero |
| `negativeOrZero` | `num` | 1. value  null 2. value is smaller than or equals zero |  value  is bigger than zero |
| `pattern`  | `String` | 1. value null 2. value matches pattern  |  value does not matches pattern |
| `email`  | `String` | 1. value null 2. value is a valid email  |  value is not a valid email |
| `url`  | `String` | 1. value is null 2. value is empty or value is a valid url  |  value is not a valid url |
| `range`  | `num` | 1. value null 2. value is in range  |  value is out of range |
| `equals`  | `dynamic` | 1. value null 2. value is equals target value  |  value is not equals target value |
| `any`  | `T` | any validators is valid  |  every validators is invalid |
| `all`  | `T` | all validators is valid  |  any validators is invalid |

when you use validators from `FormeValidates` , you must specific at least one errorText , otherwise errorText is an empty string

### async validated

async validator is supported after Forme 2.5.0 , you can specific an `onAsyncValidate` on `ValueField`'s listener , the unique difference
between `onValidate` and `onAsyncValidate` is `onAsyncValidate` return a `Future<String>` and `onValidate` return a `String`

#### when to perform a asyncValidator

if `ValueField.autovalidateMode` is `AutovalidateMode.disabled` , asyncValidator will never be performed unless you call `validate` from `FormeValueFieldController` manually.

if you specific both `onValidate` and `onAsyncValidate` , `onAsyncValidate` will only be performed after `onValidate` return null.

**after successful performed an async validator , async validator will not performed any more until field's value changed**

#### debounce

you can specific a debounce on `FormeValueFieldListener` , **debounce will not worked when you manually call `validate` on `FormeValueFieldController`**

## FormeKey Methods

### whether form has a name field

``` Dart
bool hasField = formeKey.hasField(String name);
```

### whether current form is readOnly

``` Dart
bool readOnly = formeKey.readOnly;
```

### set readOnly 

``` Dart
formeKey.readOnly = bool readOnly;
```

### get field's controller

``` Dart
T controller = formeKey.field<T extends FormeFieldController>(String name);
```

### get value field's controller

``` Dart
T controller = formeKey.valueField<T extends FormeValueFieldController>(String name);
```

### get form data

``` Dart
Map<String, dynamic> data = formeKey.data;
```

### validate

**since 2.5.0 , this method will return a Future ranther than a Map** 

``` Dart
Future<FormeValidateSnapshot> future = formKey.validate({bool quietly = false,Set<String> names = const {},
bool clearError = false,
bool validateByOrder = false,
});
```

### set form data

``` Dart
formeKey.data = Map<String,dynamic> data;
```

### reset form

``` Dart
formeKey.reset();
```

### save form

``` Dart
formeKey.save();
```

### whether validate is quietly

``` Dart
bool quietlyValidate = formKey.quietlyValidate;
```

### set quietlyValidate

``` Dart
formeKey.quieltyValidate = bool quietlyValidate;
```

### is value changed after initialed

``` Dart
bool isChanged = formeKey.isValueChanged
```

### get all field controllers

``` Dart
List<FormeFieldController> controllers = formeKey.controllers;
```

## Forme Field Methods

### get forme controller

``` Dart
FormeController formeController = field.formeController;
```

### get field's name

``` Dart
String name = field.name
```

### whether current field is readOnly

``` Dart
bool readOnly = field.readOnly;
```

### set readOnly on field

``` Dart
field.readOnly = bool readOnly;
```

### whether current field is focused

``` Dart
bool hasFocus = field.hasFocus;
```

### focus|unfocus current Field

``` Dart
field.requestFocus();
field.unfocus();
```

### focus next

``` Dart
field.nextFocus();
```

### set field model

``` Dart
field.model = FormeModel model;
```

### update field model

``` Dart
field.updateModel(FormeModel model);
```

### get field model

``` Dart
FormeModel model = field.model;
```

### ensure field is visible in viewport

``` Dart
Future<void> result = field.ensureVisibe({Duration? duration,
      Curve? curve,
      ScrollPositionAlignmentPolicy? alignmentPolicy,
      double? alignment});
```

### get focusListenable

``` Dart
ValueListenable<bool> focusListenable = field.focusListenable;
```

### get readOnlyListenable

``` Dart
ValueListenable<bool> readOnlyListenable = field.readOnlyListenable;
```

### get modelListenable

``` Dart
ValueListenable<FormeModel> modelListenable = field.modelListenable;
```

## Forme Value Field Methods

**FormeValueFieldController is extended FormeFieldController**

### get field value

``` Dart
dynamic value = valueField.value;
```

### set field value

``` Dart
valueField.value = dynamic data;
```

### reset field

``` Dart
valueField.reset();
```

### validate field

**since 2.5.0 , this method will return a Future ranther than a String** 

``` Dart
Future<FormeFieldValidateSnapshot> future = valueField.validate({bool quietly = false});
```

### get error

``` Dart
FormeValidateError? error = valueField.error;
```

### get decorator controller

``` Dart
FormeDecoratorController decoratorController = valueField.decoratorController;
```

### get errorTextListenable

``` Dart
ValueListenable<FormeValidateError?>  errorTextListenable = valueField.errorTextListenable;
```

### get valueListenable

``` Dart
ValueListenable<dynamic> valueListenable = valueField.valueListenable;
```

### get oldValue

``` Dart
dynamic value = valueField.oldValue;
```

### is value changed

``` Dart
bool isChanged = valueField.isValueChanged
```

## build your field

1. create your `FormeModel` , if you don't need it , use `FormeEmptyModel` instead
2. create your `ValueField<T,E>` ,  T is your field return value's type, E is your `FormeModel`'s type
3. if you want to create your custom `State`,extends `ValueFieldState<T,E>`

links below is some examples to help you to build your field

### common field

1. https://github.com/wwwqyhme/forme/blob/main/lib/src/field/forme_visible.dart
2. https://github.com/wwwqyhme/forme/blob/main/lib/src/field/forme_flex.dart

### value field

1. https://github.com/wwwqyhme/forme/blob/main/lib/src/field/forme_filter_chip.dart
2. https://github.com/wwwqyhme/forme/blob/main/lib/src/field/forme_radio_group.dart