import 'package:postgres_builder/postgres_builder.dart';

class Select implements SqlStatement {
  const Select(
    this.columns, {
    required String from,
    this.where,
    this.order,
    this.limit,
    this.join,
  }) : table = from;

  final List<SqlStatement> columns;
  final String table;
  final FilterStatement? where;
  final Order? order;
  final int? limit;
  final List<Join>? join;

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
      if (join != null) ...join!.map((e) => e.toSql().query),
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
        for (final column in columns) ...column.toSql().parameters,
        if (join != null)
          for (final currentJoin in join!) ...currentJoin.toSql().parameters,
      },
    );
  }
}
