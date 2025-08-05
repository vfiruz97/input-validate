import 'dart:async';

import 'validation_rule.dart';

/// A validation rule that checks if a value meets a minimum constraint.
///
/// For numbers, validates the numeric value.
/// For strings and lists, validates the length.
class MinRule implements ValidationRule {
  /// The minimum value or length required.
  final num min;

  const MinRule(this.min);

  @override
  String get message => 'This field must be at least $min';

  @override
  FutureOr<bool> passes(dynamic value) {
    if (value == null) return false;

    if (value is num) {
      return value >= min;
    }

    if (value is String) {
      return value.length >= min;
    }

    if (value is List) {
      return value.length >= min;
    }

    return false;
  }
}

/// A validation rule that checks if a value meets a maximum constraint.
///
/// For numbers, validates the numeric value.
/// For strings and lists, validates the length.
class MaxRule implements ValidationRule {
  /// The maximum value or length allowed.
  final num max;

  const MaxRule(this.max);

  @override
  String get message => 'This field must be at most $max';

  @override
  FutureOr<bool> passes(dynamic value) {
    if (value == null) return false;

    if (value is num) {
      return value <= max;
    }

    if (value is String) {
      return value.length <= max;
    }

    if (value is List) {
      return value.length <= max;
    }

    return false;
  }
}

/// A validation rule that checks if a value is in a set of allowed values.
class InRule implements ValidationRule {
  /// The set of allowed values.
  final Set<dynamic> allowedValues;

  const InRule(this.allowedValues);

  @override
  String get message =>
      'This field must be one of: ${allowedValues.join(', ')}';

  @override
  FutureOr<bool> passes(dynamic value) {
    return allowedValues.contains(value);
  }
}
