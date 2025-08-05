import 'package:input_validate/input_validate.dart';
import 'package:test/test.dart';

void main() {
  group('NullableRule Integration Tests', () {
    test(
        'should skip other rules when value is null and NullableRule is present',
        () async {
      final rules = {
        'user.surname': [
          NullableRule(),
          IsStringRule(),
          MinRule(3),
          MaxRule(20),
        ],
      };

      final input = {
        'user': {'surname': null}
      };

      // Should pass validation because NullableRule allows null
      final result = await InputValidate.validate(input, rules);
      expect(
          result,
          equals({
            'user': {'surname': null}
          }));
    });

    test('should apply other rules when value is not null', () async {
      final rules = {
        'user.surname': [
          NullableRule(),
          IsStringRule(),
          MinRule(3),
          MaxRule(20),
        ],
      };

      final input = {
        'user': {'surname': 'John'}
      };

      // Should pass because 'John' meets all requirements
      final result = await InputValidate.validate(input, rules);
      expect(
          result,
          equals({
            'user': {'surname': 'John'}
          }));
    });

    test(
        'should fail other rules when value is not null and does not meet requirements',
        () async {
      final rules = {
        'user.surname': [
          NullableRule(),
          IsStringRule(),
          MinRule(3),
          MaxRule(20),
        ],
      };

      final input = {
        'user': {'surname': 'Jo'} // Too short (less than 3 characters)
      };

      // Should fail MinRule validation
      expect(
        () async => await InputValidate.validate(input, rules),
        throwsA(isA<ValidationException>()),
      );
    });

    test('should fail when value is null but no NullableRule is present',
        () async {
      final rules = {
        'user.surname': [
          IsStringRule(),
          MinRule(3),
          MaxRule(20),
        ],
      };

      final input = {
        'user': {'surname': null}
      };

      // Should fail because no NullableRule allows null
      expect(
        () async => await InputValidate.validate(input, rules),
        throwsA(isA<ValidationException>()),
      );
    });

    test('should work with wildcard paths', () async {
      final rules = {
        'users.*.email': [
          NullableRule(),
          IsStringRule(),
          EmailRule(),
        ],
      };

      final input = {
        'users': [
          {'email': 'user1@example.com'},
          {'email': null}, // This should pass due to NullableRule
          {'email': 'user3@example.com'},
        ]
      };

      final result = await InputValidate.validate(input, rules);
      expect(
          result,
          equals({
            'users': [
              {'email': 'user1@example.com'},
              {'email': null},
              {'email': 'user3@example.com'},
            ]
          }));
    });

    test('should work with nested paths and wildcards', () async {
      final rules = {
        'company.departments.*.teams.*.members.*.bio': [
          NullableRule(),
          IsStringRule(),
          MinRule(10),
        ],
      };

      final input = {
        'company': {
          'departments': [
            {
              'teams': [
                {
                  'members': [
                    {'bio': 'Software developer with 5 years experience'},
                    {'bio': null}, // Should pass due to NullableRule
                  ]
                }
              ]
            }
          ]
        }
      };

      final result = await InputValidate.validate(input, rules);
      expect(
          result['company']['departments'][0]['teams'][0]['members'][0]['bio'],
          equals('Software developer with 5 years experience'));
      expect(
          result['company']['departments'][0]['teams'][0]['members'][1]['bio'],
          equals(null));
    });

    test('should handle multiple fields with different nullable configurations',
        () async {
      final rules = {
        'user.name': [
          RequiredRule(),
          IsStringRule()
        ], // Required, no null allowed
        'user.email': [NullableRule(), IsStringRule(), EmailRule()], // Optional
        'user.age': [RequiredRule(), IsNumberRule(), MinRule(0)], // Required
        'user.bio': [NullableRule(), IsStringRule(), MinRule(10)], // Optional
      };

      final input = {
        'user': {
          'name': 'John Doe',
          'email': null, // Should pass due to NullableRule
          'age': 25,
          'bio': null, // Should pass due to NullableRule
        }
      };

      final result = await InputValidate.validate(input, rules);
      expect(
          result,
          equals({
            'user': {
              'name': 'John Doe',
              'email': null,
              'age': 25,
              'bio': null,
            }
          }));
    });

    test(
        'should fail when required field is null even with other rules present',
        () async {
      final rules = {
        'user.name': [
          RequiredRule(),
          NullableRule(),
          IsStringRule()
        ], // Required overrides nullable
      };

      final input = {
        'user': {'name': null}
      };

      // Should fail because RequiredRule doesn't allow null regardless of NullableRule
      expect(
        () async => await InputValidate.validate(input, rules),
        throwsA(isA<ValidationException>()),
      );
    });

    test('should work with complex validation scenarios', () async {
      final rules = {
        'order.customer.name': [RequiredRule(), IsStringRule()],
        'order.customer.email': [NullableRule(), IsStringRule(), EmailRule()],
        'order.items.*.name': [RequiredRule(), IsStringRule()],
        'order.items.*.price': [RequiredRule(), IsNumberRule(), MinRule(0)],
        'order.items.*.description': [
          NullableRule(),
          IsStringRule(),
          MinRule(5)
        ],
        'order.notes': [NullableRule(), IsStringRule()],
      };

      final input = {
        'order': {
          'customer': {
            'name': 'Jane Smith',
            'email': null, // Optional
          },
          'items': [
            {
              'name': 'Widget A',
              'price': 19.99,
              'description': null, // Optional
            },
            {
              'name': 'Widget B',
              'price': 29.99,
              'description': 'High quality widget', // Valid description
            },
          ],
          'notes': null, // Optional
        }
      };

      final result = await InputValidate.validate(input, rules);
      expect(result['order']['customer']['email'], equals(null));
      expect(result['order']['items'][0]['description'], equals(null));
      expect(result['order']['notes'], equals(null));
    });
  });
}
