start:
	notify-send -i drracket "Build gestart"; raco pollen reset

preprocessor:
	find -iname '*.p' | xargs raco pollen render ; find -iname '*.pp' | xargs raco pollen render

publish:
	rm -rf ~/publish; raco pollen publish

serve:
	docker container restart apache_pollen_server

makecache:
	racket initSQLiteDB.rkt

rmcache:
	rm -f db.sqlite

content:
	(find -iname '*.pm' | sed '/^\.\/projects\/parenlog\/parenlog\.html\.pm$$\|^\.\/coda\/glossary\.html\.pm$$\|^\.\/index\.html\.pm$$/d'; echo './projects/parenlog/parenlog.html.pm'; echo './coda/glossary.html.pm'; echo './index.html.pm') | xargs raco pollen render

all: start preprocessor rmcache makecache content publish serve
	notify-send -i drracket "Build afgewerkt"
