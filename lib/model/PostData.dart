
class PostData{
  int? albumId;
  int? id;
  String? title;
  String? url;
  String? thumbnailUrl;

  PostData({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  PostData.fromJson(Map<String, dynamic> json) {
    albumId = json['albumId'];
    id = json['id'];
    title = json['title'];
    url = json['url'];
    thumbnailUrl = json['thumbnailUrl'];
  }

}