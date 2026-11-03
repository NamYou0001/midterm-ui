import '../models/models.dart';
import '../services/api_client.dart';

class EmployeeRepository {
  EmployeeRepository(this._client);
  final ApiClient _client;

  Future<List<Employee>> getEmployees() async {
    final data =
        await _client.request('GET', '/users') as Map<String, dynamic>;
    return (data['users'] as List<dynamic>? ?? [])
        .map((item) => Employee.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Employee> create(Employee employee) async {
    final data = await _client.request('POST', '/users/add',
        body: employee.toJson()) as Map<String, dynamic>;
    return Employee.fromJson(data);
  }

  Future<Employee> update(Employee employee) async {
    final data = await _client.request('PUT', '/users/${employee.id}',
        body: employee.toJson()) as Map<String, dynamic>;
    return Employee.fromJson(data);
  }

  Future<void> delete(int id) => _client.request('DELETE', '/users/$id');
}
