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
    // === EXAMPLE 1: CONCISE SYNTAX (NEW APPROACH) ===
    print('\n🚀 Example 1: Using Concise Syntax');
    final validatedData = await InputValidate.validate(data, {
      // === BASIC SCALAR VALIDATION ===
      'name': [required(), string(), min(2), max(80)],
      'age': [required(), number(), min(18), max(119)],
      'active': [required(), boolean()],
      'score': [nullable(), string()],

      // === NESTED OBJECT VALIDATION ===
      'profile.first': [required(), string(), min(1), max(50)],
      'profile.last': [required(), string(), min(1), max(50)],
      'profile.settings.theme': [
        required(),
        string(),
        inSet({'dark', 'light', 'auto'})
      ],
      'profile.settings.notifications': [required(), boolean()],

      // === ARRAY WITH OBJECTS VALIDATION ===
      'users': [required(), list(), min(1), max(10)],
      'users.*.id': [RequiredRule(), IsNumberRule(), MinRule(1)],
      'users.*.name': [required(), string(), min(2), max(50)],
      'users.*.contacts': [nullable(), list(), max(3)],
      'users.*.contacts.*.type': [
        required(),
        string(),
        inSet({'phone', 'email', 'address'})
      ],
      'users.*.contacts.*.value': [required(), string(), min(5), max(100)],
      'users.*.tags': [required(), list(), min(1), max(5)],
      'users.*.tags.*': [required(), string(), min(2), max(20)],

      // === COMPLEX NESTED STRUCTURE VALIDATION ===
      'company.departments': [required(), list(), min(1), max(5)],
      'company.departments.*.name': [RequiredRule(), IsStringRule(), MinRule(3), MaxRule(30)],
      'company.departments.*.teams': [RequiredRule(), IsListRule(), MinRule(1)],
      'company.departments.*.teams.*.name': [RequiredRule(), IsStringRule(), MinRule(3), MaxRule(25)],
      'company.departments.*.teams.*.members': [RequiredRule(), IsListRule()],
      'company.departments.*.teams.*.members.*.name': [RequiredRule(), IsStringRule(), MinRule(2), MaxRule(50)],
      'company.departments.*.teams.*.members.*.skills': [RequiredRule(), IsListRule(), MinRule(1), MaxRule(10)],
      'company.departments.*.teams.*.members.*.skills.*': [RequiredRule(), IsStringRule(), MinRule(2), MaxRule(20)],
      'company.departments.*.teams.*.members.*.projects': [NullableRule(), IsListRule()],
      'company.departments.*.teams.*.members.*.projects.*.name': [
        RequiredRule(),
        IsStringRule(),
        MinRule(2),
        MaxRule(30)
      ],
      'company.departments.*.name': [required(), string(), max(30)],
      'company.departments.*.teams': [required(), list(), min(1)],
      'company.departments.*.teams.*.name': [required(), string(), max(25)],
      'company.departments.*.teams.*.members': [required(), list()],
      'company.departments.*.teams.*.members.*.name': [required(), string(), min(2), max(50)],
      'company.departments.*.teams.*.members.*.skills': [required(), list(), min(1), max(10)],
      'company.departments.*.teams.*.members.*.skills.*': [required(), string(), min(2), max(20)],
      'company.departments.*.teams.*.members.*.projects': [nullable(), list()],
      'company.departments.*.teams.*.members.*.projects.*.name': [required(), string(), min(2), max(30)],
      'company.departments.*.teams.*.members.*.projects.*.status': [
        required(),
        string(),
        inSet({'planning', 'active', 'completed', 'cancelled'})
      ],

      // === TEST SECTION VALIDATION ===
      'test.nested.array': [required(), list()],
      'test.nested.array.*.key': [required(), string(), min(3)],
      'test.nested.object.innerKey': [required(), string()],
      'test.emptyArray': [list(), min(0), max(5)],

      // === ADDITIONAL EDGE CASE VALIDATIONS ===
      'optionalField': [nullable(), string()],
      'profile.optional': [nullable(), number(), max(1000)],
    });

    print('✅ Concise Syntax Validation passed!');
    print('📊 Validated data has ${validatedData.keys.length} top-level fields');
    print('📄 Sample field: name = "${validatedData['name']}"');

    // === EXAMPLE 2: VERBOSE SYNTAX (BACKWARD COMPATIBILITY) ===
    print('\n🔄 Example 2: Using Verbose Syntax (Backward Compatibility)');
    final validatedData2 = await InputValidate.validate({
      'name': 'John Doe',
      'bis': [1, 2, 3, 4, 5],
    }, {
      'name': [RequiredRule(), IsStringRule(), MinRule(2), MaxRule(80)],
      'bis': [RequiredRule(), IsListRule()],
      'bis.*': [RequiredRule(), IsNumberRule()],
    });

    print('✅ Verbose Syntax Validation passed!');
    print('📊 Validated data has ${validatedData2.keys.length} top-level fields');
    print('📄 Sample field: bis = ${validatedData2['bis']}');
  } on ValidationException catch (e) {
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
