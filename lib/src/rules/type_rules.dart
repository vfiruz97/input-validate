import 'dart:async';

import 'validation_rule.dart';

/// A validation rule that checks if a value is a string.
class IsStringRule implements ValidationRule {
  const IsStringRule();

  @override
  String get message => 'This field must be a string';

  @override
  FutureOr<bool> passes(dynamic value) {
    if (value == null) return true;
    return value is String;
  }
}

/// A validation rule that checks if a value is a number (int or double).
class IsNumberRule implements ValidationRule {
  const IsNumberRule();

  @override
  String get message => 'This field must be a number';

  @override
  FutureOr<bool> passes(dynamic value) {
    if (value == null) return true;
    return value is num;
  }
}

/// A validation rule that checks if a value is a boolean.
class IsBooleanRule implements ValidationRule {
  const IsBooleanRule();

  @override
  String get message => 'This field must be a boolean';

  @override
  FutureOr<bool> passes(dynamic value) {
    if (value == null) return true;
    return value is bool;
  }
}

/// A validation rule that checks if a value is a list.
class IsListRule implements ValidationRule {
  const IsListRule();

  @override
  String get message => 'This field must be a list';

  @override
  FutureOr<bool> passes(dynamic value) {
    if (value == null) return true;
    return value is List;
  }
}

/// A validation rule that checks if a value is a map.
class IsMapRule implements ValidationRule {
  const IsMapRule();

  @override
  String get message => 'This field must be a map';

  @override
  FutureOr<bool> passes(dynamic value) {
    if (value == null) return true;
    return value is Map;
  }
}
