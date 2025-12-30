-- migrate:up
CREATE EXTENSION pg_ivm;

-- migrate:down
DROP EXTENSION pg_ivm;

