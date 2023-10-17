import 'dart:async';
import 'dart:io' hide stdout;

import 'package:json_annotation/json_annotation.dart';
import 'package:mocktail/mocktail.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

class _MockSqlStatement extends Mock implements SqlStatement {}

class _MockStdout extends Mock implements Stdout {}

class _MockProcessedSql extends Mock implements ProcessedSql {}

class TestBuilder extends PostgresBuilder {
  const TestBuilder({
    required this.results,
    super.debug = false,
    super.logger,
    super.customTypeConverter,
  });

  final List<Map<String, dynamic>> Function() results;

  @override
  FutureOr<List<Map<String, dynamic>>> runQuery(ProcessedSql sql) => results();
}

void main() {
  group('PostgresBuilder', () {
    final builder = TestBuilder(
      results: () => [
        {'key': 'value'},
      ],
    );
    final errorBuilder = TestBuilder(
      results: () => throw CheckedFromJsonException(
        {'key': 'value'},
        'key',
        'className',
        'message',
      ),
    );

    late SqlStatement statement;
    late ProcessedSql sql;

    setUp(() {
      statement = _MockSqlStatement();
      sql = _MockProcessedSql();

      when(() => statement.toSql()).thenReturn(sql);
      when(() => sql.query).thenReturn('__query__');
      when(() => sql.parameters).thenReturn({});
    });

    test('query returns results', () {
      expect(
        builder.query(statement),
        completion(
          equals([
            {'key': 'value'}
          ]),
        ),
      );
    });

    test('singleQuery returns first element in list', () {
      expect(
        builder.singleQuery(statement),
        completion(equals({'key': 'value'})),
      );
    });

    test('rawQuery returns results', () {
      expect(
        builder.rawQuery('__query__'),
        completion(
          equals([
            {'key': 'value'}
          ]),
        ),
      );
    });

    test('rawSingleQuery returns first element in list', () {
      expect(
        builder.rawSingleQuery('__query__'),
        completion(equals({'key': 'value'})),
      );
    });

    group('mapped query', () {
      test('returns elements', () {
        expect(
          builder.mappedQuery(
            statement,
            fromJson: (json) => json['key'] as String,
          ),
          completion(equals(['value'])),
        );
      });
      test('throws PostgresBuilderException on CheckFromJsonException', () {
        expect(
          () async => errorBuilder.mappedQuery(
            statement,
            fromJson: (json) => json['key'] as String,
          ),
          throwsA(isA<PostgresBuilderException>()),
        );
      });
    });

    group('rawMappedQuery', () {
      test('returns elements', () {
        expect(
          builder.rawMappedQuery(
            '__query__',
            fromJson: (json) => json['key'] as String,
          ),
          completion(equals(['value'])),
        );
      });
      test('throws PostgresBuilderException on CheckFromJsonException', () {
        expect(
          () async => errorBuilder.rawMappedQuery(
            '__query__',
            fromJson: (json) => json['key'] as String,
          ),
          throwsA(isA<PostgresBuilderException>()),
        );
      });
    });
    group('mappedSingleQuery', () {
      test('returns first mapped element', () {
        expect(
          builder.mappedSingleQuery(
            statement,
            fromJson: (json) => json['key'] as String,
          ),
          completion(equals('value')),
        );
      });

      test('throws PostgresBuilderException on CheckFromJsonException', () {
        expect(
          () async => errorBuilder.mappedSingleQuery(
            statement,
            fromJson: (json) => json['key'] as String,
          ),
          throwsA(isA<PostgresBuilderException>()),
        );
      });
    });

    group('rawMappedSingleQuery', () {
      test('returns first mapped element', () {
        expect(
          builder.rawMappedSingleQuery(
            '__query__',
            fromJson: (json) => json['key'] as String,
          ),
          completion(equals('value')),
        );
      });
      test('throws PostgresBuilderException on CheckFromJsonException', () {
        expect(
          () async => errorBuilder.rawMappedSingleQuery(
            '__query__',
            fromJson: (json) => json['key'] as String,
          ),
          throwsA(isA<PostgresBuilderException>()),
        );
      });
    });
    test('execute calls the query', () {
      expect(builder.execute(statement), completes);
    });

    test('standardLogger returns correctly', () {
      final stdout = _MockStdout();
      PostgresBuilder.standardLogger(
        stdout: stdout,
        const ProcessedSql(query: '__test__', parameters: {}),
      );
      verify(
        () => stdout.writeln("\n--EXECUTING--\n__test__\n--WITH--\n'{}'\n\n"),
      ).called(1);
    });

    test('logger is called when debugging', () async {
      var logCount = 0;
      final builder = TestBuilder(
        results: () => [],
        debug: true,
        logger: (message) => logCount++,
      );
      await builder.query(statement);
      expect(logCount, equals(1));
    });
    test('custom type converter converts types', () {
      final builder = TestBuilder(
        results: () => [
          {'key': 'value'}
        ],
        customTypeConverter: (input) => 'new_value',
      );
      expect(
        builder.singleQuery(statement),
        completion(equals({'key': 'new_value'})),
      );
    });
  });
}
