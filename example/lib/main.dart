// ignore_for_file: unused_local_variable

import 'package:postgres_builder/postgres_builder.dart';

Future<void> main() async {
  final builder = PgPoolPostgresBuilder(
    host: 'localhost',
    port: 5432,
    databaseName: 'postgres',
  );

  final users = await builder.mappedQuery(
    Select(
      [
        Column.star(),
      ],
      from: 'users',
    ),
    fromJson: User.fromJson,
  );

  // use users
}

class User {
  const User({required this.name});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(name: json['name'] as String);

  final String name;
}
