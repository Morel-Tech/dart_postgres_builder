// ignore_for_file: unused_local_variable

import 'package:postgres_builder/postgres_builder.dart';

Future<void> main() async {
  final builder = PgPoolPostgresBuilder(
    pgEndpoint: PgEndpoint(
      host: 'localhost',
      database: 'postgres',
    ),
  );

  final users = await builder.mappedQuery(
    const Select(
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
