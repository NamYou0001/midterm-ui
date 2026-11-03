import 'package:get/get.dart';
import '../data/models/models.dart';
import '../data/repositories/employee_repository.dart';
import '../data/services/api_client.dart';

class EmployeeController extends GetxController {
  EmployeeController(this._repository);
  final EmployeeRepository _repository;
  final employees = <Employee>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      employees.assignAll(await _repository.getEmployees());
    } on ApiException catch (exception) {
      error.value = exception.message;
    } catch (_) {
      error.value = 'Unable to load employees.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> save(Employee employee) async {
    try {
      final saved = employee.id == 0
          ? await _repository.create(employee)
          : await _repository.update(employee);
      if (employee.id == 0) {
        employees.insert(0, saved);
      } else {
        final index = employees.indexWhere((item) => item.id == employee.id);
        if (index >= 0) employees[index] = saved;
      }
      return true;
    } on ApiException catch (exception) {
      Get.snackbar('Could not save employee', exception.message);
      return false;
    } catch (_) {
      Get.snackbar('Could not save employee', 'Please try again.');
      return false;
    }
  }

  Future<void> remove(Employee employee) async {
    try {
      await _repository.delete(employee.id);
      employees.removeWhere((item) => item.id == employee.id);
      Get.snackbar('Deleted', '${employee.fullName} was removed.');
    } on ApiException catch (exception) {
      Get.snackbar('Could not delete employee', exception.message);
    }
  }
}
