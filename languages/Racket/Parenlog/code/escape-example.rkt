(compile-rule
 `((sibling X Y)
   (parent Z X)
   (parent Z Y)
   (,(compose not equal?) X Y)))