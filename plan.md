# Input Validation Package - Implementation Plan

Based on the detailed requirements, here's my comprehensive plan for implementing the input validation package:

## Progress Status

### ✅ Phase 1 - Core Foundation (COMPLETED)

- ✅ Project structure and exports
- ✅ ValidationRule abstract base class
- ✅ FieldPath implementation with wildcard support
- ✅ ValidationExcept5. [x] API improvements successfully implemented with zero breaking changes

6. [x] Code formatting improvements for better readability and lint compliance
7. [x] Comprehensive debug logging for validation process debugging and performance analysis
8. [x] **Recent Enhancements**: Code quality improvements, enhanced debug logging examples, and documentation refinements

## Success Criteriaystem with field-specific errors

- ✅ Basic InputValidate class structure
- ✅ Comprehensive test coverage for foundation components

### ✅ Phase 2 - Type Validation Rules (COMPLETED)

- ✅ All basic type validation rules (Required, String, Number, Boolean, List, Map)
- ✅ Constraint rules (Min, Max, In)
- ✅ Format rules (Email)
- ✅ Special rules (Nullable)
- ✅ Comprehensive test coverage for all rules

### ✅ Phase 3 - Validation Engine (COMPLETED)

- ✅ Basic field validation logic implementation
- ✅ Simple path handling (dot notation without wildcards)
- ✅ Error collection and aggregation
- ✅ Data filtering (return only validated fields)
- ✅ Async rule execution support
- ✅ Comprehensive integration tests

### ✅ Phase 4 - Wildcard Path Expansion (COMPLETED)

- ✅ Wildcard path expansion for array validation
- ✅ Support for nested wildcards (`groups.*.users.*.email`)
- ✅ Proper handling of empty arrays
- ✅ Mixed wildcard and non-wildcard path support
- ✅ Comprehensive array validation tests
- ✅ All 75+ tests passing with full wildcard functionality

### ✅ Phase 5 - Performance Optimizations & Documentation (COMPLETED)

- ✅ Parallel validation with `Future.wait()` for independent field validations
- ✅ Field path caching for improved performance
- ✅ Sequential validation with early termination option
- ✅ Performance optimization parameter (`enableParallelValidation`)
- ✅ Comprehensive API documentation in README.md
- ✅ Complete example implementations covering all features
- ✅ Custom rule creation examples
- ✅ Performance comparison examples
- ✅ All 78+ tests passing with performance features
- ✅ Production-ready documentation and examples

### ✅ Phase 6 - API Improvements & Naming Clarification (COMPLETED)

- ✅ Rename type validation rules for better clarity and consistency:
  - ✅ `StringRule` → `IsStringRule`
  - ✅ `NumberRule` → `IsNumberRule`
  - ✅ `BooleanRule` → `IsBooleanRule`
  - ✅ `ListRule` → `IsListRule`
  - ✅ `MapRule` → `IsMapRule`
- ✅ Update all references throughout the codebase:
  - ✅ Rule implementation files in `lib/src/rules/type_rules.dart`
  - ✅ Export statements in `lib/input_validate.dart`
  - ✅ Test files in `test/input_validate_test.dart` (backward compatibility maintained)
  - ✅ Documentation in `README.md`
  - ✅ Examples in `example/input_validate_example.dart`
- ✅ Maintain backward compatibility with deprecation warnings
- ✅ Update API documentation to reflect new naming convention
- ✅ Verify all tests pass with renamed rules
- ✅ Update plan.md to reflect completion status

**Status:** 🎉 ALL PHASES COMPLETE + CONCISE SYNTAX

The project is now feature-complete with:

- ✅ Complete validation rule system with clear API naming
- ✅ Full wildcard path support for complex nested data structures
- ✅ Performance optimizations with parallel validation
- ✅ Comprehensive debug logging with detailed validation insights
- ✅ **Latest Addition**: Concise validation rule syntax for improved developer experience
- ✅ Code quality improvements including:
  - Code formatting for better readability and lint compliance
  - Enhanced debug logging example with comprehensive validation scenarios
  - Minor API refinements and documentation improvements
- ✅ **Latest Updates**: Logging standardization and cache management features for improved maintainability

### 🆕 Latest Updates (Post Phase 6)

- ✅ **Code Quality Improvements**: Code formatting standardization across all source files for better readability and lint compliance
- ✅ **Enhanced Debug Logging Example**: Added comprehensive `debug_logging_example.dart` showcasing all logging capabilities including:
  - Simple field validation with detailed logging
  - Array validation with wildcard path expansion logging
  - Validation failure scenarios with error detail logging
  - Sequential vs parallel validation mode comparison
- ✅ **Documentation Refinements**: Minor improvements to README.md formatting and clarity
- ✅ **Codebase Consistency**: Improved code formatting in core validation engine for better maintainability

### ✅ Phase 7 - NullableRule Enhancement (COMPLETED)

**Task:** Fix NullableRule Implementation to Properly Handle Null Values

**Background:** The current `NullableRule` implementation doesn't follow the intended behavior. It should be a special rule that allows null values and skips further validation when the value is null.

**Required Changes:**

1. **Update NullableRule Behavior**

   - [x] Modify `NullableRule` to be a special rule that takes no parameters
   - [x] The rule should always pass validation (return true)
   - [x] Update rule message to reflect its purpose

2. **Enhance InputValidate Validation Logic**

   - [x] Add special handling for `NullableRule` in the validation flow
   - [x] When a field value is null AND contains `NullableRule`, skip all other rule validations
   - [x] When a field value is not null, continue with normal validation of all rules
   - [x] Ensure this works with wildcard paths and nested validations
   - [x] Handle interaction with `RequiredRule` (RequiredRule takes precedence)

3. **Update Tests**

   - [x] Add comprehensive tests for null value handling with `NullableRule`
   - [x] Test that other rules are skipped when value is null and `NullableRule` is present
   - [x] Test that other rules are still applied when value is not null
   - [x] Test edge cases with nested paths and wildcards
   - [x] Test interaction with `RequiredRule`

4. **Update Documentation**
   - [x] Update README.md with correct `NullableRule` usage examples
   - [x] Add documentation comments explaining the special behavior
   - [x] Update example files to demonstrate proper usage (already correct)

**Example Behavior:**

```dart
'user.surname': [
  NullableRule(),     // Allow null values
  IsStringRule(),     // Only applied if value is not null
  MinRule(3),         // Only applied if value is not null
  MaxRule(20),        // Only applied if value is not null
]

// If user.surname is null -> validation passes (other rules skipped)
// If user.surname is "John" -> all rules are applied
```

**Priority:** High - This fixes incorrect behavior in the validation system

**Status:** ✅ Implementation complete, comprehensive tests added (86 tests passing)

### ✅ Phase 8 - Example and Validation Improvements (COMPLETED)

**Task:** Update Example File and Fix Validation Rule Consistency

**Implemented Changes:**

1. **Example File Improvements**

   - [x] Updated `example/main.dart` to use proper rule names (`IsStringRule`, `IsNumberRule`, etc.)
   - [x] Replaced `dart:developer` log calls with `print()` statements for better console output
   - [x] Removed unused imports for cleaner code
   - [x] Enhanced test data structure with more realistic validation scenarios
   - [x] Added comprehensive error handling and formatting

2. **Validation Rule Consistency**

   - [x] Fixed null handling across all validation rules to return `true` when value is `null`
   - [x] Updated `NullableRule` to properly handle empty Lists and Maps
   - [x] Enhanced async/await handling in validation engine for better `FutureOr` support
   - [x] Improved error aggregation and reporting consistency

3. **Test Suite Updates**

   - [x] Updated all test files to use new rule names (`IsStringRule`, `IsNumberRule`, etc.)
   - [x] Maintained backward compatibility tests
   - [x] Enhanced test coverage for null value handling
   - [x] All tests now passing with improved validation logic

4. **Code Quality Improvements**
   - [x] Consistent null handling across all validation rules
   - [x] Improved async execution handling in validation engine
   - [x] Better error message formatting and aggregation
   - [x] Enhanced logging for debugging validation processes

**Status:** ✅ All improvements complete, comprehensive testing validated

### ✅ Phase 9 - Null Handling Delegation & NullableRule Enhancement (COMPLETED)

**Task:** Refactor Null Handling to Delegate to RequiredRule and Enhance NullableRule

**Background:** Implemented a cleaner separation of null handling responsibilities where validation rules focus on their specific logic while RequiredRule handles null validation, and NullableRule provides special behavior for empty collections.

**Implemented Changes:**

1. **Null Handling Delegation**

   - [x] Updated all validation rules (type, constraint, format) to return `true` for null values
   - [x] Delegated null validation responsibility exclusively to `RequiredRule`
   - [x] This creates cleaner separation of concerns where each rule focuses on its specific validation logic

2. **Enhanced NullableRule Behavior**

   - [x] Modified `NullableRule` to fail validation for empty lists and maps
   - [x] Maintains existing behavior for null values and non-collection types
   - [x] Added special handling: `if (value is List) return value.isNotEmpty;` and `if (value is Map) return value.isNotEmpty;`

3. **Comprehensive Test Updates**

   - [x] Updated all validation rule tests to expect `true` for null values (delegated to RequiredRule)
   - [x] Changed test names to reflect new behavior: "should pass for null values (null handling delegated to RequiredRule)"
   - [x] Updated NullableRule tests to handle new empty collection behavior
   - [x] Fixed integration tests to include RequiredRule when null validation is needed
   - [x] All 86 tests now passing with updated expectations

4. **Validation Flow Benefits**
   - [x] Cleaner rule architecture: each rule has single responsibility
   - [x] RequiredRule exclusively handles null/empty validation
   - [x] Other rules focus only on their specific type/format/constraint validation
   - [x] NullableRule provides fine-grained control over empty collections
   - [x] Maintains backward compatibility for existing validation logic

**Example of New Behavior:**

```dart
// Individual rules now pass null values through
IsStringRule().passes(null) // returns true (was false)
MinRule(5).passes(null)     // returns true (was false)
EmailRule().passes(null)    // returns true (was false)

// RequiredRule handles null validation
RequiredRule().passes(null) // returns false

// NullableRule enhanced for collections
NullableRule().passes([])   // returns false (new behavior)
NullableRule().passes({})   // returns false (new behavior)
NullableRule().passes(null) // returns true (unchanged)
```

**Status:** ✅ Implementation complete, all tests updated and passing

### ✅ Phase 10 - Logging Standardization & Cache Management (COMPLETED)

**Task:** Standardize Debug Logging and Add Cache Management Features

**Background:** Implemented consistent logging practices and cache management utilities to improve code maintainability and debugging capabilities.

**Implemented Changes:**

1. **Logging Standardization**

   - [x] Added centralized `devLog()` helper method that wraps `dart:developer.log()`
   - [x] Replaced all direct `dev.log()` calls with standardized `devLog()` calls throughout the validation engine
   - [x] Improved consistency and maintainability of debug logging across the codebase
   - [x] Centralized logging logic for easier future modifications or customizations

2. **Cache Management Enhancement**

   - [x] Added `clearCache()` static method to `InputValidate` class
   - [x] Enables manual clearing of the field path cache for memory management
   - [x] Useful for long-running applications or testing scenarios
   - [x] Includes proper debug logging when cache is cleared

3. **Code Quality Improvements**
   - [x] Consistent method organization and structure
   - [x] Improved code readability with standardized logging patterns
   - [x] Better separation of concerns with dedicated utility methods
   - [x] Enhanced debugging capabilities for development and troubleshooting

**Benefits:**

- **Maintainability**: Centralized logging makes it easier to modify logging behavior
- **Debugging**: Consistent logging format improves debugging experience
- **Memory Management**: Cache clearing capability helps with memory optimization
- **Code Quality**: Standardized patterns improve overall code quality

**Example Usage:**

```dart
// Clear field path cache when needed
InputValidate.clearCache();

// All logging now uses consistent devLog() method
// devLog('Starting validation with ${rules.length} rule sets');
// devLog('Field $fieldPath validated successfully');
```

**Status:** ✅ Implementation complete, all logging standardized and cache management added

### ✅ Phase 11 - Shorter Validation Rule Syntax (COMPLETED)

**Task:** Implement Concise Rule Syntax for Better Readability

**Background:** Based on the suggestion in `specs/make-rules-shorter.md`, implement shorter function-style syntax for validation rules to improve code readability and reduce verbosity.

**Proposed Changes:**

1. **Create Rule Shortcuts File**

   - [x] Create `lib/src/shortcuts.dart` with function-style rule creators
   - [x] Define shorthand functions for all existing rules:

     ```dart
     // Rules without parameters
     RequiredRule Function() required = RequiredRule.new;
     IsStringRule Function() string = IsStringRule.new;
     IsBooleanRule Function() boolean = IsBooleanRule.new;
     IsNumberRule Function() number = IsNumberRule.new;
     IsListRule Function() list = IsListRule.new;
     IsMapRule Function() map = IsMapRule.new;
     EmailRule Function() email = EmailRule.new;
     NullableRule Function() nullable = NullableRule.new;

     // Rules with parameters
     MinRule Function(num value) min = MinRule.new;
     MaxRule Function(num value) max = MaxRule.new;
     InRule Function(Set<dynamic> values) inSet = InRule.new;
     ```

   - [x] Export shortcuts in main `lib/input_validate.dart` file

2. **Update Examples and Documentation**

   - [x] Update `example/main.dart` to demonstrate new concise syntax
   - [x] Show side-by-side comparison of old vs new syntax
   - [x] Update `README.md` with new syntax documentation
   - [x] Maintain backward compatibility examples

3. **Update CHANGELOG.md**

   - [x] Add entry under version 1.0.1:
     ```
     ## 1.0.1
     - Added concise rule syntax for cleaner validation code
     - New shorthand functions: required(), string(), min(), max(), etc.
     - Maintains full backward compatibility with existing rule classes
     ```

4. **Testing and Validation**

   - [x] Verify all shorthand functions work correctly
   - [x] Ensure backward compatibility (existing tests should pass unchanged)
   - [ ] Add example usage in existing test files
   - [x] Validate that both syntaxes can be mixed in the same validation

5. **Testing and Validation**
   - [x] Verify all shorthand functions work correctly
   - [x] Ensure backward compatibility (existing tests should pass unchanged)
   - [x] Add example usage in existing test files
   - [x] Validate that both syntaxes can be mixed in the same validation

**Example Before/After:**

```dart
// Before (verbose)
'name': [RequiredRule(), IsStringRule(), MinRule(2), MaxRule(80)]

// After (concise)
'name': [required(), string(), min(2), max(80)]
```

**Benefits:**

- **Readability**: Shorter, more readable validation rules
- **Consistency**: Function-style syntax matches Dart conventions
- **Backward Compatibility**: Existing code continues to work unchanged
- **Developer Experience**: Faster to write and easier to understand

**Priority:** Medium - Quality of life improvement that enhances developer experience

**Status:** ✅ IMPLEMENTATION COMPLETE - All 89 tests passing

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

- [x] Create type validation rules with `const` constructors:

  - [x] `RequiredRule`: Check for null/empty values (handles strings, lists, maps)
  - [x] `IsStringRule`: Type validation for strings (renamed from `StringRule`)
  - [x] `IsNumberRule`: Type validation for numbers (renamed from `NumberRule`)
  - [x] `IsBooleanRule`: Type validation for booleans (renamed from `BooleanRule`)
  - [x] `IsListRule`: Type validation for lists (renamed from `ListRule`)
  - [x] `IsMapRule`: Type validation for maps (renamed from `MapRule`)

- [x] Implement constraint rules:

  - [x] `MinRule`: Minimum value/length constraints (numbers, strings, lists)
  - [x] `MaxRule`: Maximum value/length constraints (numbers, strings, lists)
  - [x] `InRule`: Value membership in allowed set

- [x] Create format validation rules:

  - [x] `EmailRule`: Email format validation using regex

- [x] Implement special rules:
  - [x] `NullableRule`: Allow null values (wrapper rule)

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

- [x] Add wildcard segment handling:
  - [x] Identify wildcard segments (`*`)
  - [x] Implement expansion logic for arrays
  - [x] Handle nested wildcards

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

- [x] Implement field validation logic:

  - [x] Apply rules to appropriate fields
  - [x] Handle async rule execution with `FutureOr`
  - [x] Collect validation errors without fail-fast behavior

- [x] Add wildcard expansion logic:

  - [x] Expand wildcard paths for array validation
  - [x] Handle nested arrays and objects
  - [x] Generate concrete paths from wildcard patterns

- [x] Implement data filtering:

  - [x] Track validated field paths
  - [x] Return only validated fields (strip unvalidated data)
  - [x] Preserve nested structure for validated data

- [x] Add error aggregation:
  - [x] Collect all validation errors before throwing
  - [x] Group errors by field path
  - [x] Format error messages with field context

## 6. Testing Strategy

### Subtasks:

- [x] Create unit tests for validation rules:

  - [x] Test each rule with valid/invalid inputs
  - [x] Test edge cases (null, empty, wrong types)
  - [x] Test rule-specific logic (email format, min/max values)

- [x] Write tests for field path parsing:

  - [x] Test simple paths (`name`, `user.email`)
  - [x] Test wildcard paths (`users.*.name`)
  - [x] Test nested wildcards (`groups.*.users.*.email`)
  - [x] Test edge cases and malformed paths

- [x] Implement integration tests:

  - [x] Test complete validation scenarios
  - [x] Test nested data structures
  - [x] Test array validation with wildcards
  - [x] Test error aggregation and reporting

- [x] Verify core functionality:
  - [x] Test that only validated fields are returned
  - [x] Test async rule execution
  - [x] Test exception throwing and error formatting

## 7. Advanced Features & Optimizations

### Subtasks:

- [x] Implement parallel validation:

  - [x] Use `Future.wait()` for independent field validations
  - [x] Maintain proper error aggregation

- [x] Add performance optimizations:

  - [x] Cache compiled field paths
  - [x] Optimize wildcard expansion for large arrays
  - [x] Early termination for required field failures

- [x] Create utility methods:
  - [x] Common validation pattern helpers
  - [x] Rule composition utilities
  - [x] Error message customization

## 8. Documentation & Examples

### Subtasks:

- [x] Add comprehensive API documentation:

  - [x] Document all public classes and methods
  - [x] Include usage examples in doc comments
  - [x] Document wildcard path notation

- [x] Create example implementations:

  - [x] Basic validation example
  - [x] Nested object validation
  - [x] Array validation with wildcards
  - [x] Custom rule creation example

- [x] Update README.md:

  - [x] Installation instructions
  - [x] Quick start guide
  - [x] Feature overview
  - [x] Link to examples

- [x] Add proper logging:
  - [x] Use `log()` from `dart:developer`
  - [x] Add debug logging for validation process
  - [x] Never use `print()` statements

## 9. Implementation Priority Order

### Phase 1 - Core Foundation:

1. [x] Project structure and exports
2. [x] ValidationRule abstract class
3. [x] Basic type validation rules
4. [x] FieldPath implementation
5. [x] ValidationException system

### Phase 2 - Validation Engine:

1. [x] InputValidate class structure
2. [x] All validation rules implemented (type, constraint, format, special)
3. [x] Basic field validation logic
4. [x] Simple path handling (no wildcards)
5. [x] Error collection and throwing

### Phase 3 - Advanced Features:

1. [x] Wildcard path expansion
2. [x] Array validation
3. [x] Constraint rules (Min, Max, In)
4. [x] Format rules (Email)
5. [x] Special rules (Nullable)

### Phase 4 - Polish & Testing:

1. [x] Comprehensive testing (78+ tests passing)
2. [x] Performance optimizations
3. [x] Documentation
4. [x] Examples and README

### Phase 5 - Post-Launch Improvements:

1. [x] Rename type validation rules for clarity (`StringRule` → `IsStringRule`, etc.)
2. [x] Update all codebase references and maintain backward compatibility
3. [x] Verify test compatibility and documentation updates
4. [x] API improvements successfully implemented with zero breaking changes
5. [x] Code formatting improvements for better readability and lint compliance
6. [x] Comprehensive debug logging for validation process debugging and performance analysis

## Success Criteria

- [x] All validation rules work correctly with appropriate error messages
- [x] Wildcard paths properly validate arrays and nested structures
- [x] Only validated fields are returned from input data
- [x] All validation errors are collected before throwing exception
- [x] Async rules are properly supported
- [x] Code follows Dart conventions with const constructors
- [x] Comprehensive test coverage (78+ tests passing)
- [x] Clear documentation and examples
