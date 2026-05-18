import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youscout_mobile/core/l10n/strings.dart';
import 'package:youscout_mobile/core/theme/app_colors.dart';
import 'package:youscout_mobile/features/auth/presentation/widgets/login_form.dart';
import 'package:youscout_mobile/features/auth/presentation/widgets/register_form.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.appName,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryNavy,
                                letterSpacing: -1,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Football Talent Discovery',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 24),
                        const TabBar(
                          labelColor: AppColors.primaryNavy,
                          unselectedLabelColor: AppColors.textSecondary,
                          indicatorColor: AppColors.primaryNavy,
                          tabs: [
                            Tab(text: AppStrings.login),
                            Tab(text: AppStrings.signUp),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(
                          height: 320,
                          child: TabBarView(
                            children: [
                              LoginForm(),
                              RegisterForm(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
