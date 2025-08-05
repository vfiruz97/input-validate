import 'package:input_validate/input_validate.dart';

void main(List<String> args) async {
  final data = {
    // Simple scalar
    'name': 'John Doe',
    'age': 30,
    'active': true,
    'score': null,

    // Simple nested object
    'profile': {
      'first': 'Jane',
      'last': 'Smith',
      'settings': {'theme': 'dark', 'notifications': true}
    },

    // Array with objects
    'users': [
      {
        'id': 1,
        'name': 'Alice',
        'contacts': [
          {'type': 'phone', 'value': '123-456-7890'},
          {'type': 'email', 'value': 'alice@test.com'}
        ],
        'tags': ['admin', 'active']
      },
      {
        'id': 2,
        'name': 'Bob',
        'contacts': [
          {'type': 'phone', 'value': '555-123-4567'}
        ],
        'tags': ['user']
      },
      {
        'id': 3,
        'name': 'Charlie',
        'contacts': null,
        'tags': ['inactive', 'temp', 'test']
      }
    ],

    // Complex nested structure
    'company': {
      'departments': [
        {
          'name': 'Engineering',
          'teams': [
            {
              'name': 'Backend',
              'members': [
                {
                  'name': 'Dev1',
                  'skills': ['dart', 'python'],
                  'projects': [
                    {'name': 'API', 'status': 'active'},
                    {'name': 'DB', 'status': 'completed'}
                  ]
                },
                {
                  'name': 'Dev2',
                  'skills': ['flutter', 'dart'],
                  'projects': [
                    {'name': 'Mobile', 'status': 'active'}
                  ]
                }
              ]
            },
            {
              'name': 'Frontend',
              'members': [
                {
                  'name': 'Dev3',
                  'skills': ['react', 'js'],
                  'projects': null,
                }
              ]
            }
          ]
        },
        {
          'name': 'Marketing',
          'teams': [
            {
              'name': 'Digital',
              'members': [
                {
                  'name': 'Marketer1',
                  'skills': ['seo', 'ads'],
                  'projects': [
                    {'name': 'Campaign1', 'status': 'planning'}
                  ]
                }
              ]
            }
          ]
        }
      ]
    },
    'test': {
      'nested': {
        'array': [
          {'key': 'value1'},
          {'key': 'value2'}
        ],
        'object': {'innerKey': 'innerValue'}
      },
      'emptyArray': [],
    }
  };

  try {
    final validatedData = await InputValidate.validate(data, {
      // === BASIC SCALAR VALIDATION ===
      'name': [RequiredRule(), IsStringRule(), MinRule(2), MaxRule(80)],
      'age': [RequiredRule(), IsNumberRule(), MinRule(18), MaxRule(119)],
      'active': [RequiredRule(), IsBooleanRule()],
      'score': [NullableRule(), IsStringRule()],

      // === NESTED OBJECT VALIDATION ===
      'profile.first': [
        RequiredRule(),
        IsStringRule(),
        MinRule(1),
        MaxRule(50)
      ],
      'profile.last': [RequiredRule(), IsStringRule(), MinRule(1), MaxRule(50)],
      'profile.settings.theme': [
        RequiredRule(),
        IsStringRule(),
        InRule({'dark', 'light', 'auto'})
      ],
      'profile.settings.notifications': [RequiredRule(), IsBooleanRule()],

      // === ARRAY WITH OBJECTS VALIDATION ===
      'users': [RequiredRule(), IsListRule(), MinRule(1), MaxRule(10)],
      'users.*.id': [RequiredRule(), IsNumberRule(), MinRule(1)],
      'users.*.name': [RequiredRule(), IsStringRule(), MinRule(2), MaxRule(50)],
      'users.*.contacts': [NullableRule(), IsListRule(), MaxRule(3)],
      'users.*.contacts.*.type': [
        RequiredRule(),
        IsStringRule(),
        InRule({'phone', 'email', 'address'})
      ],
      'users.*.contacts.*.value': [
        RequiredRule(),
        IsStringRule(),
        MinRule(5),
        MaxRule(100)
      ],
      'users.*.tags': [RequiredRule(), IsListRule(), MinRule(1), MaxRule(5)],
      'users.*.tags.*': [
        RequiredRule(),
        IsStringRule(),
        MinRule(2),
        MaxRule(20)
      ],

      // === COMPLEX NESTED STRUCTURE VALIDATION ===
      'company.departments': [
        RequiredRule(),
        IsListRule(),
        MinRule(1),
        MaxRule(5)
      ],
      'company.departments.*.name': [
        RequiredRule(),
        IsStringRule(),
        MinRule(3),
        MaxRule(30)
      ],
      'company.departments.*.teams': [RequiredRule(), IsListRule(), MinRule(1)],
      'company.departments.*.teams.*.name': [
        RequiredRule(),
        IsStringRule(),
        MinRule(3),
        MaxRule(25)
      ],
      'company.departments.*.teams.*.members': [RequiredRule(), IsListRule()],
      'company.departments.*.teams.*.members.*.name': [
        RequiredRule(),
        IsStringRule(),
        MinRule(2),
        MaxRule(50)
      ],
      'company.departments.*.teams.*.members.*.skills': [
        RequiredRule(),
        IsListRule(),
        MinRule(1),
        MaxRule(10)
      ],
      'company.departments.*.teams.*.members.*.skills.*': [
        RequiredRule(),
        IsStringRule(),
        MinRule(2),
        MaxRule(20)
      ],
      'company.departments.*.teams.*.members.*.projects': [
        NullableRule(),
        IsListRule()
      ],
      'company.departments.*.teams.*.members.*.projects.*.name': [
        RequiredRule(),
        IsStringRule(),
        MinRule(2),
        MaxRule(30)
      ],
      'company.departments.*.teams.*.members.*.projects.*.status': [
        RequiredRule(),
        IsStringRule(),
        InRule({'planning', 'active', 'completed', 'cancelled'})
      ],

      // === TEST SECTION VALIDATION ===
      'test.nested.array': [RequiredRule(), IsListRule()],
      'test.nested.array.*.key': [RequiredRule(), IsStringRule(), MinRule(3)],
      'test.nested.object.innerKey': [RequiredRule(), IsStringRule()],
      'test.emptyArray': [IsListRule(), MinRule(0), MaxRule(5)],

      // === ADDITIONAL EDGE CASE VALIDATIONS ===
      // Optional fields that might not exist
      'optionalField': [NullableRule(), IsStringRule()],
      'profile.optional': [NullableRule(), IsNumberRule(), MaxRule(1000)],
    });

    print('✅ All validation passed - data is completely valid!');
    print('📦 Validated data contains ${validatedData.keys.length} fields');
    print(validatedData);
  } on ValidationException catch (e) {
    print(e.inputErrors);
    print('❌ Validation failed: ${e.message}');

    if (e.inputErrors == null) {
      print('⚠️  Input errors are null');
    } else {
      print('📋 Validation Errors Summary:');
      print('═' * 50);

      var errorCount = 0;
      for (final entry in e.inputErrors!.entries) {
        errorCount++;
        print('$errorCount. Field: "${entry.key}"');
        print('   Error: ${entry.value}');
      }

      print('═' * 50);
      print('Total errors found: $errorCount');
    }
  } catch (e) {
    print('💥 Unexpected error occurred: $e');
  }
}
