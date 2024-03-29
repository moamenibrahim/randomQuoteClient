class Quote {
  final id;
  final String quoteText;
  final String quoteAuthor;
  const Quote({this.id, this.quoteText, this.quoteAuthor});

  List<Object> get props => [id, quoteText, quoteAuthor];

  static Quote fromJson(dynamic json) {
    return Quote(
      id: json['_id'],
      quoteText: json['quoteText'],
      quoteAuthor: json['quoteAuthor'],
    );
  }

  @override
  String toString() => 'Quote { id: $id }';
}
