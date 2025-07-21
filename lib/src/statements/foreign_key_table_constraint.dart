import 'package:postgres_builder/postgres_builder.dart';

/// {@template foreign_key_table_constraint}
/// A wrapper around the existing ForeignKeyConstraint for table-level use.
/// This allows using the existing ForeignKeyConstraint with CreateTable
/// constraints.
/// {@endtemplate}
class ForeignKeyTableConstraint extends TableConstraint {
  /// {@macro foreign_key_table_constraint}
  const ForeignKeyTableConstraint(
    this.foreignKeyConstraint,
  ) : super(name: null);

  /// The wrapped ForeignKeyConstraint.
  final ForeignKeyConstraint foreignKeyConstraint;

  @override
  ProcessedSql toSql() {
    return ProcessedSql(
      query: foreignKeyConstraint.toSql(),
      parameters: {},
    );
  }
}
