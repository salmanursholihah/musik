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
  final FocusNode _focusNode = FocusNode();

  bool _isSearching = false;
  String _query = '';

  // ── Riwayat pencarian ──────────────────────────────────────────────────────
  final List<String> _searchHistory = [
    'Tulus',
    'Hati-Hati di Jalan',
    'Payung Teduh',
    'BTS Dynamite',
    'Chrisye',
  ];

  // ── Filter aktif ───────────────────────────────────────────────────────────
  // 0 = Semua, 1 = Lagu, 2 = Artis, 3 = Podcast, 4 = Kategori
  int _activeFilter = 0;
  final List<Map<String, dynamic>> _filterChips = [
    {'label': 'Semua',     'icon': Icons.apps_rounded},
    {'label': 'Lagu',      'icon': Icons.music_note_rounded},
    {'label': 'Artis',     'icon': Icons.person_rounded},
    {'label': 'Podcast',   'icon': Icons.podcasts_rounded},
    {'label': 'Kategori',  'icon': Icons.category_rounded},
  ];

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
      {'title': 'Hati-Hati di Jalan',  'artist': 'Tulus',        'dur': '4:28', 'type': 'lagu'},
      {'title': 'Belahan Jiwa',         'artist': 'Yura Yunita',  'dur': '3:58', 'type': 'lagu'},
      {'title': 'Aku Bisa',             'artist': 'Pamungkas',    'dur': '3:30', 'type': 'lagu'},
      {'title': 'Melepasmu',            'artist': 'Armada',       'dur': '3:45', 'type': 'lagu'},
      {'title': 'Hingga Ujung Waktu',   'artist': 'BCL',          'dur': '4:05', 'type': 'lagu'},
      {'title': 'Cinta Luar Biasa',     'artist': 'Andmesh',      'dur': '4:12', 'type': 'lagu'},
    ],
    'Rock': [
      {'title': 'Separuh Aku',          'artist': 'Noah',         'dur': '3:52', 'type': 'lagu'},
      {'title': 'Kasih Tak Sampai',     'artist': 'Padi',         'dur': '4:22', 'type': 'lagu'},
      {'title': 'Cobalah Mengerti',     'artist': 'Padi',         'dur': '4:01', 'type': 'lagu'},
      {'title': 'Sempurna',             'artist': 'Andra & BB',   'dur': '4:15', 'type': 'lagu'},
      {'title': 'Kau Adalah',           'artist': 'Isyana & Raisa','dur': '3:50','type': 'lagu'},
      {'title': 'Demi Waktu',           'artist': 'Ungu',         'dur': '4:38', 'type': 'lagu'},
    ],
    'Hip-Hop': [
      {'title': 'Zona Nyaman',          'artist': 'Fourtwnty',    'dur': '3:44', 'type': 'lagu'},
      {'title': 'Mangu',                'artist': 'Fourtwnty',    'dur': '3:22', 'type': 'lagu'},
      {'title': 'Akad',                 'artist': 'Payung Teduh', 'dur': '4:47', 'type': 'lagu'},
      {'title': 'Pamer Bojo',           'artist': 'Didi Kempot',  'dur': '3:55', 'type': 'lagu'},
      {'title': 'Stecu Stecu',          'artist': 'Faris Adam',   'dur': '2:55', 'type': 'lagu'},
      {'title': 'Bojo Galak',           'artist': 'Pendhoza',     'dur': '3:28', 'type': 'lagu'},
    ],
    'Dangdut': [
      {'title': 'Cinta Satu Malam',     'artist': 'Melinda',      'dur': '4:10', 'type': 'lagu'},
      {'title': 'Cidro',                'artist': 'Didi Kempot',  'dur': '3:40', 'type': 'lagu'},
      {'title': 'Kalung Emas',          'artist': 'Elvy Sukaesih','dur': '4:20', 'type': 'lagu'},
      {'title': 'Sakitnya Tuh Disini',  'artist': 'Cita Citata',  'dur': '3:55', 'type': 'lagu'},
      {'title': 'Bimbang',              'artist': 'Rhoma Irama',  'dur': '4:35', 'type': 'lagu'},
      {'title': 'Jangan Menangis Lagi', 'artist': 'Ikke Nurjanah','dur': '4:00', 'type': 'lagu'},
    ],
    'Jazz': [
      {'title': 'Langit Sore',          'artist': 'Payung Teduh', 'dur': '4:10', 'type': 'lagu'},
      {'title': 'Berdua Saja',          'artist': 'Payung Teduh', 'dur': '3:55', 'type': 'lagu'},
      {'title': 'Untuk Perempuan',      'artist': 'Payung Teduh', 'dur': '4:30', 'type': 'lagu'},
      {'title': 'Resah',                'artist': 'Payung Teduh', 'dur': '5:01', 'type': 'lagu'},
      {'title': 'Mari Beraksi',         'artist': 'Dee Lestari',  'dur': '3:48', 'type': 'lagu'},
      {'title': 'Melukis Senja',        'artist': 'Budi Doremi',  'dur': '4:12', 'type': 'lagu'},
    ],
    'Electronic': [
      {'title': 'Levitating',           'artist': 'Dua Lipa',     'dur': '3:24', 'type': 'lagu'},
      {'title': 'Blinding Lights',      'artist': 'The Weeknd',   'dur': '3:20', 'type': 'lagu'},
      {'title': 'As It Was',            'artist': 'Harry Styles', 'dur': '2:47', 'type': 'lagu'},
      {'title': 'Stay',                 'artist': 'Justin Bieber','dur': '2:21', 'type': 'lagu'},
      {'title': 'Heat Waves',           'artist': 'Glass Animals','dur': '3:59', 'type': 'lagu'},
      {'title': 'Peaches',              'artist': 'Justin Bieber','dur': '3:18', 'type': 'lagu'},
    ],
    'R&B': [
      {'title': 'Runtuh',               'artist': 'Feby Putri',   'dur': '4:01', 'type': 'lagu'},
      {'title': 'Berdua',               'artist': 'Raisa',        'dur': '3:55', 'type': 'lagu'},
      {'title': 'Usai',                 'artist': 'Isyana Sarasvati','dur': '3:47','type': 'lagu'},
      {'title': 'Jatuh Hati',           'artist': 'Raisa',        'dur': '4:20', 'type': 'lagu'},
      {'title': 'Could It Be',          'artist': 'Isyana',       'dur': '3:35', 'type': 'lagu'},
      {'title': 'Ingin',                'artist': 'GAC',          'dur': '3:50', 'type': 'lagu'},
    ],
    'Indie': [
      {'title': 'Pelangi',              'artist': 'Juicy Luicy',  'dur': '3:38', 'type': 'lagu'},
      {'title': 'Sial',                 'artist': 'Mahalini',     'dur': '3:45', 'type': 'lagu'},
      {'title': 'Terlalu Lama Sendiri', 'artist': 'Kunto Aji',    'dur': '4:15', 'type': 'lagu'},
      {'title': 'Bunga',                'artist': 'Reality Club', 'dur': '3:55', 'type': 'lagu'},
      {'title': 'Sunset di Tanah Anarki','artist': 'Superman Is Dead','dur': '4:05','type': 'lagu'},
      {'title': 'Harusnya Aku',         'artist': 'Armada',       'dur': '3:52', 'type': 'lagu'},
    ],
    'Klasik': [
      {'title': 'Syair Rindu',          'artist': 'Chrisye',      'dur': '4:30', 'type': 'lagu'},
      {'title': 'Badai Pasti Berlalu',  'artist': 'Chrisye',      'dur': '5:10', 'type': 'lagu'},
      {'title': 'Kisah Kasih di Sekolah','artist': 'Chrisye',     'dur': '3:55', 'type': 'lagu'},
      {'title': 'Cinta',                'artist': 'Ebiet G. Ade', 'dur': '4:45', 'type': 'lagu'},
      {'title': 'Camelia',              'artist': 'Ebiet G. Ade', 'dur': '4:20', 'type': 'lagu'},
      {'title': 'Titip Rindu Buat Ayah','artist': 'Ebiet G. Ade', 'dur': '4:35', 'type': 'lagu'},
    ],
    'K-Pop': [
      {'title': 'Dynamite',             'artist': 'BTS',          'dur': '3:19', 'type': 'lagu'},
      {'title': 'Butter',               'artist': 'BTS',          'dur': '2:44', 'type': 'lagu'},
      {'title': 'How You Like That',    'artist': 'BLACKPINK',    'dur': '3:03', 'type': 'lagu'},
      {'title': 'Love Shot',            'artist': 'EXO',          'dur': '3:26', 'type': 'lagu'},
      {'title': 'Fancy',                'artist': 'TWICE',        'dur': '3:35', 'type': 'lagu'},
      {'title': 'ELEVEN',               'artist': 'IVE',          'dur': '2:58', 'type': 'lagu'},
    ],
    'Relaksasi': [
      {'title': 'Hujan di Bulan Juni',  'artist': 'Armand Maulana','dur': '5:02','type': 'lagu'},
      {'title': 'Sayap Pelindungmu',    'artist': 'Ungu',         'dur': '4:55', 'type': 'lagu'},
      {'title': 'Menghapus Jejakmu',    'artist': 'Peterpan',     'dur': '4:33', 'type': 'lagu'},
      {'title': 'Tinggal Kenangan',     'artist': 'Exists',       'dur': '4:45', 'type': 'lagu'},
      {'title': 'Tak Ingin Sendiri',    'artist': 'Yuni Shara',   'dur': '4:10', 'type': 'lagu'},
      {'title': 'Bidadari Kesepian',    'artist': 'Sheila On 7',  'dur': '4:25', 'type': 'lagu'},
    ],
    'Podcast': [
      {'title': 'Makna Kehidupan',      'artist': 'Podcast Deddy M','dur': '42:30','type': 'podcast'},
      {'title': 'Dunia Startup',        'artist': 'Tech Talk ID',  'dur': '55:10','type': 'podcast'},
      {'title': 'Nugas Bareng Kak Sal', 'artist': 'Sal Priadi',    'dur': '38:00','type': 'podcast'},
      {'title': 'Filosofi Teras',       'artist': 'Henry Manampiring','dur': '60:00','type': 'podcast'},
      {'title': 'Thirty Days',          'artist': 'Soleh Solihun', 'dur': '45:20','type': 'podcast'},
      {'title': 'Cerita Kuliner',       'artist': 'Bondan Winarno','dur': '50:00','type': 'podcast'},
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

  // ── Artis unik ────────────────────────────────────────────────────────────
  List<String> get _uniqueArtists {
    final seen = <String>{};
    return _allSongs
        .map((s) => s['artist']!)
        .where((a) => seen.add(a))
        .toList();
  }

  // ── Hasil filter berdasarkan query + tipe filter ──────────────────────────
  List<Map<String, String>> get _filteredSongs {
    var results = _allSongs.where((s) {
      final q = _query.toLowerCase();
      return s['title']!.toLowerCase().contains(q) ||
          s['artist']!.toLowerCase().contains(q);
    }).toList();

    switch (_activeFilter) {
      case 1: // Lagu
        results = results.where((s) => s['type'] != 'podcast').toList();
        break;
      case 2: // Artis — ambil satu lagu per artis
        final seen = <String>{};
        results = results.where((s) => seen.add(s['artist']!)).toList();
        break;
      case 3: // Podcast
        results = results.where((s) => s['type'] == 'podcast').toList();
        break;
      case 4: // Kategori — tidak tampil di list lagu, tampil kategori
        break;
    }
    return results;
  }

  // ── Kategori yang cocok dengan query ──────────────────────────────────────
  List<Map<String, dynamic>> get _filteredCategories {
    if (_query.isEmpty) return _categories;
    return _categories
        .where((c) =>
            (c['label'] as String).toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _listAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..forward();

    _focusNode.addListener(() {
      setState(() => _isSearching = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    _listAnimCtrl.dispose();
    super.dispose();
  }

  // ── Simpan ke riwayat ─────────────────────────────────────────────────────
  void _addToHistory(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      _searchHistory.remove(query);
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 8) _searchHistory.removeLast();
    });
  }

  void _applyHistoryQuery(String query) {
    _searchCtrl.text = query;
    setState(() {
      _query = query;
      _activeFilter = 0;
    });
    _focusNode.unfocus();
    _addToHistory(query);
  }

  void _removeHistory(String item) {
    setState(() => _searchHistory.remove(item));
  }

  void _clearHistory() {
    setState(() => _searchHistory.clear());
  }

  // ── Submit pencarian ──────────────────────────────────────────────────────
  void _submitSearch(String value) {
    if (value.trim().isNotEmpty) {
      _addToHistory(value.trim());
    }
    _focusNode.unfocus();
  }

  // ── Buka bottom sheet kategori ────────────────────────────────────────────
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
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
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
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: color.withOpacity(0.35), width: 1.2),
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
                          child: Icon(category['icon'] as IconData,
                              color: Colors.white, size: 28),
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
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${songs.length} lagu populer',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.55)),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            if (songs.isNotEmpty) {
                              Navigator.of(context).pushNamed(
                                AppRoutes.player,
                                arguments: {
                                  'title': songs.first['title'],
                                  'artist': songs.first['artist'],
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
                                    spreadRadius: 1)
                              ],
                            ),
                            child: const Icon(Icons.play_arrow_rounded,
                                color: Colors.white, size: 26),
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
                          color: Colors.white.withOpacity(0.55)),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
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
                          offset: Offset(0, 20 * (1 - v)), child: child),
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
                            SizedBox(
                              width: 24,
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: color.withOpacity(0.8)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(category['icon'] as IconData,
                                  color: color, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    song['title']!,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    song['artist']!,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              song['dur']!,
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.textMuted),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.more_vert,
                                color: AppColors.textMuted, size: 18),
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title ────────────────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                'Cari',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ── Search bar ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Pill search input — menyusut saat "Batal" muncul
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
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
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.search_rounded,
                              key: ValueKey(_isSearching),
                              color: _isSearching
                                  ? AppColors.primary
                                  : AppColors.textMuted,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchCtrl,
                              focusNode: _focusNode,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.3,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Lagu, artis, atau podcast',
                                hintStyle: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (v) => setState(() {
                                _query = v;
                                if (v.isEmpty) _activeFilter = 0;
                              }),
                              onSubmitted: _submitSearch,
                            ),
                          ),
                          // Tombol hapus teks (× di dalam bar)
                          AnimatedSize(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            child: _query.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      _searchCtrl.clear();
                                      setState(() {
                                        _query = '';
                                        _activeFilter = 0;
                                      });
                                      _focusNode.requestFocus();
                                    },
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.textMuted
                                            .withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: AppColors.textMuted,
                                        size: 15,
                                      ),
                                    ),
                                  )
                                : const SizedBox(width: 14),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tombol "Batal" — di LUAR bar, slide masuk dari kanan
                  AnimatedSize(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    child: _isSearching
                        ? GestureDetector(
                            onTap: () {
                              _searchCtrl.clear();
                              _focusNode.unfocus();
                              setState(() {
                                _query = '';
                                _activeFilter = 0;
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Text(
                                'Batal',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            // ── Filter chips (tampil saat ada query) ─────────────────────────
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 220),
              crossFadeState: _query.isNotEmpty
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: _filterChipsBar(),
              secondChild: const SizedBox(height: 8),
              firstCurve: Curves.easeOut,
              secondCurve: Curves.easeOut,
              sizeCurve: Curves.easeOut,
            ),

            // ── Content ──────────────────────────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: _query.isNotEmpty
                    ? _searchResults()
                    : (_isSearching && _searchHistory.isNotEmpty)
                        ? _historyPanel()
                        : _browseCategories(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FILTER CHIPS BAR
  // ══════════════════════════════════════════════════════════════════════════
  Widget _filterChipsBar() {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 2),
        scrollDirection: Axis.horizontal,
        itemCount: _filterChips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final chip = _filterChips[i];
          final isActive = _activeFilter == i;
          return GestureDetector(
            onTap: () => setState(() => _activeFilter = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    chip['icon'] as IconData,
                    size: 15,
                    color: isActive ? Colors.white : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    chip['label'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : AppColors.textSecondary,
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
  // RIWAYAT PENCARIAN
  // ══════════════════════════════════════════════════════════════════════════
  Widget _historyPanel() {
    return ListView(
      key: const ValueKey('history'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        // ── Header riwayat ────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Pencarian terakhir',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            GestureDetector(
              onTap: _clearHistory,
              child: Text(
                'Hapus semua',
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── Daftar riwayat ────────────────────────────────────────────────
        ..._searchHistory.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return TweenAnimationBuilder<double>(
            key: ValueKey(item),
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 160 + i * 40),
            curve: Curves.easeOut,
            builder: (_, v, child) => Opacity(
              opacity: v,
              child:
                  Transform.translate(offset: Offset(0, 10 * (1 - v)), child: child),
            ),
            child: GestureDetector(
              onTap: () => _applyHistoryQuery(item),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.history_rounded,
                        color: AppColors.textMuted, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    // Pakai kata kuncinya langsung di search
                    GestureDetector(
                      onTap: () {
                        _searchCtrl.text = item;
                        setState(() => _query = item);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6, left: 4),
                        child: Icon(
                          Icons.north_west_rounded,
                          color: AppColors.textMuted,
                          size: 16,
                        ),
                      ),
                    ),
                    // Hapus item ini
                    GestureDetector(
                      onTap: () => _removeHistory(item),
                      child: const Icon(Icons.close_rounded,
                          color: AppColors.textMuted, size: 16),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 20),

        // ── Pencarian populer ─────────────────────────────────────────────
        const Text(
          'Populer saat ini',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            'Tulus', 'Raisa', 'BLACKPINK', 'Chrisye',
            'Payung Teduh', 'BTS', 'Fourtwnty', 'Noah',
          ].map((tag) {
            return GestureDetector(
              onTap: () => _applyHistoryQuery(tag),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // GRID KATEGORI
  // ══════════════════════════════════════════════════════════════════════════
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
                        Positioned(
                          right: -6,
                          bottom: -6,
                          child: Icon(cat['icon'] as IconData,
                              size: 52,
                              color: Colors.black.withOpacity(0.12)),
                        ),
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
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${(_songsByCategory[cat['label']] ?? []).length} lagu',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.75)),
                              ),
                            ],
                          ),
                        ),
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
                                  color: Colors.white),
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

  // ══════════════════════════════════════════════════════════════════════════
  // HASIL PENCARIAN
  // ══════════════════════════════════════════════════════════════════════════
  Widget _searchResults() {
    // Filter = Kategori: tampilkan grid kategori yang cocok
    if (_activeFilter == 4) {
      if (_filteredCategories.isEmpty) return _emptyState();
      return GridView.builder(
        key: const ValueKey('cat-results'),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _filteredCategories.length,
        itemBuilder: (_, i) {
          final cat = _filteredCategories[i];
          final color = cat['color'] as Color;
          return GestureDetector(
            onTap: () => _showCategorySheet(cat),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -6,
                    bottom: -6,
                    child: Icon(cat['icon'] as IconData,
                        size: 52, color: Colors.black.withOpacity(0.12)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cat['label'] as String,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                        const SizedBox(height: 3),
                        Text(
                            '${(_songsByCategory[cat['label']] ?? []).length} lagu',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.75))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    // Filter = Artis: tampilkan list artis unik
    if (_activeFilter == 2) {
      final artists = _filteredSongs.map((s) => s['artist']!).toSet().toList();
      if (artists.isEmpty) return _emptyState();
      return ListView.builder(
        key: const ValueKey('artist-results'),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        itemCount: artists.length,
        itemBuilder: (_, i) {
          final artist = artists[i];
          final songsCount = _allSongs
              .where((s) => s['artist'] == artist)
              .length;
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 160 + i * 35),
            curve: Curves.easeOut,
            builder: (_, v, child) => Opacity(
                opacity: v,
                child: Transform.translate(
                    offset: Offset(0, 12 * (1 - v)), child: child)),
            child: GestureDetector(
              onTap: () {
                // Search artis ini di semua lagu
                _searchCtrl.text = artist;
                setState(() {
                  _query = artist;
                  _activeFilter = 1;
                });
                _addToHistory(artist);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Avatar artis
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_rounded,
                          color: AppColors.primary, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            artist,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '$songsCount lagu',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        color: AppColors.textMuted, size: 14),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    // Filter = Semua / Lagu / Podcast: tampilkan list lagu
    final results = _filteredSongs;
    if (results.isEmpty) return _emptyState();

    return ListView.builder(
      key: ValueKey('results-$_activeFilter'),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      itemCount: results.length,
      itemBuilder: (_, i) {
        final song = results[i];
        final isPodcast = song['type'] == 'podcast';
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 160 + i * 35),
          curve: Curves.easeOut,
          builder: (_, v, child) => Opacity(
              opacity: v,
              child:
                  Transform.translate(offset: Offset(0, 14 * (1 - v)), child: child)),
          child: GestureDetector(
            onTap: () {
              _addToHistory(_query);
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
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Thumbnail
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isPodcast
                          ? const Color(0xFF8F4FD6).withOpacity(0.2)
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isPodcast
                          ? Icons.podcasts_rounded
                          : Icons.music_note_rounded,
                      color: isPodcast
                          ? const Color(0xFF8F4FD6)
                          : AppColors.textMuted,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Highlight query di judul
                        _highlightText(song['title']!, _query),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            if (isPodcast)
                              Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8F4FD6)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Podcast',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: Color(0xFF8F4FD6),
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                song['artist']!,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
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
                  const Icon(Icons.more_vert,
                      color: AppColors.textMuted, size: 18),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── State kosong ──────────────────────────────────────────────────────────
  Widget _emptyState() {
    return Center(
      key: const ValueKey('empty'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded,
              color: AppColors.textMuted, size: 56),
          const SizedBox(height: 16),
          Text(
            'Tidak ada hasil untuk "$_query"',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Coba kata kunci lain',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ── Highlight teks yang cocok dengan query ────────────────────────────────
  Widget _highlightText(String text, String query) {
    if (query.isEmpty) {
      return Text(
        text,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    final lower = text.toLowerCase();
    final q = query.toLowerCase();
    final idx = lower.indexOf(q);
    if (idx < 0) {
      return Text(
        text,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
        children: [
          TextSpan(text: text.substring(0, idx)),
          TextSpan(
            text: text.substring(idx, idx + query.length),
            style: TextStyle(
              color: AppColors.primary,
              backgroundColor: AppColors.primary.withOpacity(0.15),
            ),
          ),
          TextSpan(text: text.substring(idx + query.length)),
        ],
      ),
    );
  }
}
