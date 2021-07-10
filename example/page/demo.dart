import 'dart:math';

import 'package:flutter/material.dart';

import 'package:forme/forme.dart';

import 'page.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final FormeKey formKey = FormeKey();

  static const List<User> _userOptions = <User>[
    User(name: 'Alice', email: 'alice@example.com'),
    User(name: 'Bob', email: 'bob@example.com'),
    User(name: 'Charlie', email: 'charlie123@gmail.com'),
  ];
  @override
  void initState() {
    super.initState();
  }

  void toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  FormeChipItem<String> _buildItem(String label, Color color) {
    return FormeChipItem<String>(
      data: label,
      labelPadding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.white70,
        child: Text(label[0].toUpperCase()),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('form'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: createForm(),
            ),
            // for using snackbar here
            Builder(builder: (context) => createButtons(context)),
          ]),
        ));
  }

  Widget createButtons(BuildContext context) {
    Wrap buttons = Wrap(
      children: [
        Builder(
          builder: (context) {
            return TextButton(
                onPressed: () {
                  formKey.readOnly = !formKey.readOnly;
                  (context as Element).markNeedsBuild();
                },
                child: Text(formKey.readOnly
                    ? 'set form editable'
                    : 'set form readonly'));
          },
        ),
        //sliderVisible
        Builder(builder: (context) {
          FormeFieldController controller = formKey.field('sliderVisible');
          bool visible =
              (controller.model as FormeVisibleModel).visible ?? true;
          return TextButton(
              onPressed: () {
                controller.model = FormeVisibleModel(visible: !visible);
                (context as Element).markNeedsBuild();
              },
              child: Text(
                visible ? 'hide slider' : 'show slider',
              ));
        }),
        TextButton(
            onPressed: () {
              setState(() {});
            },
            child: Text('rebuild page')),
        TextButton(
            onPressed: () async {
              Map<FormeValueFieldController, String> errorMap =
                  await formKey.validate(quietly: false);
              if (errorMap.isNotEmpty) {
                MapEntry<FormeValueFieldController, String> entry =
                    errorMap.entries.first;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(entry.value),
                  backgroundColor: Colors.red,
                ));
                FormeFieldController formeFieldController = entry.key;
                formeFieldController.ensureVisible().then((value) {
                  formeFieldController.requestFocus();
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('congratulations! no validate error found!'),
                  backgroundColor: Colors.green,
                ));
              }
            },
            child: Text('validate')),
        TextButton(
            onPressed: () {
              formKey.reset();
            },
            child: Text('reset')),
        TextButton(
          onPressed: () {
            print(formKey.data);
          },
          child: Text('get form data'),
        ),
        TextButton(
          onPressed: () {
            FormeFlexModel model =
                formKey.field('column').model as FormeFlexModel;
            formKey.field('column').model = model.append(FormeNumberField(
              name: Random.secure().nextDouble().toString(),
              decoration: const InputDecoration(),
            ));
          },
          child: Text('append field into dynamic column'),
        ),
        TextButton(
          onPressed: () {
            FormeFlexModel model =
                formKey.field('column').model as FormeFlexModel;
            formKey.field('column').model = model.prepend(FormeNumberField(
              name: Random.secure().nextDouble().toString(),
              model: FormeNumberFieldModel(
                textFieldModel: FormeTextFieldModel(
                  decoration: InputDecoration(
                    labelText: '456',
                  ),
                ),
              ),
            ));
          },
          child: Text('prepend field into dynamic column'),
        ),
        TextButton(
          onPressed: () {
            FormeFlexModel model =
                formKey.field('column').model as FormeFlexModel;
            formKey.field('column').model = model.swap(0, 1);
          },
          child: Text('swap first and second'),
        ),

        TextButton(
          onPressed: () {
            FormeFlexModel model =
                formKey.field('column').model as FormeFlexModel;
            formKey.field('column').model = model.remove(0);
          },
          child: Text('remove first'),
        ),

        TextButton(
          onPressed: () {
            FormeFlexModel model =
                formKey.field('column').model as FormeFlexModel;
            formKey.field('column').model = model.append(
              FormeRow(children: [], name: 'row'),
            );
          },
          child: Text('append a dynamic row'),
        ),
        TextButton(
          onPressed: () {
            FormeFlexModel model = formKey.field('row').model as FormeFlexModel;
            formKey.field('row').model = model.append(FormeSingleCheckbox(
                name: Random.secure().nextDouble().toString()));
          },
          child: Text('append field into dynamic row'),
        ),
      ],
    );
    return buttons;
  }

  Widget createForm() {
    Widget child = Column(
      children: [
        Row(children: [
          Expanded(
            child: FormeTextField(
              name: 'text',
              listener: FormeValueFieldListener(
                onFocusChanged: (field, hasFocus) {
                  field.updateModel(FormeTextFieldModel(
                      decoration:
                          InputDecoration(labelText: 'Focus:$hasFocus')));
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onValidate:
                    FormeValidates.size(min: 5, errorText: 'at least 5 length'),
                onAsyncValidate: (f, value) {
                  return Future.delayed(Duration(seconds: 2), () {
                    return value.length <= 10
                        ? 'length must bigger than 10,current is ${value.length} '
                        : null;
                  });
                },
              ),
              decoration: InputDecoration(
                labelText: 'Text',
                suffixIconConstraints: BoxConstraints.tightFor(),
                suffixIcon: FormeValueFieldBuilder(
                  builder: (context, controller) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              controller.value = '';
                            },
                            icon: Icon(Icons.clear)),
                        ValueListenableBuilder<FormeValidateError?>(
                          valueListenable: controller.errorTextListenable,
                          builder: (context, error, child) {
                            if (error == null) return SizedBox.shrink();
                            if (error.validating)
                              return CircularProgressIndicator.adaptive();
                            return !error.valid
                                ? Icon(Icons.check)
                                : Icon(Icons.error);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          FormeSingleCheckbox(name: 'checkbox'),
          FormeSingleSwitch(name: 'switch'),
        ]),
        FormeNumberField(
          name: 'number',
          decoration: InputDecoration(labelText: 'Number'),
          model: FormeNumberFieldModel(
            max: 100,
            decimal: 2,
          ),
        ),
        FormeTextFieldOnTapProxyWidget(
          child: FormeDateRangeField(
            name: 'dateRange',
            decoration: InputDecoration(
              labelText: 'Date Range',
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => formKey.valueField('dateRange').value = null,
              ),
            ),
          ),
        ),
        FormeTextFieldOnTapProxyWidget(
          child: FormeDateTimeField(
            name: 'datetime',
            decoration: InputDecoration(
              labelText: 'DateTime',
              prefixIcon: FormeValueFieldBuilder(
                builder: (context, controller) {
                  return IconButton(
                      icon: Icon(Icons.tab),
                      onPressed: () {
                        controller.updateModel(FormeDateTimeFieldModel(
                          type: FormeDateTimeFieldType.DateTime,
                        ));
                        toast(
                            context, 'field type has been changed to DateTime');
                      });
                },
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => formKey.valueField('datetime').value = null,
              ),
            ),
          ),
        ),
        FormeTextFieldOnTapProxyWidget(
          child: FormeTimeField(
            name: 'time',
            decoration: InputDecoration(
              labelText: 'Time',
              suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    formKey.valueField('time').value = null;
                  }),
            ),
          ),
        ),
        FormeDropdownButton<String>(
          items: [],
          model: FormeDropdownButtonModel<String>(
            icon: InkWell(
              child: Icon(
                Icons.local_dining,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () async {
                FormeValueFieldController controller =
                    formKey.valueField('dropdown');
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
                      icon: Row(
                        children: [
                          InkWell(
                            child: Icon(Icons.clear),
                            onTap: () {
                              formKey.valueField('dropdown').value = null;
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                      items: value));
                });
              },
            ),
          ),
          decoration: InputDecoration(labelText: 'Dropdown'),
          name: 'dropdown',
          listener: FormeValueFieldListener(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onValidate:
                FormeValidates.notNull(errorText: 'pls select one item!'),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        FormeFilterChip<String>(
          name: 'filterChip',
          decoration: InputDecoration(labelText: 'Filter Chip'),
          items: [
            _buildItem('Gamer', Colors.cyan),
            _buildItem('Hacker', Colors.cyan),
            _buildItem('Developer', Colors.cyan),
          ],
        ),
        FormeChoiceChip<String>(
          decoration: InputDecoration(labelText: 'Choice Chip'),
          name: 'choiceChip',
          items: [
            _buildItem('Gamer', Color(0xFFff6666)),
            _buildItem('Hacker', Color(0xFF007f5c)),
            _buildItem('Developer', Color(0xFF5f65d3)),
            _buildItem('Racer', Color(0xFF19ca21)),
            _buildItem('Traveller', Color(0xFF60230b)),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        FormeVisible(
          name: 'sliderVisible',
          child: FormeSlider(
            decoration: InputDecoration(labelText: 'Slider'),
            listener: FormeValueFieldListener(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onValidate: FormeValidates.min(50,
                  errorText: 'value must bigger than 50'),
            ),
            name: 'slider',
            min: 0,
            max: 100,
            model: FormeSliderModel(
              labelRender: (value) => value.round().toString(),
              sliderThemeData: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.red[700],
                inactiveTrackColor: Colors.red[100],
                trackShape: RoundedRectSliderTrackShape(),
                trackHeight: 4.0,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                thumbColor: Colors.redAccent,
                overlayColor: Colors.red.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                tickMarkShape: RoundSliderTickMarkShape(),
                activeTickMarkColor: Colors.red[700],
                inactiveTickMarkColor: Colors.red[100],
                valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: Colors.redAccent,
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        FormeRangeSlider(
          decoration: InputDecoration(labelText: 'Range Slider'),
          name: 'rangeSlider',
          min: 1,
          max: 100,
        ),
        FormeRadioGroup<String>(
          decoration: InputDecoration(labelText: 'Radio Group'),
          items: FormeUtils.toFormeListTileItems(['1', '2', '3', '4'],
              style: Theme.of(context).textTheme.subtitle1),
          name: 'radioGroup',
          model: FormeRadioGroupModel(
            radioRenderData: FormeRadioRenderData(
              activeColor: Color(0xFF6200EE),
            ),
            split: 2,
          ),
          listener: FormeValueFieldListener(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onValidate: FormeValidates.equals('2', errorText: 'pls select 2'),
          ),
        ),
        FormeListTile<String>(
          decoration: InputDecoration(labelText: 'Checkbox Tile'),
          items: [
            FormeListTileItem(
                title: Text("Checkbox 1"),
                subtitle: Text("Checkbox 1 Subtitle"),
                secondary: OutlinedButton(
                  child: Text("Say Hi"),
                  onPressed: () {
                    formKey
                        .valueField('checkboxTile')
                        .decoratorController
                        .update(
                          FormeInputDecoratorModel(
                              decoration: InputDecoration(labelText: 'xxx')),
                        );
                  },
                ),
                data: 'Checkbox 1'),
            FormeListTileItem(
                title: Text("Checkbox 1"),
                subtitle: Text("Checkbox 1 Subtitle"),
                secondary: IconButton(
                  icon: Icon(Icons.ac_unit),
                  onPressed: () {},
                ),
                data: 'Checkbox 2'),
          ],
          name: 'checkboxTile',
          type: FormeListTileType.Checkbox,
          model: FormeListTileModel(
              split: 1,
              listTileRenderData: FormeListTileRenderData(
                contentPadding: EdgeInsets.zero,
              ),
              checkboxRenderData: FormeCheckboxRenderData(
                activeColor: Colors.transparent,
                checkColor: Colors.green,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )),
        ),
        FormeListTile<String>(
          decoration: InputDecoration(labelText: 'Switch Tile'),
          name: 'switchTile',
          type: FormeListTileType.Switch,
          items: FormeUtils.toFormeListTileItems(['1', '2'],
              controlAffinity: ListTileControlAffinity.trailing),
          model: FormeListTileModel(
            split: 1,
          ),
        ),
        FormeAutocompleteText<User>(
          optionsBuilder: (v) {
            if (v.text == '') {
              return Iterable.empty();
            }
            return _userOptions.where((User option) {
              return option.toString().contains(v.text.toLowerCase());
            });
          },
          decoration: InputDecoration(labelText: 'Autocomplete Text'),
          name: 'autocomplete',
          listener: FormeValueFieldListener(
            onValidate: FormeValidates.notNull(errorText: 'pls select one'),
          ),
        ),
        FormeAsnycAutocompleteText<User>(
          optionsBuilder: (v) {
            if (v.text == '') {
              return Future.delayed(Duration.zero, () {
                return Iterable.empty();
              });
            }
            return Future.delayed(Duration(milliseconds: 800), () {
              return _userOptions.where((User option) {
                return option.toString().contains(v.text.toLowerCase());
              });
            });
          },
          decoration: InputDecoration(
              labelText: 'Async Autocomplete Text',
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.clear),
              )),
          model: FormeAsyncAutocompleteTextModel<User>(
              emptyOptionBuilder: (context) {
                return Text('no options found');
              },
              textFieldModel: FormeTextFieldModel(
                maxLines: 1,
              )),
          name: 'asyncAutocomplete',
          listener: FormeValueFieldListener(
            onValidate: FormeValidates.notNull(errorText: 'pls select one'),
          ),
        ),
        FormeAsnycAutocompleteChip<User>(
          optionsBuilder: (v) {
            if (v.text == '') {
              return Future.delayed(Duration.zero, () {
                return Iterable.empty();
              });
            }
            return Future.delayed(Duration(seconds: 8), () {
              return _userOptions.where((User option) {
                return option.toString().contains(v.text.toLowerCase());
              });
            });
          },
          decoration: InputDecoration(labelText: 'Autocomplete Chip'),
          name: 'autocompleteChip',
          listener: FormeValueFieldListener(
            onValidate: FormeValidates.notEmpty(errorText: 'pls select one'),
          ),
          model: FormeAsyncAutocompleteChipModel<User>(
            emptyOptionBuilder: (context) => Text('empty'),
          ),
        ),
        FormeColumn(
          name: 'column',
          children: [],
        ),
      ],
    );
    return Forme(
      child: child,
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onValueChanged: (a, b) {
        print(
            '${a.name}\'s value changed ... value: $b ... old value: ${a.oldValue}');
      },
      onErrorChanged: (a, b) {
        print('${a.name} ... error: ${b?.text}');
      },
      onFocusChanged: (a, b) {
        print('${a.name} ... focus: $b');
      },
      initialValue: {
        'text': '123',
        'number': 25,
        'dateRange': DateTimeRange(
            start: DateTime.now(), end: DateTime.now().add(Duration(days: 30))),
        'datetime': DateTime.now(),
        'time': TimeOfDay(hour: 12, minute: 12),
        'filterChip': ['Gamer'],
        'choiceChip': 'Gamer',
        'slider': 40.0,
        'rangeSlider': RangeValues(1.0, 10.0),
        'switchTile': ['1'],
        'testSlider': 0.0,
        'segmentedControl': 'A',
        'segmentedSlidingControl': 'B',
        'radioGroup': '1',
        'checkboxTile': ['Checkbox 2'],
        'asyncAutocomplete': _userOptions[0],
      },
    );
  }
}
