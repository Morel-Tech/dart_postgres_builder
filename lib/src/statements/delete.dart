import 'package:postgres_builder/postgres_builder.dart';

class Delete implements SqlStatement {
  const Delete({required this.from, required this.where});

  final String from;
  final FilterStatement where;

  @override
  ProcessedSql toSql() {
    final processed = where.toSql();
    return ProcessedSql(
      query: 'DELETE FROM $from WHERE ${processed.query} RETURNING *',
      parameters: processed.parameters,
    );
  }
}
