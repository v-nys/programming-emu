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

# pagenodes with TOC's are removed so their descendants are processed first
# therefore, they are re-added in a bottom-up manner
# could use parallel rendering and locking in the future to make this less fragile
content:
	(find -iname '*.pm' | sed '/^\.\/index\.html\.pm$$/d' | sed '/^\.\/languages\/index\.html\.pm$$/d' | sed '/^\.\/languages\/Racket\/index\.html\.pm$$/d' | sed '/^\.\/languages\/Racket\/Parenlog\/parenlog\.html\.pm$$/d' | sed '/^\.\/coda\/glossary\.html\.pm$$/d'; echo './languages/Racket/Parenlog/parenlog.html.pm'; echo './languages/Racket/index.html.pm'; echo './languages/index.html.pm'; echo './coda/glossary.html.pm'; echo './index.html.pm') | xargs raco pollen render

all: start preprocessor rmcache makecache content publish serve
	notify-send -i drracket "Build afgewerkt"
