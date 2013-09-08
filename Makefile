database:
	perl create_db
	rm -f perlcasts.db
	sqlite3 perlcasts.db < database.sql
