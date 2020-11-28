#lang pollen
◊(require file/convertible "resolution_without_renaming.rkt")
◊(bytes->string/utf-8 (convert drawing 'svg-bytes))