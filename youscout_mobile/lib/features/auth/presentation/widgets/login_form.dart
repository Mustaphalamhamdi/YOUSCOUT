import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youscout_mobile/core/l10n/strings.dart';
import 'package:youscout_mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:youscout_mobile/shared/widgets/app_text_field.dart';
import 'package:youscout_mobile/shared/widgets/primary_button.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authNotifierProvider.notifier).login(_emailCtrl.text.trim(), _passwordCtrl.text);
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
            label: AppStrings.loginButton,
            onPressed: _submit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
