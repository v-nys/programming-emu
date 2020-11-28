#lang pollen
◊(require file/convertible "resolution_without_renaming_with_clash.rkt")
◊(bytes->string/utf-8 (convert drawing 'svg-bytes))