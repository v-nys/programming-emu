start:
	notify-send -i drracket "Build gestart"; raco pollen reset

preprocessor:
	find -iname '*.p' | xargs raco pollen render ; find -iname '*.pp' | xargs raco pollen render

publish:
	rm -rf ~/publish; raco pollen publish

serve:
	docker container restart apache_pollen_server

content:
	find -iname '*.pm' | raco pollen render

all: start preprocessor content publish serve
	notify-send -i drracket "Build afgewerkt"
