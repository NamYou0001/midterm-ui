import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Column(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.restaurant_menu,
                              size: 36, color: Colors.white),
                        ),
                        SizedBox(height: 16),
                        Text('Restaurant Manager',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700)),
                        SizedBox(height: 4),
                        Text('Everything your team needs, in one place.',
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text('Welcome back',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                  const SizedBox(height: 6),
                  Text('Sign in to continue to your dashboard.',
                      style: TextStyle(color: colors.onSurfaceVariant)),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: controller.username,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: controller.password,
                    obscureText: true,
                    onFieldSubmitted: (_) => controller.login(),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Obx(() => SizedBox(
                        height: 54,
                        child: FilledButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.login,
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white))
                              : const Text('Sign in',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      )),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer.withValues(alpha: .45),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Demo account\nUsername: emilys  •  Password: emilyspass',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
