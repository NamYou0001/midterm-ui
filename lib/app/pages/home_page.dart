import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/employee_controller.dart';
import '../controllers/product_controller.dart';
import '../data/models/models.dart';
import '../routes/app_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final isEmployees = index == 1;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isEmployees ? 'Team' : 'Good day',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    )),
            Text(isEmployees ? 'Manage your employees' : 'Manage your menu',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          IconButton(
            onPressed: Get.find<AuthController>().logout,
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: index,
        children: const [_ProductsTab(), _EmployeesTab()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2),
              label: 'Products'),
          NavigationDestination(
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups),
              label: 'Employees'),
        ],
      ),
      floatingActionButton: isEmployees
          ? FloatingActionButton.extended(
              onPressed: () => Get.toNamed(AppRoutes.employeeForm),
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Add employee'))
          : null,
    );
  }
}

class _ProductsTab extends GetView<ProductController> {
  const _ProductsTab();
  @override
  Widget build(BuildContext context) => Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value.isNotEmpty) {
          return _ErrorState(message: controller.error.value, retry: controller.load);
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: controller.products.isEmpty
              ? const _EmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: 'No products yet',
                  message: 'Your menu items will appear here.')
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    _SummaryBanner(
                        icon: Icons.restaurant,
                        title: '${controller.products.length} menu items',
                        subtitle: 'Keep your restaurant menu up to date'),
                    const SizedBox(height: 18),
                    ...controller.products.map((product) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ProductCard(product),
                        )),
                  ],
                ),
        );
      });
}

class _EmployeesTab extends GetView<EmployeeController> {
  const _EmployeesTab();
  @override
  Widget build(BuildContext context) => Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value.isNotEmpty) {
          return _ErrorState(message: controller.error.value, retry: controller.load);
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: controller.employees.isEmpty
              ? const _EmptyState(
                  icon: Icons.groups_outlined,
                  title: 'No employees yet',
                  message: 'Add your first team member to get started.')
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                  children: [
                    _SummaryBanner(
                        icon: Icons.verified_user_outlined,
                        title: '${controller.employees.length} team members',
                        subtitle: 'Your restaurant team at a glance'),
                    const SizedBox(height: 18),
                    ...controller.employees.map((employee) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _EmployeeCard(employee),
                        )),
                  ],
                ),
        );
      });
}

class _SummaryBanner extends StatelessWidget {
  const _SummaryBanner(
      {required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.primary.withValues(alpha: .78)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white24,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(subtitle, style: const TextStyle(color: Colors.white70)),
        ]),
      ]),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard(this.product);
  final Product product;
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: product.thumbnail.isEmpty
                  ? Container(
                      width: 68,
                      height: 68,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: const Icon(Icons.fastfood_outlined))
                  : Image.network(product.thumbnail,
                      width: 68, height: 68, fit: BoxFit.cover),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(product.category,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ]),
            ),
            const SizedBox(width: 8),
            Text('\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w800)),
          ]),
        ),
      );
}

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard(this.employee);
  final Employee employee;
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(employee.firstName.isEmpty ? '?' : employee.firstName[0],
                  style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(employee.fullName,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(employee.role,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(employee.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall),
              ]),
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  Get.toNamed(AppRoutes.employeeForm, arguments: employee);
                } else if (value == 'delete') {
                  final confirmed = await Get.dialog<bool>(
                    AlertDialog(
                      title: const Text('Delete employee?'),
                      content: Text('Remove ${employee.fullName} from the team?'),
                      actions: [
                        TextButton(
                            onPressed: Get.back,
                            child: const Text('Cancel')),
                        FilledButton(
                            onPressed: () => Get.back(result: true),
                            child: const Text('Delete')),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    await Get.find<EmployeeController>().remove(employee);
                  }
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ]),
        ),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState(
      {required this.icon, required this.title, required this.message});
  final IconData icon;
  final String title;
  final String message;
  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 60, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(message),
        ]),
      );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.retry});
  final String message;
  final Future<void> Function() retry;
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.cloud_off,
                size: 52, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: retry, child: const Text('Try again')),
          ]),
        ),
      );
}
