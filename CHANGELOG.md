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
