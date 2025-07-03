import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  String _emailError = '';
  String _passwordError = '';

  // Mock credentials for testing
  final String _mockEmail = 'rider@rideconnect.com';
  final String _mockPassword = 'RideConnect123';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _isEmailValid &&
        _isPasswordValid;
  }

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _isEmailValid = false;
        _emailError = 'Email is required';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        _isEmailValid = false;
        _emailError = 'Enter a valid email address';
      } else {
        _isEmailValid = true;
        _emailError = '';
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _isPasswordValid = false;
        _passwordError = 'Password is required';
      } else if (value.length < 6) {
        _isPasswordValid = false;
        _passwordError = 'Password must be at least 6 characters';
      } else {
        _isPasswordValid = true;
        _passwordError = '';
      }
    });
  }

  Future<void> _handleLogin() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (_emailController.text == _mockEmail &&
        _passwordController.text == _mockPassword) {
      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home-feed');
      }
    } else {
      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid credentials. Use: ${_mockEmail} / ${_mockPassword}',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(4.w),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    HapticFeedback.selectionClick();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$provider login will be implemented with platform SDK',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.accentBlue,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _handleForgotPassword() {
    HapticFeedback.selectionClick();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Password reset link will be sent to your email',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.accentBlue,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 8.h),

                    // Logo Section
                    _buildLogoSection(),

                    SizedBox(height: 6.h),

                    // Login Form
                    _buildLoginForm(),

                    SizedBox(height: 4.h),

                    // Social Login Section
                    _buildSocialLoginSection(),

                    const Spacer(),

                    // Sign Up Link
                    _buildSignUpLink(),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: AppTheme.accentRed,
            borderRadius: BorderRadius.circular(4.w),
          ),
          child: CustomIconWidget(
            iconName: 'directions_car',
            color: AppTheme.textPrimary,
            size: 10.w,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'RideConnect',
          style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Connect with fellow riders',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          _buildEmailField(),

          SizedBox(height: 3.h),

          // Password Field
          _buildPasswordField(),

          SizedBox(height: 2.h),

          // Forgot Password Link
          _buildForgotPasswordLink(),

          SizedBox(height: 4.h),

          // Login Button
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          enabled: !_isLoading,
          onChanged: _validateEmail,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email address',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'email',
                color: AppTheme.textSecondary,
                size: 5.w,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color:
                    _isEmailValid ? AppTheme.surfaceColor : AppTheme.errorColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color:
                    _isEmailValid ? AppTheme.surfaceColor : AppTheme.errorColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color:
                    _isEmailValid ? AppTheme.accentBlue : AppTheme.errorColor,
                width: 2,
              ),
            ),
          ),
        ),
        if (!_isEmailValid && _emailError.isNotEmpty) ...[
          SizedBox(height: 1.h),
          Text(
            _emailError,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.errorColor,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          textInputAction: TextInputAction.done,
          enabled: !_isLoading,
          onChanged: _validatePassword,
          onFieldSubmitted: (_) => _handleLogin(),
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'lock',
                color: AppTheme.textSecondary,
                size: 5.w,
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName:
                      _isPasswordVisible ? 'visibility' : 'visibility_off',
                  color: AppTheme.textSecondary,
                  size: 5.w,
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: _isPasswordValid
                    ? AppTheme.surfaceColor
                    : AppTheme.errorColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: _isPasswordValid
                    ? AppTheme.surfaceColor
                    : AppTheme.errorColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: _isPasswordValid
                    ? AppTheme.accentBlue
                    : AppTheme.errorColor,
                width: 2,
              ),
            ),
          ),
        ),
        if (!_isPasswordValid && _passwordError.isNotEmpty) ...[
          SizedBox(height: 1.h),
          Text(
            _passwordError,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.errorColor,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _isLoading ? null : _handleForgotPassword,
        child: Text(
          'Forgot Password?',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.accentBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 6.h,
      child: ElevatedButton(
        onPressed: _isFormValid && !_isLoading ? _handleLogin : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid && !_isLoading
              ? AppTheme.accentRed
              : AppTheme.surfaceColor,
          foregroundColor: AppTheme.textPrimary,
          elevation: _isFormValid && !_isLoading ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppTheme.textPrimary),
                ),
              )
            : Text(
                'Login',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildSocialLoginSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.dividerDark,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Or continue with',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.dividerDark,
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        Row(
          children: [
            Expanded(
              child: _buildSocialButton(
                'Google',
                'g_translate',
                () => _handleSocialLogin('Google'),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildSocialButton(
                'Apple',
                'apple',
                () => _handleSocialLogin('Apple'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(
      String label, String iconName, VoidCallback onPressed) {
    return SizedBox(
      height: 6.h,
      child: OutlinedButton(
        onPressed: _isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: AppTheme.dividerDark,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.textPrimary,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'New rider? ',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Sign up screen will be implemented',
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      backgroundColor: AppTheme.accentBlue,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(4.w),
                    ),
                  );
                },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Sign Up',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.accentBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
