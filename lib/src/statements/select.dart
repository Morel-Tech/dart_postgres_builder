import 'package:postgres_builder/postgres_builder.dart';

class Select implements SqlStatement {
  const Select(
    this.columns, {
    required String from,
    this.where,
    this.order,
    this.limit,
  }) : table = from;

  final List<SqlStatement> columns;
  final String table;
  final FilterStatement? where;
  final Order? order;
  final int? limit;

  @override
  ProcessedSql toSql() {
    ProcessedSql? processedWhere;
    if (where != null) {
      processedWhere = where!.toSql();
    }
    final query = [
      'SELECT',
      columns.map((e) => e.toSql().query).join(', '),
      'FROM',
      table,
      if (processedWhere != null) ...[
        'WHERE',
        processedWhere.query,
      ],
      if (order != null) order!.toSql().query,
      if (limit != null) 'LIMIT $limit'
    ].join(' ');
    return ProcessedSql(
      query: query,
      parameters: {
        ...?processedWhere?.parameters,
        for (final column in columns) ...column.toSql().parameters
      },
    );
  }
}
