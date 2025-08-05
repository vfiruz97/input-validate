import 'dart:async';

/// Abstract base class for all validation rules.
///
/// Each validation rule must implement a [message] getter that returns
/// the error message when validation fails, and a [passes] method that
/// performs the actual validation logic.
abstract class ValidationRule {
  /// The error message to display when validation fails.
  String get message;

  /// Validates the given [value] and returns whether it passes validation.
  ///
  /// Returns `true` if the value is valid, `false` otherwise.
  /// Supports both synchronous and asynchronous validation by returning
  /// a [FutureOr<bool>].
  FutureOr<bool> passes(dynamic value);
}
