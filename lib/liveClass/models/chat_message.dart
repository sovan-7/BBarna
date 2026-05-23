class ChatMessage {
  final String senderId;
  final String senderName;
  final String text;
  final int timestamp;

  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
  });

  factory ChatMessage.fromMap(Map data) {
    return ChatMessage(
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      text: data['text'] ?? '',
      timestamp: data['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "senderName": senderName,
      "text": text,
      "timestamp": timestamp,
    };
  }
}