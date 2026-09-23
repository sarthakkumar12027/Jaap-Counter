class MantraItem {
  final String id;
  final String name;
  final String originalScript;
  final String transliteration;
  final String meaning;
  final String category;
  final int defaultMalaSize;

  const MantraItem({
    required this.id,
    required this.name,
    required this.originalScript,
    required this.transliteration,
    this.meaning = '',
    required this.category,
    this.defaultMalaSize = 108,
  });
}
