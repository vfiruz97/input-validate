# Input Validation Package - Implementation Plan

Based on the detailed requirements, here's my comprehensive plan for implementing the input validation package:

## Progress Status

### ✅ Phase 1 - Core Foundation (COMPLETED)

- ✅ Project structure and exports
- ✅ ValidationRule abstract base class
- ✅ FieldPath implementation with wildcard support
- ✅ ValidationException system with field-specific errors
- ✅ Basic InputValidate class structure
- ✅ Comprehensive test coverage for foundation components

**Next:** Phase 2 - Type validation rules (RequiredRule, StringRule, etc.)

## 1. Project Structure Setup

### Subtasks:

- [x] Create proper folder structure with separation of concerns
- [x] Configure `pubspec.yaml` with required dependencies
- [x] Setup export structure in `lib/input_validate.dart`
- [x] Implement organized folder hierarchy:
  ```
  lib/
  ├── input_validate.dart          # Public API exports
  └── src/
      ├── input_validate_base.dart # Core InputValidate class
      ├── field_path.dart          # Path parsing logic
      ├── rules/                   # All validation rules
      │   ├── validation_rule.dart # Abstract base class
      │   ├── type_rules.dart      # String, Number, Boolean, List, Map rules
      │   ├── constraint_rules.dart # Min, Max, In rules
      │   ├── format_rules.dart    # Email rule
      │   └── special_rules.dart   # Required, Nullable rules
      └── exceptions/              # Exception hierarchy
          └── validation_exception.dart
  ```

## 2. Core Validation Rule System

### Subtasks:

- [x] Implement `ValidationRule` abstract base class:

  ```dart
  abstract class ValidationRule {
    String get message;
    FutureOr<bool> passes(dynamic value);
  }
  ```

- [ ] Create type validation rules with `const` constructors:

  - [ ] `RequiredRule`: Check for null/empty values (handles strings, lists, maps)
  - [ ] `StringRule`: Type validation for strings
  - [ ] `NumberRule`: Type validation for numbers (int, double)
  - [ ] `BooleanRule`: Type validation for booleans
  - [ ] `ListRule`: Type validation for lists
  - [ ] `MapRule`: Type validation for maps

- [ ] Implement constraint rules:

  - [ ] `MinRule`: Minimum value/length constraints (numbers, strings, lists)
  - [ ] `MaxRule`: Maximum value/length constraints (numbers, strings, lists)
  - [ ] `InRule`: Value membership in allowed set

- [ ] Create format validation rules:

  - [ ] `EmailRule`: Email format validation using regex

- [ ] Implement special rules:
  - [ ] `NullableRule`: Allow null values (wrapper rule)

## 3. Field Path Implementation

### Subtasks:

- [x] Create `FieldPath` class to handle dot notation paths:

  ```dart
  class FieldPath {
    final String name;
    bool get isWildcard => name == '*';

    const FieldPath(this.name);

    // Parse path like 'users.*.name' into segments
    static List<FieldPath> parse(String path);

    @override
    String toString() => name;
  }
  ```

- [x] Implement path parsing logic:

  - [x] Split dot-separated strings into segments
  - [x] Handle edge cases (empty strings, multiple dots)
  - [x] Validate path format

- [ ] Add wildcard segment handling:
  - [x] Identify wildcard segments (`*`)
  - [ ] Implement expansion logic for arrays
  - [ ] Handle nested wildcards

## 4. Exception System

### Subtasks:

- [x] Create `ValidationException` abstract base class:

  ```dart
  abstract class ValidationException implements Exception {
    final String message;
    final Map<String, List<String>>? inputErrors;

    const ValidationException(this.message, [this.inputErrors]);

    @override
    String toString() => message;
  }
  ```

- [x] Implement concrete exception classes:
  - [x] `FieldValidationException`: Single field validation failure
  - [x] `MultipleValidationException`: Multiple field validation failures
- [x] Add error collection mechanisms:
  - [x] Aggregate errors by field path
  - [x] Format error messages consistently
  - [x] Handle wildcard path error reporting

## 5. Core Validation Logic

### Subtasks:

- [x] Implement `InputValidate` class with static validate method:

  ```dart
  class InputValidate {
    static Future<Map<String, dynamic>> validate(
      Map<String, dynamic> input,
      Map<String, List<ValidationRule>> rules
    );

    // Private helper methods
    static Future<void> _validateField(String path, dynamic value, List<ValidationRule> rules);
    static void _expandWildcardPaths(Map<String, List<ValidationRule>> rules, Map<String, dynamic> input);
    static Map<String, dynamic> _extractValidatedData(Map<String, dynamic> input, Set<String> validatedPaths);
  }
  ```

- [ ] Implement field validation logic:

  - [ ] Apply rules to appropriate fields
  - [ ] Handle async rule execution with `FutureOr`
  - [ ] Collect validation errors without fail-fast behavior

- [ ] Add wildcard expansion logic:

  - [ ] Expand wildcard paths for array validation
  - [ ] Handle nested arrays and objects
  - [ ] Generate concrete paths from wildcard patterns

- [ ] Implement data filtering:

  - [ ] Track validated field paths
  - [ ] Return only validated fields (strip unvalidated data)
  - [ ] Preserve nested structure for validated data

- [ ] Add error aggregation:
  - [ ] Collect all validation errors before throwing
  - [ ] Group errors by field path
  - [ ] Format error messages with field context

## 6. Testing Strategy

### Subtasks:

- [ ] Create unit tests for validation rules:

  - [ ] Test each rule with valid/invalid inputs
  - [ ] Test edge cases (null, empty, wrong types)
  - [ ] Test rule-specific logic (email format, min/max values)

- [ ] Write tests for field path parsing:

  - [x] Test simple paths (`name`, `user.email`)
  - [x] Test wildcard paths (`users.*.name`)
  - [ ] Test nested wildcards (`groups.*.users.*.email`)
  - [x] Test edge cases and malformed paths

- [ ] Implement integration tests:

  - [ ] Test complete validation scenarios
  - [ ] Test nested data structures
  - [ ] Test array validation with wildcards
  - [ ] Test error aggregation and reporting

- [ ] Verify core functionality:
  - [ ] Test that only validated fields are returned
  - [ ] Test async rule execution
  - [x] Test exception throwing and error formatting

## 7. Advanced Features & Optimizations

### Subtasks:

- [ ] Implement parallel validation:

  - [ ] Use `Future.wait()` for independent field validations
  - [ ] Maintain proper error aggregation

- [ ] Add performance optimizations:

  - [ ] Cache compiled field paths
  - [ ] Optimize wildcard expansion for large arrays
  - [ ] Early termination for required field failures

- [ ] Create utility methods:
  - [ ] Common validation pattern helpers
  - [ ] Rule composition utilities
  - [ ] Error message customization

## 8. Documentation & Examples

### Subtasks:

- [ ] Add comprehensive API documentation:

  - [ ] Document all public classes and methods
  - [ ] Include usage examples in doc comments
  - [ ] Document wildcard path notation

- [ ] Create example implementations:

  - [ ] Basic validation example
  - [ ] Nested object validation
  - [ ] Array validation with wildcards
  - [ ] Custom rule creation example

- [ ] Update README.md:

  - [ ] Installation instructions
  - [ ] Quick start guide
  - [ ] Feature overview
  - [ ] Link to examples

- [ ] Add proper logging:
  - [x] Use `log()` from `dart:developer`
  - [ ] Add debug logging for validation process
  - [x] Never use `print()` statements

## 9. Implementation Priority Order

### Phase 1 - Core Foundation:

1. [x] Project structure and exports
2. [x] ValidationRule abstract class
3. [ ] Basic type validation rules
4. [x] FieldPath implementation
5. [x] ValidationException system

### Phase 2 - Validation Engine:

1. [x] InputValidate class structure
2. [ ] Basic field validation logic
3. [ ] Simple path handling (no wildcards)
4. [ ] Error collection and throwing

### Phase 3 - Advanced Features:

1. [ ] Wildcard path expansion
2. [ ] Array validation
3. [ ] Constraint rules (Min, Max, In)
4. [ ] Format rules (Email)
5. [ ] Special rules (Nullable)

### Phase 4 - Polish & Testing:

1. [ ] Comprehensive testing
2. [ ] Performance optimizations
3. [ ] Documentation
4. [ ] Examples and README

## Success Criteria

- [ ] All validation rules work correctly with appropriate error messages
- [ ] Wildcard paths properly validate arrays and nested structures
- [ ] Only validated fields are returned from input data
- [ ] All validation errors are collected before throwing exception
- [ ] Async rules are properly supported
- [ ] Code follows Dart conventions with const constructors
- [ ] Comprehensive test coverage (>90%)
- [ ] Clear documentation and examples
