import 'package:flutter/material.dart';
import 'package:musik/features/player/player_page.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Model episode podcast
// ─────────────────────────────────────────────────────────────────────────────
class PodcastEpisode {
  final String title;
  final String host;
  final Color color;
  final String imageUrl;
  PodcastEpisode({
    required this.title,
    required this.host,
    required this.color,
    required this.imageUrl,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// PodcastPage
// ─────────────────────────────────────────────────────────────────────────────
class PodcastPage extends StatefulWidget {
  const PodcastPage({super.key});

  @override
  State<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage>
    with TickerProviderStateMixin {
  final ScrollController _scrollCtrl = ScrollController();
  double _appBarOpacity = 0;

  // ── Filter topik ──────────────────────────────────────────────────────────
  int _selectedTopic = 0;
  final List<String> _topics = [
    'Semua',
    'Berita',
    'Bisnis',
    'Kesehatan',
    'Teknologi',
    'Hiburan',
    'Edukasi',
  ];

  // ── Now playing state ─────────────────────────────────────────────────────
  PodcastEpisode? _nowPlaying;
  bool _isPlaying = false;
  double _miniProgress = 0.0;

  late AnimationController _miniSlideCtrl;
  late Animation<Offset> _miniSlideAnim;
  late AnimationController _miniPulseCtrl;
  late Animation<double> _miniPulseAnim;

  // ── Data: featured podcast ────────────────────────────────────────────────
  final List<Map<String, dynamic>> _featuredPodcasts = [
    {
      'title': 'Filosofi Kopi',
      'host': 'Podcast Host',
      'description':
          'Obrolan santai tentang kopi, budaya, dan cara pandang hidup sehari-hari.',
      'episodes': 48,
      'topic': 'Hiburan',
      'color': const Color(0xFF3A2A1A),
      'imageUrl': 'https://picsum.photos/seed/filosofikopi/300/300',
    },
    {
      'title': 'Makna Talks',
      'host': 'Najwa Shihab',
      'description':
          'Percakapan mendalam dengan tokoh-tokoh berpengaruh di Indonesia.',
      'episodes': 120,
      'topic': 'Berita',
      'color': const Color(0xFF1A2A3A),
      'imageUrl': 'https://picsum.photos/seed/maknatalks/300/300',
    },
    {
      'title': 'Tech Talk ID',
      'host': 'Dev Community',
      'description':
          'Diskusi teknologi, startup, dan inovasi bersama para profesional.',
      'episodes': 65,
      'topic': 'Teknologi',
      'color': const Color(0xFF2A1A3A),
      'imageUrl': 'https://picsum.photos/seed/techtalkid/300/300',
    },
  ];

  // ── Data: episode terbaru ─────────────────────────────────────────────────
  final List<Map<String, dynamic>> _latestEpisodes = [
    {
      'title': 'Eps. 48 – Filosofi Kopi',
      'host': 'Podcast Host',
      'show': 'Filosofi Kopi',
      'dur': '42:10',
      'topic': 'Hiburan',
      'isNew': true,
      'color': const Color(0xFF3A2A1A),
      'imageUrl': 'https://picsum.photos/seed/filosofikopi/200/200',
    },
    {
      'title': 'Eps. 120 – Keberanian Bersuara',
      'host': 'Najwa Shihab',
      'show': 'Makna Talks',
      'dur': '55:30',
      'topic': 'Berita',
      'isNew': true,
      'color': const Color(0xFF1A2A3A),
      'imageUrl': 'https://picsum.photos/seed/maknatalks/200/200',
    },
    {
      'title': 'Eps. 22 – Tentang Kesehatan Mental',
      'host': 'Tim Medis',
      'show': 'Ini Kata Dokter',
      'dur': '38:00',
      'topic': 'Kesehatan',
      'isNew': false,
      'color': const Color(0xFF1A3A2A),
      'imageUrl': 'https://picsum.photos/seed/inikatadr/200/200',
    },
    {
      'title': 'Eps. 65 – AI di Indonesia',
      'host': 'Dev Community',
      'show': 'Tech Talk ID',
      'dur': '1:02:15',
      'topic': 'Teknologi',
      'isNew': true,
      'color': const Color(0xFF2A1A3A),
      'imageUrl': 'https://picsum.photos/seed/techtalkid/200/200',
    },
    {
      'title': 'Eps. 30 – Skalakan Bisnismu',
      'host': 'StartUp Talks',
      'show': 'Bisnis Muda',
      'dur': '48:20',
      'topic': 'Bisnis',
      'isNew': false,
      'color': const Color(0xFF3A1A1A),
      'imageUrl': 'https://picsum.photos/seed/bisnismuda/200/200',
    },
    {
      'title': 'Eps. 15 – Belajar Sepanjang Hayat',
      'host': 'Edu Talks',
      'show': 'Belajar Terus',
      'dur': '33:45',
      'topic': 'Edukasi',
      'isNew': false,
      'color': const Color(0xFF1A3A3A),
      'imageUrl': 'https://picsum.photos/seed/belajarterus/200/200',
    },
    {
      'title': 'Eps. 9 – Pola Hidup Sehat',
      'host': 'Dr. Fitri',
      'show': 'Sehat Itu Mudah',
      'dur': '27:55',
      'topic': 'Kesehatan',
      'isNew': true,
      'color': const Color(0xFF2A3A1A),
      'imageUrl': 'https://picsum.photos/seed/sehatinutmudah/200/200',
    },
    {
      'title': 'Eps. 88 – Tren Digital 2025',
      'host': 'Dev Community',
      'show': 'Tech Talk ID',
      'dur': '51:10',
      'topic': 'Teknologi',
      'isNew': false,
      'color': const Color(0xFF2A1A3A),
      'imageUrl': 'https://picsum.photos/seed/trendigital/200/200',
    },
  ];

  // ── Data: podcast populer (horizontal scroll) ─────────────────────────────
  final List<Map<String, dynamic>> _popularShows = [
    {
      'title': 'Makna Talks',
      'host': 'Najwa Shihab',
      'episodes': '120 eps',
      'topic': 'Berita',
      'color': const Color(0xFF1A2A3A),
      'imageUrl': 'https://picsum.photos/seed/maknatalks/200/200',
    },
    {
      'title': 'Bisnis Muda',
      'host': 'StartUp Talks',
      'episodes': '52 eps',
      'topic': 'Bisnis',
      'color': const Color(0xFF3A1A1A),
      'imageUrl': 'https://picsum.photos/seed/bisnismuda/200/200',
    },
    {
      'title': 'Ini Kata Dokter',
      'host': 'Tim Medis',
      'episodes': '38 eps',
      'topic': 'Kesehatan',
      'color': const Color(0xFF1A3A2A),
      'imageUrl': 'https://picsum.photos/seed/inikatadr/200/200',
    },
    {
      'title': 'Belajar Terus',
      'host': 'Edu Talks',
      'episodes': '24 eps',
      'topic': 'Edukasi',
      'color': const Color(0xFF1A3A3A),
      'imageUrl': 'https://picsum.photos/seed/belajarterus/200/200',
    },
    {
      'title': 'Filosofi Kopi',
      'host': 'Podcast Host',
      'episodes': '48 eps',
      'topic': 'Hiburan',
      'color': const Color(0xFF3A2A1A),
      'imageUrl': 'https://picsum.photos/seed/filosofikopi/200/200',
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
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _miniSlideCtrl.dispose();
    _miniPulseCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  void _playEpisode({
    required String title,
    required String host,
    Color color = AppColors.primary,
    String imageUrl = '',
  }) {
    final isNew = _nowPlaying?.title != title;
    setState(() {
      _nowPlaying = PodcastEpisode(
        title: title,
        host: host,
        color: color,
        imageUrl: imageUrl,
      );
      _isPlaying = true;
      if (isNew) _miniProgress = 0.0;
    });
    if (isNew) _miniSlideCtrl.forward(from: 0);
  }

  void _openEpisodePlayer(
  String title,
  String host,
  Color color,
  String imageUrl,
) {
  _playEpisode(
    title: title,
    host: host,
    color: color,
    imageUrl: imageUrl,
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PlayerPage(
        title: title,
        artist: host,
        color: color,
        imageUrl: imageUrl,
      ),
    ),
  );
}

  List<Map<String, dynamic>> get _filteredEpisodes {
    if (_selectedTopic == 0) return _latestEpisodes;
    final topic = _topics[_selectedTopic];
    return _latestEpisodes.where((e) => e['topic'] == topic).toList();
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
            'Podcast',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {},
            tooltip: 'Cari Podcast',
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
              // ── Header ────────────────────────────────────────────────────
              _buildHeader(),
              const SizedBox(height: 8),

              // ── Filter topik ──────────────────────────────────────────────
              _buildTopicFilter(),
              const SizedBox(height: 16),

              // ── Show Populer ──────────────────────────────────────────────
              _sectionHeader('Show Populer'),
              _buildPopularShows(),
              const SizedBox(height: 28),

              // ── Episode Terbaru ───────────────────────────────────────────
              _sectionHeader('Episode Terbaru'),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: _buildEpisodeList(
                  key: ValueKey(_selectedTopic),
                  items: _filteredEpisodes,
                ),
              ),
              const SizedBox(height: 28),

              // ── Sorotan Podcast ───────────────────────────────────────────
              _sectionHeader('Sorotan Podcast'),
              _buildFeaturedPodcastCards(),
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
      height: 240,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0A1A2A),
            Color(0xFF102040),
            AppColors.background,
          ],
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
              const Icon(Icons.podcasts_rounded,
                  color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              const Text(
                'PODCAST',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Dengarkan & Jelajahi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_latestEpisodes.length} episode tersedia',
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
  // TOPIC FILTER
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildTopicFilter() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _topics.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final isSelected = _selectedTopic == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedTopic = i),
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
                  if (i == 0)
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.podcasts_rounded,
                        size: 13,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  Text(
                    _topics[i],
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
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // POPULAR SHOWS (horizontal scroll)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildPopularShows() {
    return SizedBox(
      height: 165,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _popularShows.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final item = _popularShows[i];
          return GestureDetector(
            onTap: () => _playEpisode(
              title: item['title'] as String,
              host: item['host'] as String,
              color: item['color'] as Color,
              imageUrl: item['imageUrl'] as String,
            ),
            child: SizedBox(
              width: 120,
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
                                Icons.podcasts_rounded,
                                color: Colors.white38,
                                size: 32,
                              ),
                            ),
                          ),
                          // Topic badge
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item['topic'] as String,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
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
                    item['episodes'] as String,
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

  // ─────────────────────────────────────────────────────────────────────────
  // EPISODE LIST
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildEpisodeList({
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
              Icon(Icons.podcasts_rounded,
                  color: AppColors.textMuted, size: 42),
              const SizedBox(height: 12),
              const Text(
                'Tidak ada podcast di topik ini',
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
        children: items.map((episode) {
          final isActive = _nowPlaying?.title == episode['title'];
          final isNew = episode['isNew'] as bool;

          return GestureDetector(
            onTap: () => _openEpisodePlayer(
              episode['title'] as String,
              episode['host'] as String,
              episode['color'] as Color,
              episode['imageUrl'] as String,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withOpacity(0.08)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: isActive
                    ? Border.all(
                        color: AppColors.primary.withOpacity(0.4))
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
                          episode['imageUrl'] as String,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 60,
                            height: 60,
                            color: episode['color'] as Color,
                            child: const Icon(
                              Icons.podcasts_rounded,
                              color: Colors.white38,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                      // NEW badge
                      if (isNew)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'BARU',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      // Playing overlay
                      if (isActive)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.black.withOpacity(0.4),
                              child: const Center(
                                child: Icon(
                                  Icons.equalizer_rounded,
                                  color: AppColors.primary,
                                  size: 22,
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
                        // Show name
                        Text(
                          episode['show'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary.withOpacity(0.9),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 3),
                        // Episode title
                        Text(
                          episode['title'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Host + duration
                        Row(
                          children: [
                            const Icon(Icons.person_outline_rounded,
                                size: 11,
                                color: AppColors.textMuted),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                episode['host'] as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.schedule_rounded,
                                size: 11,
                                color: AppColors.textMuted),
                            const SizedBox(width: 3),
                            Text(
                              episode['dur'] as String,
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

                  const SizedBox(width: 8),

                  // Play/Pause icon
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.surfaceVariant,
                      shape: BoxShape.circle,
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.35),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(
                      isActive && _isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: isActive
                          ? Colors.white
                          : AppColors.textSecondary,
                      size: 20,
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
  // FEATURED PODCAST CARDS
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildFeaturedPodcastCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: _featuredPodcasts.map((podcast) {
          return GestureDetector(
            onTap: () => _playEpisode(
              title: podcast['title'] as String,
              host: podcast['host'] as String,
              color: podcast['color'] as Color,
              imageUrl: podcast['imageUrl'] as String,
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image
                    Image.network(
                      podcast['imageUrl'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: podcast['color'] as Color,
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.85),
                          ],
                        ),
                      ),
                    ),
                    // Konten
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primary.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: AppColors.primary
                                          .withOpacity(0.4),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Text(
                                    podcast['topic'] as String,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  podcast['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  podcast['description'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.65),
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withOpacity(0.45),
                                      blurRadius: 12,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${podcast['episodes']} eps',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FLOATING MINI PLAYER
  // ══════════════════════════════════════════════════════════════════════════
  Widget _miniPlayer() {
    final ep = _nowPlaying!;
    return GestureDetector(
      onTap: () =>
          _openEpisodePlayer(ep.title, ep.host, ep.color, ep.imageUrl),
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
              color: ep.color.withOpacity(0.15),
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
                    // Artwork dengan pulse
                    AnimatedBuilder(
                      animation: _miniPulseAnim,
                      builder: (_, child) => Transform.scale(
                        scale: _isPlaying ? _miniPulseAnim.value : 1.0,
                        child: child,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ep.imageUrl.isNotEmpty
                            ? Image.network(
                                ep.imageUrl,
                                width: 46,
                                height: 46,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _miniArtFallback(ep),
                              )
                            : _miniArtFallback(ep),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Info episode
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
                          key: ValueKey(ep.title),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ep.title,
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
                              ep.host,
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

                    // Controls: rewind 15s, play/pause, forward 15s
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() {
                            _miniProgress =
                                (_miniProgress - 0.05).clamp(0.0, 1.0);
                          }),
                          child: const Icon(
                            Icons.replay_10_rounded,
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
                        GestureDetector(
                          onTap: () => setState(() {
                            _miniProgress =
                                (_miniProgress + 0.05).clamp(0.0, 1.0);
                          }),
                          child: const Icon(
                            Icons.forward_10_rounded,
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
                            duration: const Duration(milliseconds: 300),
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [ep.color, AppColors.primary],
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
      ),
    );
  }

  Widget _miniArtFallback(PodcastEpisode ep) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: ep.color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: _isPlaying
            ? [
                BoxShadow(
                  color: ep.color.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: const Icon(
        Icons.podcasts_rounded,
        color: Colors.white38,
        size: 22,
      ),
    );
  }
}
