import 'package:get/get.dart';
import '../pages/login_page.dart';
import '../pages/home_page.dart';
import '../pages/employee_form_page.dart';

abstract class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const employeeForm = '/employee-form';
}

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
    GetPage(
      name: AppRoutes.employeeForm,
      page: () => EmployeeFormPage(employee: Get.arguments),
    ),
  ];
}
