import 'package:postgres_builder/src/processed_sql.dart';

// ignore: one_member_abstracts
abstract class SqlStatement {
  const SqlStatement();
  ProcessedSql toSql();
}

abstract class FilterStatement implements SqlStatement {}
