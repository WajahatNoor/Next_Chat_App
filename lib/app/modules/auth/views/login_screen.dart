import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:next_chat/app/modules/auth/bloc/auth_bloc.dart';
import 'package:next_chat/app/modules/auth/widgets/textfield.dart';
import 'package:next_chat/app/res/app_colors.dart';
import 'package:next_chat/app/routes/app_routes.dart';
import 'package:next_chat/app/utils/app_loader.dart';
import 'package:next_chat/app/utils/app_validators.dart' show AppValidators;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isPasswordVisible.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    context.read<AuthBloc>().add(
      LoginAccountEvent(email: email, password: password),
    );
  }

  void _goToRegister() {
    context.push(AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UserLoginLoadingState) {
            AppLoader.showLoaderWithDialog();
          }
          if (state is AuthenticatedState) {
            AppLoader.hideLoader();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Login Successful")));
          }

          if (state is UserLoginErrorState) {
            AppLoader.hideLoader();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },

        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),

                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),

                  child: Form(
                    key: _formKey,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // Logo
                        Center(
                          child: Container(
                            width: 68,
                            height: 68,

                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: const Icon(
                              Icons.chat_bubble_rounded,
                              color: AppColors.surface,
                              size: 34,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Title
                        const Center(
                          child: Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Center(
                          child: Text(
                            'Login to continue to Next Chat',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Email
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),

                        const SizedBox(height: 8),

                        AppTextField(
                          controller: _emailController,
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: AppColors.secondaryText,
                          ),
                          validator: AppValidators.email,
                        ),

                        const SizedBox(height: 20),

                        // Password
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),

                        const SizedBox(height: 8),

                        ValueListenableBuilder<bool>(
                          valueListenable: _isPasswordVisible,

                          builder: (context, isVisible, _) {
                            return AppTextField(
                              controller: _passwordController,
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              obscureText: !isVisible,

                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: AppColors.secondaryText,
                              ),

                              suffixIcon: IconButton(
                                onPressed: () {
                                  _isPasswordVisible.value = !isVisible;
                                },

                                icon: Icon(
                                  isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.secondaryText,
                                ),
                              ),

                              validator: AppValidators.password,
                            );
                          },
                        ),

                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,

                          child: TextButton(
                            onPressed: () {
                              // Add forgot password later
                            },

                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 54,

                          child: ElevatedButton(
                            onPressed: _login,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,

                              foregroundColor: AppColors.surface,

                              disabledBackgroundColor: AppColors.primary
                                  .withValues(alpha: 0.6),

                              elevation: 0,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),

                            child: const Text(
                              'LOGIN',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Divider
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(color: AppColors.divider),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),

                              child: Text(
                                'OR',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ),

                            const Expanded(
                              child: Divider(color: AppColors.divider),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Register
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 14,
                                ),
                              ),

                              GestureDetector(
                                onTap: _goToRegister,

                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
