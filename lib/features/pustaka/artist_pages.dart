import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ArtistDetailPage extends StatefulWidget {
  final String name;
  final String genre;
  final String followers;
  final Color color;
  final bool isFollowed;

  const ArtistDetailPage({
    super.key,
    required this.name,
    required this.genre,
    required this.followers,
    required this.color,
    this.isFollowed = false,
  });

  @override
  State<ArtistDetailPage> createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage>
    with SingleTickerProviderStateMixin {
  late bool _isFollowed;
  late TabController _tabCtrl;
  int? _playingIndex;

  final _popularSongs = const [
    {'title': 'Hati-Hati di Jalan', 'plays': '12,4 jt', 'duration': '3:48', 'liked': true},
    {'title': 'Gajah',              'plays': '9,8 jt',  'duration': '3:55', 'liked': false},
    {'title': 'Manusia',             'plays': '8,1 jt',  'duration': '4:12', 'liked': true},
    {'title': 'Pamit',              'plays': '7,5 jt',  'duration': '4:02', 'liked': false},
    {'title': 'Selamat Ulang Tahun','plays': '6,9 jt',  'duration': '4:35', 'liked': false},
    {'title': 'Baru',               'plays': '5,4 jt',  'duration': '3:45', 'liked': true},
    {'title': 'Kamu & Kenangan',    'plays': '4,8 jt',  'duration': '4:18', 'liked': false},
    {'title': 'Ruang Sendiri',      'plays': '3,9 jt',  'duration': '4:30', 'liked': false},
  ];

  final _albums = const [
    {'title': 'Manusia',  'year': 2022, 'tracks': 11, 'color': Color(0xFF1B3A5C)},
    {'title': 'Monokrom', 'year': 2016, 'tracks': 10, 'color': Color(0xFF2A1F3D)},
    {'title': 'Gajah',   'year': 2014, 'tracks': 9,  'color': Color(0xFF2C1A10)},
    {'title': 'Tulus',   'year': 2011, 'tracks': 8,  'color': Color(0xFF1A3040)},
  ];

  late final List<Map<String, dynamic>> _songs;

  @override
  void initState() {
    super.initState();
    _isFollowed = widget.isFollowed;
    _tabCtrl = TabController(length: 3, vsync: this);
    _songs = List<Map<String, dynamic>>.from(
      _popularSongs.map((s) => Map<String, dynamic>.from(s)),
    );
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          // ── Hero header ────────────────────────────────────────────────
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
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
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
                  // Gradient bg
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.color,
                          widget.color.withOpacity(0.4),
                          AppColors.background,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0, 0.55, 1],
                      ),
                    ),
                  ),
                  // Avatar
                  Positioned(
                    top: 70,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              widget.color,
                              widget.color.withOpacity(0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 6,
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.name[0],
                            style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Name + controls ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.genre,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.followers} pengikut',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            setState(() => _isFollowed = !_isFollowed),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 12),
                          decoration: BoxDecoration(
                            color: _isFollowed
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: _isFollowed
                                  ? AppColors.primary
                                  : Colors.white38,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            _isFollowed ? 'Mengikuti' : 'Ikuti',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _isFollowed
                                  ? Colors.white
                                  : Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/player',
                          arguments: {
                            'title': _popularSongs[0]['title'],
                            'artist': widget.name,
                          },
                        ),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 14,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.play_arrow_rounded,
                              color: Colors.white, size: 30),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.more_horiz_rounded,
                            color: Colors.white70, size: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Tabs ──────────────────────────────────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabCtrl,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textMuted,
                indicatorColor: AppColors.primary,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700),
                unselectedLabelStyle:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                tabs: const [
                  Tab(text: 'Populer'),
                  Tab(text: 'Diskografi'),
                  Tab(text: 'Tentang'),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabCtrl,
          children: [
            _popularTab(),
            _discographyTab(),
            _aboutTab(),
          ],
        ),
      ),
    );
  }

  // ── Tab Populer ────────────────────────────────────────────────────────────
  Widget _popularTab() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: _songs.length,
      itemBuilder: (_, i) {
        final s = _songs[i];
        final isActive = _playingIndex == i;
        return GestureDetector(
          onTap: () {
            setState(() => _playingIndex = i);
            Navigator.pushNamed(context, '/player',
                arguments: {'title': s['title'], 'artist': widget.name});
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 4),
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
                  width: 26,
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
                const SizedBox(width: 10),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.music_note_rounded,
                      color: Colors.white24, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s['title'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? AppColors.primary
                              : Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        s['plays'] as String,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() =>
                      _songs[i]['liked'] = !(_songs[i]['liked'] as bool)),
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
                Text(s['duration'] as String,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Tab Diskografi ─────────────────────────────────────────────────────────
  Widget _discographyTab() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: _albums.length,
      itemBuilder: (_, i) {
        final a = _albums[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: a['color'] as Color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (a['color'] as Color).withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.album_rounded,
                    color: Colors.white24, size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a['title'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Album • ${a['year']} • ${a['tracks']} lagu',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.play_circle_outline_rounded,
                  color: AppColors.textSecondary, size: 28),
            ],
          ),
        );
      },
    );
  }

  // ── Tab Tentang ────────────────────────────────────────────────────────────
  Widget _aboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem('${widget.followers}', 'Pengikut'),
                _vDivider(),
                _statItem('${_albums.length}', 'Album'),
                _vDivider(),
                _statItem('${_songs.length * 3}', 'Lagu'),
                _vDivider(),
                _statItem('2011', 'Debut'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('Biografi',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 10),
          Text(
            '${widget.name} adalah musisi Indonesia yang dikenal dengan gaya bermusik yang unik dan lirik yang puitis. '
            'Bergenre ${widget.genre}, ia telah merilis beberapa album yang mendapat sambutan luar biasa dari penggemar di seluruh Indonesia.\n\n'
            'Dengan suara yang khas dan aransemen musik yang kaya, ${widget.name} telah menjadi salah satu ikon musik Indonesia kontemporer. '
            'Karya-karyanya seringkali mengangkat tema kehidupan sehari-hari, cinta, dan perjalanan hidup yang membuat banyak pendengar dapat merasakan kedekatan emosional.',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 20),

          const Text('Genre',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.genre.split(' / ').map((g) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Text(g,
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
        const SizedBox(height: 3),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _vDivider() => Container(
        width: 1,
        height: 28,
        color: Colors.white.withOpacity(0.08),
      );
}

// Persistent header delegate for TabBar
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate(this.tabBar);

  @override
  Widget build(
          BuildContext ctx, double shrinkOffset, bool overlapsContent) =>
      Container(
        color: AppColors.background,
        child: tabBar,
      );

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(_TabBarDelegate old) => false;
}
