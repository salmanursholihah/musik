import 'package:flutter/material.dart';
import 'package:musik/features/content/podcast_pages.dart';
import 'package:musik/features/player/player_page.dart';
import 'package:musik/features/songs/all_songs_pages.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Model lagu yang sedang diputar (shared state ringan)
// ─────────────────────────────────────────────────────────────────────────────
class NowPlaying {
  final String title;
  final String artist;
  final Color color;
  final String imageUrl;
  NowPlaying({
    required this.title,
    required this.artist,
    required this.color,
    required this.imageUrl,
  });
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

  // ── Filter chip state ──────────────────────────────────────────────────────
  int _selectedFilter = 0;
  final List<String> _filters = ['Semua', 'Musik', 'Podcast'];

  // ── Mini player state ──────────────────────────────────────────────────────
  NowPlaying? _nowPlaying;
  bool _isPlaying = true;
  double _miniProgress = 0.35;

  late AnimationController _miniSlideCtrl;
  late Animation<Offset> _miniSlideAnim;
  late AnimationController _miniPulseCtrl;
  late Animation<double> _miniPulseAnim;

  // ── Hero banner animation ──────────────────────────────────────────────────
  late AnimationController _heroBannerCtrl;
  late Animation<double> _heroBannerAnim;
  int _heroIdx = 0;

  // ── Data: Recent ───────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _recent = [
    {
      'title': 'Chill Vibes',
      'color': const Color(0xFF1E3A5F),
      'imageUrl': 'https://picsum.photos/seed/chillvibes/200/200',
    },
    {
      'title': 'Indie Folk',
      'color': const Color(0xFF2D1B4E),
      'imageUrl': 'https://picsum.photos/seed/indiefolk/200/200',
    },
    {
      'title': 'Top Hits ID',
      'color': const Color(0xFF1A4035),
      'imageUrl': 'https://picsum.photos/seed/tophitsid/200/200',
    },
    {
      'title': 'Rock Klasik',
      'color': const Color(0xFF4A1C1C),
      'imageUrl': 'https://picsum.photos/seed/rockklasik/200/200',
    },
    {
      'title': 'Morning Mood',
      'color': const Color(0xFF1E2A4A),
      'imageUrl': 'https://picsum.photos/seed/morningmood/200/200',
    },
    {
      'title': 'EDM Bangers',
      'color': const Color(0xFF2C2A1A),
      'imageUrl': 'https://picsum.photos/seed/edmbangers/200/200',
    },
  ];

  // ── Data: Featured Playlist ────────────────────────────────────────────────
  final List<Map<String, dynamic>> _featured = [
    {
      'title': 'Trending Indonesia',
      'sub': '50 lagu',
      'color': const Color(0xFF1DB8E8),
      'imageUrl': 'https://picsum.photos/seed/trendingidn/300/300',
    },
    {
      'title': 'Mood Booster',
      'sub': '35 lagu',
      'color': const Color(0xFF6C4FD6),
      'imageUrl': 'https://picsum.photos/seed/moodbooster/300/300',
    },
    {
      'title': 'Relaksasi Malam',
      'sub': '28 lagu',
      'color': const Color(0xFF2A7D5F),
      'imageUrl': 'https://picsum.photos/seed/relaksasimalam/300/300',
    },
    {
      'title': 'Workout Mix',
      'sub': '42 lagu',
      'color': const Color(0xFFD65F4F),
      'imageUrl': 'https://picsum.photos/seed/workoutmix/300/300',
    },
  ];

  // ── Data: Chart ────────────────────────────────────────────────────────────
  final List<Map<String, String>> _charts = [
    {
      'rank': '1',
      'title': 'Belahan Jiwa',
      'artist': 'Yura Yunita',
      'plays': '12.4 jt',
      'imageUrl': 'https://picsum.photos/seed/belahanjiwayura/200/200',
    },
    {
      'rank': '2',
      'title': 'Masih Disini',
      'artist': 'Tulus',
      'plays': '10.8 jt',
      'imageUrl': 'https://picsum.photos/seed/masihdisinitulus/200/200',
    },
    {
      'rank': '3',
      'title': 'Runtuh',
      'artist': 'Feby Putri',
      'plays': '9.2 jt',
      'imageUrl': 'https://picsum.photos/seed/runtuhfeby/200/200',
    },
    {
      'rank': '4',
      'title': 'Hati-Hati di Jalan',
      'artist': 'Tulus',
      'plays': '8.7 jt',
      'imageUrl': 'https://picsum.photos/seed/hatihatijalan/200/200',
    },
    {
      'rank': '5',
      'title': 'Mangu',
      'artist': 'Fourtwnty',
      'plays': '7.5 jt',
      'imageUrl': 'https://picsum.photos/seed/mangufourtwnty/200/200',
    },
  ];

  // ── Data: Recommended ─────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _recommended = [
    {
      'title': 'Melepasmu',
      'artist': 'Armada',
      'dur': '3:45',
      'color': const Color(0xFF1E3A5F),
      'imageUrl': 'https://picsum.photos/seed/melepasmuarmada/200/200',
    },
    {
      'title': 'Salah Apa Aku',
      'artist': 'Judika',
      'dur': '4:12',
      'color': const Color(0xFF2D1B4E),
      'imageUrl': 'https://picsum.photos/seed/salahapaakujudika/200/200',
    },
    {
      'title': 'Kasih Tak Sampai',
      'artist': 'Padi',
      'dur': '4:28',
      'color': const Color(0xFF1A4035),
      'imageUrl': 'https://picsum.photos/seed/kasihtaksampai/200/200',
    },
    {
      'title': 'Separuh Aku',
      'artist': 'Noah',
      'dur': '3:58',
      'color': const Color(0xFF4A1C1C),
      'imageUrl': 'https://picsum.photos/seed/separuhakunoah/200/200',
    },
    {
      'title': 'Tak Bisa Memilikimu',
      'artist': 'Sheila On 7',
      'dur': '3:33',
      'color': const Color(0xFF2C2A1A),
      'imageUrl': 'https://picsum.photos/seed/takbisamemilikimu/200/200',
    },
  ];

  // ── Data: Baru Dirilis ─────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _newReleases = [
    {
      'title': 'Satu Nama Tetap di Hati',
      'artist': 'Ipank',
      'badge': 'BARU',
      'color': const Color(0xFF1A3A5C),
      'imageUrl': 'https://picsum.photos/seed/satunama/300/300',
    },
    {
      'title': 'Sampai Menutup Mata',
      'artist': 'Slam',
      'badge': 'BARU',
      'color': const Color(0xFF3A1A5C),
      'imageUrl': 'https://picsum.photos/seed/sampainutup/300/300',
    },
    {
      'title': 'Cahaya Dari Surga',
      'artist': 'Nike Ardilla',
      'badge': 'BARU',
      'color': const Color(0xFF1A5C3A),
      'imageUrl': 'https://picsum.photos/seed/cahayasurga/300/300',
    },
    {
      'title': 'Bintang di Surga',
      'artist': 'Peter Pan',
      'badge': 'BARU',
      'color': const Color(0xFF5C3A1A),
      'imageUrl': 'https://picsum.photos/seed/bintangsurga/300/300',
    },
    {
      'title': 'Kisah Tak Sempurna',
      'artist': 'Sandy Sandoro',
      'badge': 'BARU',
      'color': const Color(0xFF1A4A5C),
      'imageUrl': 'https://picsum.photos/seed/kisahtaksempurna/300/300',
    },
  ];

  // ── Data: Artis Terpopuler ─────────────────────────────────────────────────
  final List<Map<String, dynamic>> _artists = [
    {
      'name': 'Tulus',
      'followers': '5.2 jt',
      'color': const Color(0xFF1A3A5C),
      'imageUrl': 'https://picsum.photos/seed/artistulus/200/200',
    },
    {
      'name': 'Raisa',
      'followers': '4.8 jt',
      'color': const Color(0xFF5C1A3A),
      'imageUrl': 'https://picsum.photos/seed/artistraisa/200/200',
    },
    {
      'name': 'Rizky Febian',
      'followers': '4.1 jt',
      'color': const Color(0xFF1A5C3A),
      'imageUrl': 'https://picsum.photos/seed/artistrizky/200/200',
    },
    {
      'name': 'Isyana',
      'followers': '3.9 jt',
      'color': const Color(0xFF3A1A5C),
      'imageUrl': 'https://picsum.photos/seed/artistisyana/200/200',
    },
    {
      'name': 'Noah',
      'followers': '6.0 jt',
      'color': const Color(0xFF5C3A1A),
      'imageUrl': 'https://picsum.photos/seed/artistnoah/200/200',
    },
    {
      'name': 'Dewa 19',
      'followers': '5.5 jt',
      'color': const Color(0xFF1A5C5C),
      'imageUrl': 'https://picsum.photos/seed/artistdewa/200/200',
    },
  ];

  // ── Data: Mood & Aktivitas ─────────────────────────────────────────────────
  final List<Map<String, dynamic>> _moods = [
    {
      'label': 'Santai',
      'icon': Icons.beach_access_rounded,
      'color': const Color(0xFF1DB8E8),
      'count': '24 lagu',
    },
    {
      'label': 'Semangat',
      'icon': Icons.bolt_rounded,
      'color': const Color(0xFFE8931D),
      'count': '31 lagu',
    },
    {
      'label': 'Sedih',
      'icon': Icons.water_drop_rounded,
      'color': const Color(0xFF5B6FD6),
      'count': '18 lagu',
    },
    {
      'label': 'Fokus',
      'icon': Icons.psychology_rounded,
      'color': const Color(0xFF2A7D5F),
      'count': '27 lagu',
    },
    {
      'label': 'Romantis',
      'icon': Icons.favorite_rounded,
      'color': const Color(0xFFD65F7A),
      'count': '20 lagu',
    },
    {
      'label': 'Tidur',
      'icon': Icons.nightlight_rounded,
      'color': const Color(0xFF4A3D7C),
      'count': '15 lagu',
    },
  ];

  // ── Data: Hero banner ──────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _heroBanners = [
    {
      'title': 'Hati-Hati di Jalan',
      'artist': 'Tulus',
      'label': 'Populer Sekarang',
      'color': const Color(0xFF1A3A5C),
      'imageUrl': 'https://picsum.photos/seed/herobannertulus/400/400',
    },
    {
      'title': 'Melepasmu',
      'artist': 'Armada',
      'label': 'Top di Indonesia',
      'color': const Color(0xFF3A1A5C),
      'imageUrl': 'https://picsum.photos/seed/herobannerarmada/400/400',
    },
    {
      'title': 'Belahan Jiwa',
      'artist': 'Yura Yunita',
      'label': 'Trending Minggu Ini',
      'color': const Color(0xFF1A5C3A),
      'imageUrl': 'https://picsum.photos/seed/herobanneryrua/400/400',
    },
  ];

  // ── Data: Podcast Preview ──────────────────────────────────────────────────
  final List<Map<String, dynamic>> _podcastPreview = [
    {
      'title': 'Filosofi Kopi',
      'host': 'Podcast Host',
      'dur': '42:10',
      'color': const Color(0xFF3A2A1A),
      'imageUrl': 'https://picsum.photos/seed/filosofikopi/200/200',
    },
    {
      'title': 'Makna Talks',
      'host': 'Najwa Shihab',
      'dur': '55:30',
      'color': const Color(0xFF1A2A3A),
      'imageUrl': 'https://picsum.photos/seed/maknatalks/200/200',
    },
    {
      'title': 'Tech Talk ID',
      'host': 'Dev Community',
      'dur': '1:02:15',
      'color': const Color(0xFF2A1A3A),
      'imageUrl': 'https://picsum.photos/seed/techtalkid/200/200',
    },
  ];

  // ── Init ───────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    _scrollCtrl.addListener(() {
      final o = (_scrollCtrl.offset / 120).clamp(0.0, 1.0);
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

    _heroBannerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _heroBannerAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _heroBannerCtrl, curve: Curves.easeOut),
    );
    _heroBannerCtrl.forward();

    // Auto-slide hero banner setiap 4 detik
    Future.delayed(const Duration(seconds: 4), _autoSlideHero);
  }

  void _autoSlideHero() {
    if (!mounted) return;
    _heroBannerCtrl.reverse().then((_) {
      if (!mounted) return;
      setState(() => _heroIdx = (_heroIdx + 1) % _heroBanners.length);
      _heroBannerCtrl.forward();
    });
    Future.delayed(const Duration(seconds: 4), _autoSlideHero);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _miniSlideCtrl.dispose();
    _miniPulseCtrl.dispose();
    _heroBannerCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  void _playSong({
    required String title,
    required String artist,
    Color color = AppColors.primary,
    String imageUrl = '',
  }) {
    final isNew = _nowPlaying?.title != title;
    setState(() {
      _nowPlaying = NowPlaying(
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

  void _openPlayer(String title, String artist, Color color, String imageUrl) {
    _playSong(title: title, artist: artist, color: color, imageUrl: imageUrl);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlayerPage(
          title: title,
          artist: artist,
          color: color,
          imageUrl: imageUrl,
        ),
      ),
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
          // GestureDetector(
          //   onTap: () =>
          //       Navigator.of(context).pushNamed(AppRoutes.subscription),
          //   // child: Container(
          //   //   margin: const EdgeInsets.only(right: 16),
          //   //   padding:
          //   //       const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          //   //   decoration: BoxDecoration(
          //   //     gradient: AppColors.primaryGradient,
          //   //     borderRadius: BorderRadius.circular(20),
          //   //   ),
          //   //   // child: const Text(
          //   //   //   'Premium',
          //   //   //   style: TextStyle(
          //   //   //       fontSize: 12,
          //   //   //       fontWeight: FontWeight.w700,
          //   //   //       color: Colors.white),
          //   //   // ),
          //   // ),
          // ),
        ],
      ),
      body: Stack(
        children: [
          // ── Konten utama ──────────────────────────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: _buildContent(key: ValueKey(_selectedFilter)),
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

  // ── Routing konten berdasarkan filter ─────────────────────────────────────
  Widget _buildContent({Key? key}) {
    return _buildHomeContent(key: key);
  }

  // ── Home utama (Semua / Musik) ─────────────────────────────────────────────
  Widget _buildHomeContent({Key? key}) {
    return ListView(
      key: key,
      controller: _scrollCtrl,
      padding: EdgeInsets.only(bottom: _nowPlaying != null ? 100 : 20),
      children: [
        // ── Hero header dengan banner ──────────────────────────────────────
        _heroHeader(),

        // ── Quick filter chips ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
          child: _quickFilters(),
        ),

        // ── Baru-baru ini diputar ──────────────────────────────────────────
        _sectionHeader(
          'Baru-baru ini diputar',
          onSeeAll: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AllSongsPage(
                title: 'Baru-baru ini diputar',
                items: _recent
                    .map((e) => {
                          'title': e['title'] as String,
                          'artist': 'Berbagai Artis',
                          'dur': '',
                          'color': e['color'] as Color,
                          'imageUrl': e['imageUrl'] as String,
                        })
                    .toList(),
              ),
            ),
          ),
        ),
        _recentGrid(),
        const SizedBox(height: 28),

        // ── Baru Dirilis ───────────────────────────────────────────────────
        _sectionHeader('Baru Dirilis', onSeeAll: () {}),
        _newReleasesSection(),
        const SizedBox(height: 28),

        // ── Playlist Pilihan ───────────────────────────────────────────────
        _sectionHeader(
          'Playlist Pilihan',
          onSeeAll: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AllSongsPage(
                title: 'Playlist Pilihan',
                items: _featured
                    .map((e) => {
                          'title': e['title'] as String,
                          'artist': e['sub'] as String,
                          'dur': '',
                          'color': e['color'] as Color,
                          'imageUrl': e['imageUrl'] as String,
                        })
                    .toList(),
              ),
            ),
          ),
        ),
        _featuredList(),
        const SizedBox(height: 28),

        // ── Mood & Aktivitas ───────────────────────────────────────────────
        _sectionHeader('Mood & Aktivitas', onSeeAll: () {}),
        _moodGrid(),
        const SizedBox(height: 28),

        // ── Tangga Lagu ────────────────────────────────────────────────────
        _sectionHeader(
          'Tangga Lagu',
          onSeeAll: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AllSongsPage(
                title: 'Tangga Lagu',
                items: _charts
                    .map((e) => {
                          'title': e['title'] as String,
                          'artist': e['artist'] as String,
                          'dur': e['plays'] as String,
                          'color': AppColors.primary,
                          'imageUrl': e['imageUrl'] as String,
                        })
                    .toList(),
                showRank: true,
              ),
            ),
          ),
        ),
        _chartSection(),
        const SizedBox(height: 28),

        // ── Artis Terpopuler ───────────────────────────────────────────────
        _sectionHeader('Artis Terpopuler', onSeeAll: () {}),
        _artistsSection(),
        const SizedBox(height: 28),

        // ── Banner offline & premium ───────────────────────────────────────
        _offlineBanner(),
        const SizedBox(height: 14),
        // _premiumBanner(),
        // const SizedBox(height: 28),

        // ── Podcast preview (hanya di filter Semua) ────────────────────────
        if (_selectedFilter == 0) ...[
          _podcastPreviewSection(),
          const SizedBox(height: 28),
        ],

        // ── Direkomendasikan ───────────────────────────────────────────────
        _sectionHeader('Direkomendasikan'),
        _recommendedList(),
        const SizedBox(height: 8),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HERO HEADER + BANNER
  // ══════════════════════════════════════════════════════════════════════════
  Widget _heroHeader() {
    final banner = _heroBanners[_heroIdx];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (banner['color'] as Color).withOpacity(0.9),
            AppColors.background,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 120, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Salam
          Text(
            _greeting,
            style: TextStyle(
                fontSize: 13, color: Colors.white.withOpacity(0.6)),
          ),
          const SizedBox(height: 2),
          const Text(
            'Selamat datang, Pengguna!',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white),
          ),
          const SizedBox(height: 20),

          // Banner kartu lagu pilihan
          FadeTransition(
            opacity: _heroBannerAnim,
            child: GestureDetector(
              onTap: () => _openPlayer(
                banner['title'] as String,
                banner['artist'] as String,
                banner['color'] as Color,
                banner['imageUrl'] as String,
              ),
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: (banner['color'] as Color).withOpacity(0.5),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gambar background
                      Image.network(
                        banner['imageUrl'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: banner['color'] as Color,
                        ),
                      ),
                      // Gradient gelap kiri
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.65],
                          ),
                        ),
                      ),
                      // Konten teks
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.85),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                banner['label'] as String,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              banner['title'] as String,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              banner['artist'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _heroBannerPlayBtn(banner),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color:
                                            Colors.white.withOpacity(0.2)),
                                  ),
                                  child: const Text(
                                    '+ Simpan',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Indikator dot
                      Positioned(
                        top: 14,
                        right: 14,
                        child: Row(
                          children: List.generate(
                            _heroBanners.length,
                            (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(left: 4),
                              width: i == _heroIdx ? 16 : 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: i == _heroIdx
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroBannerPlayBtn(Map<String, dynamic> banner) {
    return GestureDetector(
      onTap: () => _openPlayer(
        banner['title'] as String,
        banner['artist'] as String,
        banner['color'] as Color,
        banner['imageUrl'] as String,
      ),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow_rounded,
                color: banner['color'] as Color, size: 18),
            const SizedBox(width: 4),
            Text(
              'Putar',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: banner['color'] as Color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUICK FILTERS
  // ══════════════════════════════════════════════════════════════════════════
  Widget _quickFilters() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final isSelected = _selectedFilter == i;
          return GestureDetector(
            onTap: () {
              if (i == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PodcastPage()),
                );
                return;
              }
              setState(() => _selectedFilter = i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (i == 2)
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.podcasts_rounded,
                        size: 14,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  Text(
                    _filters[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
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

  // ══════════════════════════════════════════════════════════════════════════
  // BARU DIRILIS SECTION
  // ══════════════════════════════════════════════════════════════════════════
  Widget _newReleasesSection() {
    return SizedBox(
      height: 195,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _newReleases.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final item = _newReleases[i];
          return GestureDetector(
            onTap: () => _openPlayer(
              item['title'] as String,
              item['artist'] as String,
              item['color'] as Color,
              item['imageUrl'] as String,
            ),
            child: SizedBox(
              width: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item['imageUrl'] as String,
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 140,
                            height: 140,
                            color: item['color'] as Color,
                            child: const Icon(Icons.music_note_rounded,
                                color: Colors.white38, size: 36),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'BARU',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
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

  // ══════════════════════════════════════════════════════════════════════════
  // MOOD & AKTIVITAS GRID
  // ══════════════════════════════════════════════════════════════════════════
  Widget _moodGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.1,
        ),
        itemCount: _moods.length,
        itemBuilder: (_, i) {
          final mood = _moods[i];
          return GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: (mood['color'] as Color).withOpacity(0.18),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: (mood['color'] as Color).withOpacity(0.3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: (mood['color'] as Color).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      mood['icon'] as IconData,
                      color: mood['color'] as Color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mood['label'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    mood['count'] as String,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ARTIS TERPOPULER SECTION
  // ══════════════════════════════════════════════════════════════════════════
  Widget _artistsSection() {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _artists.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (_, i) {
          final artist = _artists[i];
          return GestureDetector(
            onTap: () {},
            child: SizedBox(
              width: 70,
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (artist['color'] as Color).withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        artist['imageUrl'] as String,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: artist['color'] as Color,
                          child: const Icon(Icons.person_rounded,
                              color: Colors.white38, size: 30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    artist['name'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    artist['followers'] as String,
                    style: const TextStyle(
                        fontSize: 9, color: AppColors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PODCAST PREVIEW SECTION
  // ══════════════════════════════════════════════════════════════════════════
  Widget _podcastPreviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.podcasts_rounded,
                      color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Podcast Pilihan',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PodcastPage()),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Lihat semua',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: _podcastPreview.map((ep) {
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PodcastPage()),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          ep['imageUrl'] as String,
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 54,
                            height: 54,
                            color: ep['color'] as Color,
                            child: const Icon(Icons.podcasts_rounded,
                                color: Colors.white38, size: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ep['title'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(Icons.person_outline_rounded,
                                    size: 11, color: AppColors.textMuted),
                                const SizedBox(width: 3),
                                Text(ep['host'] as String,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textMuted)),
                                const SizedBox(width: 10),
                                const Icon(Icons.schedule_rounded,
                                    size: 11, color: AppColors.textMuted),
                                const SizedBox(width: 3),
                                Text(ep['dur'] as String,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textMuted)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow_rounded,
                            color: AppColors.textSecondary, size: 20),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FLOATING MINI PLAYER
  // ══════════════════════════════════════════════════════════════════════════
  Widget _miniPlayer() {
    final song = _nowPlaying!;
    return GestureDetector(
      onTap: () =>
          _openPlayer(song.title, song.artist, song.color, song.imageUrl),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Row(
                  children: [
                    // Album art dengan pulse animation
                    AnimatedBuilder(
                      animation: _miniPulseAnim,
                      builder: (_, child) => Transform.scale(
                        scale: _isPlaying ? _miniPulseAnim.value : 1.0,
                        child: child,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: song.imageUrl.isNotEmpty
                            ? Image.network(
                                song.imageUrl,
                                width: 46,
                                height: 46,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _miniArtFallback(song),
                              )
                            : _miniArtFallback(song),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Song info
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
                        GestureDetector(
                          onTap: () =>
                              setState(() => _miniProgress = 0),
                          child: const Icon(
                            Icons.skip_previous_rounded,
                            color: AppColors.textSecondary,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 6),
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
                                  color:
                                      AppColors.primary.withOpacity(0.4),
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
                        GestureDetector(
                          onTap: () {
                            final songs = [
                              ..._charts.map((c) => {
                                    'title': c['title']!,
                                    'artist': c['artist']!,
                                    'color': AppColors.primary,
                                    'imageUrl': c['imageUrl']!,
                                  }),
                              ..._recommended,
                            ];
                            final idx = songs.indexWhere(
                                (s) => s['title'] == song.title);
                            final next =
                                songs[(idx + 1) % songs.length];
                            _playSong(
                              title: next['title'] as String,
                              artist: next['artist'] as String,
                              color: (next['color'] as Color?) ??
                                  AppColors.primary,
                              imageUrl:
                                  next['imageUrl'] as String? ?? '',
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

              // Progress bar
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
                              Container(
                                height: 3,
                                color: Colors.white.withOpacity(0.1),
                              ),
                              FractionallySizedBox(
                                widthFactor: _miniProgress,
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 300),
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

  Widget _miniArtFallback(NowPlaying song) {
    return Container(
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
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HOME CONTENT WIDGETS
  // ══════════════════════════════════════════════════════════════════════════

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
                color: Colors.white),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Lihat semua',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600),
                ),
              ),
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
              title: item['title'] as String,
              artist: 'Berbagai Artis',
              color: item['color'] as Color,
              imageUrl: item['imageUrl'] as String,
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
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Image.network(
                          item['imageUrl'] as String,
                          width: 56,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 56,
                            color: Colors.black.withOpacity(0.3),
                            child: Icon(
                              isActive
                                  ? Icons.equalizer_rounded
                                  : Icons.music_note,
                              color: isActive
                                  ? AppColors.primary
                                  : Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        if (isActive)
                          Container(
                            width: 56,
                            color: Colors.black.withOpacity(0.45),
                            child: const Icon(
                              Icons.equalizer_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                      ],
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
              item['title'] as String,
              'Berbagai Artis',
              item['color'] as Color,
              item['imageUrl'] as String,
            ),
            child: SizedBox(
              width: 155,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            item['imageUrl'] as String,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: item['color'] as Color,
                              child: Icon(
                                isActive
                                    ? Icons.equalizer_rounded
                                    : Icons.music_note,
                                color: isActive
                                    ? AppColors.primary
                                    : Colors.white38,
                                size: 36,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (isActive)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppColors.primary, width: 2),
                              ),
                            ),
                          if (isActive)
                            const Center(
                              child: Icon(
                                Icons.equalizer_rounded,
                                color: AppColors.primary,
                                size: 32,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['sub'] as String? ?? '',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textMuted),
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
              c['imageUrl']!,
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
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        Image.network(
                          c['imageUrl']!,
                          width: 46,
                          height: 46,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 46,
                            height: 46,
                            color: AppColors.surfaceVariant,
                            child: Icon(
                              isActive
                                  ? Icons.equalizer_rounded
                                  : Icons.music_note,
                              color: isActive
                                  ? AppColors.primary
                                  : AppColors.textMuted,
                              size: 22,
                            ),
                          ),
                        ),
                        if (isActive)
                          Container(
                            width: 46,
                            height: 46,
                            color: Colors.black.withOpacity(0.4),
                            child: const Icon(
                              Icons.equalizer_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c['title']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.55)),
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

  // Widget _premiumBanner() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     child: GestureDetector(
  //       onTap: () => Navigator.of(context).pushNamed(AppRoutes.subscription),
  //       child: Container(
  //         padding: const EdgeInsets.all(20),
  //         decoration: BoxDecoration(
  //           gradient: AppColors.primaryGradient,
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const Text(
  //                     'Upgrade ke Premium',
  //                     style: TextStyle(
  //                         fontSize: 17,
  //                         fontWeight: FontWeight.w800,
  //                         color: Colors.white),
  //                   ),
  //                   const SizedBox(height: 6),
  //                   Text(
  //                     'Nikmati musik tanpa iklan & unduh untuk offline',
  //                     style: TextStyle(
  //                         fontSize: 12,
  //                         color: Colors.white.withOpacity(0.8)),
  //                   ),
  //                   const SizedBox(height: 14),
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(
  //                         horizontal: 18, vertical: 8),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(20),
  //                     ),
  //                     child: const Text(
  //                       'Coba Gratis',
  //                       style: TextStyle(
  //                           fontSize: 13,
  //                           fontWeight: FontWeight.w700,
  //                           color: AppColors.primaryDark),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(width: 16),
  //             const Icon(Icons.workspace_premium,
  //                 color: Colors.white, size: 60),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
              song['imageUrl'] as String,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        Image.network(
                          song['imageUrl'] as String,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 48,
                            height: 48,
                            color: song['color'] as Color,
                            child: Icon(
                              isActive
                                  ? Icons.equalizer_rounded
                                  : Icons.music_note,
                              color: isActive
                                  ? AppColors.primary
                                  : Colors.white38,
                              size: 24,
                            ),
                          ),
                        ),
                        if (isActive)
                          Container(
                            width: 48,
                            height: 48,
                            color: Colors.black.withOpacity(0.4),
                            child: const Icon(
                              Icons.equalizer_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                      ],
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
