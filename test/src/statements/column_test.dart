import 'package:mocktail/mocktail.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

class _MockSelect extends Mock implements Select {}

void main() {
  group('Column', () {
    group('toSql', () {
      test('returns correctly with all properties', () {
        expect(
          const Column('__colName__', as: '__alias__', table: '__table__')
              .toSql(),
          equalsSql(
            query: '__table__.__colName__ AS "__alias__"',
          ),
        );
      });
      test('returns correctly with no alias or table', () {
        expect(
          const Column('__colName__').toSql(),
          equalsSql(
            query: '__colName__',
          ),
        );
      });
      test('returns correctly with just alias', () {
        expect(
          const Column('__colName__', as: '__alias__').toSql(),
          equalsSql(
            query: '__colName__ AS "__alias__"',
          ),
        );
      });
      test('returns correctly with just table', () {
        expect(
          const Column('__colName__', table: '__table__').toSql(),
          equalsSql(
            query: '__table__.__colName__',
          ),
        );
      });
    });
    group('paramName returns correct', () {
      test('when table is null', () {
        expect(const Column('col_name').parameterName, 'colName');
      });
      test('when table is not null', () {
        expect(
          const Column('col_name', table: 'table_name').parameterName,
          'tableNameColName',
        );
      });
    });

    group('operators and comparison methods', () {
      late Column column;

      setUp(() {
        column = const Column('__colName__', table: '__table__');
      });

      test('~ operator returns Not', () {
        final result = ~column;
        expect(result, isA<Not>());
        expect(
          result.toSql(),
          equalsSql(
            query: 'NOT __table__.__colName__',
          ),
        );
      });

      test('equals returns Equals', () {
        final result = column.equals('__value__');
        expect(result, isA<Equals>());
        expect(
          result.toSql(),
          equalsSql(
            query: '__table__.__colName__ = @tableColName',
            parameters: {'tableColName': '__value__'},
          ),
        );
      });

      test('notEquals returns NotEquals', () {
        final result = column.notEquals('__value__');
        expect(result, isA<NotEquals>());
        expect(
          result.toSql(),
          equalsSql(
            query: '__table__.__colName__ != @tableColName',
            parameters: {'tableColName': '__value__'},
          ),
        );
      });

      test('greaterThan returns GreaterThan', () {
        final result = column.greaterThan('__value__');
        expect(result, isA<GreaterThan>());
        expect(
          result.toSql(),
          equalsSql(
            query: '__table__.__colName__ > @tableColName',
            parameters: {'tableColName': '__value__'},
          ),
        );
      });

      test('greaterThanOrEqual returns GreaterThanOrEqual', () {
        final result = column.greaterThanOrEqual('__value__');
        expect(result, isA<GreaterThanOrEqual>());
        expect(
          result.toSql(),
          equalsSql(
            query: '__table__.__colName__ >= @tableColName',
            parameters: {'tableColName': '__value__'},
          ),
        );
      });

      test('lessThan returns LessThan', () {
        final result = column.lessThan('__value__');
        expect(result, isA<LessThan>());
        expect(
          result.toSql(),
          equalsSql(
            query: '__table__.__colName__ < @tableColName',
            parameters: {'tableColName': '__value__'},
          ),
        );
      });

      test('lessThanOrEqual returns LessThanOrEqual', () {
        final result = column.lessThanOrEqual('__value__');
        expect(result, isA<LessThanOrEqual>());
        expect(
          result.toSql(),
          equalsSql(
            query: '__table__.__colName__ <= @tableColName',
            parameters: {'tableColName': '__value__'},
          ),
        );
      });

      test('between returns Between', () {
        final result = column.between('__lower__', '__upper__');
        expect(result, isA<Between>());
        expect(
          result.toSql(),
          equalsSql(
            query:
                '''__table__.__colName__ BETWEEN @tableColName_lower AND @tableColName_upper''',
            parameters: {
              'tableColName_lower': '__lower__',
              'tableColName_upper': '__upper__',
            },
          ),
        );
      });

      test('ascending returns Sort with default direction', () {
        final result = column.ascending();
        expect(result, isA<Sort>());
        expect(
          result.toSql(),
          equalsSql(
            query: '__table__.__colName__ ASC',
          ),
        );
      });

      test('descending returns Sort with descending direction', () {
        final result = column.descending();
        expect(result, isA<Sort>());
        expect(
          result.toSql(),
          equalsSql(
            query: '__table__.__colName__ DESC',
          ),
        );
      });

      test('isNull returns IsNull', () {
        final result = column.isNull();
        expect(result, isA<IsNull>());
        expect(
          result.toSql(),
          equalsSql(
            query: '__table__.__colName__ IS NULL',
          ),
        );
      });

      test('isNotNull returns IsNotNull', () {
        final result = column.isNotNull();
        expect(result, isA<IsNotNull>());
        expect(
          result.toSql(),
          equalsSql(
            query: '__table__.__colName__ IS NOT NULL',
          ),
        );
      });
    });
  });
  group('Column.star()', () {
    group('toSql', () {
      test('returns correctly with no properties', () {
        expect(
          const Column.star().toSql(),
          equalsSql(
            query: '*',
          ),
        );
      });
      test('returns correctly with  table', () {
        expect(
          const Column.star(table: '__table__').toSql(),
          equalsSql(
            query: '__table__.*',
          ),
        );
      });
    });
  });
  group('Column.nested()', () {
    group('toSql', () {
      late Select select;
      setUp(() {
        select = _MockSelect();
        when(() => select.toSql()).thenReturn(
          const ProcessedSql(
            query: '__query__',
            parameters: {'__key__': '__value__'},
          ),
        );
      });
      test('returns correctly with no properties', () {
        expect(
          Column.nested(select, as: '__alias__').toSql(),
          equalsSql(
            query:
                '''(SELECT COALESCE(json_agg(__alias__.*), '[]'::json) FROM (__query__) as __alias__) as "__alias__"''',
            parameters: {'__key__': '__value__'},
          ),
        );
      });
      test('returns correctly when single', () {
        expect(
          Column.nested(select, as: '__alias__', single: true).toSql(),
          equalsSql(
            query:
                '''(SELECT row_to_json(__alias__.*) FROM (__query__) as __alias__) as "__alias__"''',
            parameters: {'__key__': '__value__'},
          ),
        );
      });
      test('returns correctly when as is null', () {
        expect(
          Column.nested(select, as: null, single: true).toSql(),
          equalsSql(
            query: '''(SELECT row_to_json(*) FROM (__query__))''',
            parameters: {'__key__': '__value__'},
          ),
        );
      });
      test('returns correctly when as is null an not single', () {
        expect(
          Column.nested(select, as: null).toSql(),
          equalsSql(
            query:
                '''(SELECT COALESCE(json_agg(*), '[]'::json) FROM (__query__))''',
            parameters: {'__key__': '__value__'},
          ),
        );
      });
      test('returns correctly when as is null an convert to json is false', () {
        expect(
          Column.nested(select, as: null, convertToJson: false).toSql(),
          equalsSql(
            query: '(__query__)',
            parameters: {'__key__': '__value__'},
          ),
        );
      });
      test('returns correctly when as is set an convert to json is false', () {
        expect(
          Column.nested(select, as: '__alias__', convertToJson: false).toSql(),
          equalsSql(
            query: '(__query__) AS "__alias__"',
            parameters: {'__key__': '__value__'},
          ),
        );
      });
    });
  });
}
