// ignore_for_file: unnecessary_lambdas

import 'package:mocktail/mocktail.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:postgres_pool/postgres_pool.dart';
import 'package:test/test.dart';

class _MockPgPool extends Mock implements PgPool {}

class _MockPgPoolStatus extends Mock implements PgPoolStatus {}

class _MockPostgreSQLResult extends Mock implements PostgreSQLResult {}

class _MockPostgreSQLResultRow extends Mock implements PostgreSQLResultRow {}

class _MockColumnDescription extends Mock implements ColumnDescription {}

void main() {
  group('PgPoolPostgresBuilder', () {
    test('can be instantiated', () {
      expect(PgPoolPostgresBuilder(), isNotNull);
    });

    test('close closes connection', () async {
      final pgPool = _MockPgPool();
      when(() => pgPool.close()).thenAnswer((_) async {});
      await PgPoolPostgresBuilder(connection: pgPool).close();
      verify(() => pgPool.close()).called(1);
    });
    test('status returns status', () async {
      final pgPool = _MockPgPool();
      final status = _MockPgPoolStatus();
      when(() => pgPool.status()).thenReturn(status);
      expect(PgPoolPostgresBuilder(connection: pgPool).status(), status);
    });

    group('runQuery', () {
      late PgPool pgPool;
      late PostgreSQLResult result;
      late PgPoolPostgresBuilder builder;
      const sql = ProcessedSql(query: '__query__', parameters: {});
      setUp(() {
        pgPool = _MockPgPool();
        result = _MockPostgreSQLResult();
        builder = PgPoolPostgresBuilder(connection: pgPool);
        when(
          () => pgPool.query(
            any(),
            substitutionValues: any(named: 'substitutionValues'),
          ),
        ).thenAnswer((_) async => result);
      });

      test('returns empty list if results are empty', () {
        when(() => result.isEmpty).thenReturn(true);

        expect(builder.runQuery(sql), completion(equals([])));
      });
      test('returns the correct value', () {
        final row = _MockPostgreSQLResultRow();
        final column = _MockColumnDescription();
        when(() => column.columnName).thenReturn('__columnName__');
        when(() => result.columnDescriptions).thenReturn([column]);
        when(() => result.isEmpty).thenReturn(false);
        when(() => result[any()]).thenReturn(row);
        when(() => result.length).thenReturn(1);
        when(() => row[any()]).thenReturn('__value__');
        when(() => row.length).thenReturn(1);

        expect(
          builder.runQuery(sql),
          completion(
            equals([
              {'__columnName__': '__value__'},
            ]),
          ),
        );
      });
      test('throws a PostgresBuilderException on PostgreSQLException', () {
        when(
          () => pgPool.query(
            any(),
            substitutionValues: any(named: 'substitutionValues'),
          ),
        ).thenThrow(PostgreSQLException('__message__'));

        expect(
          () => builder.runQuery(sql),
          throwsA(
            isA<PostgresBuilderException>().having(
              (exception) => exception.message,
              'message',
              equals('__message__'),
            ),
          ),
        );
      });
    });
  });
}
