import 'package:mocktail/mocktail.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

class _MockColumn extends Mock implements Column {}

void main() {
  group('GreaterThan', () {
    test('toSql returns correctly', () {
      final column = _MockColumn();
      when(column.toSql).thenReturn(
        const ProcessedSql(query: '__column__', parameters: {}),
      );
      when(() => column.parameterName).thenReturn('__column__');

      expect(
        GreaterThan(column, '__value__').toSql(),
        equalsSql(
          query: '__column__ > @__column__',
          parameters: {'__column__': '__value__'},
        ),
      );
    });
  });

  group('GreaterThanOrEqual', () {
    test('toSql returns correctly', () {
      final column = _MockColumn();
      when(column.toSql).thenReturn(
        const ProcessedSql(query: '__column__', parameters: {}),
      );
      when(() => column.parameterName).thenReturn('__column__');

      expect(
        GreaterThanOrEqual(column, '__value__').toSql(),
        equalsSql(
          query: '__column__ >= @__column__',
          parameters: {'__column__': '__value__'},
        ),
      );
    });
  });

  group('LessThan', () {
    test('toSql returns correctly', () {
      final column = _MockColumn();
      when(column.toSql).thenReturn(
        const ProcessedSql(query: '__column__', parameters: {}),
      );
      when(() => column.parameterName).thenReturn('__column__');

      expect(
        LessThan(column, '__value__').toSql(),
        equalsSql(
          query: '__column__ < @__column__',
          parameters: {'__column__': '__value__'},
        ),
      );
    });
  });

  group('LessThanOrEqual', () {
    test('toSql returns correctly', () {
      final column = _MockColumn();
      when(column.toSql).thenReturn(
        const ProcessedSql(query: '__column__', parameters: {}),
      );
      when(() => column.parameterName).thenReturn('__column__');

      expect(
        LessThanOrEqual(column, '__value__').toSql(),
        equalsSql(
          query: '__column__ <= @__column__',
          parameters: {'__column__': '__value__'},
        ),
      );
    });
  });

  group('Between', () {
    test('toSql returns correctly', () {
      final column = _MockColumn();
      when(column.toSql).thenReturn(
        const ProcessedSql(query: '__column__', parameters: {}),
      );
      when(() => column.parameterName).thenReturn('__column__');

      expect(
        Between(column, '__lower__', '__upper__').toSql(),
        equalsSql(
          query: '__column__ BETWEEN @__column___lower AND @__column___upper',
          parameters: {
            '__column___lower': '__lower__',
            '__column___upper': '__upper__',
          },
        ),
      );
    });
  });
}
