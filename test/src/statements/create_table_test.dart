import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('CreateTable', () {
    test('toSql returns correctly (backward compatibility)', () {
      final columns = [
        const ColumnDefinition(name: 'id', type: 'SERIAL', primaryKey: true),
        const ColumnDefinition(name: 'name', type: 'TEXT'),
      ];
      final statement = CreateTable(
        name: 'users',
        columns: columns,
        ifNotExists: true,
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''CREATE TABLE IF NOT EXISTS users (id SERIAL NOT NULL PRIMARY KEY, name TEXT NOT NULL)''',
          parameters: {},
        ),
      );
    });

    test('toSql with composite primary key', () {
      final columns = [
        const ColumnDefinition(name: 'user_id', type: 'INTEGER'),
        const ColumnDefinition(name: 'tenant_id', type: 'INTEGER'),
        const ColumnDefinition(name: 'name', type: 'TEXT'),
      ];
      final statement = CreateTable(
        name: 'user_tenants',
        columns: columns,
        constraints: [
          PrimaryKeyConstraint(['user_id', 'tenant_id']),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''CREATE TABLE user_tenants (user_id INTEGER NOT NULL, tenant_id INTEGER NOT NULL, name TEXT NOT NULL, PRIMARY KEY (user_id, tenant_id))''',
          parameters: {},
        ),
      );
    });

    test('toSql with composite primary key and ifNotExists', () {
      final columns = [
        const ColumnDefinition(name: 'user_id', type: 'INTEGER'),
        const ColumnDefinition(name: 'tenant_id', type: 'INTEGER'),
        const ColumnDefinition(name: 'email', type: 'TEXT'),
      ];
      final statement = CreateTable(
        name: 'user_tenants',
        columns: columns,
        ifNotExists: true,
        constraints: [
          PrimaryKeyConstraint(['user_id', 'tenant_id']),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''CREATE TABLE IF NOT EXISTS user_tenants (user_id INTEGER NOT NULL, tenant_id INTEGER NOT NULL, email TEXT NOT NULL, PRIMARY KEY (user_id, tenant_id))''',
          parameters: {},
        ),
      );
    });

    test('toSql with multiple table constraints', () {
      final columns = [
        const ColumnDefinition(name: 'user_id', type: 'INTEGER'),
        const ColumnDefinition(name: 'tenant_id', type: 'INTEGER'),
        const ColumnDefinition(name: 'email', type: 'TEXT'),
        const ColumnDefinition(name: 'created_at', type: 'TIMESTAMP'),
      ];
      final statement = CreateTable(
        name: 'user_accounts',
        columns: columns,
        constraints: [
          PrimaryKeyConstraint(['user_id', 'tenant_id']),
          UniqueConstraint(['email', 'tenant_id']),
          const CheckConstraint("created_at > '2020-01-01'::timestamp"),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''CREATE TABLE user_accounts (user_id INTEGER NOT NULL, tenant_id INTEGER NOT NULL, email TEXT NOT NULL, created_at TIMESTAMP NOT NULL, PRIMARY KEY (user_id, tenant_id), UNIQUE (email, tenant_id), CHECK (created_at > '2020-01-01'::timestamp))''',
          parameters: {},
        ),
      );
    });

    test('toSql with named constraints', () {
      final columns = [
        const ColumnDefinition(name: 'id', type: 'SERIAL'),
        const ColumnDefinition(name: 'tenant_id', type: 'INTEGER'),
        const ColumnDefinition(name: 'email', type: 'TEXT'),
      ];
      final statement = CreateTable(
        name: 'users',
        columns: columns,
        constraints: [
          PrimaryKeyConstraint(['id', 'tenant_id'], name: 'users_pk'),
          UniqueConstraint(['email'], name: 'users_email_unique'),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''CREATE TABLE users (id SERIAL NOT NULL, tenant_id INTEGER NOT NULL, email TEXT NOT NULL, CONSTRAINT users_pk PRIMARY KEY (id, tenant_id), CONSTRAINT users_email_unique UNIQUE (email))''',
          parameters: {},
        ),
      );
    });

    test('toSql with foreign key constraint', () {
      final columns = [
        const ColumnDefinition(name: 'id', type: 'SERIAL'),
        const ColumnDefinition(name: 'user_id', type: 'INTEGER'),
        const ColumnDefinition(name: 'tenant_id', type: 'INTEGER'),
        const ColumnDefinition(name: 'title', type: 'TEXT'),
      ];
      final statement = CreateTable(
        name: 'posts',
        columns: columns,
        constraints: [
          PrimaryKeyConstraint(['id']),
          const ForeignKeyTableConstraint(
            ForeignKeyConstraint(
              columns: ['user_id', 'tenant_id'],
              referencesTable: 'users',
              referencesColumns: ['id', 'tenant_id'],
            ),
          ),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''CREATE TABLE posts (id SERIAL NOT NULL, user_id INTEGER NOT NULL, tenant_id INTEGER NOT NULL, title TEXT NOT NULL, PRIMARY KEY (id), FOREIGN KEY (user_id, tenant_id) REFERENCES users (id, tenant_id))''',
          parameters: {},
        ),
      );
    });

    test('toSql with foreign key constraint with cascades', () {
      final columns = [
        const ColumnDefinition(name: 'id', type: 'SERIAL'),
        const ColumnDefinition(name: 'user_id', type: 'INTEGER'),
        const ColumnDefinition(name: 'content', type: 'TEXT'),
      ];
      final statement = CreateTable(
        name: 'comments',
        columns: columns,
        constraints: [
          PrimaryKeyConstraint(['id']),
          const ForeignKeyTableConstraint(
            ForeignKeyConstraint(
              columns: ['user_id'],
              referencesTable: 'users',
              referencesColumns: ['id'],
              onDelete: ReferentialAction.cascade,
              onUpdate: ReferentialAction.restrict,
            ),
          ),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''CREATE TABLE comments (id SERIAL NOT NULL, user_id INTEGER NOT NULL, content TEXT NOT NULL, PRIMARY KEY (id), FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE RESTRICT)''',
          parameters: {},
        ),
      );
    });

    test('toSql with no constraints (empty list)', () {
      final columns = [
        const ColumnDefinition(name: 'id', type: 'INTEGER'),
        const ColumnDefinition(name: 'name', type: 'TEXT'),
      ];
      final statement = CreateTable(
        name: 'simple_table',
        columns: columns,
        constraints: [],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''CREATE TABLE simple_table (id INTEGER NOT NULL, name TEXT NOT NULL)''',
          parameters: {},
        ),
      );
    });

    test('toSql mixing column-level and table-level primary keys should work',
        () {
      final columns = [
        const ColumnDefinition(name: 'id', type: 'INTEGER', primaryKey: true),
        const ColumnDefinition(name: 'tenant_id', type: 'INTEGER'),
        const ColumnDefinition(name: 'name', type: 'TEXT'),
      ];
      final statement = CreateTable(
        name: 'mixed_table',
        columns: columns,
        constraints: [
          UniqueConstraint(['tenant_id', 'name']),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''CREATE TABLE mixed_table (id INTEGER NOT NULL PRIMARY KEY, tenant_id INTEGER NOT NULL, name TEXT NOT NULL, UNIQUE (tenant_id, name))''',
          parameters: {},
        ),
      );
    });

    test('toSql with single column primary key using constraint', () {
      final columns = [
        const ColumnDefinition(name: 'id', type: 'SERIAL'),
        const ColumnDefinition(name: 'name', type: 'TEXT'),
      ];
      final statement = CreateTable(
        name: 'users',
        columns: columns,
        constraints: [
          PrimaryKeyConstraint(['id']),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''CREATE TABLE users (id SERIAL NOT NULL, name TEXT NOT NULL, PRIMARY KEY (id))''',
          parameters: {},
        ),
      );
    });
  });
}
