" Vim syntax file
" Language:   PAC (AM Simple Packing Format)
" Maintainer: André Müller
" Version:    1.0.0

"-----------------------------------------------------------------------------
" PAC File Format
"-----------------------------------------------------------------------------
"  - encoding: ASCII, multibyte characters must not be used
"  - line endings: LF only
"  - whitespace: no semantic meaning other than separating numbers / tags
"  - shape type names are case insensitive and can optionally contain
"    underscores or dashes, the preferred convention is to use CamelCase
"  - characters
"      - ignored: - _ , ;
"      - decimal separator: .
"      - reserved special:  ! @ # $ % ^ & * ( ) [ ] { } | \ / < > ~
"
"   _______________________________
"  | #SOLUTIONS                    |  |_ optional: multiple solutions
"  |     <# scenarios>             |  |
"  | #PACKING                      |  1st solution
"  | #CONTAINERS                   |
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
"  | #REMAINING                    |  |
"  |   <item type of batch 0>      |  |
"  |   <# in batch 0>              |  |- optional: loose items
"  |     <item 0>                  |  |  that are not contained
"  |     <item 1>                  |  |
"  |     ...                       |  |
"  |   ...                         |  |
"  | #PACKING                      |  2nd solution
"  | ...                           |
"   -------------------------------
"
"  EXAMPLE
"   _______________________________
"  | #PACKING                      |
"  | #CONTAINERS                   |
"  | Circle                        |
"  | 1                             |
"  | 20.0 0.0 0.0                  |
"  | #CONTENT                      |
"  | Rectangle                     |
"  | 2                             |
"  | 1.0 2.0 -5.0 0.0              |
"  | 1.0 2.0 5.0 0.0               |
"   -------------------------------

"-----------------------------------------------------------------------------
" SHP File Format (only shapes)
"-----------------------------------------------------------------------------
"   _______________________________
"  | <shape type>                  |
"  | <# of shapes>                 |
"  |   <shape 0>                   |
"  |   <shape 1>                   |
"  |   ...                         |
"   -------------------------------



if exists("b:current_syntax")
    finish
endif


syn match   pacNumber       "[-+]\=\<\([0-9]*[.]\)\=[0-9]\+\([eE][-+]\=\d\+\)\=\>"
syn match   pacSeparator    "\s\+//\s\+"

syn match   pacScenario     "#SOLUTION[S]\{0,1}"
syn match   pacPacking      "#PACKING"
syn match   pacContainer    "#CONTAINER[S]\{0,1}"
syn match   pacContent      "#CONTENT[S]\{0,1}"
syn match   pacRemaining    "#REMAINING"

syn match   pacFileRef      "$file\|$File\|$FILE"
syn match   pacEntityCount  "^\s*[0-9]\+\s*$" skipnl

syn keyword pacEntityType   NONE None none
syn keyword pacEntityType   Line line
syn keyword pacEntityType   Circle circle Ellipse ellipse Ring ring
syn keyword pacEntityType   SquareAA SquareAxisAligned AxisAlignedSquare
syn keyword pacEntityType   squareaa squareaxisaligned axisalignedsquare
syn keyword pacEntityType   Rect RectangleAA RectangleAxisAligned AxisAlignedRectangle
syn keyword pacEntityType   rect rectangleaa rectangleaxisaligned axisalignedrectangle
syn keyword pacEntityType   Square Rectangle square rectangle
syn keyword pacEntityType   Frame frame RoundedFrame roundedframe
syn keyword pacEntityType   RegularTriangle RegularPentagon RegularHexagon 
syn keyword pacEntityType   regulartriangle regularpentagon regularhexagon 
syn keyword pacEntityType   RegularHeptagon RegularOctagon RegularNonagon RegularDecagon
syn keyword pacEntityType   regularheptagon regularoctagon regularnonagon regulardecagon
syn keyword pacEntityType   Pentagon Hexagon Heptagon Octagon Nonagon Decagon
syn keyword pacEntityType   pentagon hexagon heptagon octagon nonagon decagon
syn keyword pacEntityType   Pill pill Capsule Capsule2d capsule capsule2d
syn keyword pacEntityType   RoundedRectangle roundedrectangle
syn keyword pacEntityType   Tri Triangle tri triangle
syn keyword pacEntityType   RightTriangle IsoTriangle IsoscelesTriangle
syn keyword pacEntityType   righttriangle isotriangle isoscelestriangle
syn keyword pacEntityType   EquiTriangle equitriangle 
syn keyword pacEntityType   EquilateralTriangle equilateraltriangle 
syn keyword pacEntityType   LLATriangle llatriangle
syn keyword pacEntityType   Diamond diamond
syn keyword pacEntityType   Parallelogram parallelogram
syn keyword pacEntityType   Trapezoid trapezoid
syn keyword pacEntityType   Dart dart Kite kite
syn keyword pacEntityType   House house Spear spear Chevron chevron Arrow arrow
syn keyword pacEntityType   Cross StraightH StraightL StraightT StraightU
syn keyword pacEntityType   cross straighth straightl straightt straightu
syn keyword pacEntityType   ChamferedRectangle chamferedrectangle
syn keyword pacEntityType   ChamferedFrame chamferedframe
syn keyword pacEntityType   IBeam Ibeam ibeam
syn keyword pacEntityType   Star RegularStar star regularstar
syn keyword pacEntityType   SawBladeStar SawbladeStar sawbladestar
syn keyword pacEntityType   SawBlade Sawblade sawblade
syn keyword pacEntityType   NGon Ngon RegularNGon RegularNgon regularngon
syn keyword pacEntityType   Poly Polygon poly polygon
syn keyword pacEntityType   Path path
syn keyword pacEntityType   Sphere HyperSphere4d HyperSphere5d
syn keyword pacEntityType   sphere hypersphere4d hypersphere5d
syn keyword pacEntityType   Ellipsoid ellipsoid
syn keyword pacEntityType   Box CubeAA Cube CuboidAA Cuboid
syn keyword pacEntityType   box cubeaa cube cuboidaa cuboid
syn keyword pacEntityType   RoundedBox RoundedCube roundedbox roundedcube
syn keyword pacEntityType   RegularTetrahedron RegularPyramid
syn keyword pacEntityType   regulartetrahedron regularpyramid
syn keyword pacEntityType   Points points PointCloud pointcloud
syn keyword pacEntityType   trianglemesh


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
