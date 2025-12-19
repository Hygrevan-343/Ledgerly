import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/auth_provider.dart';
import '../services/widget_service.dart';
import '../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(text: 'kavinesh.p123@gmail.com');
  final TextEditingController _passwordController = TextEditingController(text: 'test123');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSignUp = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // App always starts fresh from login page
    print('🔐 Login screen initialized - credentials auto-filled');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      
      if (_isSignUp) {
        // For now, just show success message for sign up
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Sign up successful! Please sign in.'),
            backgroundColor: AppConstants.primaryTeal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusM)),
          ),
        );
        setState(() {
          _isSignUp = false;
        });
      } else {
        // Handle login
        final success = await authProvider.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (success) {
          // Check for pending widget actions after login
          await _handlePendingWidgetActions();
          Navigator.pushReplacementNamed(context, '/main');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Invalid email or password'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusM)),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundDark,
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.spacingL),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: AppConstants.spacingXL * 2),
                    
                    // Google Logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppConstants.surfaceDark,
                        borderRadius: BorderRadius.circular(AppConstants.radiusL),
                        border: Border.all(
                          color: AppConstants.dividerColor,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.primaryTeal.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppConstants.radiusL),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Image.asset(
                            'assets/images/google_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.spacingXL),
                    
                    // App Title
                    const Text(
                      'Raseed',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeTitle,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textPrimary,
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.spacingM),
                    
                    // Welcome Message
                    if (_isSignUp)
                      const Text(
                        'Create your account to get started.',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeL,
                          color: AppConstants.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    
                    const SizedBox(height: AppConstants.spacingXL * 2),
                    
                    // Email Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeL,
                            color: AppConstants.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingS),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            hintStyle: const TextStyle(color: AppConstants.textSecondary),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: AppConstants.textSecondary,
                            ),
                            filled: true,
                            fillColor: AppConstants.cardDark,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusM),
                              borderSide: const BorderSide(color: AppConstants.dividerColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusM),
                              borderSide: const BorderSide(color: AppConstants.dividerColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusM),
                              borderSide: const BorderSide(color: AppConstants.primaryTeal, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusM),
                              borderSide: const BorderSide(color: Colors.red, width: 1),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusM),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingM,
                              vertical: AppConstants.spacingM,
                            ),
                          ),
                          style: const TextStyle(color: AppConstants.textPrimary),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppConstants.spacingL),
                    
                    // Password Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeL,
                            color: AppConstants.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingS),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            hintStyle: const TextStyle(color: AppConstants.textSecondary),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: AppConstants.textSecondary,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: AppConstants.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: AppConstants.cardDark,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusM),
                              borderSide: const BorderSide(color: AppConstants.dividerColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusM),
                              borderSide: const BorderSide(color: AppConstants.dividerColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusM),
                              borderSide: const BorderSide(color: AppConstants.primaryTeal, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusM),
                              borderSide: const BorderSide(color: Colors.red, width: 1),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusM),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingM,
                              vertical: AppConstants.spacingM,
                            ),
                          ),
                          style: const TextStyle(color: AppConstants.textPrimary),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppConstants.spacingM),
                    
                    // Forgot Password (only for sign in)
                    if (!_isSignUp)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Forgot password feature coming soon!'),
                                backgroundColor: AppConstants.primaryTeal,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusM)),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppConstants.primaryTeal,
                              fontSize: AppConstants.fontSizeM,
                            ),
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: AppConstants.spacingXL),
                    
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryTeal,
                          disabledBackgroundColor: AppConstants.primaryTeal.withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.radiusM),
                          ),
                          elevation: 0,
                        ),
                        child: authProvider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            : Text(
                                _isSignUp ? 'Sign Up' : 'Sign In',
                                style: const TextStyle(
                                  fontSize: AppConstants.fontSizeL,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.spacingXL),
                    
                    // Toggle Sign In/Sign Up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isSignUp ? "Already have an account? " : "Don't have an account? ",
                          style: const TextStyle(
                            color: AppConstants.textSecondary,
                            fontSize: AppConstants.fontSizeM,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isSignUp = !_isSignUp;
                            });
                          },
                          child: Text(
                            _isSignUp ? 'Sign In' : 'Sign Up',
                            style: const TextStyle(
                              color: AppConstants.primaryTeal,
                              fontSize: AppConstants.fontSizeM,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  Future<void> _handlePendingWidgetActions() async {
    try {
      final pendingAction = await WidgetService.getPendingLoginAction();
      if (pendingAction != null && pendingAction.isNotEmpty) {
        // Wait a bit for the main screen to load
        await Future.delayed(const Duration(milliseconds: 500));
        
        switch (pendingAction) {
          case 'camera':
            await _handleCameraAction();
            break;
          case 'gallery':
            await _handleGalleryAction();
            break;
          case 'assist':
            _navigateToAssist();
            break;
          default:
            break;
        }
      }
    } catch (e) {
      print('Error handling pending widget actions: $e');
    }
  }
  
  Future<void> _handleCameraAction() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        _showSuccessMessage('Photo captured! Processing receipt...');
      }
    } catch (e) {
      _showErrorMessage('Failed to open camera');
    }
  }
  
  Future<void> _handleGalleryAction() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _showSuccessMessage('Image selected! Processing receipt...');
      }
    } catch (e) {
      _showErrorMessage('Failed to open gallery');
    }
  }
  
  void _navigateToAssist() {
    // The assist action will be handled by MainScreen when it loads
    // No need to navigate here as the main screen will check for pending actions
  }
  
  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppConstants.primaryTeal,
        ),
      );
    }
  }
  
  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} 