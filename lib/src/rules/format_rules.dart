import 'dart:async';

import 'validation_rule.dart';

/// A validation rule that checks if a string value matches email format.
///
/// Uses a regex pattern to validate email addresses according to a
/// reasonable subset of RFC 5322 specification.
class EmailRule implements ValidationRule {
  /// Regular expression pattern for email validation.
  static final RegExp _emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  const EmailRule();

  @override
  String get message => 'This field must be a valid email address';

  @override
  FutureOr<bool> passes(dynamic value) {
    if (value == null) return true;
    if (value is! String) return false;

    return _emailPattern.hasMatch(value);
  }
}
