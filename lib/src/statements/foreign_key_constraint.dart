import 'package:postgres_builder/postgres_builder.dart';

/// A foreign key constraint that can be used at the table level.
class ForeignKeyConstraint {
  const ForeignKeyConstraint({
    required this.columns,
    required this.referencesTable,
    required this.referencesColumns,
    this.name,
    this.onDelete,
    this.onUpdate,
  });

  /// Optional name for the constraint.
  final String? name;

  /// The columns in this table that form the foreign key.
  final List<String> columns;

  /// The table that is referenced by this foreign key.
  final String referencesTable;

  /// The columns in the referenced table.
  final List<String> referencesColumns;

  /// The action to take when the referenced row is deleted.
  final ReferentialAction? onDelete;

  /// The action to take when the referenced row is updated.
  final ReferentialAction? onUpdate;

  /// Converts this foreign key constraint to SQL.
  String toSql() {
    final query = StringBuffer();

    if (name != null) {
      query.write('CONSTRAINT $name ');
    }

    query
      ..write('FOREIGN KEY (${columns.join(', ')}) ')
      ..write('REFERENCES $referencesTable (${referencesColumns.join(', ')})');

    if (onDelete != null) {
      query.write(' ON DELETE ${onDelete!.sql}');
    }

    if (onUpdate != null) {
      query.write(' ON UPDATE ${onUpdate!.sql}');
    }

    return query.toString();
  }
}
