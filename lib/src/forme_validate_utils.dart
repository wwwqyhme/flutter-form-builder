import 'package:flutter/cupertino.dart';

/// validatos for [Forme]
class FormeValidates {
  FormeValidates._();

//https://stackoverflow.com/a/50663835/7514037
  static const String EMAIL_PATTERN =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  static FormFieldValidator notNull({String errorText = ''}) {
    return (v) => v == null ? errorText : null;
  }

  static FormFieldValidator size({String errorText = '', int? min, int? max}) {
    return (v) {
      if (v == null) return null;
      if (min == null && max == null) return null;
      if (v is Iterable || v is Map || v is String)
        return _validateSize(v.length, min, max, errorText: errorText);
    };
  }

  static FormFieldValidator<num> min(double min, {String errorText = ''}) {
    return (v) => (v != null && v < min) ? errorText : null;
  }

  static FormFieldValidator<num> max(double max, {String errorText = ''}) {
    return (v) => (v != null && v > max) ? errorText : null;
  }

  static FormFieldValidator notEmpty({String errorText = ''}) {
    return (v) {
      if (v == null) return errorText;
      if (v is Iterable || v is Map || v is String) if (v.length == 0)
        return errorText;
    };
  }

  static FormFieldValidator<String> notBlank({String errorText = ''}) {
    return (v) {
      if (v == null) return null;
      return v.trim().length > 0 ? null : errorText;
    };
  }

  static FormFieldValidator<num> positive({String errorText = ''}) {
    return (v) {
      if (v == null) return null;
      return v > 0 ? null : errorText;
    };
  }

  static FormFieldValidator<num> positiveOrZero({String errorText = ''}) {
    return (v) {
      if (v == null) return null;
      return v >= 0 ? null : errorText;
    };
  }

  static FormFieldValidator<num> negative({String errorText = ''}) {
    return (v) {
      if (v == null) return null;
      return v < 0 ? null : errorText;
    };
  }

  static FormFieldValidator<num> negativeOrZero({String errorText = ''}) {
    return (v) {
      if (v == null) return null;
      return v <= 0 ? null : errorText;
    };
  }

  static FormFieldValidator<String> pattern(String pattern,
      {String errorText = ''}) {
    return (v) {
      if (v == null) return null;
      bool isValid = RegExp(pattern).hasMatch(v);
      if (!isValid) return errorText;
      return null;
    };
  }

  static FormFieldValidator<String> email({String errorText = ''}) {
    return pattern(EMAIL_PATTERN, errorText: errorText);
  }

  static FormFieldValidator<String> url({
    String errorText = '',
    String? schema,
    String? host,
    int? port,
  }) {
    return (v) {
      if (v == null || v.length == 0) return null;

      Uri? uri = Uri.tryParse(v);
      if (uri == null) return errorText;

      if (schema != null && schema.length > 0 && !uri.isScheme(schema))
        return errorText;
      if (host != null && host.length > 0 && uri.host != host) return errorText;
      if (port != null && uri.port != port) return errorText;
    };
  }

  static FormFieldValidator<T> any<T>(List<FormFieldValidator<T>> validators,
      {String errorText = ''}) {
    return (v) {
      for (FormFieldValidator<T> validator in validators) {
        if (validator(v) == null) {
          return null;
        }
      }
      return errorText;
    };
  }

  static FormFieldValidator<T> all<T>(List<FormFieldValidator<T>> validators,
      {String errorText = ''}) {
    return (v) {
      for (FormFieldValidator<T> validator in validators) {
        String? _errorText = validator(v);
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
