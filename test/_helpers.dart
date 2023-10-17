import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

Matcher equalsSql({String? query, Map<String, dynamic>? parameters}) {
  var matcher = isA<ProcessedSql>();
  if (query != null) {
    matcher = matcher.having((sql) => sql.query, 'query', equals(query));
  }
  if (parameters != null) {
    matcher = matcher.having(
      (sql) => sql.parameters,
      'parameters',
      equals(parameters),
    );
  }
  return equals(matcher);
}
