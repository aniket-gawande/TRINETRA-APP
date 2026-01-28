import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    try {
      setState(() => _isLoading = true);
      await Provider.of<AuthProvider>(context, listen: false)
          .login(_emailCtrl.text.trim(), _passCtrl.text.trim());
      if (mounted) {
        if (!context.mounted) return;
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleGoogleSignIn() async {
    try {
      setState(() => _isLoading = true);
      final success = await Provider.of<AuthProvider>(context, listen: false).signInWithGoogle();
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/');
      } else if (mounted) {
        final errorMsg = Provider.of<AuthProvider>(context, listen: false).errorMessage ?? 'Google Sign-in failed';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg)));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020604),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo/Title
                const Text(
                  "PARYARAK",
                  style: TextStyle(
                    color: Color(0xFF10b981),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "🚜",
                  style: TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 30),
                
                // Sign In Title
                const Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // Google Sign-in Button
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleGoogleSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF020604),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.login),
                  label: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          "Sign in with Google",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
                const SizedBox(height: 20),

                // Divider
                Row(
                  children: const [
                    Expanded(child: Divider(color: Color(0xFF334155))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("OR", style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(color: Color(0xFF334155))),
                  ],
                ),
                const SizedBox(height: 20),

                // Email Field
                TextField(
                  controller: _emailCtrl,
                  enabled: !_isLoading,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: const TextStyle(color: Colors.grey),
                    hintText: "test@gmail.com",
                    hintStyle: const TextStyle(color: Color(0xFF64748b)),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF334155)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF10b981)),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Password Field
                TextField(
                  controller: _passCtrl,
                  obscureText: true,
                  enabled: !_isLoading,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Colors.grey),
                    hintText: "1234567",
                    hintStyle: const TextStyle(color: Color(0xFF64748b)),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF334155)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF10b981)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10b981),
                      disabledBackgroundColor: const Color(0xFF6b7280),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),
                
                // Test Credentials Help Text
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1e293b),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Test Credentials:",
                        style: TextStyle(
                          color: Color(0xFF10b981),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Email: test@gmail.com\nPassword: 1234567",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
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

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }
}