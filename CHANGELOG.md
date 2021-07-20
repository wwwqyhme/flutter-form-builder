## 2.5.2

1. `FormeController`'s `validate` method support `clearError` and `validateByOrder` params. if `clearError` is true , field error will be cleared before validate. if `validateByOrder` is true , will only validate one field at a time , and break validation chain  if any field validate not passed or failed

## 2.5.1

1. add `autovalidateByOrder` on `Forme` ,support validate form fields by order  , and stop validate further if validate failed
2. add a nullable attribute `order` on `BaseValueField`
3. `Future<Map<FormeValueFieldController, String>> validate({bool quietly = false})` changed to `  Future<FormeValidateSnapshot> validate({bool quietly = false, Set<String> names = const {}})`
4. ` Future<String?>? validate({bool quietly = false})` changed to `Future<FormeFieldValidateSnapshot<T>> validate({bool quietly = false})`
5. add `isValueChanged` method on `FormeController` , used to check whether form data changed after initialed

## 2.5.0

1. remove `onValueChanged`,`onErrorChanged`,`onFocusChanged`,`onInitialed`,`validator`,`autovalidateMode` on `Field` , they are moved to `FormeFieldListener` , `validator` is renamed to `onValidate` 
2. support `onAsyncValidate` and `asyncValidatorDebounce` on `FormeValueFieldListener` to support async validate
3. remove `fieldListenable` from `FormeFieldController`
4. remove `lazyFieldListenable` from `FormeKey`
5. `ValueField` is not a `FormField` any more
6. you can create a nonnull or nullable `ValueField` by `ValueField`'s generic type , eg:`ValueField<String>` is nonnull , but `ValueField<String?>` is nullable
7. remove `clearValue` from `FormeValueFieldController`
8. support 'autovalidateMode' on `Forme`

## 2.1.2

1. remove `buildTextSpan` from `FormeTextFieldController` , it cannot be compiled success before flutter 2.2.2

## 2.1.1

1. bug fix: can't get current field error in onValueChanged
2. `FormeSingleSwitch` & `FormeListTile` always use material switch
3. `FormeValidates` add `range` and `equals` vaidator

## 2.1.0

1. remove `Cupertino` fields ,they will be moved to another package
2. `FormeSlider` and `FormeRangeSlider` will perform validate in onChangeEnd ,not in onChange
3. `FormeTextField`'s controller can be cast to `FormeTextController`, set `TextEditingValue` and `Selection` is easily via this controller
4. `FormeValueFieldController` support `nextFocus` , used to focus next focusable widget
5. remove `beforeUpdateModel` from `AbstractFieldState` , you can do some logic in `afterUpdateModel`
6. `AbstractFieldState`'s didUpdateWidget will call `afterUpdateModel` by default
7. bug fix 

## 2.0.4+1

1. bug fix: timer in `FormeRawAutocomplete` will be cancelled in dispose !

## 2.0.4

1. add `modelListenable` on `FormeFieldController`
2. after value changed , you can get old value via `FormeValueFieldController`'s `oldValue`
3. validate method add parameter `notify` , used to determine  whether trigger `errorListenable`
4. `FormeAsnycAutocompleteChipModel` support `max` and `exceedCallback`.

## 2.0.3+1

1. bug fix: readOnlyNotifier will be disposed !

## 2.0.3

1. fields add `InputDecoration` and `maxLines` properties , used to quickly specific labelText or others
2. add `FormeAsyncAutocompleteChip`

## 2.0.2

1. add `FormeAutocompleteText`
2. add `FormeAsyncAutocompleteText`

## 2.0.1

1. StatefulField support `onInitialed` , used to listen `FormeFieldController` initialed
2. add `FormeValidateUtils`
3. bug fix : onErrorChanged and errorTextListenable not triggered in build 

## 2.0.0

forme is completely rewrite version of https://pub.dev/packages/form_builder much more powerful and won't break your layout