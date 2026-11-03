import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/repositories/auth_repository.dart';
import '../data/services/api_client.dart';
import '../routes/app_pages.dart';

class AuthController extends GetxController {
  AuthController(this._repository);
  final AuthRepository _repository;
  final username = TextEditingController(text: 'emilys');
  final password = TextEditingController(text: 'emilyspass');
  final isLoading = false.obs;

  Future<void> login() async {
    if (username.text.trim().isEmpty || password.text.isEmpty) {
      Get.snackbar('Required fields', 'Enter your username and password.');
      return;
    }
    isLoading.value = true;
    try {
      await _repository.login(username.text.trim(), password.text);
      Get.offAllNamed(AppRoutes.home);
    } on ApiException catch (error) {
      Get.snackbar('Login failed', error.message);
    } catch (_) {
      Get.snackbar('Login failed', 'Check your connection and try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    username.dispose();
    password.dispose();
    super.onClose();
  }
}
