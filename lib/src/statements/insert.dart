import 'package:postgres_builder/postgres_builder.dart';

class Insert implements SqlStatement {
  const Insert(
    this.values, {
    required String into,
  }) : table = into;

  final List<Map<String, dynamic>> values;
  final String table;

  @override
  ProcessedSql toSql() {
    final columns = values.first.keys;
    final query = [
      'INSERT',
      'INTO',
      table,
      '(${columns.join(', ')})',
      'VALUES',
      for (var row = 0; row < values.length; row++)
        '''(${columns.map((e) => '@$e$row').join(', ')})${row == values.length - 1 ? '' : ','}''',
      'RETURNING *'
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
