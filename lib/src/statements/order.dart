import 'package:postgres_builder/postgres_builder.dart';

class Order implements SqlStatement {
  const Order(this.sorts);

  final List<Sort> sorts;

  @override
  ProcessedSql toSql() {
    final sortsSql = sorts.map((e) => e.toSql());
    return ProcessedSql(
      query: 'ORDER BY ${sortsSql.map((e) => e.query).join(', ')}',
      parameters: {
        for (final sort in sorts) ...sort.toSql().parameters,
      },
    );
  }
}

class Sort implements SqlStatement {
  const Sort(this.column, {this.direction = SortDirection.ascending});
  final Column column;
  final SortDirection direction;

  @override
  ProcessedSql toSql() {
    final columnSql = column.toSql();
    final directionSql = direction.toSql();
    return ProcessedSql(
      query: '$columnSql ${directionSql.query}',
      parameters: {...columnSql.parameters, ...directionSql.parameters},
    );
  }
}

enum SortDirection implements SqlStatement {
  ascending,
  descending;

  @override
  ProcessedSql toSql() => switch (this) {
        SortDirection.ascending => const ProcessedSql(
            query: 'ASC',
            parameters: {},
          ),
        SortDirection.descending => const ProcessedSql(
            query: 'DESC',
            parameters: {},
          ),
      };
}
