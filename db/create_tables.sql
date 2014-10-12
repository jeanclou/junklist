CREATE TABLE top_sites (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name CHAR(255),
	scheme CHAR(10),
	host CHAR(255),
	path CHAR(255),
	query CHAR(255),
	url CHAR(512)
);

CREATE TABLE ext_links (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name CHAR(255),
	scheme CHAR(10),
	host CHAR(255),
	path CHAR(255),
	query CHAR(255),
	url CHAR(512),
	top_id INTEGER
);


