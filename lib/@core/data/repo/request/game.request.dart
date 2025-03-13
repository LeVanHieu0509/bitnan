class GameRequest {
  final int id;
  final int? method;
  final String? session, record, link;

  GameRequest(
      {this.link, required this.id, this.session, this.record, this.method});
}
