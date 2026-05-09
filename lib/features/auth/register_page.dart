import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  bool _agreeTerms = false;
  late AnimationController _animCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _fadeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap setujui syarat & ketentuan')),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) {
      setState(() => _loading = false);
      Navigator.of(context).pushReplacementNamed(AppRoutes.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),

                      // Back button + title
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.arrow_back_ios_new,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Buat Akun',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 56),
                        child: Text(
                          'Bergabung dengan jutaan pendengar',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),

                      const SizedBox(height: 36),

                      _label('Nama Lengkap'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Nama kamu',
                          prefixIcon: Icon(Icons.person_outline,
                              color: AppColors.textMuted, size: 20),
                        ),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Nama harus diisi' : null,
                      ),

                      const SizedBox(height: 18),

                      _label('Email'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'email@contoh.com',
                          prefixIcon: Icon(Icons.email_outlined,
                              color: AppColors.textMuted, size: 20),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Email harus diisi';
                          if (!v.contains('@')) return 'Email tidak valid';
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      _label('Password'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscurePass,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Minimal 6 karakter',
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: AppColors.textMuted, size: 20),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => _obscurePass = !_obscurePass),
                            icon: Icon(
                              _obscurePass
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                              size: 20,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password harus diisi';
                          if (v.length < 6) return 'Password minimal 6 karakter';
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      _label('Konfirmasi Password'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _confirmCtrl,
                        obscureText: _obscureConfirm,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Ulangi password',
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: AppColors.textMuted, size: 20),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => _obscureConfirm = !_obscureConfirm),
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                              size: 20,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Konfirmasi password harus diisi';
                          if (v != _passCtrl.text)
                            return 'Password tidak cocok';
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: () => setState(() => _agreeTerms = !_agreeTerms),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: _agreeTerms
                                    ? AppColors.primary
                                    : Colors.transparent,
                                border: Border.all(
                                  color: _agreeTerms
                                      ? AppColors.primary
                                      : AppColors.textMuted,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: _agreeTerms
                                  ? const Icon(Icons.check,
                                      color: Colors.white, size: 14)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 13),
                                  children: const [
                                    TextSpan(text: 'Saya setuju dengan '),
                                    TextSpan(
                                      text: 'Syarat & Ketentuan',
                                      style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(text: ' dan '),
                                    TextSpan(
                                      text: 'Kebijakan Privasi',
                                      style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      ElevatedButton(
                        onPressed: _loading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28)),
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor:
                              AppColors.primary.withOpacity(0.5),
                        ),
                        child: _loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                            : const Text(
                                'Buat Akun',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sudah punya akun? ',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                                fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Text(
                              'Masuk',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
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

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary),
      );
}
