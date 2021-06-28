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