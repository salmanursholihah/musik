import 'package:flutter/material.dart';
import 'package:musik/features/presentation/widgets/ranking_card.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: const [

          Text(
            "Peringkat",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 20),

          RankingCard(title: "Indonesia Hits"),
          RankingCard(title: "Dangdut Hits"),
        ],
      ),
    );
  }
}
