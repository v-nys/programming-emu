#lang racket
(require db)
(define sqlc
  (sqlite3-connect #:database "db.sqlite" #:mode 'create))
(query-exec sqlc
  "CREATE TABLE IF NOT EXISTS Glossary(term varchar(100), explanation varchar(500))")
(query-exec sqlc
  "CREATE TABLE IF NOT EXISTS Titles(pagenode varchar(500), title varchar(500))")
; (query-exec sqlc "INSERT INTO glossary(term,explanation) VALUES ('boheemse herder', 'kleine tsjechische voorouder van de duitse herder')")
