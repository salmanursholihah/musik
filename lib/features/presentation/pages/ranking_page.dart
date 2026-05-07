// import 'package:flutter/material.dart';
// import 'package:musik/features/presentation/widgets/ranking_card.dart';

// class RankingPage extends StatelessWidget {
//   const RankingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: ListView(
//         padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
//         children: const [

//           Text(
//             "Peringkat",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),

//           SizedBox(height: 20),

//           RankingCard(title: "Indonesia Hits"),
//           RankingCard(title: "Dangdut Hits"),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();

  bool isSearching = false;

  final List<String> dummyResults = [
    "Mangu - fourtwnty",
    "DJ Remix 2025",
    "Stecu Stecu - Faris Adam",
    "Lesung Pipi - Raim Laode",
    "Taylor Swift - Lover",
    "Pamungkas - To The Bone",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _searchBar(),
            Expanded(child: isSearching ? _searchResult() : _popularSection()),
            _miniPlayer(),
          ],
        ),
      ),
    );
  }

  // ================= SEARCH BAR =================

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: searchController,
                onChanged: (v) {
                  setState(() {
                    isSearching = v.isNotEmpty;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Cari lagu, artis, album...",
                  border: InputBorder.none,
                ),
              ),
            ),
            const Icon(Icons.mic_none, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ================= POPULAR =================

  Widget _popularSection() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const Text(
          "Populer",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(child: _rankingCard(Colors.blue, Colors.purple)),
            const SizedBox(width: 12),
            Expanded(child: _rankingCard(Colors.orange, Colors.pink)),
          ],
        ),
      ],
    );
  }

  Widget _rankingCard(Color c1, Color c2) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 260,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [c1, c2]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          10,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              "${i + 1}. Lagu populer ${i + 1}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // ================= RESULT =================

  Widget _searchResult() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: dummyResults.length,
      itemBuilder: (_, i) {
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          title: Text(dummyResults[i]),
          subtitle: const Text("Artist Unknown"),
          trailing: const Icon(Icons.more_vert),
        );
      },
    );
  }

  // ================= MINI PLAYER =================

  Widget _miniPlayer() {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Internet Girl", style: TextStyle(color: Colors.white)),
                Text(
                  "KATSEYE",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.play_arrow, color: Colors.white),
        ],
      ),
    );
  }
}
