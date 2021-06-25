import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'field/forme_filter_chip.dart';
import 'field/forme_list_tile.dart';

class FormeUtils {
  FormeUtils._();

  static bool compare(dynamic a, dynamic b) {
    if (a == b) return true;
    if (a is List && b is List) return listEquals(a, b);
    if (a is Set && b is Set) return setEquals(a, b);
    if (a is Map && b is Map) return mapEquals(a, b);
    return false;
  }

  static List<FormeChipItem<String>> toFormeChipItems(List<String> items,
      {EdgeInsets? padding, EdgeInsets? labelPadding}) {
    return items
        .map((e) => FormeChipItem<String>(
            label: Text(e),
            padding: padding,
            data: e,
            labelPadding: labelPadding))
        .toList();
  }

  static List<FormeListTileItem<String>> toFormeListTileItems(
    List<String> items, {
    EdgeInsets? padding,
    TextStyle? style,
    ListTileControlAffinity? controlAffinity,
  }) {
    return items
        .map((e) => FormeListTileItem<String>(
              title: Text(e, style: style),
              padding: padding,
              data: e,
              controlAffinity: controlAffinity,
            ))
        .toList();
  }

  static List<DropdownMenuItem<String>> toDropdownMenuItems(
    List<String> items, {
    TextStyle? textStyle,
    VoidCallback? onTap,
  }) {
    return items.map<DropdownMenuItem<String>>((value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: textStyle,
        ),
        onTap: onTap,
      );
    }).toList();
  }

  static TextSelection selection(int start, int end) {
    int extendsOffset = end;
    int baseOffset = start < 0
        ? 0
        : start > extendsOffset
            ? extendsOffset
            : start;
    return TextSelection(baseOffset: baseOffset, extentOffset: extendsOffset);
  }
}
