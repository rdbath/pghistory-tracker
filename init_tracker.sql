-- hist_tracker
CREATE SCHEMA hist_tracker;


-- _HT_NextTagValue(text, text)
CREATE OR REPLACE FUNCTION _HT_NextTagValue(dbschema text, dbtable text)
RETURNS integer AS
$$
DECLARE
	sql text;
	cnt integer;

BEGIN
	sql := 'SELECT MAX(id_tag) FROM hist_tracker.tags 
		WHERE dbschema = ''' || quote_ident(dbschema) || '''
		AND dbtable = ''' || quote_ident(dbtable) || '''';

	EXECUTE sql INTO cnt;

	IF cnt IS NULL THEN
		RETURN 1;
	ELSE
		RETURN cnt + 1;
	END IF;
END;
$$
LANGUAGE plpgsql VOLATILE;

-- hist_tracker.tags
CREATE TABLE hist_tracker.tags (
	id serial PRIMARY KEY,
	id_tag integer CHECK (id_tag = _HT_NextTagValue(dbschema, dbtable)),
	dbschema character varying,
	dbtable character varying,
	dbuser character varying,
	time_tag timestamp,
	changes_count integer,
	message character varying
);

-- # vim: set syntax=python ts=4 sts=4 sw=4 noet: 
