all:
	notify-send -i drracket "Build begonnen"; rm -rf ~/publish; raco pollen reset; raco pollen render; raco pollen publish; docker container restart apache_pollen_server; notify-send -i drracket "Build afgewerkt"
