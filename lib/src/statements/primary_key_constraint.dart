import 'package:postgres_builder/postgres_builder.dart';

/// {@template primary_key_constraint}
/// A PRIMARY KEY constraint for one or more columns.
/// {@endtemplate}
class PrimaryKeyConstraint extends TableConstraint {
  /// {@macro primary_key_constraint}
  const PrimaryKeyConstraint(
    this.columns, {
    super.name,
  }) : assert(columns.length > 0, 'Primary key must have at least one column');

  /// The columns that make up the primary key.
  final List<String> columns;

  @override
  ProcessedSql toSql() {
    final columnList = columns.join(', ');
    return ProcessedSql(
      query: '${constraintNamePrefix}PRIMARY KEY ($columnList)',
      parameters: {},
    );
  }
}
