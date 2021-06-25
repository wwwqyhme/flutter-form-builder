import 'package:flutter/widgets.dart';
import 'package:forme/forme.dart';

/// a form field which can control visible of child
///
/// ``` dart
/// formeController.field(nameOfVisibleField).model = FormeVisibleModel(visible:true|false);
/// ```
class FormeVisible extends CommonField<FormeVisibleModel> {
  FormeVisible({
    required String name,
    required Widget child,
    FormeVisibleModel? model,
    Key? key,
  }) : super(
          key: key,
          name: name,
          model: model ?? FormeVisibleModel(),
          builder: (state) {
            bool visible = state.model.visible ?? true;
            return Visibility(
              child: child,
              maintainState: true,
              visible: visible,
            );
          },
        );
}

class FormeVisibleModel extends FormeModel {
  final bool? visible;
  FormeVisibleModel({this.visible});
  @override
  FormeVisibleModel copyWith(FormeModel oldModel) {
    FormeVisibleModel old = oldModel as FormeVisibleModel;
    return FormeVisibleModel(
      visible: visible ?? old.visible,
    );
  }
}
