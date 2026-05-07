import 'package:flutter/material.dart';
import 'package:musik/features/presentation/widgets/song_tile.dart';

class PlaylistDetailPage extends StatelessWidget {
  const PlaylistDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// HEADER
          Container(
            height: 260,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffE7A6B6), Color(0xffEED5DC)],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "K-POP NOW",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.deepPurple,
                  child: const Icon(Icons.play_arrow, color: Colors.white),
                ),
              ],
            ),
          ),

          /// SONG LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 120),
              itemCount: 15,
              itemBuilder: (_, i) => const SongTile(),
            ),
          ),
        ],
      ),
    );
  }
}
