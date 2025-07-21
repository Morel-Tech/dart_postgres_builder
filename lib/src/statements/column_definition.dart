import 'package:postgres_builder/postgres_builder.dart';

/// Referential actions for foreign key constraints.
enum ReferentialAction {
  cascade('CASCADE'),
  setNull('SET NULL'),
  setDefault('SET DEFAULT'),
  restrict('RESTRICT'),
  noAction('NO ACTION');

  const ReferentialAction(this.sql);
  final String sql;
}

/// {@template column_definition}
/// A column in a table.
/// {@endtemplate}
class ColumnDefinition implements SqlStatement {
  /// {@macro column_definition}
  const ColumnDefinition({
    required this.name,
    required this.type,
    this.defaultValue,
    this.nullable = false,
    this.primaryKey = false,
    this.unique = false,
    this.autoIncrement = false,
    this.check,
    this.references,
    this.onDelete,
    this.onUpdate,
    this.collate,
    this.generated,
  });

  /// The name of the column.
  final String name;

  /// The type of the column.
  final String type;

  /// The default value of the column.
  final String? defaultValue;

  /// Whether the column is nullable.
  final bool nullable;

  /// Whether the column is a primary key.
  final bool primaryKey;

  /// Whether the column is a unique key.
  final bool unique;

  /// Whether the column auto-increments.
  final bool autoIncrement;

  /// A CHECK constraint expression.
  final String? check;

  /// A foreign key reference in the format 'table(column)'.
  final String? references;

  /// The action to take when the referenced row is deleted.
  final ReferentialAction? onDelete;

  /// The action to take when the referenced row is updated.
  final ReferentialAction? onUpdate;

  /// The collation to use for the column.
  final String? collate;

  /// The expression for a generated column.
  final String? generated;

  @override
  ProcessedSql toSql() {
    final query = StringBuffer('$name $type');

    if (generated != null) {
      query.write(' GENERATED ALWAYS AS ($generated) STORED');
    } else {
      if (defaultValue != null) {
        query.write(' DEFAULT ');
        // Handle string literals and other types appropriately
        if (defaultValue!.toLowerCase() == 'null') {
          query.write('NULL');
        } else if (defaultValue!.toLowerCase() == 'true' ||
            defaultValue!.toLowerCase() == 'false') {
          query.write(defaultValue!.toUpperCase());
        } else {
          // Simple value, no quoting needed
          query.write(defaultValue);
        }
      }
    }

    if (!nullable) {
      query.write(' NOT NULL');
    }

    if (autoIncrement) {
      query.write(' GENERATED ALWAYS AS IDENTITY');
    }

    if (primaryKey) {
      query.write(' PRIMARY KEY');
    }

    if (unique) {
      query.write(' UNIQUE');
    }

    if (check != null) {
      query.write(' CHECK ($check)');
    }

    if (references != null) {
      query.write(' REFERENCES $references');

      if (onDelete != null) {
        query.write(' ON DELETE ${onDelete!.sql}');
      }

      if (onUpdate != null) {
        query.write(' ON UPDATE ${onUpdate!.sql}');
      }
    }

    if (collate != null) {
      query.write(' COLLATE $collate');
    }

    return ProcessedSql(
      query: query.toString(),
      parameters: {},
    );
  }
}
