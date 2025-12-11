import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String senderName;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.senderName,
    required this.text,
    required this.timestamp,
  });

  // Convert app data to Firestore format
  Map<String, dynamic> toMap() {
    return {
      'senderName': senderName,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp), // Converts DateTime to Timestamp
    };
  }

  // Convert Firestore data to app format
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      senderName: map['senderName'] ?? 'Anonymous',
      text: map['text'] ?? '',
      // FIXED: Safety check. If timestamp is missing, use "now" instead of crashing.
      timestamp: map['timestamp'] != null 
          ? (map['timestamp'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }
}