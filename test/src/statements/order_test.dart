import 'package:mocktail/mocktail.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

class _MockColumn extends Mock implements Column {
  @override
  String toString() => '__colName__';
}

void main() {
  group('Order', () {
    test('toSql() returns correctly', () {
      final column = _MockColumn();
      when(column.toSql)
          .thenReturn(const ProcessedSql(query: '__colName__', parameters: {}));
      expect(
        Order([Sort(column)]).toSql(),
        equalsSql(
          query: 'ORDER BY __colName__ ASC',
          parameters: {},
        ),
      );
    });
    test('toSql() returns correctly when direction is descending', () {
      final column = _MockColumn();
      when(column.toSql)
          .thenReturn(const ProcessedSql(query: '__colName__', parameters: {}));
      expect(
        Order([Sort(column, direction: SortDirection.descending)]).toSql(),
        equalsSql(
          query: 'ORDER BY __colName__ DESC',
          parameters: {},
        ),
      );
    });

    test('toSql() returns correctly when there are multiple sorts', () {
      final column1 = _MockColumn();
      final column2 = _MockColumn();
      when(column1.toSql).thenReturn(
        const ProcessedSql(query: '__colName1__', parameters: {}),
      );
      when(column2.toSql).thenReturn(
        const ProcessedSql(query: '__colName2__', parameters: {}),
      );
      expect(
        Order([
          Sort(column1, direction: SortDirection.descending),
          Sort(column2),
        ]).toSql(),
        equalsSql(
          query: 'ORDER BY __colName1__ DESC, __colName2__ ASC',
          parameters: {},
        ),
      );
    });

    test('toSql() returns correctly', () {
      final column = _MockColumn();
      when(column.toSql)
          .thenReturn(const ProcessedSql(query: '__colName__', parameters: {}));
      expect(
        Order([Sort(column)]).toSql(),
        equalsSql(
          query: 'ORDER BY __colName__ ASC',
          parameters: {},
        ),
      );
    });
  });

  group('SortDirection', () {
    test('toSql() returns correctly', () {
      expect(
        SortDirection.ascending.toSql(),
        equalsSql(query: 'ASC', parameters: {}),
      );
      expect(
        SortDirection.descending.toSql(),
        equalsSql(query: 'DESC', parameters: {}),
      );
    });
  });
}
