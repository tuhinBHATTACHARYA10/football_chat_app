import 'package:flutter/material.dart';
import 'match_list_screen.dart';

class LeagueSelectScreen extends StatelessWidget {
  final String userName;
  final Color teamColor;

  // FIXED: Using LOCAL ASSETS (Filenames match what you saved)
  final List<Map<String, String>> leagues = [
    {
      'name': 'Premier League',
      'code': 'PL', 
      'image': 'assets/images/pl.png' 
    },
    {
      'name': 'La Liga',
      'code': 'PD',
      'image': 'assets/images/laliga.png'
    },
    {
      'name': 'Serie A',
      'code': 'SA',
      'image': 'assets/images/seriea.png'
    },
    {
      'name': 'Bundesliga',
      'code': 'BL1',
      'image': 'assets/images/bundesliga.png'
    },
    {
      'name': 'Ligue 1',
      'code': 'FL1',
      'image': 'assets/images/ligue1.png'
    },
    {
      'name': 'Champions League',
      'code': 'CL',
      'image': 'assets/images/cl.png'
    },
  ];

  LeagueSelectScreen({
    super.key, 
    required this.userName, 
    required this.teamColor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Competition", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF37003C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: leagues.length,
          itemBuilder: (context, index) {
            final league = leagues[index];
            
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatchListScreen(
                        userName: userName,
                        teamColor: teamColor,
                        leagueCode: league['code']!,
                        leagueName: league['name']!,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Image.asset(
                          league['image']!,
                          fit: BoxFit.contain,
                          errorBuilder: (c,e,s) => const Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          league['name']!,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}