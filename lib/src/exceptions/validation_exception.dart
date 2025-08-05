/// Abstract base class for all validation exceptions.
///
/// Contains a human-readable error message and optionally field-specific
/// error details for form validation scenarios.
abstract class ValidationException implements Exception {
  /// The main error message describing the validation failure.
  final String message;

  /// Field-specific errors mapped by field path.
  /// Format: {'field.path': ['Error message 1', 'Error message 2']}
  final Map<String, List<String>>? inputErrors;

  /// Creates a new validation exception with the given [message] and optional [inputErrors].
  const ValidationException(this.message, [this.inputErrors]);

  @override
  String toString() => message;
}

/// Exception thrown when a single field fails validation.
class FieldValidationException extends ValidationException {
  /// The field path that failed validation.
  final String fieldPath;

  /// The validation rule that failed.
  final String ruleName;

  /// Creates a new field validation exception.
  const FieldValidationException(
    this.fieldPath,
    this.ruleName,
    String message, [
    Map<String, List<String>>? inputErrors,
  ]) : super(message, inputErrors);
}

/// Exception thrown when multiple fields fail validation.
class MultipleValidationException extends ValidationException {
  /// The number of fields that failed validation.
  final int failureCount;

  /// Creates a new multiple validation exception.
  const MultipleValidationException(
    this.failureCount,
    String message,
    Map<String, List<String>> inputErrors,
  ) : super(message, inputErrors);

  /// Creates a multiple validation exception from a map of field errors.
  factory MultipleValidationException.fromErrors(
    Map<String, List<String>> errors,
  ) {
    final count = errors.length;
    final message = 'Validation failed for $count field${count == 1 ? '' : 's'}';

    return MultipleValidationException(count, message, errors);
  }
}
