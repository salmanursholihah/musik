import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AlbumDetailPage extends StatefulWidget {
  final String title;
  final String artist;
  final int year;
  final int trackCount;
  final Color color;
  final bool isSaved;

  const AlbumDetailPage({
    super.key,
    required this.title,
    required this.artist,
    required this.year,
    required this.trackCount,
    required this.color,
    this.isSaved = false,
  });

  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  bool _isSaved = false;
  bool _isPlaying = false;
  int? _playingIndex;

  final _trackData = const [
    {'title': 'Hati-Hati di Jalan', 'duration': '3:48', 'liked': true},
    {'title': 'Manusia',             'duration': '4:12', 'liked': false},
    {'title': 'Gajah',              'duration': '3:55', 'liked': true},
    {'title': 'Ruang Sendiri',      'duration': '4:30', 'liked': false},
    {'title': 'Terlalu Lama Sendiri','duration': '3:58', 'liked': false},
    {'title': 'Pamit',              'duration': '4:02', 'liked': true},
    {'title': 'Baru',               'duration': '3:45', 'liked': false},
    {'title': 'Kamu & Kenangan',    'duration': '4:18', 'liked': true},
    {'title': 'Satu Hari di Bulan Juni','duration':'5:01','liked': false},
    {'title': 'Selamat Ulang Tahun','duration': '4:35', 'liked': false},
    {'title': 'Riakmu',             'duration': '3:29', 'liked': true},
    {'title': 'Doa Ibu',            'duration': '4:47', 'liked': false},
  ];

  late final List<Map<String, dynamic>> _tracks;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.isSaved;
    final count = widget.trackCount.clamp(1, _trackData.length);
    _tracks = List<Map<String, dynamic>>.from(
      _trackData.take(count).map((t) => Map<String, dynamic>.from(t)),
    );
  }

  String get _totalDuration {
    final totalSec = _tracks.fold<int>(
      0,
      (sum, t) {
        final parts = (t['duration'] as String).split(':');
        return sum + int.parse(parts[0]) * 60 + int.parse(parts[1]);
      },
    );
    final m = totalSec ~/ 60;
    final s = totalSec % 60;
    return m >= 60
        ? '${m ~/ 60} jam ${m % 60} menit'
        : '$m menit $s detik';
  }

  // Related albums (other albums by same artist)
  late final List<Map<String, dynamic>> _related = [
    {'title': 'Monokrom',    'year': 2016, 'color': Color(0xFF2A1F3D)},
    {'title': 'Tulus',       'year': 2011, 'color': Color(0xFF1A3040)},
    {'title': 'Gajah',       'year': 2014, 'color': Color(0xFF2C1A10)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ──────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 22),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => setState(() => _isSaved = !_isSaved),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color:
                        _isSaved ? AppColors.primary : Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.color,
                          widget.color.withOpacity(0.5),
                          AppColors.background,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0, 0.5, 1],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 65,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          color: widget.color,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withOpacity(0.6),
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.album_rounded,
                            color: Colors.white24, size: 80),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Info ────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {},
                    child: Text(widget.artist,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary)),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _infoPill(Icons.calendar_today_rounded,
                          '${widget.year}'),
                      const SizedBox(width: 10),
                      _infoPill(Icons.music_note_rounded,
                          '${_tracks.length} lagu'),
                      const SizedBox(width: 10),
                      _infoPill(Icons.timer_rounded, _totalDuration),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Controls
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
                                  _isPlaying ? 'Jeda' : 'Putar Album',
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
                        onTap: () => setState(() => _isSaved = !_isSaved),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: _isSaved
                                ? AppColors.primary.withOpacity(0.2)
                                : AppColors.surfaceVariant,
                            shape: BoxShape.circle,
                            border: _isSaved
                                ? Border.all(
                                    color: AppColors.primary, width: 1.5)
                                : null,
                          ),
                          child: Icon(
                            _isSaved
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            color: _isSaved
                                ? AppColors.primary
                                : AppColors.textMuted,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.white.withOpacity(0.08)),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // ── Track list ───────────────────────────────────────────────────
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => _trackTile(i),
              childCount: _tracks.length,
            ),
          ),

          // ── Related albums ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Album Lain dari ${widget.artist}',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 150,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _related.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (_, i) {
                        final r = _related[i];
                        return SizedBox(
                          width: 110,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: r['color'] as Color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.album_rounded,
                                    color: Colors.white24, size: 50),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                r['title'] as String,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${r['year']}',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _trackTile(int i) {
    final t = _tracks[i];
    final isActive = _playingIndex == i;

    return GestureDetector(
      onTap: () {
        setState(() {
          _playingIndex = i;
          _isPlaying = true;
        });
        Navigator.pushNamed(context, '/player',
            arguments: {'title': t['title'], 'artist': widget.artist});
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
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t['title'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color:
                          isActive ? AppColors.primary : Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.artist,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(
                  () => _tracks[i]['liked'] = !(_tracks[i]['liked'] as bool)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  (_tracks[i]['liked'] as bool)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: (_tracks[i]['liked'] as bool)
                      ? AppColors.primary
                      : AppColors.textMuted,
                  size: 18,
                ),
              ),
            ),
            Text(t['duration'] as String,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textMuted)),
            const SizedBox(width: 8),
            const Icon(Icons.more_vert_rounded,
                color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _infoPill(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.textMuted, size: 13),
        const SizedBox(width: 4),
        Text(text,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textMuted)),
      ],
    );
  }
}
