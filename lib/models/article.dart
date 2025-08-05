class Article {
  final String numero;
  final String titre;
  final String texte;

  Article({
    required this.numero,
    required this.titre,
    required this.texte,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      numero: json['numero'] as String,
      titre: json['titre'] as String,
      texte: json['texte'] as String,
    );
  }
}
