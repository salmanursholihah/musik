import 'package:flutter/material.dart';

class SongTile extends StatelessWidget {
  const SongTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      title: const Text("Internet Girl"),
      subtitle: const Text("KATSEYE"),
      trailing: PopupMenuButton(
        itemBuilder: (_) => const [
          PopupMenuItem(child: Text("Tambah Playlist")),
          PopupMenuItem(child: Text("Hapus")),
        ],
      ),
    );
  }
}
