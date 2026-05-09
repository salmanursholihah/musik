import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
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
    'plan': 'Premium 6 Bulan',
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
              // Handle
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

              // Header
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

              // Label
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

              // Text field
              TextField(
                controller: ctrl,
                autofocus: true,
                keyboardType: keyboardType,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                onChanged: (v) => setSheet(() => hasChanged = v.trim() != currentValue),
                decoration: InputDecoration(
                  hintText: 'Masukkan $label baru...',
                  hintStyle: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  suffixIcon: ctrl.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            ctrl.clear();
                            setSheet(() => hasChanged = false);
                          },
                          child: const Icon(
                            Icons.close_rounded,
                            color: AppColors.textMuted,
                            size: 18,
                          ),
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 24),

              // Action buttons
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
                              : const LinearGradient(
                                  colors: [AppColors.surfaceVariant, AppColors.surfaceVariant],
                                ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: hasChanged ? Colors.white : AppColors.textMuted,
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
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 28),

            // Animated icon
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

            // Progress indicator steps
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

            // Close button
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
          // ── SliverAppBar ─────────────────────────────────────────────────
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
                        onTap: () => _showUnderDevelopment(featureName: 'Ubah Foto Profil'),
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
                                      color: AppColors.primary.withOpacity(0.3),
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
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushNamed(AppRoutes.subscription),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.workspace_premium,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _user['plan'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

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
                  // ── Akun ─────────────────────────────────────────────────
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
                    _infoTile(
                      Icons.calendar_today_outlined,
                      'Aktif hingga',
                      _user['planExpiry'],
                      () => Navigator.of(context).pushNamed(AppRoutes.subscription),
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
                            child: const Icon(
                              Icons.wifi_off_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
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
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.textMuted,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Langganan ─────────────────────────────────────────────
                  _sectionTitle('Langganan'),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.subscription),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.workspace_premium,
                            color: Colors.amber,
                            size: 36,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _user['plan'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Aktif hingga ${_user['planExpiry']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white70,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Pengaturan ────────────────────────────────────────────
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
                      () => _showUnderDevelopment(featureName: 'Ganti Bahasa'),
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
                      () => _showUnderDevelopment(featureName: 'Bagikan Aplikasi'),
                    ),
                    _navTile(
                      Icons.star_outline_rounded,
                      'Beri Rating',
                      null,
                      () => _showUnderDevelopment(featureName: 'Rating Aplikasi'),
                    ),
                    _navTile(
                      Icons.help_outline,
                      'Bantuan & Dukungan',
                      null,
                      () => _showUnderDevelopment(featureName: 'Bantuan & Dukungan'),
                    ),
                    _navTile(
                      Icons.privacy_tip_outlined,
                      'Kebijakan Privasi',
                      null,
                      () => _showUnderDevelopment(featureName: 'Kebijakan Privasi'),
                    ),
                    _navTile(
                      Icons.description_outlined,
                      'Syarat & Ketentuan',
                      null,
                      () => _showUnderDevelopment(featureName: 'Syarat & Ketentuan'),
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
                          Icon(
                            Icons.logout_rounded,
                            color: AppColors.error,
                            size: 20,
                          ),
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

  // Info tile — tappable, shows edit hint
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
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
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
            const Icon(
              Icons.edit_outlined,
              color: AppColors.textMuted,
              size: 16,
            ),
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
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
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
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textMuted,
              size: 14,
            ),
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
      {'label': 'Normal (96 kbps)',  'sub': 'Hemat data, kualitas standar'},
      {'label': 'Standar (128 kbps)','sub': 'Keseimbangan kualitas & data'},
      {'label': 'Tinggi (256 kbps)', 'sub': 'Kualitas baik, cocok untuk Wi-Fi'},
      {'label': 'Tinggi (320 kbps)', 'sub': 'Kualitas terbaik (direkomendasikan)'},
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
                  child: const Icon(
                    Icons.music_note_outlined,
                    color: AppColors.primary,
                    size: 22,
                  ),
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
                      color: isSelected ? AppColors.primary : Colors.transparent,
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
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
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
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.white24, borderRadius: BorderRadius.circular(2),
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
              child: const Icon(
                Icons.music_note_rounded,
                color: Colors.white,
                size: 36,
              ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
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
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
