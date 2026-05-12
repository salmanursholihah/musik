import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AllSongsPage extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final bool showRank;

  const AllSongsPage({
    super.key,
    required this.title,
    required this.items,
    this.showRank = false,
  });

  @override
  State<AllSongsPage> createState() => _AllSongsPageState();
}

class _AllSongsPageState extends State<AllSongsPage> {
  String _searchQuery = '';
  String? _playingTitle;

  List<Map<String, dynamic>> get _filtered {
    if (_searchQuery.isEmpty) return widget.items;
    return widget.items.where((s) {
      final q = _searchQuery.toLowerCase();
      return (s['title'] as String).toLowerCase().contains(q) ||
          (s['artist'] as String).toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Collapsible App Bar ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              title: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Grid mosaic cover art dari item-item
                  _buildMosaicBackground(),
                  // Gradient overlay
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x661A3A5C),
                          AppColors.background,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Search bar ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Cari di ${widget.title}…',
                    hintStyle: const TextStyle(
                        color: AppColors.textMuted, fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppColors.textMuted, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? GestureDetector(
                            onTap: () => setState(() => _searchQuery = ''),
                            child: const Icon(Icons.close_rounded,
                                color: AppColors.textMuted, size: 18),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
          ),

          // ── Jumlah hasil ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(
                '${_filtered.length} lagu',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textMuted),
              ),
            ),
          ),

          // ── Daftar lagu ───────────────────────────────────────────────────
          _filtered.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded,
                            color: AppColors.textMuted, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          'Tidak ada hasil untuk\n"$_searchQuery"',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final song = _filtered[index];
                      final isActive = _playingTitle == song['title'];
                      return _SongTile(
                        song: song,
                        index: index,
                        isActive: isActive,
                        showRank: widget.showRank,
                        onTap: () => setState(
                            () => _playingTitle = song['title'] as String),
                      );
                    },
                    childCount: _filtered.length,
                  ),
                ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // Mosaic dari 4 cover art pertama sebagai background header
  Widget _buildMosaicBackground() {
    final covers = widget.items
        .take(4)
        .map((e) => e['imageUrl'] as String? ?? '')
        .toList();

    if (covers.isEmpty) {
      return Container(color: const Color(0xFF1A3A5C));
    }

    if (covers.length == 1) {
      return Image.network(
        covers[0],
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Container(color: const Color(0xFF1A3A5C)),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _coverTile(covers[0]),
              ),
              if (covers.length > 2)
                Expanded(
                  child: _coverTile(covers[2]),
                ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _coverTile(covers[1]),
              ),
              if (covers.length > 3)
                Expanded(
                  child: _coverTile(covers[3]),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _coverTile(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) =>
          Container(color: const Color(0xFF1E3A5F)),
    );
  }
}

// ── Song tile individual ────────────────────────────────────────────────────
class _SongTile extends StatelessWidget {
  final Map<String, dynamic> song;
  final int index;
  final bool isActive;
  final bool showRank;
  final VoidCallback onTap;

  const _SongTile({
    required this.song,
    required this.index,
    required this.isActive,
    required this.showRank,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = song['imageUrl'] as String? ?? '';
    final color = song['color'] is Color
        ? song['color'] as Color
        : AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: AppColors.primary.withOpacity(0.4))
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            // Nomor urut / rank
            if (showRank)
              SizedBox(
                width: 28,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isActive ? AppColors.primary : AppColors.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Cover art
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _artFallback(color),
                        )
                      : _artFallback(color),
                  // Overlay equalizer saat aktif
                  if (isActive)
                    Container(
                      width: 52,
                      height: 52,
                      color: Colors.black.withOpacity(0.45),
                      child: const Icon(
                        Icons.equalizer_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            // Info lagu
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song['title'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isActive ? AppColors.primary : Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    song['artist'] as String,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Durasi / status
            if (isActive)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Diputar',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else if ((song['dur'] as String?)?.isNotEmpty == true)
              Text(
                song['dur'] as String,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textMuted),
              ),

            const SizedBox(width: 8),

            // More options
            GestureDetector(
              onTap: () => _showOptions(context, song),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.more_vert,
                    color: AppColors.textMuted, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _artFallback(Color color) {
    return Container(
      width: 52,
      height: 52,
      color: color,
      child: const Icon(
        Icons.music_note,
        color: Colors.white38,
        size: 24,
      ),
    );
  }

  void _showOptions(BuildContext context, Map<String, dynamic> song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1E2A3A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 20),

            // Header lagu
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    song['imageUrl'] as String? ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 50,
                      height: 50,
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.music_note,
                          color: Colors.white38, size: 22),
                    ),
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
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        song['artist'] as String,
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white10, height: 1),
            const SizedBox(height: 8),

            // Menu opsi
            _optionTile(
                icon: Icons.playlist_add_rounded,
                label: 'Tambah ke playlist'),
            _optionTile(
                icon: Icons.favorite_border_rounded,
                label: 'Tambah ke favorit'),
            _optionTile(
                icon: Icons.download_rounded, label: 'Unduh lagu'),
            _optionTile(
                icon: Icons.share_rounded, label: 'Bagikan'),
          ],
        ),
      ),
    );
  }

  Widget _optionTile({required IconData icon, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70, size: 22),
        title: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        contentPadding: EdgeInsets.zero,
        dense: true,
        onTap: () {},
      ),
    );
  }
}
