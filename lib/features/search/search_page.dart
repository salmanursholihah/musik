import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _isSearching = false;
  String _query = '';
  String? _activeCategory; // kategori yang sedang dibuka

  late AnimationController _listAnimCtrl;

  // ── Kategori ──────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _categories = [
    {'label': 'Pop',        'icon': Icons.auto_awesome_rounded,      'color': Color(0xFF1DB8E8)},
    {'label': 'Rock',       'icon': Icons.electric_bolt_rounded,     'color': Color(0xFFE84040)},
    {'label': 'Hip-Hop',    'icon': Icons.mic_rounded,               'color': Color(0xFF6C4FD6)},
    {'label': 'Dangdut',    'icon': Icons.music_video_rounded,        'color': Color(0xFFE8891D)},
    {'label': 'Jazz',       'icon': Icons.piano_rounded,             'color': Color(0xFF2A7D5F)},
    {'label': 'Electronic', 'icon': Icons.equalizer_rounded,         'color': Color(0xFF4F8FD6)},
    {'label': 'R&B',        'icon': Icons.favorite_rounded,          'color': Color(0xFFD64F8F)},
    {'label': 'Indie',      'icon': Icons.emoji_nature_rounded,      'color': Color(0xFF8FD64F)},
    {'label': 'Klasik',     'icon': Icons.queue_music_rounded,       'color': Color(0xFFD6C84F)},
    {'label': 'K-Pop',      'icon': Icons.star_rounded,              'color': Color(0xFFD64F4F)},
    {'label': 'Relaksasi',  'icon': Icons.self_improvement_rounded,  'color': Color(0xFF4FD6C8)},
    {'label': 'Podcast',    'icon': Icons.podcasts_rounded,          'color': Color(0xFF8F4FD6)},
  ];

  // ── Lagu per kategori ─────────────────────────────────────────────────────
  final Map<String, List<Map<String, String>>> _songsByCategory = {
    'Pop': [
      {'title': 'Hati-Hati di Jalan',  'artist': 'Tulus',        'dur': '4:28'},
      {'title': 'Belahan Jiwa',         'artist': 'Yura Yunita',  'dur': '3:58'},
      {'title': 'Aku Bisa',             'artist': 'Pamungkas',    'dur': '3:30'},
      {'title': 'Melepasmu',            'artist': 'Armada',       'dur': '3:45'},
      {'title': 'Hingga Ujung Waktu',   'artist': 'BCL',          'dur': '4:05'},
      {'title': 'Cinta Luar Biasa',     'artist': 'Andmesh',      'dur': '4:12'},
    ],
    'Rock': [
      {'title': 'Separuh Aku',          'artist': 'Noah',         'dur': '3:52'},
      {'title': 'Kasih Tak Sampai',     'artist': 'Padi',         'dur': '4:22'},
      {'title': 'Cobalah Mengerti',     'artist': 'Padi',         'dur': '4:01'},
      {'title': 'Sempurna',             'artist': 'Andra & BB',   'dur': '4:15'},
      {'title': 'Kau Adalah',           'artist': 'Isyana & Raisa','dur': '3:50'},
      {'title': 'Demi Waktu',           'artist': 'Ungu',         'dur': '4:38'},
    ],
    'Hip-Hop': [
      {'title': 'Zona Nyaman',          'artist': 'Fourtwnty',    'dur': '3:44'},
      {'title': 'Mangu',                'artist': 'Fourtwnty',    'dur': '3:22'},
      {'title': 'Akad',                 'artist': 'Payung Teduh', 'dur': '4:47'},
      {'title': 'Pamer Bojo',           'artist': 'Didi Kempot',  'dur': '3:55'},
      {'title': 'Stecu Stecu',          'artist': 'Faris Adam',   'dur': '2:55'},
      {'title': 'Bojo Galak',           'artist': 'Pendhoza',     'dur': '3:28'},
    ],
    'Dangdut': [
      {'title': 'Cinta Satu Malam',     'artist': 'Melinda',      'dur': '4:10'},
      {'title': 'Cidro',                'artist': 'Didi Kempot',  'dur': '3:40'},
      {'title': 'Kalung Emas',          'artist': 'Elvy Sukaesih','dur': '4:20'},
      {'title': 'Sakitnya Tuh Disini',  'artist': 'Cita Citata',  'dur': '3:55'},
      {'title': 'Bimbang',              'artist': 'Rhoma Irama',  'dur': '4:35'},
      {'title': 'Jangan Menangis Lagi', 'artist': 'Ikke Nurjanah','dur': '4:00'},
    ],
    'Jazz': [
      {'title': 'Langit Sore',          'artist': 'Payung Teduh', 'dur': '4:10'},
      {'title': 'Berdua Saja',          'artist': 'Payung Teduh', 'dur': '3:55'},
      {'title': 'Untuk Perempuan',      'artist': 'Payung Teduh', 'dur': '4:30'},
      {'title': 'Resah',                'artist': 'Payung Teduh', 'dur': '5:01'},
      {'title': 'Mari Beraksi',         'artist': 'Dee Lestari',  'dur': '3:48'},
      {'title': 'Melukis Senja',        'artist': 'Budi Doremi',  'dur': '4:12'},
    ],
    'Electronic': [
      {'title': 'Levitating',           'artist': 'Dua Lipa',     'dur': '3:24'},
      {'title': 'Blinding Lights',      'artist': 'The Weeknd',   'dur': '3:20'},
      {'title': 'As It Was',            'artist': 'Harry Styles', 'dur': '2:47'},
      {'title': 'Stay',                 'artist': 'Justin Bieber','dur': '2:21'},
      {'title': 'Heat Waves',           'artist': 'Glass Animals','dur': '3:59'},
      {'title': 'Peaches',              'artist': 'Justin Bieber','dur': '3:18'},
    ],
    'R&B': [
      {'title': 'Runtuh',               'artist': 'Feby Putri',   'dur': '4:01'},
      {'title': 'Berdua',               'artist': 'Raisa',        'dur': '3:55'},
      {'title': 'Usai',                 'artist': 'Isyana Sarasvati','dur': '3:47'},
      {'title': 'Jatuh Hati',           'artist': 'Raisa',        'dur': '4:20'},
      {'title': 'Could It Be',          'artist': 'Isyana',       'dur': '3:35'},
      {'title': 'Ingin',                'artist': 'GAC',          'dur': '3:50'},
    ],
    'Indie': [
      {'title': 'Pelangi',              'artist': 'Juicy Luicy',  'dur': '3:38'},
      {'title': 'Sial',                 'artist': 'Mahalini',     'dur': '3:45'},
      {'title': 'Terlalu Lama Sendiri', 'artist': 'Kunto Aji',    'dur': '4:15'},
      {'title': 'Bunga',                'artist': 'Reality Club', 'dur': '3:55'},
      {'title': 'Sunset di Tanah Anarki','artist': 'Superman Is Dead','dur': '4:05'},
      {'title': 'Harusnya Aku',         'artist': 'Armada',       'dur': '3:52'},
    ],
    'Klasik': [
      {'title': 'Syair Rindu',          'artist': 'Chrisye',      'dur': '4:30'},
      {'title': 'Badai Pasti Berlalu',  'artist': 'Chrisye',      'dur': '5:10'},
      {'title': 'Kisah Kasih di Sekolah','artist': 'Chrisye',     'dur': '3:55'},
      {'title': 'Cinta',                'artist': 'Ebiet G. Ade', 'dur': '4:45'},
      {'title': 'Camelia',              'artist': 'Ebiet G. Ade', 'dur': '4:20'},
      {'title': 'Titip Rindu Buat Ayah','artist': 'Ebiet G. Ade', 'dur': '4:35'},
    ],
    'K-Pop': [
      {'title': 'Dynamite',             'artist': 'BTS',          'dur': '3:19'},
      {'title': 'Butter',               'artist': 'BTS',          'dur': '2:44'},
      {'title': 'How You Like That',    'artist': 'BLACKPINK',    'dur': '3:03'},
      {'title': 'Love Shot',            'artist': 'EXO',          'dur': '3:26'},
      {'title': 'Fancy',                'artist': 'TWICE',        'dur': '3:35'},
      {'title': 'ELEVEN',               'artist': 'IVE',          'dur': '2:58'},
    ],
    'Relaksasi': [
      {'title': 'Hujan di Bulan Juni',  'artist': 'Armand Maulana','dur': '5:02'},
      {'title': 'Sayap Pelindungmu',    'artist': 'Ungu',         'dur': '4:55'},
      {'title': 'Menghapus Jejakmu',    'artist': 'Peterpan',     'dur': '4:33'},
      {'title': 'Tinggal Kenangan',     'artist': 'Exists',       'dur': '4:45'},
      {'title': 'Tak Ingin Sendiri',    'artist': 'Yuni Shara',   'dur': '4:10'},
      {'title': 'Bidadari Kesepian',    'artist': 'Sheila On 7',  'dur': '4:25'},
    ],
    'Podcast': [
      {'title': 'Makna Kehidupan',      'artist': 'Podcast Deddy M','dur': '42:30'},
      {'title': 'Dunia Startup',        'artist': 'Tech Talk ID',  'dur': '55:10'},
      {'title': 'Nugas Bareng Kak Sal', 'artist': 'Sal Priadi',    'dur': '38:00'},
      {'title': 'Filosofi Teras',       'artist': 'Henry Manampiring','dur': '60:00'},
      {'title': 'Thirty Days',          'artist': 'Soleh Solihun', 'dur': '45:20'},
      {'title': 'Cerita Kuliner',       'artist': 'Bondan Winarno','dur': '50:00'},
    ],
  };

  // ── Semua lagu untuk search ────────────────────────────────────────────────
  List<Map<String, String>> get _allSongs {
    final all = <Map<String, String>>[];
    for (final songs in _songsByCategory.values) {
      all.addAll(songs);
    }
    return all;
  }

  List<Map<String, String>> get _filtered {
    if (_query.isEmpty) return _allSongs;
    return _allSongs
        .where((s) =>
            s['title']!.toLowerCase().contains(_query.toLowerCase()) ||
            s['artist']!.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _listAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..forward();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _listAnimCtrl.dispose();
    super.dispose();
  }

  // ── Buka bottom sheet daftar lagu per kategori ────────────────────────────
  void _showCategorySheet(Map<String, dynamic> category) {
    final label = category['label'] as String;
    final color = category['color'] as Color;
    final songs = _songsByCategory[label] ?? [];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.45,
        maxChildSize: 0.94,
        expand: false,
        builder: (_, scrollCtrl) => Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Column(
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
                  const SizedBox(height: 18),

                  // Category banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: color.withOpacity(0.35),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            category['icon'] as IconData,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                label,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${songs.length} lagu populer',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.55),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            if (songs.isNotEmpty) {
                              final first = songs.first;
                              Navigator.of(context).pushNamed(
                                AppRoutes.player,
                                arguments: {
                                  'title': first['title'],
                                  'artist': first['artist'],
                                },
                              );
                            }
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.4),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Daftar Lagu',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.55),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // ── Song list ────────────────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                itemCount: songs.length,
                itemBuilder: (_, i) {
                  final song = songs[i];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 200 + i * 60),
                    curve: Curves.easeOut,
                    builder: (_, v, child) => Opacity(
                      opacity: v,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - v)),
                        child: child,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(
                          AppRoutes.player,
                          arguments: {
                            'title': song['title'],
                            'artist': song['artist'],
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // Track number
                            SizedBox(
                              width: 24,
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: color.withOpacity(0.8),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Thumbnail
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                category['icon'] as IconData,
                                color: color,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    song['title']!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    song['artist']!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Duration
                            Text(
                              song['dur']!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(width: 8),

                            // More
                            const Icon(
                              Icons.more_vert,
                              color: AppColors.textMuted,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: const Text(
                'Cari',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ── Search bar ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: _isSearching
                        ? AppColors.primary
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(
                      Icons.search,
                      color: _isSearching
                          ? AppColors.primary
                          : AppColors.textMuted,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Lagu, artis, atau podcast',
                          hintStyle: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (v) => setState(() => _query = v),
                        onTap: () => setState(() => _isSearching = true),
                        onSubmitted: (_) => setState(() => _isSearching = false),
                      ),
                    ),
                    if (_searchCtrl.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchCtrl.clear();
                          setState(() {
                            _query = '';
                            _isSearching = false;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.close,
                            color: AppColors.textMuted,
                            size: 18,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Content ──────────────────────────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: _query.isNotEmpty
                    ? _searchResults()
                    : _browseCategories(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Grid kategori ─────────────────────────────────────────────────────────
  Widget _browseCategories() {
    return SingleChildScrollView(
      key: const ValueKey('browse'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jelajahi semua',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _categories.length,
            itemBuilder: (_, i) {
              final cat = _categories[i];
              final color = cat['color'] as Color;
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.7, end: 1.0),
                duration: Duration(milliseconds: 250 + i * 40),
                curve: Curves.easeOutBack,
                builder: (_, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: GestureDetector(
                  onTap: () => _showCategorySheet(cat),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Background icon (dekoratif, pojok kanan bawah)
                        Positioned(
                          right: -6,
                          bottom: -6,
                          child: Icon(
                            cat['icon'] as IconData,
                            size: 52,
                            color: Colors.black.withOpacity(0.12),
                          ),
                        ),

                        // Label + lagu count
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                cat['label'] as String,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${(_songsByCategory[cat['label']] ?? []).length} lagu',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.75),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Ripple visual — small play icon
                        Positioned(
                          right: 12,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Hasil pencarian ───────────────────────────────────────────────────────
  Widget _searchResults() {
    if (_filtered.isEmpty) {
      return Center(
        key: const ValueKey('empty'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, color: AppColors.textMuted, size: 56),
            const SizedBox(height: 16),
            Text(
              'Tidak ada hasil untuk "$_query"',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      key: const ValueKey('results'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filtered.length,
      itemBuilder: (_, i) {
        final song = _filtered[i];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 180 + i * 40),
          curve: Curves.easeOut,
          builder: (_, v, child) => Opacity(
            opacity: v,
            child: Transform.translate(
              offset: Offset(0, 16 * (1 - v)),
              child: child,
            ),
          ),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              AppRoutes.player,
              arguments: {
                'title': song['title'],
                'artist': song['artist'],
              },
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.music_note,
                      color: AppColors.textMuted,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song['title']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          song['artist']!,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    song['dur']!,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.more_vert,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
