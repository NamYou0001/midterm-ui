import 'package:flutter_test/flutter_test.dart';
import 'package:employee_app/app/data/models/models.dart';

void main() {
  test('employee model maps API data and exposes a full name', () {
    final employee = Employee.fromJson({
      'id': 7,
      'firstName': 'Ada',
      'lastName': 'Lovelace',
      'email': 'ada@example.com',
      'phone': '123',
      'role': 'Manager',
    });

    expect(employee.fullName, 'Ada Lovelace');
    expect(employee.toJson()['role'], 'Manager');
  });
}
