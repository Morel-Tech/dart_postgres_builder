import 'package:postgres_builder/postgres_builder.dart';

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
    this.collate,
    this.generated,
    this.isStored = false,
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

  /// The collation to use for the column.
  final String? collate;

  /// The expression for a generated column.
  final String? generated;

  /// Whether a generated column is STORED (true) or VIRTUAL (false).
  final bool isStored;

  @override
  ProcessedSql toSql() {
    final query = StringBuffer('$name $type');

    if (generated != null) {
      query
        ..write(' GENERATED ALWAYS AS ($generated)')
        ..write(isStored ? ' STORED' : ' VIRTUAL');
    } else {
      if (defaultValue != null) {
        query.write(' DEFAULT ');
        // Handle string literals and other types appropriately
        if (defaultValue!.toLowerCase() == 'null') {
          query.write('NULL');
        } else if (defaultValue!.toLowerCase() == 'true' ||
            defaultValue!.toLowerCase() == 'false') {
          query.write(defaultValue!.toUpperCase());
        } else if (defaultValue!.startsWith("'") &&
            defaultValue!.endsWith("'")) {
          // Already quoted string
          query.write(defaultValue);
        } else if (defaultValue!.contains(RegExp('[^a-zA-Z0-9_]'))) {
          // Contains special characters, needs quoting
          query.write("'${defaultValue!.replaceAll("'", "''")}'");
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
