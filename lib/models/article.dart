class Article {
  final String id;
  final String texte;

  Article({required this.id, required this.texte});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String,
      texte: json['texte'] as String,
    );
  }
}
