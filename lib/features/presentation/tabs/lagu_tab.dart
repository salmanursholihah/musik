import 'package:flutter/material.dart';

class LaguTab extends StatelessWidget {
  const LaguTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (_, i) {
        return ListTile(
          leading: _thumb(),
          title: Text("Lagu $i"),
          subtitle: const Text("Artist tak diketahui"),
          trailing: const Icon(Icons.more_vert),
        );
      },
    );
  }

  Widget _thumb() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
