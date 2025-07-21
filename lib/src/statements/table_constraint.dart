import 'package:postgres_builder/postgres_builder.dart';

/// {@template table_constraint}
/// An abstract base class for table-level constraints.
/// {@endtemplate}
abstract class TableConstraint implements SqlStatement {
  /// {@macro table_constraint}
  const TableConstraint({this.name});

  /// The optional name of the constraint.
  final String? name;

  /// Generates the constraint name prefix if a name is provided.
  String get constraintNamePrefix => name != null ? 'CONSTRAINT $name ' : '';
}
