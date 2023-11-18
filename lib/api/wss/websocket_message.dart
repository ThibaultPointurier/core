abstract interface class WebsocketMessage<T> {
  String get channelName;

  DateTime get createdAt;

  String get originalContent;

  abstract T content;
}

final class WebsocketMessageImpl<T> implements WebsocketMessage<T> {
  @override
  final String channelName;

  @override
  final DateTime createdAt;

  @override
  final String originalContent;

  @override
  T content;

  WebsocketMessageImpl(
      {required this.channelName,
      required this.createdAt,
      required this.originalContent,
      required this.content});
}
