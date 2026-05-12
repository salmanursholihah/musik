import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PlaylistDetailPage extends StatefulWidget {
  final String name;
  final int songCount;
  final Color color;
  final bool isDownloaded;

  const PlaylistDetailPage({
    super.key,
    required this.name,
    required this.songCount,
    required this.color,
    this.isDownloaded = false,
  });

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  bool _isPlaying = false;
  int? _playingIndex;
  bool _isShuffle = false;

  // Sample songs — in a real app these come from the playlist data
  late final List<Map<String, dynamic>> _songs;

  final _allSongs = const [
    {'title': 'Hati-Hati di Jalan', 'artist': 'Tulus',           'duration': '3:48', 'liked': true},
    {'title': 'Manusia',             'artist': 'Tulus',           'duration': '4:12', 'liked': false},
    {'title': 'Gajah',              'artist': 'Tulus',           'duration': '3:55', 'liked': true},
    {'title': 'Ruang Sendiri',      'artist': 'Kunto Aji',       'duration': '4:30', 'liked': false},
    {'title': 'Terlalu Lama Sendiri','artist': 'Float',          'duration': '3:58', 'liked': true},
    {'title': 'Selamat Ulang Tahun','artist': 'Jamrud',          'duration': '4:02', 'liked': false},
    {'title': 'Yang Terdalam',      'artist': 'Padi',            'duration': '4:45', 'liked': true},
    {'title': 'Aisyah',             'artist': 'Not Tujuh Belas', 'duration': '3:34', 'liked': false},
    {'title': 'Menghitung Hari',    'artist': 'Krisdayanti',     'duration': '4:10', 'liked': false},
    {'title': 'Separuh Aku',        'artist': 'Noah',            'duration': '4:08', 'liked': true},
    {'title': 'Kita Selamanya',     'artist': 'Fabio Asher',     'duration': '3:52', 'liked': false},
    {'title': 'Rembulan Malam',     'artist': 'Payung Teduh',    'duration': '4:22', 'liked': true},
    {'title': 'Garis Terdepan',     'artist': 'Fourtwnty',       'duration': '3:47', 'liked': false},
    {'title': 'Rehat',              'artist': 'Kunto Aji',       'duration': '4:38', 'liked': true},
    {'title': 'Firasat',            'artist': 'Indra Lesmana',   'duration': '5:01', 'liked': false},
    {'title': 'Berdua Saja',        'artist': 'Payung Teduh',    'duration': '3:29', 'liked': false},
    {'title': 'Widuri',             'artist': 'Bob Tutupoly',    'duration': '3:55', 'liked': true},
    {'title': 'Tentang Kita',       'artist': 'Potret',          'duration': '4:17', 'liked': false},
    {'title': 'Kisah Kasih di Sekolah','artist':'Chrisye',       'duration': '3:41', 'liked': false},
    {'title': 'Sebatas Mimpi',      'artist': 'Nano',            'duration': '4:05', 'liked': true},
  ];

  final _colors = [
    const Color(0xFF1E3A5F),
    const Color(0xFF2D1B4E),
    const Color(0xFF1A4035),
    const Color(0xFF4A1C1C),
    const Color(0xFF2C2A1A),
    const Color(0xFF1E2A4A),
  ];

  @override
  void initState() {
    super.initState();
    // Ambil sejumlah lagu sesuai songCount (max 20)
    final count = widget.songCount.clamp(1, _allSongs.length);
    _songs = List<Map<String, dynamic>>.from(
      _allSongs.take(count).map((s) => Map<String, dynamic>.from(s)),
    );
  }

  String get _totalDuration {
    final totalSec = _songs.length * 225; // ~3:45 rata-rata
    final h = totalSec ~/ 3600;
    final m = (totalSec % 3600) ~/ 60;
    return h > 0 ? '$h jam $m menit' : '$m menit';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Collapsible header ─────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 22),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.more_vert_rounded,
                      color: Colors.white, size: 22),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.color,
                          widget.color.withOpacity(0.6),
                          AppColors.background,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Cover art mosaic (2×2)
                  Positioned(
                    top: 60,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _songs.length >= 4
                              ? GridView.count(
                                  crossAxisCount: 2,
                                  padding: EdgeInsets.zero,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  children: List.generate(4, (i) {
                                    return Container(
                                      color: _colors[i % _colors.length],
                                      child: const Icon(
                                          Icons.music_note_rounded,
                                          color: Colors.white24,
                                          size: 40),
                                    );
                                  }),
                                )
                              : Container(
                                  color: widget.color,
                                  child: const Icon(Icons.queue_music_rounded,
                                      color: Colors.white30, size: 80),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Info + controls ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.person_rounded,
                          color: AppColors.textMuted, size: 14),
                      const SizedBox(width: 4),
                      const Text('Kamu',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textMuted)),
                      const SizedBox(width: 12),
                      const Icon(Icons.music_note_rounded,
                          color: AppColors.textMuted, size: 14),
                      const SizedBox(width: 4),
                      Text('${_songs.length} lagu',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textMuted)),
                      const SizedBox(width: 12),
                      const Icon(Icons.timer_rounded,
                          color: AppColors.textMuted, size: 14),
                      const SizedBox(width: 4),
                      Text(_totalDuration,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
                  if (widget.isDownloaded) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.download_done_rounded,
                            color: AppColors.primary, size: 14),
                        const SizedBox(width: 4),
                        const Text('Tersedia offline',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.primary)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Play / Shuffle buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _isPlaying = !_isPlaying),
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _isPlaying ? 'Jeda' : 'Putar Semua',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _isShuffle = !_isShuffle),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: _isShuffle
                                ? AppColors.primary.withOpacity(0.2)
                                : AppColors.surfaceVariant,
                            shape: BoxShape.circle,
                            border: _isShuffle
                                ? Border.all(
                                    color: AppColors.primary, width: 1.5)
                                : null,
                          ),
                          child: Icon(
                            Icons.shuffle_rounded,
                            color: _isShuffle
                                ? AppColors.primary
                                : AppColors.textMuted,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── Song list ──────────────────────────────────────────────────────
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => _songTile(i),
              childCount: _songs.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _songTile(int i) {
    final s = _songs[i];
    final isActive = _playingIndex == i;

    return GestureDetector(
      onTap: () {
        setState(() {
          _playingIndex = i;
          _isPlaying = true;
        });
        Navigator.pushNamed(
          context,
          '/player',
          arguments: {'title': s['title'], 'artist': s['artist']},
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(
                  color: AppColors.primary.withOpacity(0.3), width: 1)
              : null,
        ),
        child: Row(
          children: [
            // Rank atau animasi
            SizedBox(
              width: 32,
              child: isActive
                  ? const Icon(Icons.equalizer_rounded,
                      color: AppColors.primary, size: 18)
                  : Text(
                      '${i + 1}',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textMuted),
                      textAlign: TextAlign.center,
                    ),
            ),
            const SizedBox(width: 8),
            // Thumbnail
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _colors[i % _colors.length],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.music_note_rounded,
                  color: Colors.white24, size: 20),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s['title'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActive ? AppColors.primary : Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    s['artist'] as String,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            // Like
            GestureDetector(
              onTap: () =>
                  setState(() => _songs[i]['liked'] = !(_songs[i]['liked'] as bool)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  (_songs[i]['liked'] as bool)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: (_songs[i]['liked'] as bool)
                      ? AppColors.primary
                      : AppColors.textMuted,
                  size: 18,
                ),
              ),
            ),
            // Duration
            Text(
              s['duration'] as String,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textMuted),
            ),
            // More
            GestureDetector(
              onTap: () => _showSongOptions(context, s),
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.more_vert_rounded,
                    color: AppColors.textMuted, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSongOptions(BuildContext ctx, Map<String, dynamic> s) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: _colors[0],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.music_note_rounded,
                      color: Colors.white24, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s['title'] as String,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    Text(s['artist'] as String,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Divider(color: Colors.white.withOpacity(0.07)),
            ...[
              {'icon': Icons.playlist_add_rounded,  'label': 'Tambah ke playlist'},
              {'icon': Icons.download_rounded,       'label': 'Unduh lagu'},
              {'icon': Icons.share_rounded,          'label': 'Bagikan'},
              {'icon': Icons.person_rounded,         'label': 'Lihat artis'},
              {'icon': Icons.remove_circle_outline_rounded,
               'label': 'Hapus dari playlist', 'isDestructive': true},
            ].map((opt) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(opt['icon'] as IconData,
                      color: opt['isDestructive'] == true
                          ? Colors.red
                          : AppColors.textSecondary,
                      size: 22),
                  title: Text(opt['label'] as String,
                      style: TextStyle(
                          fontSize: 14,
                          color: opt['isDestructive'] == true
                              ? Colors.red
                              : Colors.white)),
                  onTap: () => Navigator.pop(ctx),
                )),
          ],
        ),
      ),
    );
  }
}
