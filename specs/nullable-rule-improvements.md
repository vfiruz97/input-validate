Just now notice that the NullableRule is not what It was meant to be. This is a special rule.
It does not take any params.

- It should allow values be null
- If the value is null and there is NullableRule, then it should not be validated with any other rules.

Example:

```dart
'user.surname': [
  NullableRule(),
  StringRule(),
  MinLengthRule(3),
  MaxLengthRule(20),
], // we allow `user.surname` pass validation if it is null. if `user.surname` is null, then it will not be validated with StringRule, MinLengthRule, MaxLengthRule, otherwise it will be validated with all of them.
```
