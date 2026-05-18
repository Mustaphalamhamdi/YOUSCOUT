import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youscout_mobile/core/l10n/strings.dart';
import 'package:youscout_mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:youscout_mobile/shared/widgets/app_text_field.dart';
import 'package:youscout_mobile/shared/widgets/primary_button.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authNotifierProvider.notifier).register(
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
          _nameCtrl.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);
    final isLoading = state.isLoading;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: AppStrings.displayName,
            controller: _nameCtrl,
            textInputAction: TextInputAction.next,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? AppStrings.displayNameRequired : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: AppStrings.email,
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (v) =>
                (v == null || !v.contains('@')) ? AppStrings.invalidEmail : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: AppStrings.password,
            controller: _passwordCtrl,
            obscureText: true,
            textInputAction: TextInputAction.done,
            validator: (v) =>
                (v == null || v.length < 6) ? AppStrings.passwordTooShort : null,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: AppStrings.registerButton,
            onPressed: _submit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
