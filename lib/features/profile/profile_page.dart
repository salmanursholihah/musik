import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _notifEnabled = true;
  bool _autoPlayEnabled = true;
  bool _dataSaverEnabled = false;
  String _audioQuality = 'Tinggi (320 kbps)';

  late AnimationController _avatarPulseCtrl;
  late Animation<double> _avatarPulseAnim;

  final Map<String, dynamic> _user = {
    'name': 'Budi Santoso',
    'email': 'budi.santoso@email.com',
    'phone': '+62 812-3456-7890',
    // 'plan': 'Premium 6 Bulan',
    'planExpiry': '12 November 2025',
    'followers': '128',
    'following': '45',
    'playlists': '12',
  };

  @override
  void initState() {
    super.initState();
    _avatarPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _avatarPulseAnim = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _avatarPulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _avatarPulseCtrl.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // POPUP — EDIT FIELD AKUN
  // ══════════════════════════════════════════════════════════════════════════
  void _showEditDialog({
    required String label,
    required String currentValue,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required void Function(String newValue) onSave,
  }) {
    final ctrl = TextEditingController(text: currentValue);
    bool hasChanged = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ubah $label',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Perbarui informasi $label kamu',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: ctrl,
                autofocus: true,
                keyboardType: keyboardType,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                onChanged: (v) =>
                    setSheet(() => hasChanged = v.trim() != currentValue),
                decoration: InputDecoration(
                  hintText: 'Masukkan $label baru...',
                  hintStyle:
                      const TextStyle(color: AppColors.textMuted, fontSize: 14),
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  suffixIcon: ctrl.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            ctrl.clear();
                            setSheet(() => hasChanged = false);
                          },
                          child: const Icon(Icons.close_rounded,
                              color: AppColors.textMuted, size: 18),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final newVal = ctrl.text.trim();
                        if (newVal.isEmpty) return;
                        onSave(newVal);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$label berhasil diperbarui'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          gradient: hasChanged
                              ? AppColors.primaryGradient
                              : const LinearGradient(colors: [
                                  AppColors.surfaceVariant,
                                  AppColors.surfaceVariant
                                ]),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color:
                                hasChanged ? Colors.white : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // POPUP — LUPA KATA SANDI (4 STEP)
  // ══════════════════════════════════════════════════════════════════════════
  void _showForgotPassword() {
    // step 0 = email, 1 = otp, 2 = new password, 3 = success
    int step = 0;
    bool isLoading = false;
    bool obscureNew = true;
    bool obscureConfirm = true;

    final emailCtrl =
        TextEditingController(text: _user['email'] as String);
    final otpCtrls = List.generate(6, (_) => TextEditingController());
    final otpFocuses = List.generate(6, (_) => FocusNode());
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();

    String? otpError;
    String? passError;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) {
          // ── handle
          Widget handle = Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );

          // ── STEP 0 — Email input ──────────────────────────────────────────
          Widget stepEmail() => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  handle,
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.lock_reset_rounded,
                            color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lupa Kata Sandi',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Kami kirimkan kode OTP ke emailmu',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'EMAIL',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailCtrl,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Masukkan emailmu...',
                      hintStyle: const TextStyle(
                          color: AppColors.textMuted, fontSize: 14),
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                      prefixIcon: const Icon(Icons.email_outlined,
                          color: AppColors.textMuted, size: 20),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Kode OTP akan dikirimkan ke alamat email yang terdaftar.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.4),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _fwButton(
                    label: isLoading ? null : 'Kirim Kode OTP',
                    loading: isLoading,
                    onTap: () async {
                      final email = emailCtrl.text.trim();
                      if (email.isEmpty || !email.contains('@')) return;
                      setSheet(() => isLoading = true);
                      await Future.delayed(const Duration(milliseconds: 1200));
                      setSheet(() {
                        isLoading = false;
                        step = 1;
                      });
                    },
                  ),
                ],
              );

          // ── STEP 1 — OTP input ───────────────────────────────────────────
          Widget stepOtp() => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  handle,
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setSheet(() => step = 0),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white70, size: 16),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kode Verifikasi',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Masukkan 6 digit kode yang dikirim',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Email hint
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.mark_email_read_outlined,
                            color: AppColors.primary, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Kode dikirim ke ${emailCtrl.text}',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 6-digit OTP boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (i) {
                      return SizedBox(
                        width: 46,
                        height: 54,
                        child: TextField(
                          controller: otpCtrls[i],
                          focusNode: otpFocuses[i],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: otpCtrls[i].text.isNotEmpty
                                ? AppColors.primary.withOpacity(0.12)
                                : AppColors.surfaceVariant,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppColors.error, width: 1.5),
                            ),
                          ),
                          onChanged: (v) {
                            setSheet(() => otpError = null);
                            if (v.isNotEmpty && i < 5) {
                              otpFocuses[i + 1].requestFocus();
                            } else if (v.isEmpty && i > 0) {
                              otpFocuses[i - 1].requestFocus();
                            }
                            setSheet(() {});
                          },
                        ),
                      );
                    }),
                  ),

                  if (otpError != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.error, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          otpError!,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.error),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Resend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tidak menerima kode? ',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.45)),
                      ),
                      GestureDetector(
                        onTap: () {
                          for (final c in otpCtrls) {
                            c.clear();
                          }
                          setSheet(() => otpError = null);
                        },
                        child: const Text(
                          'Kirim ulang',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  _fwButton(
                    label: isLoading ? null : 'Verifikasi',
                    loading: isLoading,
                    onTap: () async {
                      final otp = otpCtrls.map((c) => c.text).join();
                      if (otp.length < 6) {
                        setSheet(
                            () => otpError = 'Masukkan 6 digit kode OTP');
                        return;
                      }
                      setSheet(() => isLoading = true);
                      await Future.delayed(const Duration(milliseconds: 1000));
                      // Simulate wrong OTP with '000000'
                      if (otp == '000000') {
                        setSheet(() {
                          isLoading = false;
                          otpError = 'Kode OTP salah. Silakan coba lagi.';
                        });
                        return;
                      }
                      setSheet(() {
                        isLoading = false;
                        step = 2;
                      });
                    },
                  ),
                ],
              );

          // ── STEP 2 — New password ─────────────────────────────────────────
          Widget stepNewPass() => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  handle,
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setSheet(() => step = 1),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white70, size: 16),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buat Kata Sandi Baru',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Minimal 8 karakter dengan kombinasi huruf & angka',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Step indicator
                  _fwStepBar(currentStep: 2),
                  const SizedBox(height: 24),

                  const Text(
                    'KATA SANDI BARU',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: newPassCtrl,
                    obscureText: obscureNew,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    onChanged: (_) => setSheet(() => passError = null),
                    decoration: InputDecoration(
                      hintText: 'Masukkan kata sandi baru...',
                      hintStyle: const TextStyle(
                          color: AppColors.textMuted, fontSize: 14),
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: AppColors.textMuted, size: 20),
                      suffixIcon: GestureDetector(
                        onTap: () =>
                            setSheet(() => obscureNew = !obscureNew),
                        child: Icon(
                          obscureNew
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),

                  // Password strength indicator
                  const SizedBox(height: 10),
                  _fwPasswordStrength(newPassCtrl.text),

                  const SizedBox(height: 20),
                  const Text(
                    'KONFIRMASI KATA SANDI',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmPassCtrl,
                    obscureText: obscureConfirm,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    onChanged: (_) => setSheet(() => passError = null),
                    decoration: InputDecoration(
                      hintText: 'Ulangi kata sandi baru...',
                      hintStyle: const TextStyle(
                          color: AppColors.textMuted, fontSize: 14),
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: AppColors.textMuted, size: 20),
                      suffixIcon: GestureDetector(
                        onTap: () =>
                            setSheet(() => obscureConfirm = !obscureConfirm),
                        child: Icon(
                          obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: AppColors.error, width: 1.5),
                      ),
                    ),
                  ),

                  if (passError != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.error, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          passError!,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.error),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 28),

                  _fwButton(
                    label: isLoading ? null : 'Simpan Kata Sandi',
                    loading: isLoading,
                    onTap: () async {
                      final np = newPassCtrl.text;
                      final cp = confirmPassCtrl.text;
                      if (np.length < 8) {
                        setSheet(() => passError =
                            'Kata sandi minimal 8 karakter');
                        return;
                      }
                      if (np != cp) {
                        setSheet(
                            () => passError = 'Konfirmasi kata sandi tidak sama');
                        return;
                      }
                      setSheet(() => isLoading = true);
                      await Future.delayed(const Duration(milliseconds: 1200));
                      setSheet(() {
                        isLoading = false;
                        step = 3;
                      });
                    },
                  ),
                ],
              );

          // ── STEP 3 — Success ─────────────────────────────────────────────
          Widget stepSuccess() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  handle,
                  const SizedBox(height: 12),

                  // Animated checkmark
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.4, end: 1.0),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.elasticOut,
                    builder: (_, scale, child) =>
                        Transform.scale(scale: scale, child: child),
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.35),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 46,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Kata Sandi Berhasil Diubah!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Kata sandi akunmu telah berhasil diperbarui.\nGunakan kata sandi baru untuk masuk.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.5),
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Security tips
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        _securityTip(
                            Icons.shield_outlined, 'Jangan bagikan kata sandimu ke siapapun'),
                        const SizedBox(height: 10),
                        _securityTip(
                            Icons.update_rounded, 'Perbarui kata sandi secara berkala'),
                        const SizedBox(height: 10),
                        _securityTip(
                            Icons.lock_outline, 'Gunakan kombinasi huruf, angka & simbol'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Selesai',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );

          return Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, anim) => SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.08, 0),
                  end: Offset.zero,
                ).animate(anim),
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: KeyedSubtree(
                key: ValueKey(step),
                child: step == 0
                    ? stepEmail()
                    : step == 1
                        ? stepOtp()
                        : step == 2
                            ? stepNewPass()
                            : stepSuccess(),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Forgot-password button ───────────────────────────────────────────────
  Widget _fwButton({
    required String? label,
    required bool loading,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                label!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  // ── Step progress bar (shown on step 2) ──────────────────────────────────
  Widget _fwStepBar({required int currentStep}) {
    final labels = ['Email', 'Kode OTP', 'Kata Sandi'];
    return Row(
      children: List.generate(labels.length, (i) {
        final isDone = i < currentStep - 1;
        final isActive = i == currentStep - 1;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: isDone || isActive
                            ? AppColors.primaryGradient
                            : const LinearGradient(colors: [
                                AppColors.surfaceVariant,
                                AppColors.surfaceVariant,
                              ]),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 10,
                        color: isActive
                            ? AppColors.primary
                            : isDone
                                ? AppColors.textSecondary
                                : AppColors.textMuted,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (i < labels.length - 1) const SizedBox(width: 6),
            ],
          ),
        );
      }),
    );
  }

  // ── Password strength meter ───────────────────────────────────────────────
  Widget _fwPasswordStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#\$%^&*]'))) strength++;

    if (password.isEmpty) return const SizedBox.shrink();

    const labels = ['Lemah', 'Cukup', 'Kuat', 'Sangat Kuat'];
    const colors = [
      AppColors.error,
      Color(0xFFFF8C00),
      Color(0xFF4CAF50),
      AppColors.primary,
    ];
    final idx = (strength - 1).clamp(0, 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(right: 4),
                height: 3,
                decoration: BoxDecoration(
                  color: i < strength ? colors[idx] : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 5),
        Text(
          'Kekuatan: ${labels[idx]}',
          style: TextStyle(fontSize: 11, color: colors[idx]),
        ),
      ],
    );
  }

  // ── Security tip row ──────────────────────────────────────────────────────
  Widget _securityTip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // POPUP — SEDANG DALAM TAHAP PENGEMBANGAN
  // ══════════════════════════════════════════════════════════════════════════
  void _showUnderDevelopment({String? featureName}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 28),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.5, end: 1.0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              builder: (_, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.construction_rounded,
                  color: AppColors.primary,
                  size: 38,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sedang Dikembangkan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              featureName != null
                  ? 'Fitur "$featureName" sedang dalam tahap pengembangan.\nNantikan pembaruan selanjutnya!'
                  : 'Fitur ini sedang dalam tahap pengembangan.\nNantikan pembaruan selanjutnya!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.55),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300 + i * 100),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == 0 ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == 0
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Mengerti',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar ──────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: const SizedBox(),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A3A5C), AppColors.background],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),

                      // Avatar
                      GestureDetector(
                        onTap: () => _showUnderDevelopment(
                            featureName: 'Ubah Foto Profil'),
                        child: AnimatedBuilder(
                          animation: _avatarPulseAnim,
                          builder: (_, child) => Transform.scale(
                            scale: _avatarPulseAnim.value,
                            child: child,
                          ),
                          child: Stack(
                            children: [
                              Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 2.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppColors.primary.withOpacity(0.3),
                                      blurRadius: 16,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.background,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        _user['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Plan badge
                      // GestureDetector(
                      //   onTap: () => Navigator.of(context)
                      //       .pushNamed(AppRoutes.subscription),
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 12, vertical: 4),
                      //     decoration: BoxDecoration(
                      //       gradient: AppColors.primaryGradient,
                      //       borderRadius: BorderRadius.circular(20),
                      //     ),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         const Icon(Icons.workspace_premium,
                      //             color: Colors.amber, size: 14),
                      //         const SizedBox(width: 4),
                      //         Text(
                      //           _user['plan'],
                      //           style: const TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 12,
                      //             fontWeight: FontWeight.w600,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      const SizedBox(height: 16),

                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _stat(_user['followers'], 'Pengikut',
                              () => _showUnderDevelopment(featureName: 'Daftar Pengikut')),
                          _divider(),
                          _stat(_user['following'], 'Mengikuti',
                              () => _showUnderDevelopment(featureName: 'Daftar Mengikuti')),
                          _divider(),
                          _stat(_user['playlists'], 'Playlist',
                              () => _showUnderDevelopment(featureName: 'Semua Playlist')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Content ───────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Akun ──────────────────────────────────────────────────
                  _sectionTitle('Akun'),
                  const SizedBox(height: 10),
                  _card([
                    _infoTile(
                      Icons.person_outline,
                      'Nama',
                      _user['name'],
                      () => _showEditDialog(
                        label: 'Nama',
                        currentValue: _user['name'],
                        icon: Icons.person_outline,
                        onSave: (v) => setState(() => _user['name'] = v),
                      ),
                    ),
                    _infoTile(
                      Icons.email_outlined,
                      'Email',
                      _user['email'],
                      () => _showEditDialog(
                        label: 'Email',
                        currentValue: _user['email'],
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        onSave: (v) => setState(() => _user['email'] = v),
                      ),
                    ),
                    _infoTile(
                      Icons.phone_outlined,
                      'Nomor HP',
                      _user['phone'],
                      () => _showEditDialog(
                        label: 'Nomor HP',
                        currentValue: _user['phone'],
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        onSave: (v) => setState(() => _user['phone'] = v),
                      ),
                    ),
                    // ── Kata Sandi / Forgot Password ──────────────────────
                    _navTile(
                      Icons.lock_outline_rounded,
                      'Kata Sandi',
                      '••••••••',
                      _showForgotPassword,
                    ),
                    _infoTile(
                      Icons.calendar_today_outlined,
                      'Aktif hingga',
                      _user['planExpiry'],
                      () => Navigator.of(context)
                          .pushNamed(AppRoutes.subscription),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // ── Musik Offline ─────────────────────────────────────────
                  _sectionTitle('Musik Offline'),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.offline),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.wifi_off_rounded,
                                color: AppColors.primary, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Kelola Musik Offline',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '7 lagu • 49.7 MB tersimpan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              color: AppColors.textMuted, size: 16),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const SizedBox(height: 24),

                  // ── Pengaturan ─────────────────────────────────────────────
                  _sectionTitle('Pengaturan'),
                  const SizedBox(height: 10),
                  _card([
                    _switchTile(
                      Icons.notifications_outlined,
                      'Notifikasi',
                      'Terima notifikasi dari Misik',
                      _notifEnabled,
                      (v) => setState(() => _notifEnabled = v),
                    ),
                    _switchTile(
                      Icons.play_circle_outline,
                      'Putar Otomatis',
                      'Lanjutkan ke lagu berikutnya',
                      _autoPlayEnabled,
                      (v) => setState(() => _autoPlayEnabled = v),
                    ),
                    _switchTile(
                      Icons.data_saver_on_outlined,
                      'Hemat Data',
                      'Kurangi penggunaan data seluler',
                      _dataSaverEnabled,
                      (v) => setState(() => _dataSaverEnabled = v),
                    ),
                    _navTile(
                      Icons.music_note_outlined,
                      'Kualitas Audio',
                      _audioQuality,
                      _showQualitySheet,
                    ),
                    _navTile(
                      Icons.language_outlined,
                      'Bahasa',
                      'Indonesia',
                      () =>
                          _showUnderDevelopment(featureName: 'Ganti Bahasa'),
                    ),
                    _navTile(
                      Icons.palette_outlined,
                      'Tema',
                      'Gelap',
                      () => _showUnderDevelopment(featureName: 'Pilih Tema'),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // ── Lainnya ───────────────────────────────────────────────
                  _sectionTitle('Lainnya'),
                  const SizedBox(height: 10),
                  _card([
                    _navTile(
                      Icons.share_outlined,
                      'Bagikan Aplikasi',
                      null,
                      () => _showUnderDevelopment(
                          featureName: 'Bagikan Aplikasi'),
                    ),
                    _navTile(
                      Icons.star_outline_rounded,
                      'Beri Rating',
                      null,
                      () => _showUnderDevelopment(
                          featureName: 'Rating Aplikasi'),
                    ),
                    _navTile(
                      Icons.help_outline,
                      'Bantuan & Dukungan',
                      null,
                      () => _showUnderDevelopment(
                          featureName: 'Bantuan & Dukungan'),
                    ),
                    _navTile(
                      Icons.privacy_tip_outlined,
                      'Kebijakan Privasi',
                      null,
                      () => _showUnderDevelopment(
                          featureName: 'Kebijakan Privasi'),
                    ),
                    _navTile(
                      Icons.description_outlined,
                      'Syarat & Ketentuan',
                      null,
                      () => _showUnderDevelopment(
                          featureName: 'Syarat & Ketentuan'),
                    ),
                    _navTile(
                      Icons.info_outline,
                      'Tentang Misik',
                      'Versi 1.0.0',
                      () => _showAboutSheet(),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // ── Logout ────────────────────────────────────────────────
                  GestureDetector(
                    onTap: () => _showLogout(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.error.withOpacity(0.25),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded,
                              color: AppColors.error, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Keluar',
                            style: TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _divider() => Container(
        width: 1,
        height: 30,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        color: Colors.white24,
      );

  Widget _stat(String value, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) {
    return Text(
      t,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: List.generate(children.length, (i) {
          return Column(
            children: [
              children[i],
              if (i < children.length - 1)
                Divider(
                  height: 1,
                  color: Colors.white.withOpacity(0.06),
                  indent: 56,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _infoTile(
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit_outlined,
                color: AppColors.textMuted, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(
    IconData icon,
    String label,
    String subtitle,
    bool value,
    ValueChanged<bool> onChange,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChange,
            activeColor: AppColors.primary,
            inactiveThumbColor: AppColors.textMuted,
            inactiveTrackColor: AppColors.surfaceVariant,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _navTile(
    IconData icon,
    String label,
    String? subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: AppColors.textMuted, size: 14),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUALITY SHEET
  // ══════════════════════════════════════════════════════════════════════════
  void _showQualitySheet() {
    final options = [
      {'label': 'Normal (96 kbps)', 'sub': 'Hemat data, kualitas standar'},
      {
        'label': 'Standar (128 kbps)',
        'sub': 'Keseimbangan kualitas & data'
      },
      {
        'label': 'Tinggi (256 kbps)',
        'sub': 'Kualitas baik, cocok untuk Wi-Fi'
      },
      {
        'label': 'Tinggi (320 kbps)',
        'sub': 'Kualitas terbaik (direkomendasikan)'
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.music_note_outlined,
                      color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Kualitas Audio',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...options.map((o) {
              final isSelected = _audioQuality == o['label'];
              return GestureDetector(
                onTap: () {
                  setState(() => _audioQuality = o['label']!);
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.12)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isSelected ? AppColors.primary : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              o['label']!,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.white,
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              o['sub']!,
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.primary, size: 22),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ABOUT SHEET
  // ══════════════════════════════════════════════════════════════════════════
  void _showAboutSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.music_note_rounded,
                  color: Colors.white, size: 36),
            ),
            const SizedBox(height: 16),
            const Text(
              'Misik',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Versi 1.0.0',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            Text(
              'Misik adalah aplikasi streaming musik yang membawa pengalaman mendengarkan musik terbaik untuk kamu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.55),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _aboutItem('1.0.0', 'Versi'),
                  _aboutItem('2024', 'Tahun'),
                  _aboutItem('Flutter', 'Platform'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Tutup',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _aboutItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // LOGOUT DIALOG
  // ══════════════════════════════════════════════════════════════════════════
  void _showLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Keluar dari Misik?',
          style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Kamu akan keluar dari akun ${_user['name']}.',
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.login, (r) => false),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Keluar',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
