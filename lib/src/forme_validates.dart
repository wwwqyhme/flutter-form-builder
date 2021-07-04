import 'package:forme/forme.dart';

/// validatos for [Forme]
class FormeValidates {
  FormeValidates._();

//https://stackoverflow.com/a/50663835/7514037
  static const String EMAIL_PATTERN =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  /// when valid:
  ///
  /// 1. value is null
  /// 2. value == given value
  static FormeValidator equals(dynamic value, {String errorText = ''}) {
    return (f, v) => value == null || v == value ? null : errorText;
  }

  /// when valid
  ///
  /// 1. value is not null
  static FormeValidator notNull({String errorText = ''}) {
    return (f, v) => v == null ? errorText : null;
  }

  /// when valid
  ///
  /// 1. value is null
  /// 2. min == null && max == null
  /// 3. value's length is > min and < max
  static FormeValidator size({String errorText = '', int? min, int? max}) {
    return (f, v) {
      if (v == null) return null;
      if (min == null && max == null) return null;
      if (v is Iterable || v is Map || v is String)
        return _validateSize(v.length, min, max, errorText: errorText);
      throw 'only Iterable|Map|String support this validator';
    };
  }

  /// when valid
  ///
  /// 1. value is null
  /// 2. value is >= min
  static FormeValidator min(double min, {String errorText = ''}) {
    return (f, v) => (v != null && v < min) ? errorText : null;
  }

  /// when valid
  ///
  /// 1. value is null
  /// 2. value is <= max
  static FormeValidator max(double max, {String errorText = ''}) {
    return (f, v) => (v != null && v > max) ? errorText : null;
  }

  /// when valid:
  ///
  /// 1. value is null
  /// 2. value >= min && value <= max
  static FormeValidator range(double min, double max, {String errorText = ''}) {
    return (f, v) => (v == null || (v >= min && v <= max)) ? null : errorText;
  }

  /// when valid
  ///
  /// 1. value is null
  /// 2. value's length > 0
  static FormeValidator notEmpty({String errorText = ''}) {
    return (f, v) {
      if (v == null) return errorText;
      if (v is Iterable || v is Map || v is String) if (v.length == 0)
        return errorText;
    };
  }

  /// when valid
  ///
  /// 1. value is null
  /// 2. value's length(after trim) > 0
  static FormeValidator notBlank({String errorText = ''}) {
    return (f, v) {
      if (v == null) return null;
      return v.trim().length > 0 ? null : errorText;
    };
  }

  /// when valid
  ///
  /// 1. value is null
  /// 2. value > 0
  static FormeValidator positive({String errorText = ''}) {
    return (f, v) {
      if (v == null) return null;
      return v > 0 ? null : errorText;
    };
  }

  /// when valid
  ///
  /// 1. value is null
  /// 2. value >= 0
  static FormeValidator positiveOrZero({String errorText = ''}) {
    return (f, v) {
      if (v == null) return null;
      return v >= 0 ? null : errorText;
    };
  }

  /// when valid
  ///
  /// 1. value is null
  /// 2. value < 0
  static FormeValidator negative({String errorText = ''}) {
    return (f, v) {
      if (v == null) return null;
      return v < 0 ? null : errorText;
    };
  }

  /// when valid
  ///
  /// 1. value is null
  /// 2. value <= 0
  static FormeValidator negativeOrZero({String errorText = ''}) {
    return (f, v) {
      if (v == null) return null;
      return v <= 0 ? null : errorText;
    };
  }

  /// when valid
  ///
  /// 1. value is null
  /// 2. value match pattern
  static FormeValidator pattern(String pattern, {String errorText = ''}) {
    return (f, v) {
      if (v == null) return null;
      bool isValid = RegExp(pattern).hasMatch(v);
      if (!isValid) return errorText;
      return null;
    };
  }

  /// when valid
  ///
  /// 1. value is null
  /// 2. value is an email
  static FormeValidator email({String errorText = ''}) {
    return pattern(EMAIL_PATTERN, errorText: errorText);
  }

  /// when valid
  ///
  /// 1. value is null
  /// 2. value is an url
  static FormeValidator url({
    String errorText = '',
    String? schema,
    String? host,
    int? port,
  }) {
    return (f, v) {
      if (v == null || v.length == 0) return null;

      Uri? uri = Uri.tryParse(v);
      if (uri == null) return errorText;

      if (schema != null && schema.length > 0 && !uri.isScheme(schema))
        return errorText;
      if (host != null && host.length > 0 && uri.host != host) return errorText;
      if (port != null && uri.port != port) return errorText;
    };
  }

  /// when valid
  ///
  /// 1. any validator return null
  static FormeValidator any(List<FormeValidator> validators,
      {String errorText = ''}) {
    return (f, v) {
      for (FormeValidator validator in validators) {
        if (validator(f, v) == null) {
          return null;
        }
      }
      return errorText;
    };
  }

  /// when valid
  ///
  /// 1. every validator return null
  static FormeValidator all(List<FormeValidator> validators,
      {String errorText = ''}) {
    return (f, v) {
      for (FormeValidator validator in validators) {
        String? _errorText = validator(f, v);
        if (_errorText != null) {
          return _errorText == '' ? errorText : _errorText;
        }
      }
      return null;
    };
  }

  static String? _validateSize(int length, int? min, int? max,
      {String errorText = ''}) {
    if (min != null && min > length) return errorText;
    if (max != null && max < length) return errorText;
    return null;
  }
}
