import 'dart:convert';

import 'package:client/features/admin/presentation/screens/admin_screen.dart';
import 'package:client/features/auth/presentation/providers/auth_provider.dart';
import 'package:client/features/menu/presentation/screens/main_navigation_screen.dart';
import 'package:flutter/material.dart';
import '../../../../core/colors.dart';
import '../widgets/custom_text_field.dart';
import 'signup_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../menu/presentation/screens/home_screen.dart';

// StateProvider to hold current login params
final loginParamsProvider = StateProvider<Map<String, String>?>((ref) => null);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final params = {
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    };

    ref.read(loginParamsProvider.notifier).state = params;
  }

  @override
  Widget build(BuildContext context) {
    final loginParams = ref.watch(loginParamsProvider);

    final loginAsync = loginParams == null
        ? const AsyncValue.data(null)
        : ref.watch(loginProvider(loginParams));

    // Navigate to Home if login successful and reset params to avoid repeated navigation
    loginAsync.whenData((session) {
      if (session != null) {

        final user = jsonDecode(session.user);

        final role = user['role'] ?? '';

        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          );
        }

        ref.read(loginParamsProvider.notifier).state = null;
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        //TEMPORARY CHANGE
                        //TODO: Remove this later
                        //MaterialPageRoute(builder: (_) => const AdminScreen()),
                        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                      );
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: AppColors.textGray, fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.mainOrange,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Center(
                          child: Text('🍔', style: TextStyle(fontSize: 40)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Login to continue ordering',
                        style: TextStyle(color: AppColors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 32),
                      CustomTextField(
                        hintText: 'Email Address',
                        icon: Icons.email_outlined,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: 'Password',
                        icon: Icons.lock_outline,
                        controller: _passwordController,
                        isPassword: !_isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.grey,
                          ),
                          onPressed: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.mainOrange,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: loginAsync.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.mainOrange,
                                ),
                              )
                            : ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainOrange,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 8,
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 24),
                      if (loginAsync.hasError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            loginAsync.error.toString(),
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppColors.grey.withOpacity(0.3),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR',
                              style: TextStyle(color: AppColors.grey),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppColors.grey.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.g_mobiledata, size: 24),
                              label: const Text('Google'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryDark,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.facebook, size: 20),
                              label: const Text('Facebook'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryDark,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignupScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: AppColors.mainOrange,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
