import 'package:postgres_builder/postgres_builder.dart';

class Column implements SqlStatement {
  const Column(this.name, {String? as}) : alias = as;

  static List<Column> star() => [const Column('*')];

  final String name;
  final String? alias;

  @override
  ProcessedSql toSql() {
    if (alias == null) {
      return ProcessedSql(query: name, parameters: {});
    }
    return ProcessedSql(query: '$name as $alias', parameters: {});
  }
}
