import 'package:postgres_builder/postgres_builder.dart';

class Order implements SqlStatement {
  const Order(
    this.columns, {
    this.sort = SortOrder.ascending,
  });
  final List<Column> columns;
  final SortOrder sort;

  @override
  ProcessedSql toSql() {
    return ProcessedSql(
      query: 'ORDER BY ${columns.join(', ')} ${sort.toSql().query}',
      parameters: {},
    );
  }
}

enum SortOrder implements SqlStatement {
  ascending,
  descending;

  @override
  ProcessedSql toSql() => switch (this) {
        SortOrder.ascending => const ProcessedSql(
            query: 'ASC',
            parameters: {},
          ),
        SortOrder.descending => const ProcessedSql(
            query: 'DESC',
            parameters: {},
          ),
      };
}
