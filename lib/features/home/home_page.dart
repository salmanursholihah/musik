import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Model lagu yang sedang diputar (shared state ringan)
// ─────────────────────────────────────────────────────────────────────────────
class NowPlaying {
  final String title;
  final String artist;
  final Color color;
  NowPlaying({required this.title, required this.artist, required this.color});
}

// ─────────────────────────────────────────────────────────────────────────────
// HomePage
// ─────────────────────────────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ScrollController _scrollCtrl = ScrollController();
  double _appBarOpacity = 0;

  // ── Mini player state ──────────────────────────────────────────────────────
  NowPlaying? _nowPlaying;
  bool _isPlaying = true;
  double _miniProgress = 0.35;

  late AnimationController _miniSlideCtrl;
  late Animation<Offset> _miniSlideAnim;
  late AnimationController _miniPulseCtrl;
  late Animation<double> _miniPulseAnim;

  // ── Data ───────────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _recent = [
    {'title': 'Chill Vibes',   'color': Color(0xFF1E3A5F)},
    {'title': 'Indie Folk',    'color': Color(0xFF2D1B4E)},
    {'title': 'Top Hits ID',   'color': Color(0xFF1A4035)},
    {'title': 'Rock Klasik',   'color': Color(0xFF4A1C1C)},
    {'title': 'Morning Mood',  'color': Color(0xFF1E2A4A)},
    {'title': 'EDM Bangers',   'color': Color(0xFF2C2A1A)},
  ];

  final List<Map<String, dynamic>> _featured = [
    {'title': 'Trending Indonesia', 'sub': '50 lagu', 'color': Color(0xFF1DB8E8)},
    {'title': 'Mood Booster',       'sub': '35 lagu', 'color': Color(0xFF6C4FD6)},
    {'title': 'Relaksasi Malam',    'sub': '28 lagu', 'color': Color(0xFF2A7D5F)},
    {'title': 'Workout Mix',        'sub': '42 lagu', 'color': Color(0xFFD65F4F)},
  ];

  final List<Map<String, String>> _charts = [
    {'rank': '1', 'title': 'Belahan Jiwa',      'artist': 'Yura Yunita', 'plays': '12.4 jt'},
    {'rank': '2', 'title': 'Masih Disini',       'artist': 'Tulus',       'plays': '10.8 jt'},
    {'rank': '3', 'title': 'Runtuh',             'artist': 'Feby Putri',  'plays': '9.2 jt'},
    {'rank': '4', 'title': 'Hati-Hati di Jalan', 'artist': 'Tulus',       'plays': '8.7 jt'},
    {'rank': '5', 'title': 'Mangu',              'artist': 'Fourtwnty',   'plays': '7.5 jt'},
  ];

  final List<Map<String, dynamic>> _recommended = [
    {'title': 'Melepasmu',          'artist': 'Armada',      'dur': '3:45', 'color': Color(0xFF1E3A5F)},
    {'title': 'Salah Apa Aku',      'artist': 'Judika',      'dur': '4:12', 'color': Color(0xFF2D1B4E)},
    {'title': 'Kasih Tak Sampai',   'artist': 'Padi',        'dur': '4:28', 'color': Color(0xFF1A4035)},
    {'title': 'Separuh Aku',        'artist': 'Noah',        'dur': '3:58', 'color': Color(0xFF4A1C1C)},
    {'title': 'Tak Bisa Memilikimu','artist': 'Sheila On 7', 'dur': '3:33', 'color': Color(0xFF2C2A1A)},
  ];

  // ── Init ───────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    _scrollCtrl.addListener(() {
      final o = (_scrollCtrl.offset / 120).clamp(0.0, 1.0);
      if (o != _appBarOpacity) setState(() => _appBarOpacity = o);
    });

    // Mini player slide animation
    _miniSlideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _miniSlideAnim = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _miniSlideCtrl,
      curve: Curves.easeOutCubic,
    ));

    // Mini player pulse (indicates playing)
    _miniPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _miniPulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _miniPulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _miniSlideCtrl.dispose();
    _miniPulseCtrl.dispose();
    super.dispose();
  }

  // ── Play song helper ───────────────────────────────────────────────────────
  void _playSong({
    required String title,
    required String artist,
    Color color = AppColors.primary,
  }) {
    final isNew = _nowPlaying?.title != title;
    setState(() {
      _nowPlaying = NowPlaying(title: title, artist: artist, color: color);
      _isPlaying = true;
      if (isNew) _miniProgress = 0.0;
    });
    if (isNew) {
      _miniSlideCtrl.forward(from: 0);
    }
  }

  // Navigate to full player and keep mini in sync
  void _openPlayer(String title, String artist, Color color) {
    _playSong(title: title, artist: artist, color: color);
    Navigator.of(context).pushNamed(
      AppRoutes.player,
      arguments: {'title': title, 'artist': artist},
    );
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Selamat Pagi ☀️';
    if (h < 17) return 'Selamat Siang 🌤';
    if (h < 20) return 'Selamat Sore 🌇';
    return 'Selamat Malam 🌙';
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(_appBarOpacity),
        title: AnimatedOpacity(
          opacity: _appBarOpacity,
          duration: const Duration(milliseconds: 150),
          child: const Text('Beranda'),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.offline),
            icon: const Icon(Icons.download),
            tooltip: 'Musik Offline',
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.subscription),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Premium',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      // ── Stack: content + floating mini player ────────────────────────────
      body: Stack(
        children: [
          // Main scroll content
          ListView(
            controller: _scrollCtrl,
            // Extra bottom padding so content doesn't hide behind mini player
            padding: EdgeInsets.only(bottom: _nowPlaying != null ? 100 : 20),
            children: [
              // Header gradient
              Container(
                height: 240,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A3A5C), AppColors.background],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 110, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting,
                      style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6)),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Selamat datang, Pengguna!',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    _quickFilters(),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              _sectionHeader('Baru-baru ini diputar'),
              _recentGrid(),
              const SizedBox(height: 24),
              _sectionHeader('Playlist Pilihan'),
              _featuredList(),
              const SizedBox(height: 24),
              _sectionHeader('Tangga Lagu'),
              _chartSection(),
              const SizedBox(height: 24),
              _offlineBanner(),
              const SizedBox(height: 24),
              _premiumBanner(),
              const SizedBox(height: 24),
              _sectionHeader('Direkomendasikan'),
              _recommendedList(),
            ],
          ),

          // ── Floating mini player ──────────────────────────────────────────
          if (_nowPlaying != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SlideTransition(
                position: _miniSlideAnim,
                child: _miniPlayer(),
              ),
            ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FLOATING MINI PLAYER
  // ══════════════════════════════════════════════════════════════════════════
  Widget _miniPlayer() {
    final song = _nowPlaying!;
    return GestureDetector(
      onTap: () => _openPlayer(song.title, song.artist, song.color),
      // Swipe down to dismiss
      onVerticalDragEnd: (d) {
        if (d.primaryVelocity != null && d.primaryVelocity! > 200) {
          _miniSlideCtrl.reverse().then((_) {
            if (mounted) setState(() => _nowPlaying = null);
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: song.color.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: -2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Main row ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Row(
                  children: [
                    // Album art with pulse animation when playing
                    AnimatedBuilder(
                      animation: _miniPulseAnim,
                      builder: (_, child) => Transform.scale(
                        scale: _isPlaying ? _miniPulseAnim.value : 1.0,
                        child: child,
                      ),
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: song.color,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _isPlaying
                              ? [
                                  BoxShadow(
                                    color: song.color.withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : [],
                        ),
                        child: const Icon(
                          Icons.music_note_rounded,
                          color: Colors.white38,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Song info — animated cross-fade when song changes
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.08, 0),
                              end: Offset.zero,
                            ).animate(anim),
                            child: child,
                          ),
                        ),
                        child: Column(
                          key: ValueKey(song.title),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              song.artist,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Controls
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Prev
                        GestureDetector(
                          onTap: () => setState(() => _miniProgress = 0),
                          child: const Icon(
                            Icons.skip_previous_rounded,
                            color: AppColors.textSecondary,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 6),

                        // Play / Pause
                        GestureDetector(
                          onTap: () => setState(() {
                            _isPlaying = !_isPlaying;
                            _isPlaying
                                ? _miniPulseCtrl.repeat(reverse: true)
                                : _miniPulseCtrl.stop();
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 10,
                                  spreadRadius: 1,
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
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),

                        // Next
                        GestureDetector(
                          onTap: () {
                            // Simulate next song
                            final songs = [
                              ..._charts.map((c) => {
                                    'title': c['title']!,
                                    'artist': c['artist']!,
                                  }),
                              ..._recommended,
                            ];
                            final idx = songs.indexWhere(
                              (s) => s['title'] == song.title,
                            );
                            final next = songs[(idx + 1) % songs.length];
                            _playSong(
                              title: next['title'] as String,
                              artist: next['artist'] as String,
                              color: (next['color'] as Color?) ?? AppColors.primary,
                            );
                          },
                          child: const Icon(
                            Icons.skip_next_rounded,
                            color: AppColors.textSecondary,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Progress bar ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onHorizontalDragUpdate: (d) {
                          final w = context.size?.width ?? 360;
                          final delta = d.delta.dx / (w - 24);
                          setState(() {
                            _miniProgress =
                                (_miniProgress + delta).clamp(0.0, 1.0);
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Stack(
                            children: [
                              // Track
                              Container(
                                height: 3,
                                color: Colors.white.withOpacity(0.1),
                              ),
                              // Filled
                              FractionallySizedBox(
                                widthFactor: _miniProgress,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: 3,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        song.color,
                                        AppColors.primary,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HOME CONTENT WIDGETS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _quickFilters() {
    final filters = ['Semua', 'Musik', 'Podcast', 'Live'];
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: i == 0 ? AppColors.primary : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            filters[i],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: i == 0 ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          Text(
            'Lihat semua',
            style: TextStyle(
                fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _recentGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _recent.length,
        itemBuilder: (_, i) {
          final item = _recent[i];
          final isActive = _nowPlaying?.title == item['title'];
          return GestureDetector(
            onTap: () => _playSong(
              title: item['title'],
              artist: 'Berbagai Artis',
              color: item['color'],
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: item['color'] as Color,
                borderRadius: BorderRadius.circular(8),
                border: isActive
                    ? Border.all(color: AppColors.primary, width: 1.8)
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(isActive ? 0.4 : 0.25),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Icon(
                      isActive ? Icons.equalizer_rounded : Icons.music_note,
                      color: isActive ? AppColors.primary : Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item['title'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _featuredList() {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _featured.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final item = _featured[i];
          final isActive = _nowPlaying?.title == item['title'];
          return GestureDetector(
            onTap: () => _openPlayer(
              item['title'],
              'Berbagai Artis',
              item['color'],
            ),
            child: SizedBox(
              width: 155,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      decoration: BoxDecoration(
                        color: item['color'] as Color,
                        borderRadius: BorderRadius.circular(10),
                        border: isActive
                            ? Border.all(color: AppColors.primary, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Icon(
                          isActive
                              ? Icons.equalizer_rounded
                              : Icons.music_note,
                          color: isActive ? AppColors.primary : Colors.white38,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['sub'] ?? '',
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _chartSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: _charts.map((c) {
          final isActive = _nowPlaying?.title == c['title'];
          return GestureDetector(
            onTap: () => _openPlayer(
              c['title']!,
              c['artist']!,
              AppColors.primary,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: isActive
                    ? Border.all(color: AppColors.primary.withOpacity(0.4))
                    : null,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 28,
                    child: Text(
                      c['rank']!,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isActive ? AppColors.primary : AppColors.primary,
                      ),
                    ),
                  ),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isActive ? Icons.equalizer_rounded : Icons.music_note,
                      color: isActive ? AppColors.primary : AppColors.textMuted,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c['title']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.white : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          c['artist']!,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  if (isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Diputar',
                        style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  else
                    Text(
                      c['plays']!,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textMuted),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _offlineBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.offline),
        child: Container(
          padding: const EdgeInsets.all(18),
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.wifi_off_rounded,
                    color: AppColors.primary, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Musik Offline',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '7 lagu tersimpan di perangkat',
                      style: TextStyle(
                          fontSize: 12, color: Colors.white.withOpacity(0.55)),
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
    );
  }

  Widget _premiumBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.subscription),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upgrade ke Premium',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Nikmati musik tanpa iklan & unduh untuk offline',
                      style: TextStyle(
                          fontSize: 12, color: Colors.white.withOpacity(0.8)),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Coba Gratis',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.workspace_premium, color: Colors.white, size: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recommendedList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: _recommended.map((song) {
          final isActive = _nowPlaying?.title == song['title'];
          return GestureDetector(
            onTap: () => _openPlayer(
              song['title'] as String,
              song['artist'] as String,
              song['color'] as Color,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: isActive
                    ? Border.all(color: AppColors.primary.withOpacity(0.4))
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: song['color'] as Color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isActive ? Icons.equalizer_rounded : Icons.music_note,
                      color: isActive ? AppColors.primary : Colors.white38,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song['title'] as String,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          song['artist'] as String,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  if (isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Diputar',
                        style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  else
                    Text(
                      song['dur'] as String,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                  const SizedBox(width: 8),
                  const Icon(Icons.more_vert,
                      color: AppColors.textMuted, size: 20),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
