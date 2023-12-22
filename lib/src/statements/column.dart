import 'package:postgres_builder/postgres_builder.dart';
import 'package:recase/recase.dart';

class Column implements SqlStatement {
  const Column(String columnName, {this.as, this.table}) : name = columnName;
  const Column._({this.name, this.as, this.table});
  factory Column.nested(
    Select select, {
    required String? as,
    bool single = false,
    bool convertToJson = true,
  }) =>
      _NestedColumn(
        select,
        as: as,
        single: single,
        convertToJson: convertToJson,
      );

  const Column.star({this.table})
      : name = '*',
        as = null;

  final String? name;
  final String? table;
  final String? as;

  String? get parameterName => name == null
      ? null
      : table != null
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
    required this.convertToJson,
    super.as,
  }) : super._();

  final Select select;
  final bool single;
  final bool convertToJson;

  @override
  ProcessedSql toSql() {
    final selectSql = select.toSql();
    final String query;
    if (convertToJson) {
      if (as == null) {
        query = single
            ? '''(SELECT row_to_json(*) FROM (${selectSql.query}))'''
            : '''(SELECT COALESCE(json_agg(*), '[]'::json) FROM (${selectSql.query}))''';
      } else {
        query = single
            ? '''(SELECT row_to_json($as.*) FROM (${selectSql.query}) as $as) as "$as"'''
            : '''(SELECT COALESCE(json_agg($as.*), '[]'::json) FROM (${selectSql.query}) as $as) as "$as"''';
      }
    } else {
      if (as == null) {
        query = '(${selectSql.query})';
      } else {
        query = '(${selectSql.query}) AS "$as"';
      }
    }

    return ProcessedSql(
      query: query,
      parameters: selectSql.parameters,
    );
  }
}
