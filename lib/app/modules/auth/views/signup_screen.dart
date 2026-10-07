import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:next_chat/app/modules/auth/bloc/auth_bloc.dart';
import 'package:next_chat/app/modules/auth/widgets/textfield.dart';
import 'package:next_chat/app/res/app_colors.dart';
import 'package:next_chat/app/routes/app_routes.dart';
import 'package:next_chat/app/utils/app_loader.dart';
import 'package:next_chat/app/utils/app_validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier(false);

  final ValueNotifier<bool> _isConfirmPasswordVisible = ValueNotifier(false);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _isPasswordVisible.dispose();
    _isConfirmPasswordVisible.dispose();
    super.dispose();
  }

  void registerUser() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    context.read<AuthBloc>().add(
      CreateAccountEvent(
        userEmail: email,
        userPassword: password,
        userName: name,
      ),
    );
  }

  void _goToLogin() {
    context.push(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUserCreateLoadingState) {
            AppLoader.showLoaderWithDialog();
          }
          if (state is AuthenticatedState) {
            AppLoader.hideLoader();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Account Created Successfully")),
            );
          }

          if (state is AuthUserCreateErrorState) {
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
                            'Create Account',
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
                            'Create your account to start chatting',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Full Name
                        const Text(
                          'Full Name',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),

                        const SizedBox(height: 8),

                        AppTextField(
                          controller: _nameController,
                          labelText: 'Full Name',
                          hintText: 'Enter your full name',
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: AppColors.secondaryText,
                          ),
                          validator: AppValidators.required,
                        ),

                        const SizedBox(height: 20),

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

                              textInputAction: TextInputAction.next,

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
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.secondaryText,
                                ),
                              ),

                              validator: AppValidators.password,
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // Confirm Password
                        const Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),

                        const SizedBox(height: 8),

                        ValueListenableBuilder<bool>(
                          valueListenable: _isConfirmPasswordVisible,

                          builder: (context, isVisible, _) {
                            return AppTextField(
                              controller: _confirmPasswordController,

                              labelText: 'Confirm Password',

                              hintText: 'Re-enter your password',

                              obscureText: !isVisible,

                              textInputAction: TextInputAction.done,

                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: AppColors.secondaryText,
                              ),

                              suffixIcon: IconButton(
                                onPressed: () {
                                  _isConfirmPasswordVisible.value = !isVisible;
                                },

                                icon: Icon(
                                  isVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.secondaryText,
                                ),
                              ),

                              validator: (value) =>
                                  AppValidators.confirmPassword(
                                    value,
                                    _passwordController.text,
                                  ),
                            );
                          },
                        ),

                        const SizedBox(height: 28),

                        // Register Button
                        SizedBox(
                          width: double.infinity,
                          height: 54,

                          child: ElevatedButton(
                            onPressed: registerUser,

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
                              'CREATE ACCOUNT',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Login
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 14,
                                ),
                              ),

                              GestureDetector(
                                onTap: _goToLogin,

                                child: const Text(
                                  'Login',
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
