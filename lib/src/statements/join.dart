import 'package:postgres_builder/postgres_builder.dart';

class Join extends SqlStatement {
  const Join(
    this.table, {
    required this.on,
    this.type = 'LEFT',
    this.as,
  });

  final String table;
  final String type;
  final FilterStatement on;
  final String? as;

  @override
  ProcessedSql toSql() {
    final onSql = on.toSql();
    final words = [
      type.toUpperCase(),
      'JOIN',
      table,
      if (as != null) 'AS',
      if (as != null) '"$as"',
      'ON',
      onSql.query,
    ];

    return ProcessedSql(query: words.join(' '), parameters: onSql.parameters);
  }
}
