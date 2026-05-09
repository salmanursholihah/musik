import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class OfflinePage extends StatefulWidget {
  const OfflinePage({super.key});

  @override
  State<OfflinePage> createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _offlineModeEnabled = true;
  String _sortBy = 'Terbaru';

  final List<Map<String, dynamic>> _downloadedSongs = [
    {
      'title': 'Hati-Hati di Jalan',
      'artist': 'Tulus',
      'album': 'Manusia',
      'size': '8.2 MB',
      'duration': '4:28',
      'quality': '320 kbps',
      'color': Color(0xFF1E3A5F),
    },
    {
      'title': 'Mangu',
      'artist': 'Fourtwnty',
      'album': 'Lelaku',
      'size': '6.8 MB',
      'duration': '3:22',
      'quality': '320 kbps',
      'color': Color(0xFF2D1B4E),
    },
    {
      'title': 'Runtuh',
      'artist': 'Feby Putri ft. Fiersa Besari',
      'album': 'Single',
      'size': '7.5 MB',
      'duration': '4:01',
      'quality': '320 kbps',
      'color': Color(0xFF1A4035),
    },
    {
      'title': 'Separuh Aku',
      'artist': 'Noah',
      'album': 'Separuh Aku',
      'size': '7.1 MB',
      'duration': '3:52',
      'quality': '256 kbps',
      'color': Color(0xFF4A1C1C),
    },
    {
      'title': 'Langit Sore',
      'artist': 'Payung Teduh',
      'album': 'Dunia Batas',
      'size': '5.9 MB',
      'duration': '4:10',
      'quality': '320 kbps',
      'color': Color(0xFF2C2A1A),
    },
    {
      'title': 'Kasih Tak Sampai',
      'artist': 'Padi',
      'album': 'Lain Dunia',
      'size': '7.8 MB',
      'duration': '4:22',
      'quality': '256 kbps',
      'color': Color(0xFF1E2A4A),
    },
    {
      'title': 'Melepasmu',
      'artist': 'Armada',
      'album': 'Mabuk Cinta',
      'size': '6.4 MB',
      'duration': '3:45',
      'quality': '320 kbps',
      'color': Color(0xFF3A1E2D),
    },
  ];

  final List<Map<String, dynamic>> _downloadedPlaylists = [
    {
      'title': 'Chill Vibes',
      'songs': 18,
      'size': '142 MB',
      'color': Color(0xFF1E3A5F),
    },
    {
      'title': 'Mood Booster',
      'songs': 12,
      'size': '96 MB',
      'color': Color(0xFF2D1B4E),
    },
    {
      'title': 'Workout Mix',
      'songs': 25,
      'size': '198 MB',
      'color': Color(0xFF1A4035),
    },
  ];

  double get _totalUsed => _downloadedSongs.fold(0, (sum, s) {
        final str = (s['size'] as String).replaceAll(' MB', '');
        return sum + (double.tryParse(str) ?? 0);
      });

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back_ios_new, size: 20),
            ),
            title: const Text('Musik Offline'),
            actions: [
              IconButton(
                onPressed: _showSortSheet,
                icon: const Icon(Icons.sort_rounded),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0A2540), AppColors.background],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _offlineModeCard(),
                        const SizedBox(height: 14),
                        _storageBar(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              indicatorWeight: 2.5,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textMuted,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Lagu'),
                Tab(text: 'Playlist'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _songsTab(),
            _playlistsTab(),
          ],
        ),
      ),
    );
  }

  // ─── Offline mode toggle ──────────────────────────────────────────────────
  Widget _offlineModeCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _offlineModeEnabled
            ? AppColors.primary.withOpacity(0.12)
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _offlineModeEnabled
              ? AppColors.primary.withOpacity(0.4)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _offlineModeEnabled ? Icons.wifi_off_rounded : Icons.wifi_rounded,
            color: _offlineModeEnabled
                ? AppColors.primary
                : AppColors.textMuted,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mode Offline',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _offlineModeEnabled
                      ? 'Hanya lagu unduhan yang bisa diputar'
                      : 'Streaming aktif — unduhan tetap tersedia',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: _offlineModeEnabled,
              onChanged: (v) => setState(() => _offlineModeEnabled = v),
              activeColor: AppColors.primary,
              inactiveThumbColor: AppColors.textMuted,
              inactiveTrackColor: AppColors.surfaceVariant,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Storage progress bar ─────────────────────────────────────────────────
  Widget _storageBar() {
    const double limit = 1024;
    final usedPct = (_totalUsed / limit).clamp(0.0, 1.0);
    final usedText = '${_totalUsed.toStringAsFixed(0)} MB';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Penyimpanan: $usedText / 1 GB',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${(usedPct * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: usedPct,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation(
              usedPct > 0.85 ? AppColors.error : AppColors.primary,
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  // ─── Songs tab ────────────────────────────────────────────────────────────
  Widget _songsTab() {
    if (_downloadedSongs.isEmpty) return _emptyState();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Row(
            children: [
              Text(
                '${_downloadedSongs.length} lagu',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
              const Spacer(),
              _actionBtn(Icons.shuffle_rounded, 'Acak', () {}),
              const SizedBox(width: 10),
              _actionBtn(
                Icons.play_circle_filled_rounded,
                'Putar Semua',
                () => Navigator.of(context).pushNamed(
                  AppRoutes.player,
                  arguments: {
                    'title': _downloadedSongs[0]['title'],
                    'artist': _downloadedSongs[0]['artist'],
                  },
                ),
                primary: true,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            itemCount: _downloadedSongs.length,
            itemBuilder: (_, i) => _songTile(_downloadedSongs[i], i),
          ),
        ),
      ],
    );
  }

  Widget _songTile(Map<String, dynamic> song, int index) {
    return GestureDetector(
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
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // Album art
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: song['color'] as Color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.music_note_rounded,
                color: Colors.white30,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song['title'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    song['artist'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      _badge(Icons.download_done_rounded, song['quality']),
                      const SizedBox(width: 6),
                      _badge(Icons.straighten_rounded, song['size']),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            Text(
              song['duration'] as String,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(width: 8),

            // Options
            GestureDetector(
              onTap: () => _showSongOptions(song, index),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.more_vert,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: AppColors.primary),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Playlists tab ────────────────────────────────────────────────────────
  Widget _playlistsTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      children: [
        // Download more banner
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.cloud_download_rounded,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Unduh Lebih Banyak',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Nikmati musik saat offline tanpa gangguan',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Jelajahi',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        ..._downloadedPlaylists.map(_playlistTile),
      ],
    );
  }

  Widget _playlistTile(Map<String, dynamic> p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: p['color'] as Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.queue_music_rounded,
              color: Colors.white30,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p['title'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${p['songs']} lagu • ${p['size']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                _badge(Icons.download_done_rounded, 'Diunduh'),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.play_circle_rounded,
                  color: AppColors.primary,
                  size: 36,
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () =>
                    _showDeletePlaylistDialog(p['title'] as String),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.textMuted,
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Empty state ──────────────────────────────────────────────────────────
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.download_rounded,
              color: AppColors.textMuted,
              size: 48,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Belum ada musik offline',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Unduh lagu favoritmu untuk\ndidengarkan tanpa internet',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded, size: 18),
            label: const Text('Cari Lagu untuk Diunduh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              minimumSize: const Size(220, 48),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Song options bottom sheet ────────────────────────────────────────────
  void _showSongOptions(Map<String, dynamic> song, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: song['color'] as Color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.music_note_rounded,
                    color: Colors.white30,
                    size: 26,
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
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        song['artist'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.white.withOpacity(0.06)),
            const SizedBox(height: 8),
            _option(Icons.play_circle_outline_rounded, 'Putar Sekarang', () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(
                AppRoutes.player,
                arguments: {
                  'title': song['title'],
                  'artist': song['artist'],
                },
              );
            }),
            _option(
              Icons.playlist_add_rounded,
              'Tambah ke Playlist',
              () => Navigator.pop(context),
            ),
            _option(Icons.info_outline_rounded, 'Detail Lagu', () {
              Navigator.pop(context);
              _showDetail(song);
            }),
            _option(
              Icons.delete_outline_rounded,
              'Hapus dari Unduhan',
              () {
                Navigator.pop(context);
                final removed = _downloadedSongs.removeAt(index);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${removed['title']} dihapus'),
                    action: SnackBarAction(
                      label: 'Urungkan',
                      onPressed: () => setState(
                        () => _downloadedSongs.insert(index, removed),
                      ),
                    ),
                  ),
                );
              },
              destructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _option(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool destructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  destructive ? AppColors.error : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: destructive ? AppColors.error : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Song detail bottom sheet ─────────────────────────────────────────────
  void _showDetail(Map<String, dynamic> song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Detail Lagu',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _detailRow('Judul', song['title']),
            _detailRow('Artis', song['artist']),
            _detailRow('Album', song['album']),
            _detailRow('Durasi', song['duration']),
            _detailRow('Kualitas', song['quality']),
            _detailRow('Ukuran', song['size']),
            _detailRow('Status', 'Tersimpan di perangkat'),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Sort bottom sheet ────────────────────────────────────────────────────
  void _showSortSheet() {
    final options = ['Terbaru', 'Terlama', 'A–Z', 'Ukuran', 'Artis'];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Urutkan',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ...options.map(
              (o) => GestureDetector(
                onTap: () {
                  setState(() => _sortBy = o);
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _sortBy == o
                        ? AppColors.primary.withOpacity(0.12)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _sortBy == o
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          o,
                          style: TextStyle(
                            color: _sortBy == o
                                ? AppColors.primary
                                : Colors.white,
                            fontSize: 14,
                            fontWeight: _sortBy == o
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (_sortBy == o)
                        const Icon(
                          Icons.check_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Delete playlist dialog ───────────────────────────────────────────────
  void _showDeletePlaylistDialog(String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Hapus Unduhan?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Semua lagu dalam "$title" akan dihapus dari perangkat.',
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _downloadedPlaylists
                  .removeWhere((p) => p['title'] == title));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"$title" dihapus dari unduhan'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  Widget _actionBtn(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool primary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: primary ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
