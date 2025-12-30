-- migrate:up
CREATE EXTENSION pg_ivm;

-- Add pg_ivm to preload libraries
shared_preload_libraries = 'pg_ivm';

-- migrate:down
DROP EXTENSION pg_ivm;

shared_preload_libraries = '';
