import 'package:flutter/material.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 90),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 15),
        ],
      ),
      child: Row(
        children: [

          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Internet Girl", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("KATSEYE", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
