// import 'dart:developer';
// import 'package:input_validate/input_validate.dart';

// void main(List<String> args) async {
//   final data = {
//     // Simple scalar
//     'name': 'John Doe',
//     'age': 30,
//     'active': true,
//     'score': null,

//     // Simple nested object
//     'profile': {
//       'first': 'Jane',
//       'last': 'Smith',
//       'settings': {'theme': 'dark', 'notifications': true}
//     },

//     // Array with objects
//     'users': [
//       {
//         'id': 1,
//         'name': 'Alice',
//         'contacts': [
//           {'type': 'phone', 'value': '123-456-7890'},
//           {'type': 'email', 'value': 'alice@test.com'}
//         ],
//         'tags': ['admin', 'active']
//       },
//       {
//         'id': 2,
//         'name': 'Bob',
//         'contacts': [
//           {'type': 'phone', 'value': '555-123-4567'}
//         ],
//         'tags': ['user']
//       },
//       {
//         'id': 3,
//         'name': 'Charlie',
//         'contacts': [],
//         'tags': ['inactive', 'temp', 'test']
//       }
//     ],

//     // Complex nested structure
//     'company': {
//       'departments': [
//         {
//           'name': 'Engineering',
//           'teams': [
//             {
//               'name': 'Backend',
//               'members': [
//                 {
//                   'name': 'Dev1',
//                   'skills': ['dart', 'python'],
//                   'projects': [
//                     {'name': 'API', 'status': 'active'},
//                     {'name': 'DB', 'status': 'completed'}
//                   ]
//                 },
//                 {
//                   'name': 'Dev2',
//                   'skills': ['flutter', 'dart'],
//                   'projects': [
//                     {'name': 'Mobile', 'status': 'active'}
//                   ]
//                 }
//               ]
//             },
//             {
//               'name': 'Frontend',
//               'members': [
//                 {
//                   'name': 'Dev3',
//                   'skills': ['react', 'js'],
//                   'projects': []
//                 }
//               ]
//             }
//           ]
//         },
//         {
//           'name': 'Marketing',
//           'teams': [
//             {
//               'name': 'Digital',
//               'members': [
//                 {
//                   'name': 'Marketer1',
//                   'skills': ['seo', 'ads'],
//                   'projects': [
//                     {'name': 'Campaign1', 'status': 'planning'}
//                   ]
//                 }
//               ]
//             }
//           ]
//         }
//       ]
//     },
//     'test': {
//       'nested': {
//         'array': [
//           {'key': 'value1'},
//           {'key': 'value2'}
//         ],
//         'object': {'innerKey': 'innerValue'}
//       },
//       'emptyArray': [],
//       'emptyObject': {}
//     }
//   };

//   try {
//     final validatedData = await InputValidate.validate(data, {
//       // === BASIC SCALAR VALIDATION ===
//       'name': [RequiredRule(), StringRule(), MinRule(2), MaxRule(80)],
//       'age': [RequiredRule(), NumberRule(), MinRule(18), MaxRule(119)],
//       'active': [RequiredRule(), BooleanRule()],
//       'score': [NullableRule(), StringRule()],

//       // === NESTED OBJECT VALIDATION ===
//       'profile.first': [RequiredRule(), StringRule(), MinRule(1), MaxRule(50)],
//       'profile.last': [RequiredRule(), StringRule(), MinRule(1), MaxRule(50)],
//       'profile.settings.theme': [RequiredRule(), StringRule(), InRule(['dark', 'light', 'auto'])],
//       'profile.settings.notifications': [RequiredRule(), BooleanRule()],

//       // === ARRAY WITH OBJECTS VALIDATION ===
//       'users': [RequiredRule(), ListRule(), MinRule(1), MaxRule(10)],
//       'users.*.id': [RequiredRule(), NumberRule(), MinRule(1)],
//       'users.*.name': [RequiredRule(), StringRule(), MinRule(2), MaxRule(50)],
//       'users.*.contacts': [NullableRule(), ListRule(), MaxRule(3)],
//       'users.*.contacts.*.type': [RequiredRule(), StringRule(), InRule(['phone', 'email', 'address'])],
//       'users.*.contacts.*.value': [RequiredRule(), StringRule(), MinRule(5), MaxRule(100)],
//       'users.*.tags': [RequiredRule(), ListRule(), MinRule(1), MaxRule(5)],
//       'users.*.tags.*': [RequiredRule(), StringRule(), MinRule(2), MaxRule(20)],

//       // === COMPLEX NESTED STRUCTURE VALIDATION ===
//       'company.departments': [RequiredRule(), ListRule(), MinRule(1), MaxRule(5)],
//       'company.departments.*.name': [RequiredRule(), StringRule(), MinRule(3), MaxRule(30)],
//       'company.departments.*.teams': [RequiredRule(), ListRule(), MinRule(1)],
//       'company.departments.*.teams.*.name': [RequiredRule(), StringRule(), MinRule(3), MaxRule(25)],
//       'company.departments.*.teams.*.members': [RequiredRule(), ListRule()],
//       'company.departments.*.teams.*.members.*.name': [RequiredRule(), StringRule(), MinRule(2), MaxRule(50)],
//       'company.departments.*.teams.*.members.*.skills': [RequiredRule(), ListRule(), MinRule(1), MaxRule(10)],
//       'company.departments.*.teams.*.members.*.skills.*': [RequiredRule(), StringRule(), MinRule(2), MaxRule(20)],
//       'company.departments.*.teams.*.members.*.projects': [NullableRule(), ListRule()],
//       'company.departments.*.teams.*.members.*.projects.*.name': [RequiredRule(), StringRule(), MinRule(2), MaxRule(30)],
//       'company.departments.*.teams.*.members.*.projects.*.status': [
//         RequiredRule(),
//         StringRule(),
//         InRule(['planning', 'active', 'completed', 'cancelled'])
//       ],

//       // === TEST SECTION VALIDATION ===
//       'test.nested.array': [RequiredRule(), ListRule()],
//       'test.nested.array.*.key': [RequiredRule(), StringRule(), MinRule(3)],
//       'test.nested.object.innerKey': [RequiredRule(), StringRule()],
//       'test.emptyArray': [ListRule(), MinRule(0), MaxRule(5)],

//       // === ADDITIONAL EDGE CASE VALIDATIONS ===
//       // Optional fields that might not exist
//       'optionalField': [NullableRule(), StringRule()],
//       'profile.optional': [NullableRule(), NumberRule(), MaxRule(1000)],
//     });
    
//     log('✅ All validation passed - data is completely valid!');
//     log('📦 Validated data contains ${validatedData.keys.length} fields');
//   } on ValidationException catch (e) {
//     log('❌ Validation failed: ${e.message}');

//     if (e.inputErrors == null) {
//       log('⚠️  Input errors are null');
//     } else {
//       log('📋 Validation Errors Summary:');
//       log('═' * 50);

//       var errorCount = 0;
//       for (final entry in e.inputErrors!.entries) {
//         errorCount++;
//         log('$errorCount. Field: "${entry.key}"');
//         log('   Error: ${entry.value}');
//       }

//       log('═' * 50);
//       log('Total errors found: $errorCount');
//     }
//   } catch (e) {
//     log('💥 Unexpected error occurred: $e');
//   }
// }