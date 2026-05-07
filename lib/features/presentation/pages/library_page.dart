// import 'package:flutter/material.dart';
// import 'package:musik/features/presentation/widgets/song_tile.dart';

// class LibraryPage extends StatelessWidget {
//   const LibraryPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 6,
//       child: SafeArea(
//         child: Column(
//           children: [
//             const TabBar(
//               isScrollable: true,
//               tabs: [
//                 Tab(text: "Lagu"),
//                 Tab(text: "Video"),
//                 Tab(text: "Artis"),
//                 Tab(text: "Album"),
//                 Tab(text: "Folder"),
//                 Tab(text: "Cache"),
//               ],
//             ),

//             Expanded(
//               child: TabBarView(
//                 children: List.generate(6, (i) {
//                   return ListView.builder(
//                     padding: const EdgeInsets.only(bottom: 120),
//                     itemCount: 15,
//                     itemBuilder: (_, index) => const SongTile(),
//                   );
//                 }),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  int tabIndex = 0;

  final tabs = ["Lagu", "Video", "Artis", "Album", "Folder", "Cache"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            /// SEARCH
            _searchBar(),

            const SizedBox(height: 14),

            /// SHORTCUT CARD
            _shortcutRow(),

            const SizedBox(height: 20),

            /// TAB
            _tabBar(),

            const SizedBox(height: 14),

            /// LIST CONTENT
            Expanded(child: _contentList()),
          ],
        ),
      ),
    );
  }

  /// SEARCH BAR
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 46,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            Icon(Icons.search),
            SizedBox(width: 10),
            Text("Cari lagu, daftar putar, dan penyanyi"),
            Spacer(),
            Icon(Icons.mic_none),
          ],
        ),
      ),
    );
  }

  /// SHORTCUT
  Widget _shortcutRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _shortcutCard("Favorit", Colors.purple),
          const SizedBox(width: 12),
          _shortcutCard("Daftar putar", Colors.teal),
          const SizedBox(width: 12),
          _shortcutCard("Terkini", Colors.orange),
        ],
      ),
    );
  }

  Widget _shortcutCard(String title, Color color) {
    return Expanded(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color, color.withOpacity(.7)]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// TAB BAR
  Widget _tabBar() {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (_, i) {
          final selected = tabIndex == i;

          return GestureDetector(
            onTap: () => setState(() => tabIndex = i),

            child: Container(
              margin: const EdgeInsets.only(right: 18),
              child: Column(
                children: [
                  Text(
                    tabs[i],
                    style: TextStyle(
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (selected)
                    Container(
                      height: 3,
                      width: 26,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// CONTENT LIST
  Widget _contentList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 12,
      itemBuilder: (_, i) => _fileTile(),
    );
  }

  /// FILE TILE
  Widget _fileTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          /// THUMB
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          const SizedBox(width: 14),

          /// TEXT
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "VID_20250102_11041",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Artis tak diketahui",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          const Icon(Icons.more_vert),
        ],
      ),
    );
  }
}
