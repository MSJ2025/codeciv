class Article {
  final String id;
  final String texte;
  final String? livre;
  final String? titre;
  final String? chapitre;

  Article({
    required this.id,
    required this.texte,
    this.livre,
    this.titre,
    this.chapitre,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String,
      texte: json['texte'] as String,
      livre: json['livre'] as String?,
      titre: json['titre'] as String?,
      chapitre: json['chapitre'] as String?,
    );
  }
}
