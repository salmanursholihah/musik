import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../home/home_page.dart';
import '../search/search_page.dart';
import '../profile/profile_page.dart';
import '../subscription/subscription_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fabCtrl;
  late Animation<double> _fabScale;

  final _pages = const [
    HomePage(),
    SearchPage(),
    _LibraryPlaceholder(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _fabCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fabScale = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _fabCtrl, curve: Curves.elasticOut));
    _fabCtrl.forward();
  }

  @override
  void dispose() {
    _fabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),

          // Mini Player floating

        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
                color: Colors.white.withOpacity(0.08), width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle:
              const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search_rounded),
              label: 'Cari',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music_outlined),
              activeIcon: Icon(Icons.library_music_rounded),
              label: 'Pustaka',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniPlayer extends StatefulWidget {
  @override
  State<_MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<_MiniPlayer>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = true;
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _slideAnim = Tween<Offset>(
            begin: const Offset(0, 1.5), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 600), _slideCtrl.forward);
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnim,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('/player',
            arguments: {'title': 'Hati-Hati di Jalan', 'artist': 'Tulus'}),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: AppColors.primary.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                // Progress
                FractionallySizedBox(
                  widthFactor: 0.35,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    color: AppColors.primary.withOpacity(0.12),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.music_note_rounded,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hati-Hati di Jalan',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Tulus',
                              style: TextStyle(
                                  fontSize: 11, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _isPlaying = !_isPlaying),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            _isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            key: ValueKey(_isPlaying),
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.skip_next_rounded,
                          color: Colors.white, size: 26),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LibraryPlaceholder extends StatelessWidget {
  const _LibraryPlaceholder();

  @override
  Widget build(BuildContext context) {
    final items = [
      'Favorit Saya',
      'Lagu Unduhan',
      'Rock Terbaik',
      'Chill Weekend',
      'Old Songs',
      'Workout Mix',
    ];

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pustaka Saya',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 22),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Playlist', 'Album', 'Artis', 'Podcast']
                    .map(
                      (t) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(t,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12)),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final colors = [
                  const Color(0xFF1E3A5F),
                  const Color(0xFF2D1B4E),
                  const Color(0xFF1A4035),
                  const Color(0xFF4A1C1C),
                  const Color(0xFF2C2A1A),
                  const Color(0xFF1E2A4A),
                ];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: colors[i % colors.length],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.music_note,
                            color: Colors.white30, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              items[i],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Playlist • 12 lagu',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.more_vert,
                          color: AppColors.textMuted, size: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
