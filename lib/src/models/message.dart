class Message {
  final String id;
  final String senderId;
  final String recipientId;
  final String message;
  final DateTime sentTime;
  bool isRead;
  bool isReply;
  final String messageReplyId;

  Message({
    this.id,
    this.senderId,
    this.recipientId,
    this.message,
    this.sentTime,
    this.isRead,
    this.isReply,
    this.messageReplyId,
  });
}
