import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Model live event
// ─────────────────────────────────────────────────────────────────────────────
class LiveEvent {
  final String title;
  final String artist;
  final Color color;
  final String imageUrl;
  LiveEvent({
    required this.title,
    required this.artist,
    required this.color,
    required this.imageUrl,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// LivePage
// ─────────────────────────────────────────────────────────────────────────────
class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> with TickerProviderStateMixin {
  final ScrollController _scrollCtrl = ScrollController();
  double _appBarOpacity = 0;

  // ── Filter kategori live ──────────────────────────────────────────────────
  int _selectedCategory = 0;
  final List<String> _categories = [
    'Semua',
    'Konser',
    'Festival',
    'DJ Session',
    'Jazz',
    'Indie',
  ];

  // ── Now playing state ─────────────────────────────────────────────────────
  LiveEvent? _nowPlaying;
  bool _isPlaying = true;
  double _miniProgress = 0.0;

  late AnimationController _miniSlideCtrl;
  late Animation<Offset> _miniSlideAnim;
  late AnimationController _miniPulseCtrl;
  late Animation<double> _miniPulseAnim;
  late AnimationController _liveBadgeCtrl;
  late Animation<double> _liveBadgeAnim;

  // ── Data live featured ────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _featuredLive = [
    {
      'title': 'Live: Konser Raisa',
      'artist': 'Raisa',
      'viewers': '12.4 rb menonton',
      'genre': 'Pop',
      'color': const Color(0xFF4A1A2A),
      'imageUrl': 'https://picsum.photos/seed/liveraisa/400/220',
    },
    {
      'title': 'Live: Jazz Malam',
      'artist': 'Jazz Club Jakarta',
      'viewers': '3.8 rb menonton',
      'genre': 'Jazz',
      'color': const Color(0xFF1A2A4A),
      'imageUrl': 'https://picsum.photos/seed/livejazzmalam/400/220',
    },
    {
      'title': 'Live: Indie Fest',
      'artist': 'Various Artists',
      'viewers': '8.1 rb menonton',
      'genre': 'Indie',
      'color': const Color(0xFF3A1A4A),
      'imageUrl': 'https://picsum.photos/seed/liveindiefest/400/220',
    },
  ];

  // ── Data live aktif sekarang ──────────────────────────────────────────────
  final List<Map<String, dynamic>> _liveNow = [
    {
      'title': 'Live: Konser Raisa',
      'artist': 'Raisa',
      'viewers': '12.4 rb',
      'genre': 'Pop',
      'dur': 'LIVE',
      'color': const Color(0xFF4A1A2A),
      'imageUrl': 'https://picsum.photos/seed/liveraisa/200/200',
    },
    {
      'title': 'Live: Jazz Malam',
      'artist': 'Jazz Club Jakarta',
      'viewers': '3.8 rb',
      'genre': 'Jazz',
      'dur': 'LIVE',
      'color': const Color(0xFF1A2A4A),
      'imageUrl': 'https://picsum.photos/seed/livejazmalam/200/200',
    },
    {
      'title': 'Live: Indie Fest',
      'artist': 'Various Artists',
      'viewers': '8.1 rb',
      'genre': 'Indie',
      'dur': 'LIVE',
      'color': const Color(0xFF3A1A4A),
      'imageUrl': 'https://picsum.photos/seed/liveindiefest/200/200',
    },
    {
      'title': 'Live: DJ Session',
      'artist': 'DJ Winky',
      'viewers': '5.2 rb',
      'genre': 'DJ Session',
      'dur': 'LIVE',
      'color': const Color(0xFF1A3A4A),
      'imageUrl': 'https://picsum.photos/seed/livedjsession/200/200',
    },
    {
      'title': 'Live: Tulus Akustik',
      'artist': 'Tulus',
      'viewers': '9.7 rb',
      'genre': 'Konser',
      'dur': 'LIVE',
      'color': const Color(0xFF2A4A1A),
      'imageUrl': 'https://picsum.photos/seed/livetulus/200/200',
    },
    {
      'title': 'Live: Sheila On 7',
      'artist': 'Sheila On 7',
      'viewers': '7.3 rb',
      'genre': 'Konser',
      'dur': 'LIVE',
      'color': const Color(0xFF4A3A1A),
      'imageUrl': 'https://picsum.photos/seed/livesheila/200/200',
    },
  ];

  // ── Data upcoming live ────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _upcomingLive = [
    {
      'title': 'Konser Noah',
      'artist': 'Noah',
      'time': 'Besok, 20:00',
      'color': const Color(0xFF1E3A5F),
      'imageUrl': 'https://picsum.photos/seed/livenowah/200/200',
    },
    {
      'title': 'Festival Musik ID',
      'artist': 'Various Artists',
      'time': 'Sabtu, 18:00',
      'color': const Color(0xFF3A1E5F),
      'imageUrl': 'https://picsum.photos/seed/livefestivalid/200/200',
    },
    {
      'title': 'Konser Afgan',
      'artist': 'Afgan',
      'time': 'Minggu, 19:30',
      'color': const Color(0xFF1E5F3A),
      'imageUrl': 'https://picsum.photos/seed/liveafgan/200/200',
    },
    {
      'title': 'EDM Night Jakarta',
      'artist': 'DJ Riri & Friends',
      'time': 'Jumat, 22:00',
      'color': const Color(0xFF5F3A1E),
      'imageUrl': 'https://picsum.photos/seed/liveedmnight/200/200',
    },
  ];

  // ── Init ──────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    _scrollCtrl.addListener(() {
      final o = (_scrollCtrl.offset / 100).clamp(0.0, 1.0);
      if (o != _appBarOpacity) setState(() => _appBarOpacity = o);
    });

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

    _miniPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _miniPulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _miniPulseCtrl, curve: Curves.easeInOut),
    );

    _liveBadgeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _liveBadgeAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _liveBadgeCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _miniSlideCtrl.dispose();
    _miniPulseCtrl.dispose();
    _liveBadgeCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  void _playLive({
    required String title,
    required String artist,
    Color color = AppColors.primary,
    String imageUrl = '',
  }) {
    final isNew = _nowPlaying?.title != title;
    setState(() {
      _nowPlaying = LiveEvent(
        title: title,
        artist: artist,
        color: color,
        imageUrl: imageUrl,
      );
      _isPlaying = true;
      if (isNew) _miniProgress = 0.0;
    });
    if (isNew) _miniSlideCtrl.forward(from: 0);
  }

  void _openLivePlayer(
      String title, String artist, Color color, String imageUrl) {
    _playLive(title: title, artist: artist, color: color, imageUrl: imageUrl);
    Navigator.of(context).pushNamed(
      AppRoutes.player,
      arguments: {'title': title, 'artist': artist},
    );
  }

  List<Map<String, dynamic>> get _filteredLive {
    if (_selectedCategory == 0) return _liveNow;
    final genre = _categories[_selectedCategory];
    return _liveNow
        .where((e) => e['genre'] == genre)
        .toList();
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(_appBarOpacity),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AnimatedOpacity(
          opacity: _appBarOpacity,
          duration: const Duration(milliseconds: 150),
          child: const Text(
            'Live',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded,
                color: Colors.white),
            onPressed: () {},
            tooltip: 'Notifikasi',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollCtrl,
            padding: EdgeInsets.only(
              bottom: _nowPlaying != null ? 100 : 24,
            ),
            children: [
              // ── Hero header ───────────────────────────────────────────────
              _buildHeader(),
              const SizedBox(height: 8),

              // ── Filter kategori ───────────────────────────────────────────
              _buildCategoryFilter(),
              const SizedBox(height: 24),

              // ── Sedang Live sekarang ──────────────────────────────────────
              _sectionHeader('Sedang Live Sekarang'),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: _buildLiveList(
                  key: ValueKey(_selectedCategory),
                  items: _filteredLive,
                ),
              ),
              const SizedBox(height: 28),

              // ── Upcoming Live ─────────────────────────────────────────────
              _sectionHeader('Akan Datang'),
              _buildUpcomingList(),
              const SizedBox(height: 28),

              // ── Featured banner ───────────────────────────────────────────
              _sectionHeader('Sorotan Live'),
              _buildFeaturedLiveCarousel(),
              const SizedBox(height: 28),
            ],
          ),

          // ── Floating mini player ─────────────────────────────────────────
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

  // ─────────────────────────────────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2A0A0A), Color(0xFF4A0A0A), AppColors.background],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 56,
        20,
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Animasi dot live
              AnimatedBuilder(
                animation: _liveBadgeAnim,
                builder: (_, __) => Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(_liveBadgeAnim.value),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'LIVE SEKARANG',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.red,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Musik Live & Konser',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_liveNow.length} acara sedang berlangsung',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CATEGORY FILTER
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final isSelected = _selectedCategory == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected ? Colors.red : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                _categories[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color:
                      isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SECTION HEADER
  // ─────────────────────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Lihat semua',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // LIVE LIST (Sedang Live)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildLiveList({
    required List<Map<String, dynamic>> items,
    Key? key,
  }) {
    if (items.isEmpty) {
      return Padding(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.wifi_tethering_off_rounded,
                  color: AppColors.textMuted, size: 42),
              const SizedBox(height: 12),
              const Text(
                'Tidak ada live di kategori ini',
                style:
                    TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: items.map((item) {
          final isActive = _nowPlaying?.title == item['title'];
          return GestureDetector(
            onTap: () => _openLivePlayer(
              item['title'] as String,
              item['artist'] as String,
              item['color'] as Color,
              item['imageUrl'] as String,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.red.withOpacity(0.08)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: isActive
                    ? Border.all(color: Colors.red.withOpacity(0.4))
                    : Border.all(
                        color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  // Thumbnail
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item['imageUrl'] as String,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 60,
                            height: 60,
                            color: item['color'] as Color,
                            child: const Icon(
                              Icons.wifi_tethering_rounded,
                              color: Colors.white38,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      // Live badge di atas thumbnail
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: AnimatedBuilder(
                          animation: _liveBadgeAnim,
                          builder: (_, __) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red
                                  .withOpacity(0.85 + _liveBadgeAnim.value * 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'LIVE',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 14),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
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
                          item['artist'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(
                              Icons.remove_red_eye_outlined,
                              size: 12,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item['viewers'] as String,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Tombol tonton
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.red.withOpacity(0.15)
                          : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isActive ? 'Menonton' : 'Tonton',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isActive ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // UPCOMING LIST
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildUpcomingList() {
    return SizedBox(
      height: 165,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _upcomingLive.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final item = _upcomingLive[i];
          return GestureDetector(
            onTap: () {},
            child: SizedBox(
              width: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            item['imageUrl'] as String,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: item['color'] as Color,
                              child: const Icon(
                                Icons.event_rounded,
                                color: Colors.white38,
                                size: 32,
                              ),
                            ),
                          ),
                          // Gradient overlay
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.75),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Waktu di bawah gambar
                          Positioned(
                            bottom: 8,
                            left: 8,
                            right: 8,
                            child: Row(
                              children: [
                                const Icon(Icons.schedule_rounded,
                                    size: 10, color: Colors.white70),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item['time'] as String,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['artist'] as String,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // FEATURED LIVE CAROUSEL
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildFeaturedLiveCarousel() {
    return SizedBox(
      height: 195,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _featuredLive.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final item = _featuredLive[i];
          final isActive = _nowPlaying?.title == item['title'];
          return GestureDetector(
            onTap: () => _openLivePlayer(
              item['title'] as String,
              item['artist'] as String,
              item['color'] as Color,
              item['imageUrl'] as String,
            ),
            child: SizedBox(
              width: 260,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image
                    Image.network(
                      item['imageUrl'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: item['color'] as Color,
                        child: const Icon(
                          Icons.wifi_tethering_rounded,
                          color: Colors.white24,
                          size: 48,
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                    // Konten teks
                    Positioned(
                      bottom: 14,
                      left: 14,
                      right: 14,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AnimatedBuilder(
                                animation: _liveBadgeAnim,
                                builder: (_, __) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(
                                        0.85 + _liveBadgeAnim.value * 0.15),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Text(
                                    'LIVE',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  const Icon(Icons.remove_red_eye_outlined,
                                      size: 11, color: Colors.white70),
                                  const SizedBox(width: 3),
                                  Text(
                                    item['viewers'] as String,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item['title'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['artist'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Border aktif
                    if (isActive)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border:
                              Border.all(color: Colors.red, width: 2.5),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FLOATING MINI PLAYER
  // ══════════════════════════════════════════════════════════════════════════
  Widget _miniPlayer() {
    final event = _nowPlaying!;
    return GestureDetector(
      onTap: () => _openLivePlayer(
          event.title, event.artist, event.color, event.imageUrl),
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
            color: Colors.red.withOpacity(0.3),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.red.withOpacity(0.12),
              blurRadius: 20,
              spreadRadius: -2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Row(
              children: [
                // Thumbnail dengan pulse
                AnimatedBuilder(
                  animation: _miniPulseAnim,
                  builder: (_, child) => Transform.scale(
                    scale: _isPlaying ? _miniPulseAnim.value : 1.0,
                    child: child,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: event.imageUrl.isNotEmpty
                        ? Image.network(
                            event.imageUrl,
                            width: 46,
                            height: 46,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _miniArtFallback(event),
                          )
                        : _miniArtFallback(event),
                  ),
                ),
                const SizedBox(width: 12),

                // Live badge + info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AnimatedBuilder(
                            animation: _liveBadgeAnim,
                            builder: (_, __) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(
                                    0.8 + _liveBadgeAnim.value * 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'LIVE',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        event.artist,
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

                const SizedBox(width: 8),

                // Controls
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
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniArtFallback(LiveEvent event) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: event.color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: _isPlaying
            ? [
                BoxShadow(
                  color: event.color.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: const Icon(
        Icons.wifi_tethering_rounded,
        color: Colors.white38,
        size: 22,
      ),
    );
  }
}
