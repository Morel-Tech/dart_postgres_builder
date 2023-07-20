class PostgresBuilderException implements Exception {
  const PostgresBuilderException(this.message, [this.payload]);

  final String? message;
  final Map<String, dynamic>? payload;
}
