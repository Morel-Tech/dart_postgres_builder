import 'package:postgres_builder/postgres_builder.dart';

class Sort implements SqlStatement {
  const Sort(this.column, {this.direction = SortDirection.ascending});
  final Column column;
  final SortDirection direction;

  @override
  ProcessedSql toSql() {
    final columnSql = column.toSql();
    final directionSql = direction.toSql();
    return ProcessedSql(
      query: '${columnSql.query} ${directionSql.query}',
      parameters: {...columnSql.parameters, ...directionSql.parameters},
    );
  }

  Sort operator ~() => Sort(column, direction: direction);
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
