import 'dart:async';
import 'dart:io' as io;

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:postgres_builder/postgres_builder.dart';

abstract class PostgresBuilder {
  const PostgresBuilder({
    dynamic Function(dynamic input)? customTypeConverter,
    this.debug = false,
    FutureOr<void> Function(ProcessedSql message)? logger,
  })  : _customTypesConverter = customTypeConverter,
        _logger = logger ?? standardLogger;

  @visibleForOverriding
  FutureOr<List<Map<String, dynamic>>> runQuery(
    ProcessedSql processed,
  );

  final bool debug;
  final FutureOr<void> Function(ProcessedSql message) _logger;
  final dynamic Function(dynamic input)? _customTypesConverter;

  Future<List<Map<String, dynamic>>> _runQuery(
    ProcessedSql processed,
  ) async {
    if (debug) {
      _logger(processed);
    }

    final result = await runQuery(processed);
    return _customTypesConverter == null
        ? result
        : [
            for (final row in result)
              {
                for (final MapEntry(:key, :value) in row.entries)
                  key: _customTypesConverter!(value)
              }
          ];
  }

  Future<List<T>> _runMappedQuery<T>(
    ProcessedSql processed, {
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    try {
      final results = await _runQuery(processed);
      return results.map((e) => fromJson(e)).toList();
    } on CheckedFromJsonException catch (e) {
      throw PostgresBuilderException(
        e.message,
        {'key': e.key, 'badKey': e.badKey, 'map': e.map},
      );
    }
  }

  Future<List<Map<String, dynamic>>> query(
    SqlStatement statement,
  ) =>
      _runQuery(statement.toSql());

  Future<void> execute(SqlStatement statement) => _runQuery(statement.toSql());

  Future<Map<String, dynamic>> singleQuery(SqlStatement statement) async =>
      (await _runQuery(statement.toSql())).single;

  Future<List<T>> mappedQuery<T>(
    SqlStatement statement, {
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    return _runMappedQuery(statement.toSql(), fromJson: fromJson);
  }

  Future<T> mappedSingleQuery<T>(
    SqlStatement statement, {
    required T Function(Map<String, dynamic> json) fromJson,
  }) async =>
      (await _runMappedQuery(statement.toSql(), fromJson: fromJson)).single;

  Future<List<Map<String, dynamic>>> rawQuery(
    String query, {
    Map<String, dynamic> substitutionValues = const {},
  }) =>
      _runQuery(ProcessedSql(query: query, parameters: substitutionValues));

  Future<Map<String, dynamic>> rawSingleQuery(
    String query, {
    Map<String, dynamic> substitutionValues = const {},
  }) async =>
      (await _runQuery(
        ProcessedSql(query: query, parameters: substitutionValues),
      ))
          .single;

  Future<List<T>> rawMappedQuery<T>(
    String query, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic> substitutionValues = const {},
  }) =>
      _runMappedQuery(
        ProcessedSql(query: query, parameters: substitutionValues),
        fromJson: fromJson,
      );

  Future<T> rawMappedSingleQuery<T>(
    String query, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic> substitutionValues = const {},
  }) async =>
      (await _runMappedQuery(
        ProcessedSql(query: query, parameters: substitutionValues),
        fromJson: fromJson,
      ))
          .single;

  static void standardLogger(
    ProcessedSql value, {
    @visibleForTesting io.Stdout? stdout,
  }) =>
      (stdout ?? io.stdout).writeln(
        "\n--EXECUTING--\n${value.query}\n--WITH--\n'${value.parameters}'\n\n",
      );
}
