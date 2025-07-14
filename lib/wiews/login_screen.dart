import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:staj_copy/wiews/RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  String? errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final user = await AuthService.signIn(
        emailCtrl.text.trim(),
        passwordCtrl.text.trim(),
      );
      if (user != null) {
        widget.onLoginSuccess();
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Giriş yapılamadı: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint, // Dikkat: Artık labelText değil hintText
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFFD3D3D3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Giriş Yap',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: emailCtrl,
                        decoration: _inputDecoration('Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                        value!.isEmpty ? 'Email gerekli' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordCtrl,
                        decoration: _inputDecoration('Şifre'),
                        obscureText: true,
                        validator: (value) =>
                        value!.isEmpty ? 'Şifre gerekli' : null,
                      ),
                      const SizedBox(height: 24),
                      if (errorMessage != null)
                        Text(
                          errorMessage!,
                          style: TextStyle(
                            color: Colors.red[300],
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF357ABD),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                        ),
                        child: isLoading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Color(0xFF357ABD),
                            strokeWidth: 2.5,
                          ),
                        )
                            : const Text(
                          'Giriş Yap',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => RegisterScreen()),
                          );
                        },
                        child: const Text(
                          'Hesabın yok mu? Kayıt ol',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
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
    );
  }
}
