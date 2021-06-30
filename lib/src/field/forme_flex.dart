import 'package:flutter/widgets.dart';
import 'package:forme/forme.dart';

class FormeColumn extends _FormeFlex {
  FormeColumn({
    required List<Widget> children,
    FormeFlexRenderData? formeFlexRenderData,
    required String name,
  }) : super(
          name: name,
          children: children,
          formeFlexRenderData: formeFlexRenderData,
          builder: (field) {
            _FormeFlexState state = field as _FormeFlexState;
            FormeFlexRenderData? renderData = state.model.formeFlexRenderData;
            return Column(
              children: state.model._widgets,
              mainAxisAlignment:
                  renderData?.mainAxisAlignment ?? MainAxisAlignment.start,
              mainAxisSize: renderData?.mainAxisSize ?? MainAxisSize.max,
              crossAxisAlignment:
                  renderData?.crossAxisAlignment ?? CrossAxisAlignment.center,
              verticalDirection:
                  renderData?.verticalDirection ?? VerticalDirection.down,
              textDirection: renderData?.textDirection,
              textBaseline: renderData?.textBaseline,
            );
          },
        );
}

class FormeRow extends _FormeFlex {
  FormeRow({
    required List<Widget> children,
    FormeFlexRenderData? formeFlexRenderData,
    required String name,
  }) : super(
          name: name,
          children: children,
          formeFlexRenderData: formeFlexRenderData,
          builder: (field) {
            _FormeFlexState state = field as _FormeFlexState;
            FormeFlexRenderData? renderData = state.model.formeFlexRenderData;
            return Row(
              children: state.model._widgets,
              mainAxisAlignment:
                  renderData?.mainAxisAlignment ?? MainAxisAlignment.start,
              mainAxisSize: renderData?.mainAxisSize ?? MainAxisSize.max,
              crossAxisAlignment:
                  renderData?.crossAxisAlignment ?? CrossAxisAlignment.center,
              verticalDirection:
                  renderData?.verticalDirection ?? VerticalDirection.down,
              textDirection: renderData?.textDirection,
              textBaseline: renderData?.textBaseline,
            );
          },
        );
}

abstract class _FormeFlex extends CommonField<FormeFlexModel> {
  final List<Widget> children;

  _FormeFlex({
    required String name,
    FormeFlexRenderData? formeFlexRenderData,
    required this.children,
    required Widget Function(CommonFieldState<FormeFlexModel>) builder,
  }) : super(
            name: name,
            builder: builder,
            model:
                FormeFlexModel._([], formeFlexRenderData: formeFlexRenderData));

  @override
  _FormeFlexState createState() => _FormeFlexState();
}

class _FormeFlexState extends CommonFieldState<FormeFlexModel> {
  late List<_FormeFlexWidget> widgets;

  @override
  void initState() {
    super.initState();
    widgets = (widget as _FormeFlex).children.map((e) {
      return _FormeFlexWidget(e, GlobalKey());
    }).toList();
  }

  @override
  FormeFlexModel get model {
    return FormeFlexModel._(List.of(widgets));
  }

  @override
  void afterUpdateModel(FormeFlexModel old, FormeFlexModel current) {
    widgets.clear();
    widgets.addAll(current._widgets);
  }
}

class _FormeFlexWidget extends StatelessWidget {
  final Widget child;
  const _FormeFlexWidget(this.child, GlobalKey key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class FormeFlexModel extends FormeModel {
  final List<_FormeFlexWidget> _widgets;
  final FormeFlexRenderData? formeFlexRenderData;

  FormeFlexModel._(this._widgets, {this.formeFlexRenderData});

  FormeFlexModel prepend(Widget widget) {
    _widgets.insert(0, _FormeFlexWidget(widget, GlobalKey()));
    return this;
  }

  FormeFlexModel append(Widget widget) {
    _widgets.add(_FormeFlexWidget(widget, GlobalKey()));
    return this;
  }

  FormeFlexModel remove(int index) {
    _rangeCheck(index);
    _widgets.removeAt(index);
    return this;
  }

  FormeFlexModel insert(int index, Widget widget) {
    if (index == 0) {
      return prepend(widget);
    }
    if (index == _widgets.length) {
      return append(widget);
    }
    if (index < 1 || index > _widgets.length - 1) {
      throw 'index out of range , range is [0,${_widgets.length}]';
    }
    _widgets.insert(index, _FormeFlexWidget(widget, GlobalKey()));
    return this;
  }

  FormeFlexModel swap(int oldIndex, int newIndex) {
    _rangeCheck(oldIndex);
    _rangeCheck(newIndex);
    if (oldIndex == newIndex) throw 'oldIndex must not equals newIndex';
    _FormeFlexWidget oldWidget = _widgets.removeAt(oldIndex);
    _widgets.insert(newIndex, oldWidget);
    return this;
  }

  FormeFlexModel renderData(FormeFlexRenderData renderData) {
    return FormeFlexModel._(_widgets, formeFlexRenderData: renderData);
  }

  _rangeCheck(int index) {
    if (index < 0 || index > _widgets.length - 1) {
      throw 'index out of range , range is [0,${_widgets.length - 1}]';
    }
  }

  @override
  FormeModel copyWith(
    FormeModel oldModel,
  ) {
    FormeFlexModel old = oldModel as FormeFlexModel;
    return FormeFlexModel._(_widgets,
        formeFlexRenderData: FormeFlexRenderData.copy(
            old.formeFlexRenderData, formeFlexRenderData));
  }
}

class FormeFlexRenderData {
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final CrossAxisAlignment? crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection? verticalDirection;
  final TextBaseline? textBaseline;

  const FormeFlexRenderData({
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.textDirection,
    this.verticalDirection,
    this.textBaseline,
  });

  static FormeFlexRenderData? copy(
      FormeFlexRenderData? old, FormeFlexRenderData? current) {
    if (old == null) return current;
    if (current == null) return old;
    return FormeFlexRenderData(
      mainAxisAlignment: current.mainAxisAlignment ?? old.mainAxisAlignment,
      mainAxisSize: current.mainAxisSize ?? old.mainAxisSize,
      crossAxisAlignment: current.crossAxisAlignment ?? old.crossAxisAlignment,
      textDirection: current.textDirection ?? old.textDirection,
      verticalDirection: current.verticalDirection ?? old.verticalDirection,
      textBaseline: current.textBaseline ?? old.textBaseline,
    );
  }
}
