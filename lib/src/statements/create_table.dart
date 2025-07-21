import 'package:postgres_builder/postgres_builder.dart';

class CreateTable extends SqlStatement {
  const CreateTable({
    required this.name,
    required this.columns,
    this.ifNotExists = false,
    this.constraints = const [],
  });

  final String name;
  final bool ifNotExists;
  final List<ColumnDefinition> columns;
  final List<TableConstraint> constraints;

  @override
  ProcessedSql toSql() {
    final query = StringBuffer(
      'CREATE TABLE ',
    );
    if (ifNotExists) {
      query.write('IF NOT EXISTS ');
    }
    query.write('$name (');
    final mappedQuery = columns.map((e) => e.toSql());

    // Add all columns with commas
    for (final (index, column) in mappedQuery.indexed) {
      query.write(column.query);
      // Add comma if not the last column OR if there are constraints
      if (index < mappedQuery.length - 1 || constraints.isNotEmpty) {
        query.write(', ');
      }
    }

    // Add table-level constraints after columns
    final mappedConstraints = constraints.map((e) => e.toSql());
    for (final (index, constraint) in mappedConstraints.indexed) {
      query.write(constraint.query);
      // Add comma if not the last constraint
      if (index < constraints.length - 1) {
        query.write(', ');
      }
    }

    query.write(')');
    return ProcessedSql(
      query: query.toString(),
      parameters: {
        for (final current in mappedQuery) ...current.parameters,
        for (final current in mappedConstraints) ...current.parameters,
      },
    );
  }
}
