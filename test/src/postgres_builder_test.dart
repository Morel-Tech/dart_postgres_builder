import 'dart:async';

import 'package:json_annotation/json_annotation.dart';
import 'package:mocktail/mocktail.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

class _MockSqlStatement extends Mock implements SqlStatement {}

class TestBuilder extends PostgresBuilder {
  const TestBuilder({
    required this.results,
  });

  final List<Map<String, dynamic>> Function() results;

  @override
  FutureOr<List<Map<String, dynamic>>> query(SqlStatement statement) =>
      results();

  @override
  FutureOr<List<Map<String, dynamic>>> rawQuery(
    String query, {
    Map<String, dynamic> substitutionValues = const {},
  }) =>
      results();
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
    test('singleQuery returns first element in list', () {
      expect(
        builder.singleQuery(_MockSqlStatement()),
        completion(equals({'key': 'value'})),
      );
    });

    test('rawSingleQuery returns first element in list', () {
      expect(
        builder.rawSingleQuery('__query__'),
        completion(equals({'key': 'value'})),
      );
    });

    test('mappedQuery returns elements', () {
      expect(
        builder.mappedQuery(
          _MockSqlStatement(),
          fromJson: (json) => json['key'] as String,
        ),
        completion(equals(['value'])),
      );
    });
    test(
        'mappedQuery throws PostgresBuilderException '
        'on CheckFromJsonException', () {
      expect(
        () async => errorBuilder.mappedQuery(
          _MockSqlStatement(),
          fromJson: (json) => json['key'] as String,
        ),
        throwsA(isA<PostgresBuilderException>()),
      );
    });

    test('rawMappedQuery returns elements', () {
      expect(
        builder.rawMappedQuery(
          '__query__',
          fromJson: (json) => json['key'] as String,
        ),
        completion(equals(['value'])),
      );
    });

    test('mappedSingleQuery returns first mapped element', () {
      expect(
        builder.mappedSingleQuery(
          _MockSqlStatement(),
          fromJson: (json) => json['key'] as String,
        ),
        completion(equals('value')),
      );
    });

    test(
        'mappedSingleQuery throws PostgresBuilderException '
        'on CheckFromJsonException', () {
      expect(
        () async => errorBuilder.mappedSingleQuery(
          _MockSqlStatement(),
          fromJson: (json) => json['key'] as String,
        ),
        throwsA(isA<PostgresBuilderException>()),
      );
    });

    test('rawMappedSingleQuery returns first mapped element', () {
      expect(
        builder.rawMappedSingleQuery(
          '__query__',
          fromJson: (json) => json['key'] as String,
        ),
        completion(equals('value')),
      );
    });
  });
}
