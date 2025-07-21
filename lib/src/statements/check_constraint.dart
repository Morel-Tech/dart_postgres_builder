import 'package:postgres_builder/postgres_builder.dart';

/// {@template check_constraint}
/// A CHECK constraint with a custom expression.
/// {@endtemplate}
class CheckConstraint extends TableConstraint {
  /// {@macro check_constraint}
  const CheckConstraint(
    this.expression, {
    super.name,
  });

  /// The CHECK constraint expression.
  final String expression;

  @override
  ProcessedSql toSql() {
    return ProcessedSql(
      query: '${constraintNamePrefix}CHECK ($expression)',
      parameters: {},
    );
  }
}
