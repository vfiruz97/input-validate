I want to write an input data validation package, that I can validate request data in my server application.
I inspired by PHP Laravel Framework request validation.

This a pure dart package for validating map data. The map can be deeply nested and contain various data types, including strings, numbers, booleans, lists, and other maps. The validation rules should be flexible and allow for custom validation logic to be applied at different levels of the map structure.

The package should be build with Dart and have the following features:

## [ValidationRule] Abstract class for validation rules

The abstract class for defining validation rules and all validation rules should extend this class:

- It has a `message` getter which describes the validation error message.
- It has a `FutureOr<bool> passes(dynamic value)` method which takes a value and returns a boolean indicating whether the value is valid according to the rule.

There will be more build-in validation rules that extend this class, such as:

- `RequiredRule`: Validates that a value is not null or empty
- `StringRule`: Validates that a value is a string type
- `NumberRule`: Validates that a value is a number type
- `BooleanRule`: Validates that a value is a boolean type
- `ListRule`: Validates that a value is a list type
- `MapRule`: Validates that a value is a map type
- `EmailRule`: Validates that a string is a valid email format
- `NullableRule`: Validates that a value can be null
- `MinRule`: Validates that a number is greater than or equal to a specified minimum value
- `MaxRule`: Validates that a number is less than or equal to a specified maximum value
- `InRule`: Validates that a value is in a specified list of allowed values

## Field Path Schema

This class represents the path key of a field in a map.

- It has a `name` property which is the key of the value in the map.
- It has a `bool get isWildcard` getter which indicates whether the key is a wildcard (e.g., `*`).

Example:

```dart
'users.*.name' // it will be list of Field Path  [users, *, name]
```

## [ValidationException] abstract exception class

All exception will be extend of this class. This exception is thrown when validation fails.

- It has a `String get message` getter which returns the error message.
- It has a `Map<String, dynamic>? inputErrors` getter which returns a map of field paths to error messages for each field that failed validation.

Example:

```dart
throw ValidationException('Validation failed', {
  'users.*.name': ['Name is required'],
  'users.*.email': ['Email is required', 'Email is invalid'],
});
```

## [InputValidate] class

This class where orchestrates the validation process. It does the following:

- Parses field paths and validation rules.
- Validates the input data against the defined rules.
- It has a method `static Future<Map<String, dynamic>> validate(Map<String, dynamic> input, Map<String, List<dynamic>> rules)` which takes the input data and validation rules and returns a map of only data which was valid according to the rules.
- The `validate` method should throw a `ValidationException` if any validation fails, containing the error messages for each field that failed validation.

Example usage:

```dart
final input = {
  'users': [
    {'name': 'John', 'email': 'john@example.com', 'age': 30},
    {'name': 'Jane', 'email': 'jane@example.com', 'age': 25},
  ]
};

final rules = {
  'users.*.name': [RequiredRule(), StringRule(), MinRule(2), MaxRule(50)],
  'users.*.email': [RequiredRule(), EmailRule()],
};
final validatedData = await InputValidate.validate(input, rules);

// validatedData will be:
// {
//   'users': [
//     {'name': 'John', 'email': 'john@example.com'},
//     {'name': 'Jane', 'email': 'jane@example.com'},
//   ]
// }
```

## Code Style

- Ensure proper separation of concerns by creating a suitable folder structure
- Put `const` constructors everywhere possible
- Use log from dart:developer rather than print or debugPrint for logging
