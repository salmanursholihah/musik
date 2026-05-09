import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _loading = false;
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
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
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
                      const SizedBox(height: 48),

                      // Logo + title
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.35),
                                    blurRadius: 24,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.music_note_rounded,
                                color: Colors.white,
                                size: 38,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Masuk ke Misik',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Selamat datang kembali!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.55),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 44),

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

                      const SizedBox(height: 20),

                      _label('Password'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscurePass,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '••••••••',
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

                      const SizedBox(height: 12),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Lupa Password?'),
                        ),
                      ),

                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: _loading ? null : _login,
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
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                            : const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),

                      const SizedBox(height: 28),

                      _divider(),

                      const SizedBox(height: 28),

                      _socialButton(
                        icon: Icons.g_mobiledata_rounded,
                        label: 'Lanjutkan dengan Google',
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      _socialButton(
                        icon: Icons.phone_android_rounded,
                        label: 'Lanjutkan dengan Nomor HP',
                        onTap: () {},
                      ),

                      const SizedBox(height: 36),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum punya akun? ',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                                fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushNamed(AppRoutes.register),
                            child: const Text(
                              'Daftar sekarang',
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
            fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
      );

  Widget _divider() => Row(
        children: [
          Expanded(child: Divider(color: Colors.white.withOpacity(0.15), thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'atau',
              style:
                  TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
            ),
          ),
          Expanded(child: Divider(color: Colors.white.withOpacity(0.15), thickness: 1)),
        ],
      );

  Widget _socialButton(
          {required IconData icon,
          required String label,
          required VoidCallback onTap}) =>
      OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(
          label,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          side: BorderSide(color: Colors.white.withOpacity(0.2), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
      );
}
