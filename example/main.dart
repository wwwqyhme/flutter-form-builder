import 'package:flutter/material.dart';
import 'package:forme/page/validate/custom_error_display.dart';
import 'page/page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forme',
      home: HomePage(),
      routes: {
        '/textfield': (context) => TextFieldPage(),
        '/timefield': (context) => TimeFieldPage(),
        '/datetimefield': (context) => DateTimeFieldPage(),
        '/daterangefield': (context) => DateRangeFieldPage(),
        '/numberfield': (context) => NumberFieldPage(),
        '/dropdownbutton': (context) => DropdownButtonFieldPage(),
        '/choicechip': (context) => ChoiceChipFieldPage(),
        '/filterchip': (context) => FilterChipFieldPage(),
        '/slider': (context) => SliderFieldPage(),
        '/rangeslider': (context) => RangeSliderFieldPage(),
        '/row': (context) => RowPage(),
        '/column': (context) => ColumnPage(),
        '/radiotile': (context) => RadioTileFieldPage(),
        '/checkboxtile': (context) => CheckboxTileFieldPage(),
        '/switchtile': (context) => SwitchTileFieldPage(),
        '/demo': (context) => DemoPage(),
        '/signup': (context) => SignupFormPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forme'),
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: Text('fields'),
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/textfield');
                  },
                  child: Text('FormeTextField')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/timefield');
                  },
                  child: Text('FormeTimeField')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/datetimefield');
                  },
                  child: Text('FormeDateTimeField')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/daterangefield');
                  },
                  child: Text('FormeDateRangeField')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/numberfield');
                  },
                  child: Text('FormeNumberField')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/dropdownbutton');
                  },
                  child: Text('FormeDropdown')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/choicechip');
                  },
                  child: Text('FormeChoiceChip')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/filterchip');
                  },
                  child: Text('FormeFilterChip')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/slider');
                  },
                  child: Text('FormeSlider')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/rangeslider');
                  },
                  child: Text('FormeRangeSlider')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/row');
                  },
                  child: Text('FormeRow')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/column');
                  },
                  child: Text('FormeColumn')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/radiotile');
                  },
                  child: Text('FormeRadioTile')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/checkboxtile');
                  },
                  child: Text('FormeCheckboxTile')),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckboxPage()));
                  },
                  child: Text('FormeSingleCheckbox')),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SwitchPage()));
                  },
                  child: Text('FormeSingleSwitch')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/switchtile');
                  },
                  child: Text('FormeSwitchTile')),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AsyncAutocompleteText()));
                  },
                  child: Text('FormeAsyncAutocompleteText')),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AutocompleteText()));
                  },
                  child: Text('FormeAutocompleteText')),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AsyncAutocompleteChip()));
                  },
                  child: Text('FormeAsyncAutocompleteChip')),
            ],
          ),
          ExpansionTile(
            title: Text('page'),
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/signup');
                  },
                  child: Text('Signup')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/demo');
                  },
                  child: Text('demo')),
            ],
          ),
          ExpansionTile(
            title: Text('validate'),
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManuallyValidatePage()));
                  },
                  child: Text('manually validate')),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomErrorDisplayPage()));
                  },
                  child: Text('custom error display')),
            ],
          ),
        ],
      ),
    );
  }
}
