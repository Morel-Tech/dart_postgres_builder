import 'package:mocktail/mocktail.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

class _MockColumn extends Mock implements Column {}

void main() {
  group('Comparison Operators', () {
    late Column column1;
    late Column column2;

    setUp(() {
      column1 = _MockColumn();
      column2 = _MockColumn();
      when(() => column1.toSql()).thenReturn(
        const ProcessedSql(query: '__column1__', parameters: {}),
      );
      when(() => column2.toSql()).thenReturn(
        const ProcessedSql(query: '__column2__', parameters: {}),
      );
      when(() => column1.parameterName).thenReturn('__column1__');
      when(() => column2.parameterName).thenReturn('__column2__');
    });

    group('& operator', () {
      test('GreaterThan & GreaterThan returns And', () {
        final result = GreaterThan(column1, 10) & GreaterThan(column2, 20);
        expect(result, isA<And>());
        expect(
          result.toSql(),
          equalsSql(
            query:
                '(__column1__ > @__column1__ AND __column2__ > @__column2__)',
            parameters: {
              '__column1__': 10,
              '__column2__': 20,
            },
          ),
        );
      });

      test('LessThan & Between returns And', () {
        final result = LessThan(column1, 10) & Between(column2, 20, 30);
        expect(result, isA<And>());
        expect(
          result.toSql(),
          equalsSql(
            query:
                '(__column1__ < @__column1__ AND __column2__ BETWEEN @__column2___lower AND @__column2___upper)',
            parameters: {
              '__column1__': 10,
              '__column2___lower': 20,
              '__column2___upper': 30,
            },
          ),
        );
      });
    });

    group('| operator', () {
      test('GreaterThan | GreaterThan returns Or', () {
        final result = GreaterThan(column1, 10) | GreaterThan(column2, 20);
        expect(result, isA<Or>());
        expect(
          result.toSql(),
          equalsSql(
            query: '(__column1__ > @__column1__ OR __column2__ > @__column2__)',
            parameters: {
              '__column1__': 10,
              '__column2__': 20,
            },
          ),
        );
      });

      test('LessThan | Between returns Or', () {
        final result = LessThan(column1, 10) | Between(column2, 20, 30);
        expect(result, isA<Or>());
        expect(
          result.toSql(),
          equalsSql(
            query:
                '(__column1__ < @__column1__ OR __column2__ BETWEEN @__column2___lower AND @__column2___upper)',
            parameters: {
              '__column1__': 10,
              '__column2___lower': 20,
              '__column2___upper': 30,
            },
          ),
        );
      });
    });
  });
}
