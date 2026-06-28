import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import '../providers/auth_provider.dart';
import '../../../../core/routes/app_router.dart';
import '../widgets/loading_overlay.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  bool _showPass = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );

    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, AppRouter.verifyEmail);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Pendaftaran gagal'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final bgColors = isDark 
        ? [const Color(0xFF2C2C2C), const Color(0xFF121212)]
        : [const Color(0xFFE0E0E0), const Color(0xFFFFFFFF)];

    final textColor = isDark ? Colors.white : Colors.black87;
    final buttonColor = isDark ? Theme.of(context).colorScheme.primary : Colors.black;
    final buttonTextColor = isDark ? Colors.black : Colors.white;
    final inputBgColor = isDark ? Colors.white10 : Colors.black.withOpacity(0.05);

    return LoadingOverlay(
      isLoading: isLoading,
      message: 'Mendaftarkan akun...',
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: bgColors,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Header with Back Button
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: textColor),
                          onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.login),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                'The Helmets',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: textColor,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Inputs
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nama Lengkap', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: inputBgColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextFormField(
                            controller: _nameCtrl,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              hintText: 'Masukkan Nama Anda',
                              hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            ),
                            validator: (v) => (v?.isEmpty ?? true) ? 'Nama wajib diisi' : null,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text('Email', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: inputBgColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              hintText: 'Masukkan Email Anda',
                              hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            ),
                            validator: (v) {
                              if (v?.isEmpty ?? true) return 'Email wajib diisi';
                              if (!EmailValidator.validate(v!)) return 'Format email salah';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text('Password', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: inputBgColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextFormField(
                            controller: _passCtrl,
                            obscureText: !_showPass,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              hintText: 'Minimal 8 karakter',
                              hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            ),
                            validator: (v) => (v?.length ?? 0) < 8 ? 'Password minimal 8 karakter' : null,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text('Konfirmasi Password', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: inputBgColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextFormField(
                            controller: _pass2Ctrl,
                            obscureText: !_showPass,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              hintText: 'Ulangi Password',
                              hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            ),
                            validator: (v) => v != _passCtrl.text ? 'Password tidak cocok' : null,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: buttonTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading 
                            ? SizedBox(
                                height: 24, width: 24, 
                                child: CircularProgressIndicator(color: buttonTextColor, strokeWidth: 2)
                              )
                            : const Text('Daftar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Sign In Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Sudah punya akun? ", style: TextStyle(color: textColor.withOpacity(0.7))),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, AppRouter.login),
                          child: Text(
                            'Masuk',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }
}