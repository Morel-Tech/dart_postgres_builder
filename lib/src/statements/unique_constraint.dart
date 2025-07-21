import 'package:postgres_builder/postgres_builder.dart';

/// {@template unique_constraint}
/// A UNIQUE constraint for one or more columns.
/// {@endtemplate}
class UniqueConstraint extends TableConstraint {
  /// {@macro unique_constraint}
  const UniqueConstraint(
    this.columns, {
    super.name,
  }) : assert(
          columns.length > 0,
          'Unique constraint must have at least one column',
        );

  /// The columns that make up the unique constraint.
  final List<String> columns;

  @override
  ProcessedSql toSql() {
    final columnList = columns.join(', ');
    return ProcessedSql(
      query: '${constraintNamePrefix}UNIQUE ($columnList)',
      parameters: {},
    );
  }
}
