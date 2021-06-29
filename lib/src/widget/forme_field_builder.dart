import 'package:flutter/widgets.dart';
import 'package:forme/forme.dart';

class FormeFieldBuilder<E extends FormeModel> extends StatelessWidget {
  final Widget Function(
      BuildContext context, FormeFieldController<E> controller) builder;
  const FormeFieldBuilder({Key? key, required this.builder}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    FormeFieldController<E> controller = FormeFieldController.of(context);
    return builder(context, controller);
  }
}

class FormeValueFieldBuilder<T, E extends FormeModel> extends StatelessWidget {
  final Widget Function(
      BuildContext context, FormeValueFieldController<T, E> controller) builder;
  const FormeValueFieldBuilder({Key? key, required this.builder})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    FormeValueFieldController<T, E> controller =
        FormeFieldController.of(context);
    return builder(context, controller);
  }
}
