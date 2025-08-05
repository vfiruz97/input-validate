import 'dart:async';

import 'validation_rule.dart';

/// A validation rule that checks if a value is present (not null or empty).
///
/// For strings, empty strings are considered invalid.
/// For lists and maps, empty collections are considered invalid.
/// For all other types, only null values are considered invalid.
class RequiredRule implements ValidationRule {
  const RequiredRule();

  @override
  String get message => 'This field is required';

  @override
  FutureOr<bool> passes(dynamic value) {
    if (value == null) return false;

    if (value is String) return value.isNotEmpty;
    if (value is List) return value.isNotEmpty;
    if (value is Map) return value.isNotEmpty;

    return true;
  }
}

/// A validation rule wrapper that allows null values to pass validation.
///
/// This rule wraps another validation rule and makes it nullable by
/// returning true if the value is null, otherwise delegating to the
/// wrapped rule.
class NullableRule implements ValidationRule {
  /// The wrapped validation rule to apply when value is not null.
  final ValidationRule rule;

  const NullableRule(this.rule);

  @override
  String get message => rule.message;

  @override
  FutureOr<bool> passes(dynamic value) {
    if (value == null) return true;
    return rule.passes(value);
  }
}
