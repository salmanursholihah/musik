// import 'package:flutter/material.dart';
// import 'package:musik/features/presentation/widgets/playlist_card.dart';
// import 'package:musik/features/presentation/widgets/song_tile.dart';

// class OnlineHomePage extends StatelessWidget {
//   const OnlineHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: ListView(
//         padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
//         children: [
//           /// SEARCH
//           Container(
//             height: 50,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: const TextField(
//               decoration: InputDecoration(
//                 hintText: "Cari lagu, daftar putar, dan penyanyi",
//                 prefixIcon: Icon(Icons.search),
//                 border: InputBorder.none,
//               ),
//             ),
//           ),

//           const SizedBox(height: 20),

//           /// PLAYLIST CATEGORY
//           const Text(
//             "Playlist",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 12),

//           SizedBox(
//             height: 160,
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: const [
//                 PlaylistCard(title: "Lagi Viral"),
//                 PlaylistCard(title: "Pop Now"),
//                 PlaylistCard(title: "Lagi Hits"),
//               ],
//             ),
//           ),

//           const SizedBox(height: 20),

//           /// SONG LIST
//           ...List.generate(8, (i) => const SongTile()),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class OnlineHomePage extends StatelessWidget {
  const OnlineHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              _header(),

              const SizedBox(height: 20),

              /// RECENT PLAY
              _sectionTitle("Baru-baru ini diputar"),
              const SizedBox(height: 14),
              _recentCard(),

              const SizedBox(height: 24),

              /// CHART
              _sectionTitle("Tangga Lagu"),
              const SizedBox(height: 14),
              _chartRow(),

              const SizedBox(height: 24),

              /// NEW RELEASE
              _sectionTitle("Rilisan Baru"),
              const SizedBox(height: 14),
              _horizontalMusicList(),

              const SizedBox(height: 24),

              /// GENRE
              _sectionTitle("Lintas Genre"),
              const SizedBox(height: 14),
              _horizontalMusicList(),

              const SizedBox(height: 24),

              /// MOOD
              _sectionTitle("Sesuai Suasana"),
              const SizedBox(height: 14),
              _horizontalMusicList(),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  /// HEADER
  Widget _header() {
    return Row(
      children: [
        const Icon(Icons.tune),
        const Spacer(),
        const Text(
          "Lumo",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        const Icon(Icons.download_outlined),
        const SizedBox(width: 12),
        const Icon(Icons.notifications_none),
      ],
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Text("Lainnya"),
              SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 18),
            ],
          ),
        ),
      ],
    );
  }

  /// RECENT CARD
  Widget _recentCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(height: 8),
        const Text("Internet Girl"),
      ],
    );
  }

  /// CHART ROW
  Widget _chartRow() {
    return Row(
      children: [
        Expanded(child: _chartCard()),
        const SizedBox(width: 12),
        Expanded(child: _chartCard()),
      ],
    );
  }

  Widget _chartCard() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }

  /// MUSIC LIST HORIZONTAL
  Widget _horizontalMusicList() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (_, i) => _musicCard(),
      ),
    );
  }

  /// MUSIC CARD
  Widget _musicCard() {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              /// PLAY BUTTON OVERLAY
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.play_arrow),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          const Text(
            "Playlist Name",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
