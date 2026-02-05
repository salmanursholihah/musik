import 'package:flutter/material.dart';
import 'package:musik/features/presentation/widgets/song_tile.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: SafeArea(
        child: Column(
          children: [

            const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: "Lagu"),
                Tab(text: "Video"),
                Tab(text: "Artis"),
                Tab(text: "Album"),
                Tab(text: "Folder"),
                Tab(text: "Cache"),
              ],
            ),

            Expanded(
              child: TabBarView(
                children: List.generate(6, (i) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 120),
                    itemCount: 15,
                    itemBuilder: (_, index) => const SongTile(),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
