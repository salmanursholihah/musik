import 'package:flutter/material.dart';

class FolderTab extends StatelessWidget {
  const FolderTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, i) {
        return ListTile(
          leading: const Icon(Icons.folder),
          title: Text("Folder Musik $i"),
          subtitle: const Text("12 File"),
        );
      },
    );
  }
}
