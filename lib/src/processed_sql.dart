class ProcessedSql {
  const ProcessedSql({
    required this.query,
    required this.parameters,
  });

  final String query;
  final Map<String, dynamic> parameters;

  @override
  String toString() => '$query\n--with--\n$parameters';
}
