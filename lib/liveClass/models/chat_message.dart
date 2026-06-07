class ChatMessage {
  final String msgId;      // ✅ document key
  final String senderId;
  final String senderName;
  final String text;
  final int timestamp;

  ChatMessage({
    required this.msgId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
  });

  factory ChatMessage.fromMap(Map data, String msgId ) {
    return ChatMessage(
      msgId: msgId,
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
      // ✅ don't store msgId in the map — it's the document key, not a field
    };
  }
}