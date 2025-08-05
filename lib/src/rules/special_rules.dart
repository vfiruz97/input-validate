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

/// A special validation rule that allows null values to pass validation.
///
/// When this rule is present in a field's validation rules and the field value is null,
/// all other validation rules for that field are skipped. If the value is not null,
/// normal validation continues with all other rules.
///
/// Special handling for List and Map types. They don't pass if they are empty.
/// This rule itself always passes validation - the special behavior is handled
/// in the validation engine.
///
/// Example:
/// ```dart
/// 'user.surname': [
///   NullableRule(),     // Allow null values
///   IsStringRule(),     // Only applied if value is not null
///   MinRule(3),         // Only applied if value is not null
///   MaxRule(20),        // Only applied if value is not null
/// ]
/// ```
class NullableRule implements ValidationRule {
  const NullableRule();

  @override
  String get message => 'Field can be null or valid';

  @override
  FutureOr<bool> passes(dynamic value) {
    if (value is List) return value.isNotEmpty;
    if (value is Map) return value.isNotEmpty;

    return true; // Always passes, special handling in validation engine
  }
}
