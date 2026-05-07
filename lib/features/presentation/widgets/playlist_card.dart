import 'package:flutter/material.dart';
import 'package:musik/features/presentation/pages/playlist_details_page.dart';

class PlaylistCard extends StatelessWidget {
  final String title;
  const PlaylistCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PlaylistDetailPage()),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
