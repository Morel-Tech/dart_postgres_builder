import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('IsNotNull', () {
    test('toSql() returns correctly for simple column', () {
      const column = Column('__colName__');
      expect(
        const IsNotNull(column).toSql(),
        equalsSql(
          query: '__colName__ IS NOT NULL',
        ),
      );
    });

    test('toSql() returns correctly for table-qualified column', () {
      const column = Column('__colName__', table: '__tableName__');
      expect(
        const IsNotNull(column).toSql(),
        equalsSql(
          query: '__tableName__.__colName__ IS NOT NULL',
        ),
      );
    });

    test('toSql() returns correctly for column with alias', () {
      const column = Column('__colName__', as: '__alias__');
      expect(
        const IsNotNull(column).toSql(),
        equalsSql(
          query: '__colName__ AS "__alias__" IS NOT NULL',
        ),
      );
    });

    test('toSql() returns correctly for table-qualified column with alias', () {
      const column =
          Column('__colName__', table: '__tableName__', as: '__alias__');
      expect(
        const IsNotNull(column).toSql(),
        equalsSql(
          query: '__tableName__.__colName__ AS "__alias__" IS NOT NULL',
        ),
      );
    });

    test('toSql() returns correctly for star column', () {
      const column = Column.star();
      expect(
        const IsNotNull(column).toSql(),
        equalsSql(
          query: '* IS NOT NULL',
        ),
      );
    });

    test('toSql() returns correctly for table-qualified star column', () {
      const column = Column.star(table: '__tableName__');
      expect(
        const IsNotNull(column).toSql(),
        equalsSql(
          query: '__tableName__.* IS NOT NULL',
        ),
      );
    });
  });
}
