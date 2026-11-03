import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/employee_controller.dart';
import '../data/models/models.dart';

class EmployeeFormPage extends StatefulWidget {
  const EmployeeFormPage({super.key, this.employee});
  final Employee? employee;
  @override
  State<EmployeeFormPage> createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController firstName;
  late final TextEditingController lastName;
  late final TextEditingController email;
  late final TextEditingController phone;
  late final TextEditingController role;
  var saving = false;

  @override
  void initState() {
    super.initState();
    final employee = widget.employee;
    firstName = TextEditingController(text: employee?.firstName);
    lastName = TextEditingController(text: employee?.lastName);
    email = TextEditingController(text: employee?.email);
    phone = TextEditingController(text: employee?.phone);
    role = TextEditingController(text: employee?.role ?? 'Employee');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.employee == null ? 'Add employee' : 'Edit employee',
              style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(children: [
                  CircleAvatar(
                    radius: 28,
                    child: Icon(widget.employee == null
                        ? Icons.person_add_alt_1
                        : Icons.edit_outlined),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.employee == null
                          ? 'Add a new team member'
                          : 'Update team member details',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 24),
              const _SectionLabel('Personal information'),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _field(firstName, 'First name')),
                const SizedBox(width: 12),
                Expanded(child: _field(lastName, 'Last name')),
              ]),
              const SizedBox(height: 4),
              _field(email, 'Email', type: TextInputType.emailAddress),
              _field(phone, 'Phone', required: false, type: TextInputType.phone),
              const SizedBox(height: 8),
              const _SectionLabel('Work information'),
              const SizedBox(height: 12),
              _field(role, 'Role'),
              const SizedBox(height: 12),
              SizedBox(
                height: 54,
                child: FilledButton.icon(
                  onPressed: saving ? null : _save,
                  icon: saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.check),
                  label: Text(saving ? 'Saving...' : 'Save employee'),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _field(TextEditingController controller, String label,
          {bool required = true, TextInputType? type}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          controller: controller,
          keyboardType: type,
          decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(label == 'Email'
                  ? Icons.email_outlined
                  : label == 'Phone'
                      ? Icons.phone_outlined
                      : label == 'Role'
                          ? Icons.badge_outlined
                          : Icons.person_outline)),
          validator: required
              ? (value) => value == null || value.trim().isEmpty
                  ? '$label is required'
                  : label == 'Email' && !value.contains('@')
                      ? 'Enter a valid email'
                      : null
              : null,
        ),
      );

  Future<void> _save() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => saving = true);
    final employee = Employee(
      id: widget.employee?.id ?? 0,
      firstName: firstName.text.trim(),
      lastName: lastName.text.trim(),
      email: email.text.trim(),
      phone: phone.text.trim(),
      role: role.text.trim(),
    );
    final saved = await Get.find<EmployeeController>().save(employee);
    if (mounted) {
      setState(() => saving = false);
      if (saved) Get.back();
    }
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    phone.dispose();
    role.dispose();
    super.dispose();
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Text(label,
      style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w800,
          letterSpacing: .2));
}
