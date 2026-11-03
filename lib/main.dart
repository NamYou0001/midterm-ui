import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/controllers/auth_controller.dart';
import 'app/controllers/employee_controller.dart';
import 'app/controllers/product_controller.dart';
import 'app/data/repositories/auth_repository.dart';
import 'app/data/repositories/employee_repository.dart';
import 'app/data/repositories/product_repository.dart';
import 'app/data/services/api_client.dart';
import 'app/data/services/token_storage.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final storage = TokenStorage(preferences);
  final client = ApiClient(storage);
  Get
    ..put(storage)
    ..put(client)
    ..put(AuthRepository(client, storage))
    ..put(ProductRepository(client))
    ..put(EmployeeRepository(client))
    ..put(AuthController(Get.find<AuthRepository>()))
    ..put(ProductController(Get.find<ProductRepository>()))
    ..put(EmployeeController(Get.find<EmployeeRepository>()));
  runApp(const EmployeeApp());
}

class EmployeeApp extends StatelessWidget {
  const EmployeeApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        title: 'Restaurant Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xffe86a33),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xfff8f7f4),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xfff8f7f4),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            margin: EdgeInsets.zero,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              side: BorderSide(color: Color(0xffeeeae4)),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
        ),
        initialRoute: AppRoutes.login,
        getPages: AppPages.pages,
      );
}
