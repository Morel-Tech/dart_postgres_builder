import 'package:postgres_builder/postgres_builder.dart';

class Upsert implements SqlStatement {
  const Upsert(
    this.values, {
    required String into,
    required this.uniqueKeys,
    this.returningColumns = const [Column.star()],
  }) : table = into;

  final List<Map<String, dynamic>> values;
  final String table;
  final List<String> uniqueKeys;
  final List<Column> returningColumns;

  @override
  ProcessedSql toSql() {
    final columns = <String>{
      for (final row in values) ...row.keys,
    };
    final query = [
      'INSERT',
      'INTO',
      table,
      '(${columns.join(', ')})',
      'VALUES',
      for (var row = 0; row < values.length; row++)
        '''(${columns.map((e) => '@$e$row').join(', ')})${row == values.length - 1 ? '' : ','}''',
      'ON CONFLICT',
      '(${uniqueKeys.join(', ')})',
      'DO UPDATE',
      'SET',
      columns.map((column) => '$column=EXCLUDED.$column').join(', '),
      'RETURNING ${returningColumns.map((e) => e.toSql().query).join(', ')}',
    ].join(' ');
    return ProcessedSql(
      query: query,
      parameters: {
        for (var row = 0; row < values.length; row++)
          for (final column in columns) '$column$row': values[row][column],
      },
    );
  }
}
