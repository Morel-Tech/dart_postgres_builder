import 'package:postgres_builder/postgres_builder.dart';

class TrueFilter extends FilterStatement {
  const TrueFilter();

  @override
  ProcessedSql toSql() => const ProcessedSql(query: 'TRUE', parameters: {});
}
