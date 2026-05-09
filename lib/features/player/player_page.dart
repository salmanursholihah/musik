import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with TickerProviderStateMixin {
  late AnimationController _rotateCtrl;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  bool _isPlaying = true;
  bool _isLiked = false;
  bool _isShuffle = false;
  int _repeatMode = 0; // 0=off 1=all 2=one
  double _progress = 0.35;
  double _volume = 0.75;

  final _totalDuration = const Duration(minutes: 3, seconds: 48);

  // Playlist data untuk popup Tambah
  final List<Map<String, dynamic>> _playlists = [
    {'name': 'Chill Vibes', 'songs': 18, 'color': Color(0xFF1E3A5F), 'added': false},
    {'name': 'Mood Booster', 'songs': 12, 'color': Color(0xFF2D1B4E), 'added': false},
    {'name': 'Workout Mix', 'songs': 25, 'color': Color(0xFF1A4035), 'added': false},
    {'name': 'Indie Folk', 'songs': 9, 'color': Color(0xFF4A1C1C), 'added': false},
    {'name': 'Lagu Favorit', 'songs': 34, 'color': Color(0xFF1E2A4A), 'added': false},
    {'name': 'Tidur Malam', 'songs': 15, 'color': Color(0xFF2C2A1A), 'added': false},
  ];

  // Device data untuk popup Perangkat
  final List<Map<String, dynamic>> _devices = [
    {
      'name': 'Ponsel Ini',
      'type': 'phone',
      'icon': Icons.phone_android_rounded,
      'active': true,
      'quality': 'Normal',
    },
    {
      'name': 'Bluetooth Speaker',
      'type': 'speaker',
      'icon': Icons.speaker_rounded,
      'active': false,
      'quality': 'Tinggi',
    },
    {
      'name': 'Galaxy Buds Pro',
      'type': 'headphone',
      'icon': Icons.headphones_rounded,
      'active': false,
      'quality': 'HD',
    },
    {
      'name': 'Smart TV - LG',
      'type': 'tv',
      'icon': Icons.tv_rounded,
      'active': false,
      'quality': 'Normal',
    },
  ];

  int _activeDevice = 0;

  @override
  void initState() {
    super.initState();
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn),
    );
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Duration get _currentPosition =>
      Duration(seconds: (_totalDuration.inSeconds * _progress).round());

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    final title = args['title'] ?? 'Hati-Hati di Jalan';
    final artist = args['artist'] ?? 'Tulus';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.playerGradient),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SafeArea(
            child: Column(
              children: [
                // ── Header ─────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                      const Column(
                        children: [
                          Text(
                            'Memutar dari',
                            style: TextStyle(fontSize: 11, color: Colors.white54),
                          ),
                          Text(
                            'Playlist Kamu',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _showQueueSheet(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.queue_music_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ── Album art ───────────────────────────────────────────────
                GestureDetector(
                  onDoubleTap: () => setState(() => _isLiked = !_isLiked),
                  child: AnimatedBuilder(
                    animation: _rotateCtrl,
                    builder: (_, child) => Transform.rotate(
                      angle: _isPlaying ? _rotateCtrl.value * 2 * 3.14159 : 0,
                      child: child,
                    ),
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 50,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.music_note_rounded,
                            size: 100,
                            color: Colors.white30,
                          ),
                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              color: AppColors.background,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // ── Song info + like ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              artist,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _isLiked = !_isLiked),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            _isLiked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            key: ValueKey(_isLiked),
                            color: _isLiked
                                ? AppColors.primary
                                : AppColors.textMuted,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Progress slider ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 7,
                          ),
                          trackHeight: 3.5,
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 16,
                          ),
                        ),
                        child: Slider(
                          value: _progress,
                          onChanged: (v) => setState(() => _progress = v),
                          activeColor: AppColors.primary,
                          inactiveColor: Colors.white24,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(_currentPosition),
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _formatDuration(_totalDuration),
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Playback controls ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _isShuffle = !_isShuffle),
                        child: Icon(
                          Icons.shuffle_rounded,
                          color: _isShuffle
                              ? AppColors.primary
                              : AppColors.textMuted,
                          size: 24,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.skip_previous_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() => _isPlaying = !_isPlaying);
                          if (_isPlaying) {
                            _rotateCtrl.repeat();
                          } else {
                            _rotateCtrl.stop();
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              _isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              key: ValueKey(_isPlaying),
                              color: Colors.white,
                              size: 38,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.skip_next_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(
                          () => _repeatMode = (_repeatMode + 1) % 3,
                        ),
                        child: Icon(
                          _repeatMode == 2
                              ? Icons.repeat_one_rounded
                              : Icons.repeat_rounded,
                          color: _repeatMode > 0
                              ? AppColors.primary
                              : AppColors.textMuted,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Volume ──────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.volume_down_rounded,
                        color: AppColors.textMuted,
                        size: 20,
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 5,
                            ),
                            trackHeight: 2.5,
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 12,
                            ),
                          ),
                          child: Slider(
                            value: _volume,
                            onChanged: (v) => setState(() => _volume = v),
                            activeColor: Colors.white,
                            inactiveColor: Colors.white24,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.volume_up_rounded,
                        color: AppColors.textMuted,
                        size: 20,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ── Bottom action buttons ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _bottomAction(
                        Icons.devices_rounded,
                        'Perangkat',
                        () => _showDeviceSheet(context),
                      ),
                      _bottomAction(
                        Icons.share_rounded,
                        'Bagikan',
                        () => _showShareSheet(context, title, artist),
                      ),
                      _bottomAction(
                        Icons.playlist_add_rounded,
                        'Tambah',
                        () => _showAddToPlaylistSheet(context, title, artist),
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

  // ── Bottom action widget ───────────────────────────────────────────────────
  Widget _bottomAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // POPUP 1 — PERANGKAT
  // ══════════════════════════════════════════════════════════════════════════
  void _showDeviceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Title
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
                      Icons.devices_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilih Perangkat',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Alihkan pemutaran ke perangkat lain',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Divider(color: Colors.white.withOpacity(0.06)),
              const SizedBox(height: 8),

              // Device list
              ..._devices.asMap().entries.map((e) {
                final i = e.key;
                final d = e.value;
                final isActive = _activeDevice == i;
                return GestureDetector(
                  onTap: () {
                    setSheet(() {});
                    setState(() => _activeDevice = i);
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (context.mounted) Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Terhubung ke ${d['name']}',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary.withOpacity(0.12)
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isActive
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Device icon
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary.withOpacity(0.2)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            d['icon'] as IconData,
                            color: isActive
                                ? AppColors.primary
                                : AppColors.textMuted,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Device info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                d['name'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isActive
                                      ? Colors.white
                                      : Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  if (isActive)
                                    Container(
                                      width: 6,
                                      height: 6,
                                      margin: const EdgeInsets.only(right: 6),
                                      decoration: const BoxDecoration(
                                        color: AppColors.success,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  Text(
                                    isActive
                                        ? 'Sedang memutar • ${d['quality']}'
                                        : 'Kualitas ${d['quality']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isActive
                                          ? AppColors.primary
                                          : AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Active indicator
                        if (isActive)
                          const Icon(
                            Icons.volume_up_rounded,
                            color: AppColors.primary,
                            size: 20,
                          )
                        else
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.textMuted,
                            size: 14,
                          ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 4),

              // Scan button
              GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mencari perangkat di sekitar...'),
                    duration: Duration(seconds: 2),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.radar_rounded,
                        color: AppColors.textSecondary,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Cari Perangkat Baru',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // POPUP 2 — BAGIKAN
  // ══════════════════════════════════════════════════════════════════════════
  void _showShareSheet(BuildContext context, String title, String artist) {
    final shareOptions = [
      {
        'label': 'WhatsApp',
        'icon': Icons.chat_rounded,
        'color': Color(0xFF25D366),
      },
      {
        'label': 'Instagram',
        'icon': Icons.camera_alt_rounded,
        'color': Color(0xFFE1306C),
      },
      {
        'label': 'Twitter / X',
        'icon': Icons.alternate_email_rounded,
        'color': Color(0xFF1DA1F2),
      },
      {
        'label': 'Telegram',
        'icon': Icons.send_rounded,
        'color': Color(0xFF0088CC),
      },
      {
        'label': 'Facebook',
        'icon': Icons.facebook_rounded,
        'color': Color(0xFF1877F2),
      },
      {
        'label': 'Salin Tautan',
        'icon': Icons.link_rounded,
        'color': AppColors.surfaceVariant,
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Song preview card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.music_note_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          artist,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.music_note_rounded,
                          size: 10,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Misik',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Bagikan ke',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Share options grid
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: shareOptions.map((opt) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    final label = opt['label'] as String;
                    final msg = label == 'Salin Tautan'
                        ? 'Tautan berhasil disalin!'
                        : 'Membuka $label...';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(msg),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: (opt['color'] as Color).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: (opt['color'] as Color).withOpacity(0.25),
                            width: 1.2,
                          ),
                        ),
                        child: Icon(
                          opt['icon'] as IconData,
                          color: opt['color'] as Color,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        opt['label'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // POPUP 3 — TAMBAH KE PLAYLIST
  // ══════════════════════════════════════════════════════════════════════════
  void _showAddToPlaylistSheet(
    BuildContext context,
    String songTitle,
    String artist,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.45,
          maxChildSize: 0.92,
          expand: false,
          builder: (_, scrollCtrl) => Column(
            children: [
              // ── Fixed header ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                            Icons.playlist_add_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tambah ke Playlist',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                songTitle,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Buat playlist baru button
                    GestureDetector(
                      onTap: () => _showCreatePlaylistDialog(ctx, setSheet),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Buat Playlist Baru',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.white.withOpacity(0.07)),
                    const SizedBox(height: 4),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Playlist Kamu',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              // ── Scrollable playlist list ───────────────────────────────────
              Expanded(
                child: ListView.builder(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  itemCount: _playlists.length,
                  itemBuilder: (_, i) {
                    final p = _playlists[i];
                    final isAdded = p['added'] as bool;
                    return GestureDetector(
                      onTap: () {
                        setSheet(() => _playlists[i]['added'] = !isAdded);
                        setState(() {});
                        if (!isAdded) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '"$songTitle" ditambahkan ke ${p['name']}',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isAdded
                              ? AppColors.primary.withOpacity(0.1)
                              : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isAdded
                                ? AppColors.primary.withOpacity(0.4)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Playlist color thumbnail
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: p['color'] as Color,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.queue_music_rounded,
                                color: Colors.white.withOpacity(0.4),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Playlist info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p['name'] as String,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${p['songs']} lagu',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Added indicator
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: isAdded
                                  ? Container(
                                      key: const ValueKey('added'),
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    )
                                  : Container(
                                      key: const ValueKey('not_added'),
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.textMuted,
                                          width: 1.5,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.add_rounded,
                                        color: AppColors.textMuted,
                                        size: 16,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Create new playlist dialog ───────────────────────────────────────────
  void _showCreatePlaylistDialog(
    BuildContext context,
    StateSetter setSheet,
  ) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    bool isPublic = false;

    final colors = [
      const Color(0xFF1E3A5F),
      const Color(0xFF2D1B4E),
      const Color(0xFF1A4035),
      const Color(0xFF4A1C1C),
      const Color(0xFF1E2A4A),
      const Color(0xFF3A1A2A),
      const Color(0xFF1DB8E8),
      const Color(0xFF6C4FD6),
    ];
    int selectedColor = 0;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dCtx, setDialog) => Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      child: const Icon(
                        Icons.library_music_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Playlist Baru',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Color picker
                const Text(
                  'Pilih Warna',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: colors.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => GestureDetector(
                      onTap: () => setDialog(() => selectedColor = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colors[i],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == i
                                ? Colors.white
                                : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        child: selectedColor == i
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Name field
                const Text(
                  'Nama Playlist',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Nama playlist kamu...',
                    hintStyle: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceVariant,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Description field
                const Text(
                  'Deskripsi (opsional)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Deskripsi singkat...',
                    hintStyle: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceVariant,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Public toggle
                GestureDetector(
                  onTap: () => setDialog(() => isPublic = !isPublic),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: isPublic
                              ? AppColors.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: isPublic
                                ? AppColors.primary
                                : AppColors.textMuted,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: isPublic
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              )
                            : null,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Jadikan publik',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(dialogCtx),
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
                          final name = nameCtrl.text.trim();
                          if (name.isEmpty) return;

                          // Add new playlist
                          setSheet(() {
                            _playlists.insert(0, {
                              'name': name,
                              'songs': 1,
                              'color': colors[selectedColor],
                              'added': true,
                            });
                          });
                          setState(() {});

                          Navigator.pop(dialogCtx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Playlist "$name" dibuat dan lagu ditambahkan!',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Buat',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
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
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUEUE SHEET
  // ══════════════════════════════════════════════════════════════════════════
  void _showQueueSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
            const SizedBox(height: 16),
            const Text(
              'Antrean',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ...['Melepasmu', 'Mangu', 'Separuh Aku', 'Runtuh'].map(
              (s) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                ),
                title: Text(
                  s,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                subtitle: const Text(
                  'Artis',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
                trailing: const Icon(
                  Icons.drag_handle_rounded,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
