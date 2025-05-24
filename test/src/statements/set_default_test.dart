import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$SetDefault', () {
    test('toSql returns correctly for a single operation', () {
      final operation = SetDefault(defaultValue: '18');
      expect(
        operation.toSql(),
        equalsSql(
          query: 'SET DEFAULT 18',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterColumn', () {
      final statement = AlterColumn(
        column: 'email',
        operations: [SetDefault(defaultValue: "'none'")],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: "ALTER COLUMN email SET DEFAULT 'none'",
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with multiple SetColumnDefault operations',
        () {
      final statement = AlterColumn(
        column: 'age',
        operations: [
          SetDefault(defaultValue: '18'),
          SetDefault(defaultValue: "'none'"),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: '''ALTER COLUMN age SET DEFAULT 18, SET DEFAULT 'none\'''',
          parameters: {},
        ),
      );
    });
  });
}
