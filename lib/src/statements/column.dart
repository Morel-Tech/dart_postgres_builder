import 'package:postgres_builder/postgres_builder.dart';

class Column implements SqlStatement {
  const Column(this.name, {this.as, this.table});

  const Column.star()
      : name = '*',
        as = null,
        table = null;

  final String name;
  final String? table;
  final String? as;

  @override
  ProcessedSql toSql() {
    if (as == null) {
      return ProcessedSql(query: toString(), parameters: {});
    }
    return ProcessedSql(query: '$this AS "$as"', parameters: {});
  }

  @override
  String toString() => table != null ? '$table.$name' : name;
}
