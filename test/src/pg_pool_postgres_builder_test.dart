// ignore_for_file: unnecessary_lambdas

import 'package:mocktail/mocktail.dart';
import 'package:postgres/postgres.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

class _MockPool extends Mock implements Pool<void> {}

class _MockResult extends Mock implements Result {}

class _MockResultRow extends Mock implements ResultRow {}

void main() {
  group('PgPoolPostgresBuilder', () {
    final endpoint = Endpoint(host: 'host', database: 'database');
    test('can be instantiated', () {
      expect(PgPoolPostgresBuilder(pgEndpoint: endpoint), isNotNull);
    });

    test('close closes connection', () async {
      final pgPool = _MockPool();
      when(() => pgPool.close()).thenAnswer((_) async {});
      await PgPoolPostgresBuilder(
        pool: pgPool,
        pgEndpoint: endpoint,
      ).close();
      verify(() => pgPool.close()).called(1);
    });

    group('runQuery', () {
      late Pool<void> pgPool;
      late Result result;
      late PgPoolPostgresBuilder builder;
      const sql = ProcessedSql(query: '__query__', parameters: {});
      setUp(() {
        pgPool = _MockPool();
        result = _MockResult();
        builder = PgPoolPostgresBuilder(
          pool: pgPool,
          pgEndpoint: endpoint,
        );
        when(
          () => pgPool.execute(
            any(),
            parameters: any(named: 'parameters'),
          ),
        ).thenAnswer((_) async => result);
      });

      test('returns empty list if results are empty', () {
        when(() => result.isEmpty).thenReturn(true);

        expect(builder.runQuery(sql), completion(equals([])));
      });
      test('returns the correct value', () {
        final row = _MockResultRow();
        final schema = ResultSchema([
          ResultSchemaColumn(
            typeOid: 0,
            type: Type.text,
            columnName: '__columnName__',
          ),
        ]);

        when(() => result.isEmpty).thenReturn(false);
        when(() => result[any()]).thenReturn(row);
        when(() => result.length).thenReturn(1);
        when(() => result.schema).thenReturn(schema);
        when(() => row[any()]).thenReturn('__value__');

        expect(
          builder.runQuery(sql),
          completion(
            equals([
              {'__columnName__': '__value__'},
            ]),
          ),
        );
      });
      test('throws a PostgresBuilderException on ServerException', () {
        when(
          () => pgPool.execute(
            any(),
            parameters: any(named: 'parameters'),
          ),
          // ignore: invalid_use_of_internal_member
        ).thenThrow(ServerException('__message__'));

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
