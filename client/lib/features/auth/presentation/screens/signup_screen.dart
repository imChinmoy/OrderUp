import 'dart:convert';

import 'package:client/features/admin/presentation/screens/admin_menu_screen.dart';
import 'package:client/features/admin/presentation/screens/admin_screen.dart';
import 'package:client/core/widgets/floating_background_icons.dart';
import 'package:client/features/menu/presentation/screens/main_navigation_screen.dart';
import 'package:client/features/profile/features/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/custom_text_field.dart';

import '../providers/auth_provider.dart';
import '../../../menu/presentation/screens/home_screen.dart';

final signupParamsProvider = StateProvider<Map<String, String>?>((ref) => null);

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _secretKeyController = TextEditingController();
  bool _isPasswordVisible = false;
  String _selectedRole = 'student';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _secretKeyController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    final params = {
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
      'name': _nameController.text.trim(),
      'role': _selectedRole,
      if (_selectedRole == 'admin') 'adminSecret': _secretKeyController.text.trim(),
    };
    ref.read(signupParamsProvider.notifier).state = params;
  }

  @override
  Widget build(BuildContext context) {
    final signupParams = ref.watch(signupParamsProvider);
    final signupAsync = signupParams == null
        ? const AsyncValue.data(null)
        : ref.watch(registerProvider(signupParams));

    signupAsync.whenData((session) {
      if (session != null) {
        final user = jsonDecode(session.user);

        final role = user['role'] ?? '';

        ref.invalidate(profileProvider);

        if (role == 'admin') {
          context.push('/admin');
        } else {
          context.push('/home');
        }
        ref.read(signupParamsProvider.notifier).state = null;
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          // Floating background icons
          const FloatingBackgroundIcons(
            imagePath: 'assets/background-float.png',
          ),
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.white),
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(height: 20),
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
                            'Create Account',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sign up to start ordering delicious food',
                            style: TextStyle(color: AppColors.grey, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          CustomTextField(
                            hintText: 'Full Name',
                            icon: Icons.person_outline,
                            controller: _nameController,
                          ),
                          const SizedBox(height: 16),
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
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_selectedRole == 'admin')
                            Column(
                              children: [
                                CustomTextField(
                                  hintText: 'Secret Key',
                                  icon: Icons.key,
                                  controller: _secretKeyController,
                                  isPassword: true,
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButton<String>(
                              value: _selectedRole,
                              isExpanded: true,
                              underline: const SizedBox(),
                              dropdownColor: AppColors.primaryDark,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.grey,
                              ),
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'student',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.school,
                                        color: AppColors.grey,
                                        size: 20,
                                      ),
                                      SizedBox(width: 12),
                                      Text('Student'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'admin',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.admin_panel_settings,
                                        color: AppColors.grey,
                                        size: 20,
                                      ),
                                      SizedBox(width: 12),
                                      Text('Admin'),
                                    ],
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: signupAsync.isLoading
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFFF8C42),
                                          Colors.deepOrange,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFFF8C42),
                                          Colors.deepOrange,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: _handleSignup,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 24),
                          if (signupAsync.hasError)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                signupAsync.error.toString(),
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
                                'Already have an account? ',
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.pop(),
                                child: const Text(
                                  'Sign In',
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
                    const SizedBox(height: 24),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(color: AppColors.grey, fontSize: 12),
                          children: [
                            TextSpan(text: 'By continuing, you agree to our '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(color: AppColors.mainOrange),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(color: AppColors.mainOrange),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}