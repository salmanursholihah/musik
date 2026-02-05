import 'package:flutter/material.dart';
import 'package:musik/features/presentation/widgets/playlist_card.dart';
import 'package:musik/features/presentation/widgets/song_tile.dart';

class OnlineHomePage extends StatelessWidget {
  const OnlineHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [

          /// SEARCH
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Cari lagu, daftar putar, dan penyanyi",
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// PLAYLIST CATEGORY
          const Text("Playlist", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                PlaylistCard(title: "Lagi Viral"),
                PlaylistCard(title: "Pop Now"),
                PlaylistCard(title: "Lagi Hits"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// SONG LIST
          ...List.generate(8, (i) => const SongTile()),
        ],
      ),
    );
  }
}
