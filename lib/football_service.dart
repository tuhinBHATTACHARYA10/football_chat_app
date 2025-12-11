import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FootballService {
  // ⚠️ PASTE YOUR API KEY HERE
  static const String apiKey = 'af1e6b584778458298d7794759b3bba6'; 

  /// Fetches matches from Yesterday to Next 7 Days
  /// This ensures "Today's" games show up regardless of timezone differences.
  Future<List<dynamic>> fetchLiveMatches(String leagueCode) async {
    DateTime now = DateTime.now();
    
    // Window: Yesterday -> Next 7 Days
    DateTime dateFrom = now.subtract(const Duration(days: 1));
    DateTime dateTo = now.add(const Duration(days: 7));
    
    String fromStr = DateFormat('yyyy-MM-dd').format(dateFrom);
    String toStr = DateFormat('yyyy-MM-dd').format(dateTo);

    final String url = 'https://api.football-data.org/v4/competitions/$leagueCode/matches?'
        'status=SCHEDULED,LIVE,IN_PLAY,PAUSED,FINISHED'
        '&dateFrom=$fromStr&dateTo=$toStr';
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'X-Auth-Token': apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['matches'];
      } else {
        print("API Error (List): ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching match list: $e");
      return [];
    }
  }

  /// Fetches real-time score for the Chat Screen
  Future<Map<String, dynamic>> fetchMatchScore(String matchId) async {
    final String url = 'https://api.football-data.org/v4/matches/$matchId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'X-Auth-Token': apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data; 
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }
}