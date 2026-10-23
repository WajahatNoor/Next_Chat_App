import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:next_chat/app/modules/auth/bloc/auth_bloc.dart';
import 'package:next_chat/app/modules/auth/widgets/textfield.dart';
import 'package:next_chat/app/res/app_colors.dart';
import 'package:next_chat/app/routes/app_routes.dart';
import 'package:next_chat/app/utils/app_validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  //forgot password method
  void _resetPassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final String email = _emailController.text.trim();
    if (email.isEmpty || email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("email is empty try to provide please")),
      );
    }
    context.read<AuthBloc>().add(SendResetPasswordEmailEvent(email: email));
  }

  @override
  Widget build(BuildContext widgetContext) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        buildWhen: (previous, current) => current is! AuthActionState,
        listenWhen: (previous, current) => current is AuthActionState,
        listener: (context, state) {
          if (state is ResetPasswordEmailSendErrorState) {
            context.go(AppRoutes.login);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Error ${state.message}")));
          }
          if (state is ResetPasswordEmailSendSuccessState) {
            context.go(AppRoutes.login);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("${state.successMessage}")));
          }
        },
        builder: (context, state) {
          final isLoading = state is ResetPasswordEmailSendLoadingState;
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
                        const SizedBox(height: 28),

                        // Title
                        const Center(
                          child: Text(
                            'Forgot your password',
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
                            'Enter your registored email address and we will send you a link to reset your password.',
                            textAlign: TextAlign.center,
                            maxLines: 2,

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

                        const SizedBox(height: 12),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 54,

                          child: ElevatedButton(
                            onPressed: isLoading ? null : _resetPassword,
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

                            child: isLoading
                                ? CircularProgressIndicator.adaptive(
                                    backgroundColor: Colors.white,
                                  )
                                : const Text(
                                    'Send',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Divider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Text("Remember Password?"),
                            InkWell(
                              onTap: context.pop,
                              child: Text(
                                ' Login',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
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
