" Vim syntax file
" Language:   PAC (AM Simple Packing Format)
" Maintainer: André Müller
" Version:    1.0.0

"   _______________________________
"  | #SCENARIO                     |  optional: multiple solutions                    
"  |     <# scenarios>             |                     
"  | #PACKING                      |  1st solution
"  | #CONTAINER                    |
"  |   <container type of batch 0> |  1st batch of containers
"  |   <# in batch 0>              |
"  |     <container 0>             |
"  |     <container 1>             |
"  |     ...                       |
"  |   <container type of batch 1> |  2nd batch of containers
"  |   <# in batch 1>              |
"  |     <container 0>             |
"  |     <container 1>             |
"  |     ...                       |
"  |   ...                         |
"  | #CONTENT                      |  content of container 0
"  |   <item type of batch 0>      |  1st batch of items
"  |   <# in batch 0>              |  
"  |     <item 0>                  |
"  |     <item 1>                  |
"  |     ...                       |
"  |   <item type of batch 1>      |  2nd batch of items
"  |   <# in batch 1>              |
"  |     <item 2>                  |
"  |     <item 3>                  |
"  |     ...                       |
"  |   ...                         |
"  | #CONTENT                      |  content of container 1
"  |   <item type of batch 0>      |
"  |   <# in batch 0>              |
"  |     <item 0>                  |
"  |     <item 1>                  |
"  |     ...                       |
"  |   ...                         |
"  | #REMAINING                    |  optional: loose items
"  |   <item type of batch 0>      |
"  |   <# in batch 0>              |
"  |     <item 0>                  |
"  |     <item 1>                  |
"  |     ...                       |
"  |   ...                         |
"  | #PACKING                      |  2nd solution 
"  | ...                           |
"   ------------------------------- 
"
"  minimal viable file ('.shp'):
"   _________________________
"  | <item type of batch 0>  |
"  | <# in batch 0>          |
"  |   <item 0>              |
"  |   <item 1>              |
"  |   ...                   |
"   -------------------------


if exists("b:current_syntax")
    finish
endif


syn match   pacNumber       "[-+]\=\<\([0-9]*[.]\)\=[0-9]\+\([eE][-+]\=\d\+\)\=\>"
syn match   pacSeparator    "\s\+//\s\+"

syn match   pacScenario     "^\s*#SCENARIO\s*$"  skipnl
syn match   pacPacking      "^\s*#PACKING\s*$"   skipnl
syn match   pacContainer    "^\s*#CONTAINER\s*$" skipnl
syn match   pacContent      "^\s*#CONTENT\s*$"   skipnl
syn match   pacRemaining    "^\s*#REMAINING\s*$" skipnl

syn match   pacFileRef      "^\s*\$file\s*\(//\s*\$plac\(ing\|e\|ement\)\>\s*\)\=\s*$" contains=pacSeparator skipnl
syn match   pacEntityCount  "^\s*[0-9]\+\s*$" skipnl

syn keyword pacEntityType   NONE None
syn keyword pacEntityType   Circle
syn keyword pacEntityType   Ellipse
syn keyword pacEntityType   SquareAA Square RectangleAA Rectangle
syn keyword pacEntityType   RegularTriangle RegularPentagon RegularHexagon 
syn keyword pacEntityType   RegularHeptagon RegularOctagon RegularNonagon RegularDecagon
syn keyword pacEntityType   Capsule2d
syn keyword pacEntityType   Polygon
syn keyword pacEntityType   Sphere HyperSphere4d HyperSphere5d
syn keyword pacEntityType   Ellipsoid
syn keyword pacEntityType   CubeAA Cube CuboidAA Cuboid
syn keyword pacEntityType   RegularTetrahedron RegularPyramid
syn keyword pacEntityType   Capsule
syn keyword pacEntityType   PointCloud TriangleCloud
syn keyword pacEntityType   TriangleMesh


" Default Highlight
hi def link pacNumber       Number
hi def link pacSeparator    String
hi def link pacScenario     PreProc
hi def link pacPacking      PreProc
hi def link pacContainer    Keyword
hi def link pacContent      Keyword
hi def link pacRemaining    Keyword
hi def link pacFileRef      Type
hi def link pacEntityType   Type 
hi def link pacEntityCount  Identifier 


let b:current_syntax = "pac"
