import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'message_model.dart';
import 'football_service.dart';

class MatchChatScreen extends StatefulWidget {
  final String matchId;
  final String userName;
  final Color teamColor;

  const MatchChatScreen({
    super.key,
    required this.matchId,
    required this.userName,
    required this.teamColor,
  });

  @override
  State<MatchChatScreen> createState() => _MatchChatScreenState();
}

class _MatchChatScreenState extends State<MatchChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FootballService _footballService = FootballService();
  
  String _homeTeam = "Loading...";
  String _awayTeam = "";
  int _homeScore = 0;
  int _awayScore = 0;
  String _status = "VS";
  Timer? _scoreTimer;

  @override
  void initState() {
    super.initState();
    _fetchScore();
    // Update score every 60 seconds
    _scoreTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _fetchScore();
    });
  }

  @override
  void dispose() {
    _scoreTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchScore() async {
    final matchData = await _footballService.fetchMatchScore(widget.matchId);
    
    if (matchData.isNotEmpty && mounted) {
      setState(() {
        _homeTeam = matchData['homeTeam']['shortName'] ?? matchData['homeTeam']['name'];
        _awayTeam = matchData['awayTeam']['shortName'] ?? matchData['awayTeam']['name'];
        _status = matchData['status'];
        _homeScore = matchData['score']['fullTime']['home'] ?? 0;
        _awayScore = matchData['score']['fullTime']['away'] ?? 0;
      });
    }
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final newMessage = ChatMessage(
      senderName: widget.userName,
      text: _controller.text,
      timestamp: DateTime.now(),
    );

    await _firestore
        .collection('matches')
        .doc(widget.matchId)
        .collection('messages')
        .add(newMessage.toMap());

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.teamColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          children: [
            Text(
              "$_homeTeam vs $_awayTeam",
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            Text(
              _status == 'IN_PLAY' || _status == 'PAUSED' || _status == 'FINISHED'
                  ? "$_homeScore - $_awayScore" 
                  : _status,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('matches')
                  .doc(widget.matchId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    if (data['text'] == null) return const SizedBox();

                    final message = ChatMessage.fromMap(data);
                    final isMe = message.senderName == widget.userName;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? widget.teamColor.withOpacity(0.8) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isMe)
                              Text(
                                message.senderName,
                                style: TextStyle(fontWeight: FontWeight.bold, color: widget.teamColor, fontSize: 12),
                              ),
                            Text(message.text, style: TextStyle(color: isMe ? Colors.white : Colors.black87)),
                            Text(
                              DateFormat('h:mm a').format(message.timestamp),
                              style: TextStyle(fontSize: 10, color: isMe ? Colors.white70 : Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: widget.teamColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}