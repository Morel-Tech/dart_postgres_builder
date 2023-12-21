import 'package:postgres_builder/postgres_builder.dart';
import 'package:recase/recase.dart';

class Column implements SqlStatement {
  const Column(String columnName, {this.as, this.table}) : name = columnName;
  const Column._({this.name, this.as, this.table});
  factory Column.nested(
    Select select, {
    required String? as,
    bool single = false,
  }) =>
      _NestedColumn(select, as: as, single: single);

  const Column.star({this.table})
      : name = '*',
        as = null;

  final String? name;
  final String? table;
  final String? as;

  String get parameterName => table != null
      ? '${table?.camelCase}_${name?.camelCase}'.camelCase
      : '${name?.camelCase}';

  @override
  ProcessedSql toSql() {
    if (as == null) {
      return ProcessedSql(query: toString(), parameters: {});
    }
    return ProcessedSql(query: '$this AS "$as"', parameters: {});
  }

  @override
  String toString() => table != null ? '$table.$name' : '$name';
}

class _NestedColumn extends Column {
  const _NestedColumn(
    this.select, {
    required this.single,
    super.as,
  }) : super._();

  final Select select;
  final bool single;

  @override
  ProcessedSql toSql() {
    final selectSql = select.toSql();
    final query = single
        ? '''(SELECT row_to_json($as.*) FROM (${selectSql.query}) as $as) as "$as"'''
        : '''(SELECT COALESCE(json_agg($as.*), '[]'::json) FROM (${selectSql.query}) as $as) as "$as"''';
    return ProcessedSql(
      query: query,
      parameters: selectSql.parameters,
    );
  }
}
