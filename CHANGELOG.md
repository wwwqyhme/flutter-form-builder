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