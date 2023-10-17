import 'package:mocktail/mocktail.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

class _MockFilterStatement extends Mock implements FilterStatement {}

void main() {
  group('Join', () {
    group('toSql() returns correctly', () {
      test('when alias is null', () {
        final filterStatement = _MockFilterStatement();
        when(filterStatement.toSql).thenReturn(
          const ProcessedSql(
            query: '__query__',
            parameters: {'__key__': '__value__'},
          ),
        );
        expect(
          Join('__table__', on: filterStatement, type: '__type__').toSql(),
          equalsSql(
            query: '__TYPE__ JOIN __table__ ON __query__',
            parameters: {'__key__': '__value__'},
          ),
        );
      });
      test('when alias is not null', () {
        final filterStatement = _MockFilterStatement();
        when(filterStatement.toSql).thenReturn(
          const ProcessedSql(
            query: '__query__',
            parameters: {'__key__': '__value__'},
          ),
        );
        expect(
          Join(
            '__table__',
            on: filterStatement,
            type: '__type__',
            as: '__alias__',
          ).toSql(),
          equalsSql(
            query: '__TYPE__ JOIN __table__ AS "__alias__" ON __query__',
            parameters: {'__key__': '__value__'},
          ),
        );
      });
    });
  });
}
