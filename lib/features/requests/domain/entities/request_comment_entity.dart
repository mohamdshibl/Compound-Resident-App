class RequestCommentEntity {
  final String id;
  final String requestId;
  final String senderId;
  final String senderName;
  final String senderRole;
  final String message;
  final List<String> attachmentUrls;
  final DateTime createdAt;

  const RequestCommentEntity({
    required this.id,
    required this.requestId,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.message,
    this.attachmentUrls = const [],
    required this.createdAt,
  });
}
