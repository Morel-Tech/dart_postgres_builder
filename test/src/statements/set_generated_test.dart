import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$SetGenerated', () {
    test('toSql returns correctly for setting a column as generated (STORED)',
        () {
      final operation = SetGenerated(
        expression: 'price * quantity',
      );
      expect(
        operation.toSql(),
        equalsSql(
          query: 'SET GENERATED ALWAYS AS (price * quantity) STORED',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterTable', () {
      final statement = AlterTable(
        table: 'orders',
        operations: [
          AlterColumn(
            column: 'total',
            operations: [SetGenerated(expression: 'price * quantity')],
          ),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''ALTER TABLE orders ALTER COLUMN total SET GENERATED ALWAYS AS (price * quantity) STORED''',
          parameters: {},
        ),
      );
    });
  });
}
