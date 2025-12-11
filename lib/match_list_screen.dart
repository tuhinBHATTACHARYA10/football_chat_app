import 'package:flutter/material.dart';
import 'match_chat_screen.dart';
import 'football_service.dart';
import 'main.dart'; // For theme switcher

class MatchListScreen extends StatefulWidget {
  final String userName;
  final Color teamColor;
  final String leagueCode; // NEW: Receives 'PL' or 'PD'
  final String leagueName; // NEW: Receives 'Premier League'

  const MatchListScreen({
    super.key, 
    required this.userName, 
    required this.teamColor,
    required this.leagueCode,
    required this.leagueName,
  });

  @override
  State<MatchListScreen> createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> {
  final FootballService _footballService = FootballService();
  late Future<List<dynamic>> _matchesFuture;

  @override
  void initState() {
    super.initState();
    // Fetch matches for the SPECIFIC league selected
    _matchesFuture = _footballService.fetchLiveMatches(widget.leagueCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.leagueName),
        actions: [
          IconButton(
            icon: Icon(themeNotifier.value == ThemeMode.light 
                ? Icons.dark_mode 
                : Icons.light_mode),
            onPressed: () {
              themeNotifier.value = themeNotifier.value == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _matchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text("Error loading matches"));
          }

          final matches = snapshot.data!;

          if (matches.isEmpty) {
            return const Center(child: Text("No matches scheduled soon."));
          }

          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              final home = match['homeTeam'];
              final away = match['awayTeam'];
              final String matchId = match['id'].toString(); 
              
              // Get Crest URLs (Logos)
              // Note: Some logos are SVG, which might need a package,
              // but we use errorBuilder to be safe.
              final String homeLogo = home['crest'] ?? '';
              final String awayLogo = away['crest'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatchChatScreen(
                          matchId: matchId,
                          userName: widget.userName,
                          teamColor: widget.teamColor,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Home Team
                        Expanded(
                          child: Column(
                            children: [
                              Image.network(homeLogo, height: 40, width: 40, 
                                errorBuilder: (c,e,s) => const Icon(Icons.shield)),
                              const SizedBox(height: 5),
                              Text(home['shortName'] ?? home['name'], textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                        
                        // VS / Score
                        Column(
                          children: [
                            Text(
                              match['status'] == 'IN_PLAY' 
                                  ? "${match['score']['fullTime']['home'] ?? 0} - ${match['score']['fullTime']['away'] ?? 0}"
                                  : "VS",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              match['status'],
                              style: TextStyle(
                                fontSize: 10, 
                                color: match['status'] == 'IN_PLAY' ? Colors.red : Colors.grey
                              ),
                            ),
                          ],
                        ),

                        // Away Team
                        Expanded(
                          child: Column(
                            children: [
                              Image.network(awayLogo, height: 40, width: 40,
                                errorBuilder: (c,e,s) => const Icon(Icons.shield)),
                              const SizedBox(height: 5),
                              Text(away['shortName'] ?? away['name'], textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}