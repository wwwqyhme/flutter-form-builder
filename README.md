## Screenshot

![screenshot](https://raw.githubusercontent.com/wwwqyhme/forme/main/ezgif-2-4c5414cc2d89.gif)

![screenshot2](https://raw.githubusercontent.com/wwwqyhme/forme/main/ezgif-3-fe95b1d8ade9.gif)

## Simple Usage

### add dependency

```
flutter pub add forme
```

### create forme

``` dart
FormeKey key = FormeKey();// formekey is a global key , also can be used to control form
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

## Differences Between Form and Forme

Forme is a form widget, but forme is not wrapped in a `Form`  , because I don't want to  refresh whole form after field's value changed or a validate performed , so it is a bit more complexable than `Form`.

|    Difference      |   Form   |  Forme   |
|  ----- |  ----- | ----- |
| AutovalidateMode | support both Form and field| only support field   |
| onChanged |   won't fired if value changed via `state.didChange` or `state.setValue`  | fired whenever field's value changed |
|   rebuild strategy      |  when field value changed or perform a validation on  field , all form fields will be rebuilded   |  only rebuild field that value changed or validated |

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
| onFocusChanged | false | `FormeFocusChanged` | listen field's focus change |
| model | true | `FormeModel` | `FormeModel` used to provider widget render data |
| onInitialed | false | `FormeFieldInitialed` | triggered when `FormeFieldController` initialed , when you specific a initialValue on `ValueField` or `Forme` , valueListenable will not listen this value , you can handle this value in `onInitialed` |

### attributes supported by all value fields

| Attribute |  Required  | Type | Description  |
| --- | --- | --- | --- |
| onValueChanged | false | `FormeValueChanged` | listen field's value change |
| onErrorChanged | false | `FormeErrorChanged` | listen field's errorText change |
| validator | false | `FormFieldValidator` | validate field's value |
| autovalidateMode | false | `AutovalidateMode` | auto validate mode , default is `AutovalidateMode.disabled`|
| initialValue | false | `dynamic` | initialValue,**can be overwritten by forme's initialValue**|
| onSaved | false | `FormFieldSetter` | triggered when call forme or field's save method|
| decoratorBuilder | false | `FormeDecoratorBuilder` | used to decorate a field |

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

## fields from other package

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

**you shouldn't use FormeValueFieldController's errorTextListenable  out of field ,use `FormfieldListenable.errorTextListenable` instead**

lifecycle of FormeValueFieldController's errorTextListenable  is same as field,when used it on another widget , `errorTextListenable` will disposed before removeListener , which will cause an error in debug mode

`FormfieldListenable` is from `formKey.fieldListenable(fieldName)`,it's lifecycle is same as `Forme`,  typically used to build a widget which is not a stateful field but relies on state  of field , eg: you want to display error of a field on a Text Widget

``` Dart
Column(
	children:[
		FormeTextField(validator:validator,name:name),
		Builder(builder:(context){
			return ValueListenableBuilder<FormeValidateError?>(
				valueListenable: formeKey.fieldListenable(name).errorTextListenable,
				build: (context,errorText,child){
					return errorText == null || errorText.isNotPresent ? SizedBox() : Text(errorText.value!);
				},
			);
		})
])
```

## listenable

there are five listenables in field 

1. focusListenable  
2. readOnlyListenable
3. errorTextListenable
4. valueListenable
5. modelListenable

### get listenable from FormeFieldController

you can get focusListenable and readOnlyListenable from `FormeFieldController`,
get valueListenable and errorTextListenable from `FormeValueFieldController`

these listenables lifecycle is same as field , so you can't use them out of field (you will get a `changenotifier was used after being disposed` error)

**right way use these listenables**

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

### get listenable from FormeController

you can get `FormeFieldListenable` via `FormeController.fieldListenable(String fieldName)` , this listenable's lifecycle is same as Forme ,it's safe to use it 
out of field but in Forme.

**FormeFieldListenable's valueListenable doesn't support generic type due to field's type may be changed at runtime though this shouldn't happend**

**when field disposed and recreated but name not changed, these listenables will continue listen this field**

### get listenable from FormeKey

you can get a `LazyFormeFieldListenable`  via `FormeKey.lazyFieldListenable(name)`.

`LazyFormeFieldListenable`'s behavior is same as `FormeFieldListenable`,the  difference is `LazyFormeFieldListenable` no need to wrap in a `Builder` or other widgets and not support `modelListenable`.

eg: 
``` Dart
Forme(
	key:formeKey,
	child:Column(
		children:[
			ValueListenableBuilder(valueListenable:formeKey.fieldListenable(name)),//will cause an error
			Builder(builder:(context){
				return ValueListenableBuilder(valueListenable:formeKey.fieldListenable(name));
			}),//will works
			ValueListenableBuilder(valueListenable:formeKey.lazyFieldListenable(name)),//will works
		]
	)
)
```

## validate

**validate is supported by FormeValidates**	

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

when you use validators from `FormeValidateUtils` , you must specific at least one errorText , otherwise errorText is an empty string

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

``` Dart
Map<FormeValueFieldController,String> errors = formKey.validate({bool quietly = false,bool notify = true});
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

### get a lazy FormeFieldListenable

``` Dart
FormeFieldListenable listenable = formeKey.lazyFieldListenable(String name);
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

``` Dart
String? errorText = valueField.validate({bool quietly = false,bool notify = true});
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