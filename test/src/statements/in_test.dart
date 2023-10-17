import 'package:mocktail/mocktail.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

class _MockColumn extends Mock implements Column {
  @override
  String toString() => '__colName__';
}

void main() {
  group('In', () {
    test('toSql() returns correctly', () {
      final column = _MockColumn();
      when(() => column.parameterName).thenReturn('__param__');
      expect(
        In(column, ['__value1__', '__value2__']).toSql(),
        equalsSql(
          query: '__colName__ IN (@__param__0, @__param__1)',
          parameters: {
            '__param__0': '__value1__',
            '__param__1': '__value2__',
          },
        ),
      );
    });
  });
}
