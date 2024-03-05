## 1.0.1

- Added much more detail to errors when `ServerError` is throw on `PgPoolPostgresBuilder`

## 1.0.0

- Changed `PgPoolPostgresBuilder` implementation to use `postgres` package in place of the discontinued `postgres_pool`.
- **breaking** removed `PgPoolPostgresBuilder.status` due to this change.

## 0.3.1

- Fixed a bug with `And` and `Or` not passing parameters correctly.

## 0.3.0

- Fixed spelling on `OperatorComparision`
- Fixed issue with `OperatorComparision` not always generating correct SQL

## 0.2.0

- Added `columnFirst` parameter on `OperatorComparision`

## 0.1.1

- Fixed `Group` not generating correct query

## 0.1.0

- Added `Group` to support `GROUP BY` clauses

## 0.0.3

- Added some documentation
- Fixed some exports
- Added `rawExecute` to keep parity with other `raw` methods
- Changed `PgPoolPostgresBuilder.status()` to `PgPoolPostgresBuilder.status`

## 0.0.2

- Added more specific options to `PgPoolPostgresBuilder`

## 0.0.1

- First public release!
