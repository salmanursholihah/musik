import 'package:flutter/material.dart';
import 'package:musik/features/pustaka/album_pages.dart';
import 'package:musik/features/pustaka/artist_pages.dart';
import 'package:musik/features/pustaka/playlist_pages.dart';
import 'package:musik/features/pustaka/podcast_pages.dart';
import '../../core/constants/app_colors.dart';

// ══════════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ══════════════════════════════════════════════════════════════════════════════

class _Playlist {
  final String name;
  final int songCount;
  final Color color;
  final bool isDownloaded;
  bool isLiked;

  _Playlist({
    required this.name,
    required this.songCount,
    required this.color,
    this.isDownloaded = false,
    this.isLiked = false,
  });
}

class _Album {
  final String title;
  final String artist;
  final int year;
  final int trackCount;
  final Color color;
  bool isSaved;

  _Album({
    required this.title,
    required this.artist,
    required this.year,
    required this.trackCount,
    required this.color,
    this.isSaved = false,
  });
}

class _Artist {
  final String name;
  final String genre;
  final String followers;
  final Color color;
  bool isFollowed;

  _Artist({
    required this.name,
    required this.genre,
    required this.followers,
    required this.color,
    this.isFollowed = false,
  });
}

class _Podcast {
  final String title;
  final String host;
  final int episodeCount;
  final String category;
  final Color color;
  bool isSubscribed;
  int newEpisodes;

  _Podcast({
    required this.title,
    required this.host,
    required this.episodeCount,
    required this.category,
    required this.color,
    this.isSubscribed = false,
    this.newEpisodes = 0,
  });
}

// ══════════════════════════════════════════════════════════════════════════════
// LIBRARY PAGE
// ══════════════════════════════════════════════════════════════════════════════

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  int _activeFilter = 0; // 0=Semua 1=Playlist 2=Album 3=Artis 4=Podcast

  final _filters = ['Semua', 'Playlist', 'Album', 'Artis', 'Podcast'];

  // ── Data ────────────────────────────────────────────────────────────────────
  final List<_Playlist> _playlists = [
    _Playlist(name: 'Favorit Saya',    songCount: 34, color: Color(0xFF1E3A5F), isLiked: true),
    _Playlist(name: 'Chill Vibes',     songCount: 18, color: Color(0xFF2D1B4E)),
    _Playlist(name: 'Lagu Unduhan',    songCount: 12, color: Color(0xFF1A4035), isDownloaded: true),
    _Playlist(name: 'Workout Mix',     songCount: 25, color: Color(0xFF4A1C1C)),
    _Playlist(name: 'Tidur Malam',     songCount: 15, color: Color(0xFF2C2A1A)),
    _Playlist(name: 'Indie Folk',      songCount: 9,  color: Color(0xFF1E2A4A)),
  ];

  final List<_Album> _albums = [
    _Album(title: 'Manusia',        artist: 'Tulus',          year: 2022, trackCount: 11, color: Color(0xFF1B3A5C), isSaved: true),
    _Album(title: 'Monokrom',       artist: 'Tulus',          year: 2016, trackCount: 10, color: Color(0xFF2A1F3D)),
    _Album(title: 'Sialnya, Aku',   artist: 'Kunto Aji',      year: 2023, trackCount: 8,  color: Color(0xFF1A3828)),
    _Album(title: 'Mantra Mantra',  artist: 'Kunto Aji',      year: 2018, trackCount: 9,  color: Color(0xFF3D1C1C)),
    _Album(title: 'Ruang Tunggu',   artist: 'Efek Rumah Kaca',year: 2021, trackCount: 12, color: Color(0xFF1C2C3A)),
  ];

  final List<_Artist> _artists = [
    _Artist(name: 'Tulus',           genre: 'Pop / Soul',     followers: '4.2 jt', color: Color(0xFF1E3A5F), isFollowed: true),
    _Artist(name: 'Kunto Aji',       genre: 'Indie Pop',      followers: '2.8 jt', color: Color(0xFF2D1B4E), isFollowed: true),
    _Artist(name: 'Efek Rumah Kaca', genre: 'Indie Rock',     followers: '1.5 jt', color: Color(0xFF1A4035)),
    _Artist(name: 'Mocca',           genre: 'Jazz / Pop',     followers: '980 rb', color: Color(0xFF4A1C1C)),
    _Artist(name: 'Payung Teduh',    genre: 'Folk / Acoustic', followers: '3.1 jt', color: Color(0xFF2C2A1A)),
    _Artist(name: 'Fourtwnty',       genre: 'Folk / Pop',     followers: '2.3 jt', color: Color(0xFF1E2A4A)),
  ];

  final List<_Podcast> _podcasts = [
    _Podcast(title: 'Makna Talks',       host: 'Jerome Polin',   episodeCount: 82,  category: 'Edukasi',    color: Color(0xFF1E3A5F), isSubscribed: true, newEpisodes: 3),
    _Podcast(title: 'Close The Door',    host: 'Deddy Corbuzier', episodeCount: 215, category: 'Lifestyle',  color: Color(0xFF2D1B4E), isSubscribed: true, newEpisodes: 1),
    _Podcast(title: 'Thirty Days Of Lunch', host: 'Raditya Dika', episodeCount: 104, category: 'Komedi',    color: Color(0xFF1A4035)),
    _Podcast(title: 'Podcast Santuy',    host: 'Aiman Witjaksono',episodeCount: 67,  category: 'Berita',    color: Color(0xFF4A1C1C)),
  ];

  // ── Add popup state ─────────────────────────────────────────────────────────
  bool _listView = true; // true=list, false=grid (untuk Artis)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Pustaka Saya',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Toggle list/grid (hanya saat filter Artis)
                  if (_activeFilter == 3)
                    GestureDetector(
                      onTap: () => setState(() => _listView = !_listView),
                      child: Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _listView
                              ? Icons.grid_view_rounded
                              : Icons.view_list_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  // Tombol tambah
                  GestureDetector(
                    onTap: () => _showAddSheet(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Filter chips ──────────────────────────────────────────────────
            SizedBox(
              height: 38,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final isActive = _activeFilter == i;
                  return GestureDetector(
                    onTap: () => setState(() => _activeFilter = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.surfaceVariant,
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
                      child: Text(
                        _filters[i],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isActive ? Colors.white : AppColors.textMuted,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 4),

            // ── Content ───────────────────────────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: KeyedSubtree(
                  key: ValueKey(_activeFilter),
                  child: _buildContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Konten sesuai filter aktif ─────────────────────────────────────────────
  Widget _buildContent() {
    switch (_activeFilter) {
      case 0:
        return _buildAllTab();
      case 1:
        return _buildPlaylistTab();
      case 2:
        return _buildAlbumTab();
      case 3:
        return _listView ? _buildArtistListTab() : _buildArtistGridTab();
      case 4:
        return _buildPodcastTab();
      default:
        return _buildAllTab();
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 0 — SEMUA
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildAllTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      children: [
        // Playlist section
        _sectionHeader('Playlist', onTap: () => setState(() => _activeFilter = 1)),
        ..._playlists.take(3).map((p) => _playlistTile(p)),
        const SizedBox(height: 8),

        // Album section
        _sectionHeader('Album', onTap: () => setState(() => _activeFilter = 2)),
        ..._albums.take(3).map((a) => _albumTile(a)),
        const SizedBox(height: 8),

        // Artis section
        _sectionHeader('Artis', onTap: () => setState(() => _activeFilter = 3)),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _artists.take(4).length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, i) => _artistCompact(_artists[i]),
          ),
        ),
        const SizedBox(height: 8),

        // Podcast section
        _sectionHeader('Podcast', onTap: () => setState(() => _activeFilter = 4)),
        ..._podcasts.take(2).map((p) => _podcastTile(p)),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 1 — PLAYLIST
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildPlaylistTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      children: [
        // Liked songs pinned item
        _pinnedLikedSongs(),
        const SizedBox(height: 8),
        ..._playlists.map((p) => _playlistTile(p)),
      ],
    );
  }

  Widget _pinnedLikedSongs() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PlaylistDetailPage(
            name: 'Lagu yang Disukai',
            songCount: 20,
            color: Color(0xFF1E3A5F),
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.25),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lagu yang Disukai',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Playlist • 58 lagu',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const Icon(Icons.play_circle_rounded,
              color: AppColors.primary, size: 32),
        ],
      ),
    ),
    );
  }

  Widget _playlistTile(_Playlist p) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PlaylistDetailPage(
            name: p.name,
            songCount: p.songCount,
            color: p.color,
            isDownloaded: p.isDownloaded,
          ),
        ),
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
            // Thumbnail
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: p.color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.queue_music_rounded,
                      color: Colors.white30, size: 26),
                  if (p.isDownloaded)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.download_done_rounded,
                            color: Colors.white, size: 8),
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
                    p.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Playlist • ${p.songCount} lagu',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _showPlaylistOptions(p),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.more_vert_rounded,
                    color: AppColors.textMuted, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 2 — ALBUM
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildAlbumTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      children: _albums.map((a) => _albumTile(a)).toList(),
    );
  }

  Widget _albumTile(_Album a) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AlbumDetailPage(
            title: a.title,
            artist: a.artist,
            year: a.year,
            trackCount: a.trackCount,
            color: a.color,
            isSaved: a.isSaved,
          ),
        ),
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
            // Cover
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: a.color,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: a.color.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.album_rounded,
                  color: Colors.white30, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${a.artist} • ${a.year}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${a.trackCount} lagu',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => a.isSaved = !a.isSaved),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  a.isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  key: ValueKey(a.isSaved),
                  color: a.isSaved ? AppColors.primary : AppColors.textMuted,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 3 — ARTIS (LIST)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildArtistListTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      children: _artists.map((a) => _artistListTile(a)).toList(),
    );
  }

  Widget _artistListTile(_Artist a) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ArtistDetailPage(
            name: a.name,
            genre: a.genre,
            followers: a.followers,
            color: a.color,
            isFollowed: a.isFollowed,
          ),
        ),
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
          // Avatar circle
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [a.color, a.color.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                a.name[0],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${a.genre} • ${a.followers} pengikut',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => a.isFollowed = !a.isFollowed),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: a.isFollowed
                    ? AppColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: a.isFollowed
                      ? AppColors.primary
                      : AppColors.textMuted,
                  width: 1.5,
                ),
              ),
              child: Text(
                a.isFollowed ? 'Diikuti' : 'Ikuti',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: a.isFollowed ? Colors.white : AppColors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  // ── TAB 3 — ARTIS (GRID) ──────────────────────────────────────────────────
  Widget _buildArtistGridTab() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 14,
        mainAxisSpacing: 20,
        childAspectRatio: 0.75,
      ),
      itemCount: _artists.length,
      itemBuilder: (_, i) => _artistGridItem(_artists[i]),
    );
  }

  Widget _artistGridItem(_Artist a) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ArtistDetailPage(
            name: a.name,
            genre: a.genre,
            followers: a.followers,
            color: a.color,
            isFollowed: a.isFollowed,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [a.color, a.color.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: a.isFollowed
                  ? [
                      BoxShadow(
                        color: a.color.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                a.name[0],
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            a.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            a.genre,
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _artistCompact(_Artist a) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ArtistDetailPage(
            name: a.name,
            genre: a.genre,
            followers: a.followers,
            color: a.color,
            isFollowed: a.isFollowed,
          ),
        ),
      ),
      child: Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [a.color, a.color.withOpacity(0.6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              a.name[0],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          a.name,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 4 — PODCAST
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildPodcastTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      children: _podcasts.map((p) => _podcastTile(p)).toList(),
    );
  }

  Widget _podcastTile(_Podcast p) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PodcastDetailPage(
            title: p.title,
            host: p.host,
            episodeCount: p.episodeCount,
            category: p.category,
            color: p.color,
            isSubscribed: p.isSubscribed,
            newEpisodes: p.newEpisodes,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // Thumbnail
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: p.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.mic_rounded,
                      color: Colors.white30, size: 28),
                ),
                if (p.newEpisodes > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${p.newEpisodes}',
                          style: const TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    p.host,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          p.category,
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${p.episodeCount} episode',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => p.isSubscribed = !p.isSubscribed),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: p.isSubscribed
                      ? AppColors.primary.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: p.isSubscribed
                        ? AppColors.primary
                        : AppColors.textMuted,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  p.isSubscribed ? 'Diikuti' : 'Ikuti',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color:
                        p.isSubscribed ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════════════════
  Widget _sectionHeader(String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: const Text(
              'Lihat semua',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // POPUP — TAMBAH PUSTAKA
  // ══════════════════════════════════════════════════════════════════════════
  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _AddLibrarySheet(
        activeFilter: _activeFilter,
        filters: _filters,
        onAddPlaylist: (name, color) {
          setState(() {
            _playlists.insert(
              0,
              _Playlist(name: name, songCount: 0, color: color),
            );
          });
        },
        onFollowArtist: (name, genre) {
          setState(() {
            _artists.insert(
              0,
              _Artist(
                name: name,
                genre: genre,
                followers: '0',
                color: AppColors.primary.withOpacity(0.4),
                isFollowed: true,
              ),
            );
          });
        },
        onSaveAlbum: (title, artist) {
          setState(() {
            _albums.insert(
              0,
              _Album(
                title: title,
                artist: artist,
                year: DateTime.now().year,
                trackCount: 0,
                color: AppColors.primary.withOpacity(0.3),
                isSaved: true,
              ),
            );
          });
        },
        onSubscribePodcast: (title, host) {
          setState(() {
            _podcasts.insert(
              0,
              _Podcast(
                title: title,
                host: host,
                episodeCount: 0,
                category: 'Umum',
                color: AppColors.primary.withOpacity(0.3),
                isSubscribed: true,
              ),
            );
          });
        },
      ),
    );
  }

  // ── Playlist options sheet ─────────────────────────────────────────────────
  void _showPlaylistOptions(_Playlist p) {
    showModalBottomSheet(
      context: context,
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
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            // Playlist preview
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: p.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.queue_music_rounded,
                      color: Colors.white30, size: 24),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    Text('${p.songCount} lagu',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.white.withOpacity(0.07)),
            ...[
              {'icon': Icons.edit_rounded,        'label': 'Edit playlist'},
              {'icon': Icons.share_rounded,        'label': 'Bagikan'},
              {'icon': Icons.download_rounded,     'label': 'Unduh playlist'},
              {'icon': Icons.delete_outline_rounded,'label': 'Hapus dari pustaka',
               'isDestructive': true},
            ].map((opt) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    opt['icon'] as IconData,
                    color: opt['isDestructive'] == true
                        ? Colors.red
                        : AppColors.textSecondary,
                    size: 22,
                  ),
                  title: Text(
                    opt['label'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: opt['isDestructive'] == true
                          ? Colors.red
                          : Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    if (opt['isDestructive'] == true) {
                      setState(() => _playlists.remove(p));
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ADD LIBRARY SHEET
// ══════════════════════════════════════════════════════════════════════════════
class _AddLibrarySheet extends StatefulWidget {
  final int activeFilter;
  final List<String> filters;
  final void Function(String name, Color color) onAddPlaylist;
  final void Function(String name, String genre) onFollowArtist;
  final void Function(String title, String artist) onSaveAlbum;
  final void Function(String title, String host) onSubscribePodcast;

  const _AddLibrarySheet({
    required this.activeFilter,
    required this.filters,
    required this.onAddPlaylist,
    required this.onFollowArtist,
    required this.onSaveAlbum,
    required this.onSubscribePodcast,
  });

  @override
  State<_AddLibrarySheet> createState() => _AddLibrarySheetState();
}

class _AddLibrarySheetState extends State<_AddLibrarySheet> {
  late int _selectedType;

  // Form state
  final _ctrl1 = TextEditingController();
  final _ctrl2 = TextEditingController();
  int _selectedColor = 0;
  bool _isPublic = false;

  final _colorOptions = [
    const Color(0xFF1E3A5F),
    const Color(0xFF2D1B4E),
    const Color(0xFF1A4035),
    const Color(0xFF4A1C1C),
    const Color(0xFF1E2A4A),
    const Color(0xFF3A1A2A),
    const Color(0xFF1DB8E8),
    const Color(0xFF6C4FD6),
  ];

  @override
  void initState() {
    super.initState();
    // Default ke filter aktif; jika "Semua", default ke Playlist
    _selectedType = widget.activeFilter == 0 ? 1 : widget.activeFilter;
  }

  @override
  void dispose() {
    _ctrl1.dispose();
    _ctrl2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 36,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add_rounded,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              const Text(
                'Tambah ke Pustaka',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Tipe selector chips
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final types = ['Playlist', 'Album', 'Artis', 'Podcast'];
                final idx = i + 1;
                final isActive = _selectedType == idx;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedType = idx;
                    _ctrl1.clear();
                    _ctrl2.clear();
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      types[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            isActive ? Colors.white : AppColors.textMuted,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),
          Divider(color: Colors.white.withOpacity(0.07)),
          const SizedBox(height: 16),

          // Form berdasarkan tipe
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: KeyedSubtree(
              key: ValueKey(_selectedType),
              child: _buildForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    switch (_selectedType) {
      case 1:
        return _playlistForm();
      case 2:
        return _twoFieldForm('Judul Album', 'Nama Artis', 'Simpan Album',
            Icons.album_rounded, _submitAlbum);
      case 3:
        return _twoFieldForm('Nama Artis', 'Genre', 'Ikuti Artis',
            Icons.person_rounded, _submitArtist);
      case 4:
        return _twoFieldForm('Nama Podcast', 'Nama Host', 'Ikuti Podcast',
            Icons.mic_rounded, _submitPodcast);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _playlistForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Color picker
        const Text('Pilih Warna',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted)),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _colorOptions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => setState(() => _selectedColor = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _colorOptions[i],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedColor == i
                        ? Colors.white
                        : Colors.transparent,
                    width: 2.5,
                  ),
                ),
                child: _selectedColor == i
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 18)
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text('Nama Playlist',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted)),
        const SizedBox(height: 8),
        _textField(_ctrl1, 'Nama playlist kamu...'),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: () => setState(() => _isPublic = !_isPublic),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color:
                      _isPublic ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: _isPublic
                        ? AppColors.primary
                        : AppColors.textMuted,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: _isPublic
                    ? const Icon(Icons.check,
                        color: Colors.white, size: 14)
                    : null,
              ),
              const SizedBox(width: 10),
              const Text('Jadikan publik',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _submitButton('Buat Playlist', Icons.add_rounded, _submitPlaylist),
      ],
    );
  }

  Widget _twoFieldForm(
    String label1,
    String label2,
    String btnLabel,
    IconData icon,
    VoidCallback onSubmit,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label1,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted)),
        const SizedBox(height: 8),
        _textField(_ctrl1, '$label1...'),
        const SizedBox(height: 14),
        Text(label2,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted)),
        const SizedBox(height: 8),
        _textField(_ctrl2, '$label2...'),
        const SizedBox(height: 20),
        _submitButton(btnLabel, icon, onSubmit),
      ],
    );
  }

  Widget _textField(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: AppColors.textMuted, fontSize: 14),
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _submitButton(
      String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitPlaylist() {
    final name = _ctrl1.text.trim();
    if (name.isEmpty) return;
    widget.onAddPlaylist(name, _colorOptions[_selectedColor]);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Playlist "$name" berhasil dibuat!'),
      duration: const Duration(seconds: 2),
    ));
  }

  void _submitAlbum() {
    final title = _ctrl1.text.trim();
    final artist = _ctrl2.text.trim();
    if (title.isEmpty) return;
    widget.onSaveAlbum(title, artist.isEmpty ? 'Artis Tidak Diketahui' : artist);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Album "$title" disimpan ke pustaka!'),
      duration: const Duration(seconds: 2),
    ));
  }

  void _submitArtist() {
    final name = _ctrl1.text.trim();
    final genre = _ctrl2.text.trim();
    if (name.isEmpty) return;
    widget.onFollowArtist(name, genre.isEmpty ? 'Musik' : genre);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Kamu mengikuti "$name"!'),
      duration: const Duration(seconds: 2),
    ));
  }

  void _submitPodcast() {
    final title = _ctrl1.text.trim();
    final host = _ctrl2.text.trim();
    if (title.isEmpty) return;
    widget.onSubscribePodcast(
        title, host.isEmpty ? 'Host Tidak Diketahui' : host);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Podcast "$title" ditambahkan!'),
      duration: const Duration(seconds: 2),
    ));
  }
}
