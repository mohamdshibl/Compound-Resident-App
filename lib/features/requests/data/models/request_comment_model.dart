import '../../domain/entities/request_comment_entity.dart';

class RequestCommentModel extends RequestCommentEntity {
  const RequestCommentModel({
    required super.id,
    required super.requestId,
    required super.senderId,
    required super.senderName,
    required super.senderRole,
    required super.message,
    super.attachmentUrls,
    required super.createdAt,
  });

  factory RequestCommentModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return RequestCommentModel(
      id: id ?? json['id'] as String? ?? '',
      requestId: json['requestId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      senderName: json['senderName'] as String? ?? '',
      senderRole: json['senderRole'] as String? ?? 'resident',
      message: json['message'] as String? ?? '',
      attachmentUrls: (json['attachmentUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requestId': requestId,
      'senderId': senderId,
      'senderName': senderName,
      'senderRole': senderRole,
      'message': message,
      'attachmentUrls': attachmentUrls,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory RequestCommentModel.fromEntity(RequestCommentEntity entity) {
    return RequestCommentModel(
      id: entity.id,
      requestId: entity.requestId,
      senderId: entity.senderId,
      senderName: entity.senderName,
      senderRole: entity.senderRole,
      message: entity.message,
      attachmentUrls: entity.attachmentUrls,
      createdAt: entity.createdAt,
    );
  }
}
