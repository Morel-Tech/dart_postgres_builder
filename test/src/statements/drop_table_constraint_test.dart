import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$DropConstraint', () {
    test('toSql returns correctly for dropping a table constraint', () {
      final operation = DropConstraint(constraintName: 'users_pk');
      expect(
        operation.toSql(),
        equalsSql(
          query: 'DROP CONSTRAINT users_pk',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterTable', () {
      final statement = AlterTable(
        table: 'users',
        operations: [DropConstraint(constraintName: 'users_pk')],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users DROP CONSTRAINT users_pk',
          parameters: {},
        ),
      );
    });
  });
}
