import 'dart:async';

import 'validation_rule.dart';

/// A validation rule that checks if a value is a string.
class StringRule implements ValidationRule {
  const StringRule();

  @override
  String get message => 'This field must be a string';

  @override
  FutureOr<bool> passes(dynamic value) {
    return value is String;
  }
}

/// A validation rule that checks if a value is a number (int or double).
class NumberRule implements ValidationRule {
  const NumberRule();

  @override
  String get message => 'This field must be a number';

  @override
  FutureOr<bool> passes(dynamic value) {
    return value is num;
  }
}

/// A validation rule that checks if a value is a boolean.
class BooleanRule implements ValidationRule {
  const BooleanRule();

  @override
  String get message => 'This field must be a boolean';

  @override
  FutureOr<bool> passes(dynamic value) {
    return value is bool;
  }
}

/// A validation rule that checks if a value is a list.
class ListRule implements ValidationRule {
  const ListRule();

  @override
  String get message => 'This field must be a list';

  @override
  FutureOr<bool> passes(dynamic value) {
    return value is List;
  }
}

/// A validation rule that checks if a value is a map.
class MapRule implements ValidationRule {
  const MapRule();

  @override
  String get message => 'This field must be a map';

  @override
  FutureOr<bool> passes(dynamic value) {
    return value is Map;
  }
}
