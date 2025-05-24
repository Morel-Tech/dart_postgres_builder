import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$DropExpression', () {
    test(
        'toSql returns correctly for dropping generated property from a column',
        () {
      final operation = DropExpression();
      expect(
        operation.toSql(),
        equalsSql(
          query: 'DROP EXPRESSION',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterTable', () {
      final statement = AlterTable(
        table: 'orders',
        operations: [
          AlterColumn(column: 'total', operations: [DropExpression()]),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE orders ALTER COLUMN total DROP EXPRESSION',
          parameters: {},
        ),
      );
    });
  });
}
