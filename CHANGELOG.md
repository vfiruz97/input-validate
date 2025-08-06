## 1.0.1

### Added

- **Concise rule syntax** for cleaner validation code
- New shorthand functions: `required()`, `string()`, `number()`, `boolean()`, `list()`, `map()`, `email()`, `nullable()`, `min()`, `max()`, `inSet()`
- Function-style rule creators that provide more readable validation definitions
- Backward compatibility aliases: `isString()`, `isNumber()`, `isBoolean()`, `isList()`, `isMap()`, `allowedValues()`

### Changed

- Enhanced developer experience with more concise syntax
- Updated example files to demonstrate both concise and verbose syntax

### Example

```dart
// New concise syntax (recommended)
'name': [required(), string(), min(2), max(80)]

// Old verbose syntax (still supported)
'name': [RequiredRule(), IsStringRule(), MinRule(2), MaxRule(80)]
```

**Note:** Full backward compatibility maintained - all existing code continues to work unchanged.

## 1.0.0

🎉 **Initial release** of Input Validate - A powerful validation package for nested map data structures.

### Features

- **Laravel-style validation rules** with familiar syntax and comprehensive rule set
- **Wildcard path support** for validating arrays and nested structures (`users.*.email`)
- **Performance optimizations** including parallel validation and field path caching
- **Comprehensive validation rules**:
  - Type rules: `RequiredRule`, `IsStringRule`, `IsNumberRule`, `IsBooleanRule`, `IsListRule`, `IsMapRule`
  - Constraint rules: `MinRule`, `MaxRule`, `InRule`
  - Format rules: `EmailRule`
  - Special rules: `NullableRule`
- **Async rule support** with `FutureOr<bool>` for both sync and async validation
- **Smart data filtering** - returns only validated fields, stripping unvalidated data
- **Detailed error reporting** with field-specific error messages and path information
- **Debug logging** capabilities for development and troubleshooting
- **Cache management** with field path caching and manual cache clearing
