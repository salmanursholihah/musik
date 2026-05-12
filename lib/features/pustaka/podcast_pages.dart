import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PodcastDetailPage extends StatefulWidget {
  final String title;
  final String host;
  final int episodeCount;
  final String category;
  final Color color;
  final bool isSubscribed;
  final int newEpisodes;

  const PodcastDetailPage({
    super.key,
    required this.title,
    required this.host,
    required this.episodeCount,
    required this.category,
    required this.color,
    this.isSubscribed = false,
    this.newEpisodes = 0,
  });

  @override
  State<PodcastDetailPage> createState() => _PodcastDetailPageState();
}

class _PodcastDetailPageState extends State<PodcastDetailPage> {
  late bool _isSubscribed;
  int? _playingIndex;
  int _filterIndex = 0; // 0=Semua 1=Belum Didengar 2=Sudah Didengar

  final _episodes = <Map<String, dynamic>>[
    {
      'title': 'Bagaimana Cara Belajar Efektif di Era Digital?',
      'date':  '12 Mei 2026',
      'duration': '1 j 12 mnt',
      'played': false,
      'isNew': true,
      'desc': 'Di episode ini kita membahas strategi belajar yang terbukti efektif untuk generasi digital, mulai dari teknik Pomodoro hingga spaced repetition.',
    },
    {
      'title': 'Membangun Kebiasaan Positif dalam 30 Hari',
      'date':  '5 Mei 2026',
      'duration': '58 mnt',
      'played': false,
      'isNew': true,
      'desc': 'Mengupas penelitian terbaru soal pembentukan kebiasaan dan bagaimana otak kita beradaptasi dengan rutinitas baru.',
    },
    {
      'title': 'Psikologi di Balik Produktivitas',
      'date':  '28 Apr 2026',
      'duration': '1 j 5 mnt',
      'played': true,
      'isNew': false,
      'desc': 'Wawancara eksklusif dengan pakar psikologi tentang mengapa kita sering menunda pekerjaan dan cara mengatasinya.',
    },
    {
      'title': 'Investasi untuk Generasi Z: Mulai dari Mana?',
      'date':  '20 Apr 2026',
      'duration': '45 mnt',
      'played': true,
      'isNew': false,
      'desc': 'Panduan lengkap memulai investasi saham, reksa dana, dan kripto khusus untuk anak muda yang baru memulai.',
    },
    {
      'title': 'Rahasia Kreator Konten Sukses di Indonesia',
      'date':  '12 Apr 2026',
      'duration': '1 j 20 mnt',
      'played': false,
      'isNew': false,
      'desc': 'Berbincang dengan 3 kreator konten top Indonesia tentang perjalanan mereka, strategi konten, dan monetisasi.',
    },
    {
      'title': 'Kesehatan Mental: Tabu yang Harus Dibicarakan',
      'date':  '5 Apr 2026',
      'duration': '1 j 8 mnt',
      'played': true,
      'isNew': false,
      'desc': 'Percakapan terbuka tentang stigma kesehatan mental di Indonesia dan langkah-langkah mencari pertolongan.',
    },
    {
      'title': 'AI dan Masa Depan Pekerjaan Kita',
      'date':  '28 Mar 2026',
      'duration': '52 mnt',
      'played': true,
      'isNew': false,
      'desc': 'Eksplorasi mendalam tentang pekerjaan mana yang akan tergantikan AI dan skill apa yang perlu dikuasai.',
    },
    {
      'title': 'Travelling Hemat ke Eropa: Tips & Trik',
      'date':  '20 Mar 2026',
      'duration': '1 j 30 mnt',
      'played': false,
      'isNew': false,
      'desc': 'Panduan praktis backpacking Eropa dengan budget minimal, termasuk akomodasi, transportasi, dan kuliner lokal.',
    },
  ];

  List<Map<String, dynamic>> get _filteredEpisodes {
    switch (_filterIndex) {
      case 1:
        return _episodes.where((e) => !(e['played'] as bool)).toList();
      case 2:
        return _episodes.where((e) => e['played'] as bool).toList();
      default:
        return _episodes;
    }
  }

  @override
  void initState() {
    super.initState();
    _isSubscribed = widget.isSubscribed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ────────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 300,
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
                  // Podcast art
                  Positioned(
                    top: 60,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: widget.color,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withOpacity(0.6),
                              blurRadius: 30,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.mic_rounded,
                            color: Colors.white30, size: 70),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Info ──────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.host,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _infoPill(Icons.headphones_rounded,
                          '${widget.episodeCount} episode'),
                      const SizedBox(width: 10),
                      _infoPill(Icons.category_rounded, widget.category),
                      if (widget.newEpisodes > 0) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${widget.newEpisodes} baru',
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Subscribe + play latest
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            setState(() => _isSubscribed = !_isSubscribed),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 12),
                          decoration: BoxDecoration(
                            color: _isSubscribed
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: _isSubscribed
                                  ? AppColors.primary
                                  : Colors.white38,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            _isSubscribed ? 'Mengikuti' : 'Ikuti',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _isSubscribed
                                  ? Colors.white
                                  : Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _playingIndex = 0),
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_arrow_rounded,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 6),
                                Text(
                                  'Putar Terbaru',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Tentang Podcast',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.title} adalah podcast yang dipersembahkan oleh ${widget.host} dengan topik-topik menarik seputar ${widget.category.toLowerCase()}. '
                    'Setiap episode menghadirkan wawasan mendalam, wawancara eksklusif, dan diskusi yang inspiratif untuk para pendengar setia.',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),

                  // Filter chips
                  Row(
                    children: [
                      const Text(
                        'Episode',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      ...['Semua', 'Belum', 'Sudah'].asMap().entries.map((e) {
                        final isActive = _filterIndex == e.key;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _filterIndex = e.key),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.primary
                                  : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              e.value,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? Colors.white
                                    : AppColors.textMuted,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // ── Episode list ──────────────────────────────────────────────────
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) {
                final eps = _filteredEpisodes;
                if (i >= eps.length) return null;
                return _episodeTile(eps[i], i);
              },
              childCount: _filteredEpisodes.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _episodeTile(Map<String, dynamic> ep, int i) {
    final isActive = _playingIndex == i;
    final isPlayed = ep['played'] as bool;
    final isNew = ep['isNew'] as bool;

    return GestureDetector(
      onTap: () => _showEpisodeSheet(ep, i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive
                ? AppColors.primary.withOpacity(0.4)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: isActive
                      ? const Icon(Icons.pause_circle_rounded,
                          color: AppColors.primary, size: 32)
                      : const Icon(Icons.mic_rounded,
                          color: Colors.white30, size: 28),
                ),
                if (isNew)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('BARU',
                          style: TextStyle(
                              fontSize: 7,
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ep['title'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isPlayed ? Colors.white54 : Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    ep['desc'] as String,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textMuted, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        ep['date'] as String,
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textMuted),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: AppColors.textMuted,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.timer_outlined,
                          color: AppColors.textMuted, size: 11),
                      const SizedBox(width: 3),
                      Text(
                        ep['duration'] as String,
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textMuted),
                      ),
                      if (isPlayed) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.textMuted, size: 12),
                        const SizedBox(width: 3),
                        const Text('Sudah didengar',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          _playingIndex = i;
                          ep['played'] = true;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary
                                : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isActive
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 15,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isActive ? 'Sedang Diputar' : 'Putar',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.download_rounded,
                              color: AppColors.textMuted, size: 14),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _showEpisodeSheet(ep, i),
                        child: const Icon(Icons.more_vert_rounded,
                            color: AppColors.textMuted, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEpisodeSheet(Map<String, dynamic> ep, int i) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
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
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.mic_rounded,
                      color: Colors.white30, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ep['title'] as String,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Text(widget.host,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Divider(color: Colors.white.withOpacity(0.07)),
            ...[
              {'icon': Icons.play_arrow_rounded,     'label': 'Putar episode'},
              {'icon': Icons.download_rounded,        'label': 'Unduh episode'},
              {'icon': Icons.share_rounded,           'label': 'Bagikan'},
              {'icon': Icons.check_circle_outline_rounded,
               'label': ep['played'] == true
                   ? 'Tandai belum didengar'
                   : 'Tandai sudah didengar'},
              {'icon': Icons.flag_outlined,           'label': 'Laporkan episode'},
            ].map((opt) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(opt['icon'] as IconData,
                      color: AppColors.textSecondary, size: 22),
                  title: Text(opt['label'] as String,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    if ((opt['label'] as String).startsWith('Putar')) {
                      setState(() {
                        _playingIndex = i;
                        ep['played'] = true;
                      });
                    } else if ((opt['label'] as String).startsWith('Tandai')) {
                      setState(() =>
                          ep['played'] = !(ep['played'] as bool));
                    }
                  },
                )),
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
