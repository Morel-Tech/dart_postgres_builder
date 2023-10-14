import 'dart:async';

import 'package:json_annotation/json_annotation.dart';
import 'package:postgres_builder/postgres_builder.dart';

abstract class PostgresBuilder {
  const PostgresBuilder();
  FutureOr<List<Map<String, dynamic>>> query(SqlStatement statement);
  FutureOr<List<Map<String, dynamic>>> rawQuery(
    String query, {
    Map<String, dynamic> substitutionValues = const {},
  });

  Future<Map<String, dynamic>> singleQuery(SqlStatement statement) async =>
      (await query(statement)).single;
  Future<List<T>> mappedQuery<T>(
    SqlStatement statement, {
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    try {
      return (await query(statement)).map(fromJson).toList();
    } on CheckedFromJsonException catch (e) {
      throw PostgresBuilderException(
        e.message,
        {'key': e.key, 'badKey': e.badKey, 'map': e.map},
      );
    }
  }

  Future<T> mappedSingleQuery<T>(
    SqlStatement statement, {
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    try {
      return fromJson(await singleQuery(statement));
    } on CheckedFromJsonException catch (e) {
      throw PostgresBuilderException(
        e.message,
        {'key': e.key, 'badKey': e.badKey, 'map': e.map},
      );
    }
  }

  Future<Map<String, dynamic>> rawSingleQuery(
    String query, {
    Map<String, dynamic> substitutionValues = const {},
  }) async =>
      (await rawQuery(query, substitutionValues: substitutionValues)).single;

  Future<List<T>> rawMappedQuery<T>(
    String query, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic> substitutionValues = const {},
  }) async =>
      (await rawQuery(query, substitutionValues: substitutionValues))
          .map(fromJson)
          .toList();

  Future<T> rawMappedSingleQuery<T>(
    String query, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic> substitutionValues = const {},
  }) async =>
      fromJson(
        await rawSingleQuery(query, substitutionValues: substitutionValues),
      );
}
