import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PlayerPage — Full-screen music player
// ─────────────────────────────────────────────────────────────────────────────
class PlayerPage extends StatefulWidget {
  final String title;
  final String artist;
  final Color? color;
  final String? imageUrl;

  const PlayerPage({
    super.key,
    required this.title,
    required this.artist,
    this.color,
    this.imageUrl,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with TickerProviderStateMixin {
  // ── Playback state ─────────────────────────────────────────────────────────
  bool _isPlaying = true;
  bool _isShuffle = false;
  int _repeatMode = 0; // 0=off, 1=all, 2=one
  bool _isLiked = false;
  double _progress = 0.28;
  double _volume = 0.75;

  // ── Extra action state ─────────────────────────────────────────────────────
  bool _isDownloaded = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  // ── Tab: lirik / antrian ───────────────────────────────────────────────────
  int _tab = 0; // 0=player, 1=lyrics, 2=queue

  // ── Animations ────────────────────────────────────────────────────────────
  late AnimationController _artSpinCtrl;
  late AnimationController _artScaleCtrl;
  late Animation<double> _artScaleAnim;
  late AnimationController _heartCtrl;
  late Animation<double> _heartAnim;

  // ── Mock duration ──────────────────────────────────────────────────────────
  final Duration _total = const Duration(minutes: 3, seconds: 45);

  Duration get _current =>
      Duration(seconds: (_total.inSeconds * _progress).round());

  String _fmt(Duration d) =>
      '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  // ── Queue data ─────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _queue = [
    {
      'title': 'Melepasmu',
      'artist': 'Armada',
      'color': const Color(0xFF1E3A5F),
      'imageUrl': 'https://picsum.photos/seed/melepasmuarmada/200/200',
    },
    {
      'title': 'Salah Apa Aku',
      'artist': 'Judika',
      'color': const Color(0xFF2D1B4E),
      'imageUrl': 'https://picsum.photos/seed/salahapaakujudika/200/200',
    },
    {
      'title': 'Kasih Tak Sampai',
      'artist': 'Padi',
      'color': const Color(0xFF1A4035),
      'imageUrl': 'https://picsum.photos/seed/kasihtaksampai/200/200',
    },
    {
      'title': 'Separuh Aku',
      'artist': 'Noah',
      'color': const Color(0xFF4A1C1C),
      'imageUrl': 'https://picsum.photos/seed/separuhakunoah/200/200',
    },
    {
      'title': 'Tak Bisa Memilikimu',
      'artist': 'Sheila On 7',
      'color': const Color(0xFF2C2A1A),
      'imageUrl': 'https://picsum.photos/seed/takbisamemilikimu/200/200',
    },
    {
      'title': 'Hati-Hati di Jalan',
      'artist': 'Tulus',
      'color': const Color(0xFF1A2A4A),
      'imageUrl': 'https://picsum.photos/seed/hatihatijalan/200/200',
    },
  ];

  // ── Lirik mock ─────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _lyrics = [
    {'time': 0.00, 'text': ''},
    {'time': 0.04, 'text': 'Kau pergi tanpa sepatah kata'},
    {'time': 0.08, 'text': 'Meninggalkan luka yang dalam'},
    {'time': 0.12, 'text': 'Ku coba untuk melupakanmu'},
    {'time': 0.17, 'text': 'Namun kau selalu hadir di pikiranku'},
    {'time': 0.22, 'text': ''},
    {'time': 0.25, 'text': 'Aku melepasmu'},
    {'time': 0.28, 'text': 'Walau hatiku menangis'},
    {'time': 0.33, 'text': 'Demi kebahagiaanmu'},
    {'time': 0.38, 'text': 'Ku ikhlaskan kamu pergi'},
    {'time': 0.44, 'text': ''},
    {'time': 0.47, 'text': 'Semoga kau bahagia'},
    {'time': 0.52, 'text': 'Di sisi orang yang kau cinta'},
    {'time': 0.57, 'text': 'Meski bukan aku'},
    {'time': 0.62, 'text': 'Yang ada di sisimu'},
    {'time': 0.68, 'text': ''},
    {'time': 0.71, 'text': 'Aku melepasmu'},
    {'time': 0.76, 'text': 'Walau hatiku menangis'},
    {'time': 0.81, 'text': 'Demi kebahagiaanmu'},
    {'time': 0.86, 'text': 'Ku ikhlaskan kamu pergi'},
    {'time': 0.92, 'text': ''},
    {'time': 0.95, 'text': 'Selamat tinggal, sayangku…'},
  ];

  int get _activeLyricIdx {
    for (int i = _lyrics.length - 1; i >= 0; i--) {
      if (_progress >= (_lyrics[i]['time'] as double)) return i;
    }
    return 0;
  }

  // ── Init ───────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    _artSpinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
    if (_isPlaying) _artSpinCtrl.repeat();

    _artScaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _artScaleAnim = Tween<double>(begin: 0.97, end: 1.0).animate(
      CurvedAnimation(parent: _artScaleCtrl, curve: Curves.easeInOut),
    );

    _heartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _heartAnim = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _heartCtrl, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _artSpinCtrl.dispose();
    _artScaleCtrl.dispose();
    _heartCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Color get _accentColor => widget.color ?? AppColors.primary;

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    _isPlaying ? _artSpinCtrl.repeat() : _artSpinCtrl.stop();
  }

  void _toggleLike() {
    setState(() => _isLiked = !_isLiked);
    _heartCtrl.forward(from: 0);
  }

  void _cycleRepeat() {
    setState(() => _repeatMode = (_repeatMode + 1) % 3);
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Gradient background dinamis ──────────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _accentColor.withOpacity(0.45),
                    AppColors.background,
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // ── Konten ──────────────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const SizedBox(height: 4),
                _buildTabBar(),
                const SizedBox(height: 4),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.04, 0),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: _tab == 1
                        ? _buildLyricsView(key: const ValueKey('lyrics'))
                        : _tab == 2
                            ? _buildQueueView(key: const ValueKey('queue'))
                            : _buildPlayerView(key: const ValueKey('player')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TOP BAR
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Tombol tutup (swipe down)
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),

          // Judul halaman
          Expanded(
            child: Column(
              children: [
                Text(
                  'Sedang Diputar',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.5),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Tombol opsi
          GestureDetector(
            onTap: () => _showOptionsSheet(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.more_horiz_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB BAR (Player / Lirik / Antrian)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildTabBar() {
    final tabs = ['Player', 'Lirik', 'Antrian'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = _tab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _accentColor.withOpacity(0.85)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: _accentColor.withOpacity(0.35),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.45),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PLAYER VIEW
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildPlayerView({Key? key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // ── Album Art ──────────────────────────────────────────────────────
          _buildAlbumArt(),
          const SizedBox(height: 28),

          // ── Song info + like ───────────────────────────────────────────────
          _buildSongInfo(),
          const SizedBox(height: 28),

          // ── Progress bar ───────────────────────────────────────────────────
          _buildProgressBar(),
          const SizedBox(height: 28),

          // ── Controls utama ─────────────────────────────────────────────────
          _buildMainControls(),
          const SizedBox(height: 24),

          // ── Volume ─────────────────────────────────────────────────────────
          _buildVolumeBar(),
          const SizedBox(height: 24),

          // ── Extra actions ──────────────────────────────────────────────────
          _buildExtraActions(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Album Art ──────────────────────────────────────────────────────────────
  Widget _buildAlbumArt() {
    return Center(
      child: AnimatedBuilder(
        animation: _artScaleAnim,
        builder: (_, child) => Transform.scale(
          scale: _isPlaying ? _artScaleAnim.value : 0.92,
          child: child,
        ),
        child: Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _accentColor.withOpacity(0.45),
                blurRadius: 40,
                spreadRadius: 4,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: -4,
              ),
            ],
          ),
          child: AnimatedBuilder(
            animation: _artSpinCtrl,
            builder: (_, child) => Transform.rotate(
              angle: _artSpinCtrl.value * 2 * 3.14159,
              child: child,
            ),
            child: ClipOval(
              child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                  ? Image.network(
                      widget.imageUrl!,
                      width: 240,
                      height: 240,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _artFallback(),
                    )
                  : _artFallback(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _artFallback() {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        gradient: SweepGradient(
          colors: [
            _accentColor,
            _accentColor.withOpacity(0.4),
            AppColors.surface,
            _accentColor.withOpacity(0.6),
            _accentColor,
          ],
        ),
      ),
      child: const Icon(
        Icons.music_note_rounded,
        color: Colors.white38,
        size: 64,
      ),
    );
  }

  // ── Song info + like ───────────────────────────────────────────────────────
  Widget _buildSongInfo() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
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
                widget.artist,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: _toggleLike,
          child: AnimatedBuilder(
            animation: _heartAnim,
            builder: (_, __) => Transform.scale(
              scale: _heartAnim.value,
              child: Icon(
                _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: _isLiked ? Colors.red : Colors.white.withOpacity(0.5),
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Progress bar ───────────────────────────────────────────────────────────
  Widget _buildProgressBar() {
    return Column(
      children: [
        GestureDetector(
          onHorizontalDragUpdate: (d) {
            final w = MediaQuery.of(context).size.width - 48;
            setState(() {
              _progress = (_progress + d.delta.dx / w).clamp(0.0, 1.0);
            });
          },
          onTapDown: (d) {
            final w = MediaQuery.of(context).size.width - 48;
            setState(() {
              _progress = (d.localPosition.dx / w).clamp(0.0, 1.0);
            });
          },
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Track background
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Progress fill
              FractionallySizedBox(
                widthFactor: _progress,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_accentColor, Colors.white],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              // Thumb dot
              Positioned(
                left: (_progress *
                        (MediaQuery.of(context).size.width - 48) -
                    8).clamp(0, double.infinity),
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _accentColor.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _fmt(_current),
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _fmt(_total),
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Main controls ──────────────────────────────────────────────────────────
  Widget _buildMainControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Shuffle
        GestureDetector(
          onTap: () => setState(() => _isShuffle = !_isShuffle),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isShuffle
                  ? _accentColor.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.shuffle_rounded,
              color: _isShuffle ? _accentColor : Colors.white.withOpacity(0.45),
              size: 22,
            ),
          ),
        ),

        // Skip Previous
        GestureDetector(
          onTap: () => setState(() => _progress = 0),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.skip_previous_rounded,
              color: Colors.white.withOpacity(0.85),
              size: 36,
            ),
          ),
        ),

        // Play / Pause — tombol utama
        GestureDetector(
          onTap: _togglePlay,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _accentColor.withOpacity(0.5),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                key: ValueKey(_isPlaying),
                color: AppColors.background,
                size: 38,
              ),
            ),
          ),
        ),

        // Skip Next
        GestureDetector(
          onTap: () => setState(() => _progress = 0),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.skip_next_rounded,
              color: Colors.white.withOpacity(0.85),
              size: 36,
            ),
          ),
        ),

        // Repeat
        GestureDetector(
          onTap: _cycleRepeat,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _repeatMode > 0
                  ? _accentColor.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  _repeatMode == 2
                      ? Icons.repeat_one_rounded
                      : Icons.repeat_rounded,
                  color: _repeatMode > 0
                      ? _accentColor
                      : Colors.white.withOpacity(0.45),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Volume bar ─────────────────────────────────────────────────────────────
  Widget _buildVolumeBar() {
    return Row(
      children: [
        Icon(
          Icons.volume_down_rounded,
          color: Colors.white.withOpacity(0.4),
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onHorizontalDragUpdate: (d) {
              final w = MediaQuery.of(context).size.width - 48 - 56;
              setState(() {
                _volume = (_volume + d.delta.dx / w).clamp(0.0, 1.0);
              });
            },
            onTapDown: (d) {
              final w = MediaQuery.of(context).size.width - 48 - 56;
              setState(() {
                _volume = (d.localPosition.dx / w).clamp(0.0, 1.0);
              });
            },
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: _volume,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Icon(
          Icons.volume_up_rounded,
          color: Colors.white.withOpacity(0.4),
          size: 18,
        ),
      ],
    );
  }

  // ── Extra actions ──────────────────────────────────────────────────────────
  Widget _buildExtraActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _extraBtn(
          icon: Icons.share_rounded,
          label: 'Bagikan',
          onTap: _showShareSheet,
        ),
        _extraBtn(
          icon: Icons.playlist_add_rounded,
          label: 'Tambah',
          onTap: _showAddToPlaylistSheet,
        ),
        _extraBtn(
          icon: _isDownloaded
              ? Icons.download_done_rounded
              : _isDownloading
                  ? Icons.downloading_rounded
                  : Icons.download_rounded,
          label: _isDownloaded ? 'Tersimpan' : 'Unduh',
          onTap: _showDownloadSheet,
          active: _isDownloaded,
          showProgress: _isDownloading,
          progress: _downloadProgress,
        ),
        _extraBtn(
          icon: Icons.radio_rounded,
          label: 'Radio',
          onTap: _showRadioSheet,
        ),
        _extraBtn(
          icon: Icons.info_outline_rounded,
          label: 'Info',
          onTap: _showInfoSheet,
        ),
      ],
    );
  }

  Widget _extraBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool active = false,
    bool showProgress = false,
    double progress = 0,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: active
                      ? _accentColor.withOpacity(0.2)
                      : Colors.white.withOpacity(0.07),
                  shape: BoxShape.circle,
                  border: active
                      ? Border.all(color: _accentColor.withOpacity(0.5))
                      : null,
                ),
                child: Icon(
                  icon,
                  color: active
                      ? _accentColor
                      : showProgress
                          ? _accentColor
                          : Colors.white.withOpacity(0.65),
                  size: 20,
                ),
              ),
              if (showProgress)
                SizedBox(
                  width: 44,
                  height: 44,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 2,
                    color: _accentColor,
                    backgroundColor: Colors.white.withOpacity(0.1),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: active
                  ? _accentColor
                  : Colors.white.withOpacity(0.4),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BAGIKAN — Share Sheet
  // ═══════════════════════════════════════════════════════════════════════════
  void _showShareSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        final platforms = [
          (Icons.link_rounded, 'Salin Tautan', const Color(0xFF2A7D5F)),
          (Icons.chat_rounded, 'WhatsApp', const Color(0xFF25D366)),
          (Icons.camera_alt_rounded, 'Instagram', const Color(0xFFE1306C)),
          (Icons.telegram, 'Telegram', const Color(0xFF2CA5E0)),
          (Icons.facebook_rounded, 'Facebook', const Color(0xFF1877F2)),
          (Icons.sms_rounded, 'Pesan SMS', const Color(0xFF5B6FD6)),
        ];
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sheetHandle(),
              const SizedBox(height: 14),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bagikan lagu ini',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${widget.title} · ${widget.artist}',
                  style: TextStyle(
                      fontSize: 13, color: Colors.white.withOpacity(0.5)),
                ),
              ),
              const SizedBox(height: 20),
              // Kotak preview tautan
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: widget.imageUrl != null
                          ? Image.network(widget.imageUrl!,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _sheetArtFallback())
                          : _sheetArtFallback(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.title,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Text(widget.artist,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.5))),
                        ],
                      ),
                    ),
                    Icon(Icons.open_in_new_rounded,
                        size: 16, color: Colors.white.withOpacity(0.3)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Grid platform
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: platforms.map((p) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackbar(
                          p.$1 == Icons.link_rounded
                              ? 'Tautan disalin!'
                              : 'Dibuka di ${p.$2}',
                          icon: p.$1);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: p.$3.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: p.$3.withOpacity(0.25)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(p.$1, color: p.$3, size: 22),
                          const SizedBox(height: 4),
                          Text(p.$2,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAMBAH — Add to Playlist Sheet
  // ═══════════════════════════════════════════════════════════════════════════
  void _showAddToPlaylistSheet() {
    final playlists = [
      {
        'name': 'Favorit Saya',
        'count': 24,
        'color': const Color(0xFF1DB8E8),
        'imageUrl': 'https://picsum.photos/seed/playlistfav/100/100',
        'added': false,
      },
      {
        'name': 'Playlist Malam',
        'count': 12,
        'color': const Color(0xFF4A3D7C),
        'imageUrl': 'https://picsum.photos/seed/playlistmalam/100/100',
        'added': false,
      },
      {
        'name': 'Lagu Sedih',
        'count': 18,
        'color': const Color(0xFF5B6FD6),
        'imageUrl': 'https://picsum.photos/seed/playlistsedih/100/100',
        'added': false,
      },
      {
        'name': 'Workout',
        'count': 30,
        'color': const Color(0xFFD65F4F),
        'imageUrl': 'https://picsum.photos/seed/playlistworkout/100/100',
        'added': false,
      },
      {
        'name': 'Perjalanan',
        'count': 15,
        'color': const Color(0xFF2A7D5F),
        'imageUrl': 'https://picsum.photos/seed/playlistperjalanan/100/100',
        'added': false,
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return StatefulBuilder(builder: (ctx, setS) {
          return DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.85,
            expand: false,
            builder: (_, scrollCtrl) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Column(
                children: [
                  _sheetHandle(),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tambah ke Playlist',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _showSnackbar('Playlist baru dibuat!',
                              icon: Icons.add_rounded);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _accentColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: _accentColor.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.add_rounded,
                                  color: _accentColor, size: 14),
                              const SizedBox(width: 4),
                              Text('Baru',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: _accentColor,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollCtrl,
                      itemCount: playlists.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final pl = playlists[i];
                        final added = pl['added'] as bool;
                        return GestureDetector(
                          onTap: () {
                            setS(() => pl['added'] = !added);
                            if (!added) {
                              _showSnackbar(
                                'Ditambahkan ke "${pl['name']}"',
                                icon: Icons.playlist_add_check_rounded,
                              );
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: added
                                  ? _accentColor.withOpacity(0.1)
                                  : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: added
                                    ? _accentColor.withOpacity(0.4)
                                    : Colors.white.withOpacity(0.07),
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    pl['imageUrl'] as String,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Container(
                                      width: 48,
                                      height: 48,
                                      color: pl['color'] as Color,
                                      child: const Icon(
                                          Icons.music_note_rounded,
                                          color: Colors.white38,
                                          size: 22),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(pl['name'] as String,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                      const SizedBox(height: 2),
                                      Text('${pl['count']} lagu',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white
                                                  .withOpacity(0.4))),
                                    ],
                                  ),
                                ),
                                AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 200),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: added
                                        ? _accentColor
                                        : Colors.white.withOpacity(0.07),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    added
                                        ? Icons.check_rounded
                                        : Icons.add_rounded,
                                    color: added
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.4),
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UNDUH — Download Sheet
  // ═══════════════════════════════════════════════════════════════════════════
  void _showDownloadSheet() {
    if (_isDownloaded) {
      // Sudah diunduh → tawarkan hapus
      showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF1A1A2E),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        builder: (_) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sheetHandle(),
              const SizedBox(height: 20),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A7D5F).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.download_done_rounded,
                    color: Color(0xFF2A7D5F), size: 32),
              ),
              const SizedBox(height: 14),
              const Text('Lagu sudah tersimpan',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              const SizedBox(height: 6),
              Text(
                '${widget.title} tersimpan di perangkatmu',
                style: TextStyle(
                    fontSize: 13, color: Colors.white.withOpacity(0.5)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() => _isDownloaded = false);
                        _showSnackbar('File dihapus dari perangkat',
                            icon: Icons.delete_outline_rounded);
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: Colors.red.withOpacity(0.3)),
                        ),
                        alignment: Alignment.center,
                        child: const Text('Hapus Unduhan',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.red)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: const Text('Tutup',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      return;
    }

    // Belum diunduh → mulai proses unduh
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return StatefulBuilder(builder: (ctx, setS) {
          void startDownload() async {
            setS(() {});
            setState(() {
              _isDownloading = true;
              _downloadProgress = 0;
            });
            // Simulasi progress unduh
            for (int i = 1; i <= 10; i++) {
              await Future.delayed(const Duration(milliseconds: 220));
              if (!mounted) return;
              setState(() => _downloadProgress = i / 10);
              setS(() {});
            }
            if (!mounted) return;
            setState(() {
              _isDownloading = false;
              _isDownloaded = true;
            });
            if (ctx.mounted) Navigator.pop(ctx);
            _showSnackbar('Lagu berhasil diunduh!',
                icon: Icons.download_done_rounded);
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _sheetHandle(),
                const SizedBox(height: 20),
                // Cover
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: widget.imageUrl != null
                      ? Image.network(widget.imageUrl!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _sheetArtFallback(size: 80))
                      : _sheetArtFallback(size: 80),
                ),
                const SizedBox(height: 14),
                Text(widget.title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                Text(widget.artist,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.5))),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Kualitas Tinggi · 4.2 MB',
                      style: TextStyle(
                          fontSize: 11,
                          color: _accentColor,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 24),
                if (_isDownloading) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _downloadProgress,
                      minHeight: 6,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      color: _accentColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Mengunduh… ${(_downloadProgress * 100).toInt()}%',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5)),
                  ),
                ] else
                  GestureDetector(
                    onTap: startDownload,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _accentColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _accentColor.withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.download_rounded,
                              color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Unduh Sekarang',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                if (!_isDownloading)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text('Batal',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.35))),
                  ),
              ],
            ),
          );
        });
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RADIO — Radio Artist Sheet
  // ═══════════════════════════════════════════════════════════════════════════
  void _showRadioSheet() {
    final stations = [
      {
        'name': 'Radio ${widget.artist}',
        'desc': 'Lagu-lagu dari ${widget.artist} & artis serupa',
        'icon': Icons.radio_rounded,
        'color': _accentColor,
        'active': true,
      },
      {
        'name': 'Genre Mix',
        'desc': 'Campuran terbaik genre ini',
        'icon': Icons.queue_music_rounded,
        'color': const Color(0xFF6C4FD6),
        'active': false,
      },
      {
        'name': 'Mood Radio',
        'desc': 'Berdasarkan suasana hati saat ini',
        'icon': Icons.mood_rounded,
        'color': const Color(0xFF1DB8E8),
        'active': false,
      },
      {
        'name': 'Dekade 2000-an',
        'desc': 'Hits terbaik era 2000an Indonesia',
        'icon': Icons.history_rounded,
        'color': const Color(0xFFE8931D),
        'active': false,
      },
      {
        'name': 'Pop Indonesia',
        'desc': 'Pop hits pilihan editorial',
        'icon': Icons.stars_rounded,
        'color': const Color(0xFFD65F7A),
        'active': false,
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => StatefulBuilder(builder: (ctx, setS) {
        int activeIdx = 0;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _sheetHandle()),
              const SizedBox(height: 16),
              const Text(
                'Putar Radio',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                'Pilih stasiun radio yang ingin diputar',
                style: TextStyle(
                    fontSize: 13, color: Colors.white.withOpacity(0.45)),
              ),
              const SizedBox(height: 16),
              ...List.generate(stations.length, (i) {
                final s = stations[i];
                final isActive = i == activeIdx;
                return GestureDetector(
                  onTap: () {
                    setS(() => activeIdx = i);
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (ctx.mounted) Navigator.pop(ctx);
                      _showSnackbar(
                        'Memutar "${s['name']}"',
                        icon: Icons.radio_rounded,
                      );
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isActive
                          ? (s['color'] as Color).withOpacity(0.15)
                          : Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isActive
                            ? (s['color'] as Color).withOpacity(0.4)
                            : Colors.white.withOpacity(0.07),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color:
                                (s['color'] as Color).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(s['icon'] as IconData,
                              color: s['color'] as Color, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s['name'] as String,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              const SizedBox(height: 2),
                              Text(s['desc'] as String,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color:
                                          Colors.white.withOpacity(0.4))),
                            ],
                          ),
                        ),
                        if (isActive)
                          Icon(Icons.play_circle_filled_rounded,
                              color: s['color'] as Color, size: 28)
                        else
                          Icon(Icons.play_circle_outline_rounded,
                              color: Colors.white.withOpacity(0.2),
                              size: 28),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INFO — Song Info Sheet
  // ═══════════════════════════════════════════════════════════════════════════
  void _showInfoSheet() {
    final infos = [
      (Icons.album_outlined, 'Album', 'Melepasmu (Single)'),
      (Icons.person_outline_rounded, 'Artis', widget.artist),
      (Icons.calendar_today_rounded, 'Tahun Rilis', '2015'),
      (Icons.library_music_outlined, 'Genre', 'Pop Indonesia'),
      (Icons.timer_outlined, 'Durasi', '3:45'),
      (Icons.headphones_rounded, 'Total Diputar', '12.4 jt kali'),
      (Icons.music_note_rounded, 'Label', 'Trinity Optima Production'),
      (Icons.language_rounded, 'Bahasa', 'Indonesia'),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.45,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollCtrl) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Column(
            children: [
              _sheetHandle(),
              const SizedBox(height: 16),
              // Header info
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: widget.imageUrl != null
                        ? Image.network(widget.imageUrl!,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _sheetArtFallback(size: 72))
                        : _sheetArtFallback(size: 72),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(widget.artist,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.55))),
                        const SizedBox(height: 8),
                        // Rating bintang
                        Row(
                          children: [
                            ...List.generate(
                                5,
                                (i) => Icon(
                                      i < 4
                                          ? Icons.star_rounded
                                          : Icons.star_half_rounded,
                                      color: const Color(0xFFFFD700),
                                      size: 16,
                                    )),
                            const SizedBox(width: 6),
                            Text('4.8',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.5),
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white12, height: 1),
              const SizedBox(height: 4),
              Expanded(
                child: ListView.builder(
                  controller: scrollCtrl,
                  itemCount: infos.length,
                  itemBuilder: (_, i) {
                    final info = infos[i];
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Colors.white.withOpacity(0.06)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(info.$1,
                                color: _accentColor, size: 18),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(info.$2,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color:
                                            Colors.white.withOpacity(0.4),
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 2),
                                Text(info.$3,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SHARED HELPERS (sheet)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _sheetHandle() {
    return Container(
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _sheetArtFallback({double size = 44}) {
    return Container(
      width: size,
      height: size,
      color: _accentColor,
      child: const Icon(Icons.music_note_rounded,
          color: Colors.white38, size: 22),
    );
  }

  void _showSnackbar(String msg, {IconData? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(msg,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF252540),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LYRICS VIEW
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildLyricsView({Key? key}) {
    final activeIdx = _activeLyricIdx;
    return ListView.builder(
      key: key,
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
      itemCount: _lyrics.length,
      itemBuilder: (_, i) {
        final isActive = i == activeIdx;
        final text = _lyrics[i]['text'] as String;
        if (text.isEmpty) return const SizedBox(height: 20);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 16),
          child: Text(
            text,
            style: TextStyle(
              fontSize: isActive ? 20 : 16,
              fontWeight:
                  isActive ? FontWeight.w800 : FontWeight.w500,
              color: isActive
                  ? Colors.white
                  : Colors.white.withOpacity(0.3),
              height: 1.5,
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // QUEUE VIEW
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildQueueView({Key? key}) {
    return ListView(
      key: key,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      children: [
        // Lagu aktif saat ini
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _accentColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _accentColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              // Cover art
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                    ? Image.network(
                        widget.imageUrl!,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _queueArtFallback(
                            widget.color ?? AppColors.primary),
                      )
                    : _queueArtFallback(widget.color ?? AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.artist,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.equalizer_rounded,
                color: _accentColor,
                size: 22,
              ),
            ],
          ),
        ),

        // Label antrian berikutnya
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Berikutnya',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.4),
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Daftar lagu berikutnya
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _queue.length,
          onReorder: (oldIdx, newIdx) {
            setState(() {
              if (newIdx > oldIdx) newIdx--;
              final item = _queue.removeAt(oldIdx);
              _queue.insert(newIdx, item);
            });
          },
          itemBuilder: (_, i) {
            final song = _queue[i];
            return _queueItem(song, i, key: ValueKey('$i-${song['title']}'));
          },
        ),
      ],
    );
  }

  Widget _queueItem(Map<String, dynamic> song, int i, {Key? key}) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Drag handle
          Icon(Icons.drag_handle_rounded,
              color: Colors.white.withOpacity(0.2), size: 20),
          const SizedBox(width: 10),
          // Cover art
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              song['imageUrl'] as String,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  _queueArtFallback(song['color'] as Color),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song['title'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  song['artist'] as String,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          // Hapus dari antrian
          GestureDetector(
            onTap: () => setState(() => _queue.removeAt(i)),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.close_rounded,
                color: Colors.white.withOpacity(0.25),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _queueArtFallback(Color color) {
    return Container(
      width: 44,
      height: 44,
      color: color,
      child: const Icon(Icons.music_note_rounded,
          color: Colors.white38, size: 20),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // OPTIONS BOTTOM SHEET
  // ═══════════════════════════════════════════════════════════════════════════
  void _showOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final opts = [
          (Icons.playlist_add_rounded, 'Tambah ke Playlist'),
          (Icons.person_outline_rounded, 'Lihat Artis'),
          (Icons.album_outlined, 'Lihat Album'),
          (Icons.share_rounded, 'Bagikan Lagu'),
          (Icons.download_rounded, 'Unduh'),
          (Icons.block_rounded, 'Jangan Rekomendasikan'),
        ];
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              // Info lagu
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: widget.imageUrl != null
                        ? Image.network(
                            widget.imageUrl!,
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 52,
                              height: 52,
                              color: _accentColor,
                              child: const Icon(Icons.music_note_rounded,
                                  color: Colors.white38),
                            ),
                          )
                        : Container(
                            width: 52,
                            height: 52,
                            color: _accentColor,
                            child: const Icon(Icons.music_note_rounded,
                                color: Colors.white38),
                          ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.artist,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white12, height: 1),
              const SizedBox(height: 8),
              ...opts.map(
                (o) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(o.$1,
                      color: Colors.white.withOpacity(0.7), size: 22),
                  title: Text(
                    o.$2,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
