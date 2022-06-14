// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      id: json['id'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      message: json['message'] == null
          ? null
          : Message.fromJson(json['message'] as Map<String, dynamic>),
      image: json['image'] as String?,
      icon: json['icon'] as String?,
      status: json['status'] as String?,
      subscription: json['subscription'] == null
          ? null
          : Subscription.fromJson(json['subscription'] as Map<String, dynamic>),
      readAt: json['readAt'] as int?,
      createdAt: json['createdAt'] as int?,
      updatedAt: json['updatedAt'] as int?,
      receivedAt: json['receivedAt'] as int?,
      imageThumb: json['imageThumb'] as String?,
      animation: json['animation'] as String?,
      tracking: json['tracking'] as String?,
      subjectName: json['subjectName'] as String?,
      isSubscribed: json['isSubscribed'] as bool?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'image': instance.image,
      'icon': instance.icon,
      'status': instance.status,
      'subscription': instance.subscription,
      'readAt': instance.readAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'receivedAt': instance.receivedAt,
      'imageThumb': instance.imageThumb,
      'animation': instance.animation,
      'tracking': instance.tracking,
      'subjectName': instance.subjectName,
      'isSubscribed': instance.isSubscribed,
    };

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) => Subscription(
      targetId: json['targetId'] as String?,
      targetType: json['targetType'] as String?,
      targetName: json['targetName'] as String?,
      level: json['level'] as int?,
    );

Map<String, dynamic> _$SubscriptionToJson(Subscription instance) =>
    <String, dynamic>{
      'targetId': instance.targetId,
      'targetType': instance.targetType,
      'targetName': instance.targetName,
      'level': instance.level,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      text: json['text'] as String?,
      highlights: (json['highlights'] as List<dynamic>?)
          ?.map((e) => Highlights.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'text': instance.text,
      'highlights': instance.highlights,
    };

Highlights _$HighlightsFromJson(Map<String, dynamic> json) => Highlights(
      offset: json['offset'] as int?,
      length: json['length'] as int?,
    );

Map<String, dynamic> _$HighlightsToJson(Highlights instance) =>
    <String, dynamic>{
      'offset': instance.offset,
      'length': instance.length,
    };
