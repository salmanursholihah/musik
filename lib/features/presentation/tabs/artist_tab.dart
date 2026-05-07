import 'package:flutter/material.dart';

class ArtisTab extends StatelessWidget {
  const ArtisTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (_, i) {
        return ListTile(
          leading: const CircleAvatar(),
          title: Text("Artist $i"),
          subtitle: const Text("20 Lagu"),
        );
      },
    );
  }
}
