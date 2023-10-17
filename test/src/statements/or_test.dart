import 'package:mocktail/mocktail.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

class _MockSqlStatement extends Mock implements SqlStatement {}

void main() {
  group('Or', () {
    test('toSql returns correctly', () {
      final statement1 = _MockSqlStatement();
      when(statement1.toSql).thenReturn(
        const ProcessedSql(
          query: '__query1__',
          parameters: {'__key1__': '__value1__'},
        ),
      );
      final statement2 = _MockSqlStatement();
      when(statement2.toSql).thenReturn(
        const ProcessedSql(
          query: '__query2__',
          parameters: {'__key2__': '__value2__'},
        ),
      );
      expect(
        Or([statement1, statement2]).toSql(),
        equalsSql(
          query: '(__query1__ OR __query2__)',
          parameters: {
            '__key1__': '__value1__',
            '__key2__': '__value2__',
          },
        ),
      );
    });
  });
}
