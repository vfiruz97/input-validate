I want to shorten the validation rule syntax. I have an idea like this:

```dart
RequiredRule Function() required = RequiredRule.new;
IsStringRule Function() string = IsStringRule.new;
MinRule Function(num) min = MinRule.new;
MaxRule Function(num) max = MaxRule.new;

final validatedData2 = await InputValidate.validate(data, {
    'name': [required(), string(), min(2), max(80)], // its shorter and more readable
    // 'name': [RequiredRule(), IsStringRule(), MinRule(2), MaxRule(80)],
```

What do you think about this idea? It makes the code more concise and easier to read, especially when using multiple rules.

If you agree, we can implement this change in the codebase.

- do this to all rules
- update example/main.dart to use the new syntax
- update CHANGELOG.md to reflect this new feature under "1.0.1"
- no need to change tests, they will still work with the new syntax
- update documentation (README.md) to explain the new syntax, keep being concise and clear
