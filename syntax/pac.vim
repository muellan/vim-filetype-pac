" Vim syntax file
" Language:   PAC (AM Simple Packing Format) (.pac/.shp)
" Maintainer: André Müller
" Version:    2.0.0

"-----------------------------------------------------------------------------
" PAC File Format
"-----------------------------------------------------------------------------
"  - encoding: ASCII, multibyte characters must not be used
"  - line endings: LF only
"  - whitespace has no semantic meaning other than separating tokens
"
"  - tags: #[A-Z]+  (# followed by only uppercase letters)
"
"  - shape type names: [A-Za-z][A-Za-z0-9_-]+
"      - case insensitive
"      - can contain '_' or '-' which are to be ignored when parsing
"      - preferred export convention: CamelCase
"
"  - custom annotations can be given before each shape's parameter list
"    and must be enclosed in single quotes
"
"  - quantifiers (min/max copies to be used) can be given before
"    each shape's parameter list and must be enclosed in curly braces
"
"  - character set
"      - ignored everywhere:     _ , ;
"      - ignored in names:       _ , ; -
"      - decimal separator:      .
"      - special:                # $ / ' {}
"      - reserved:               () []
"
"   _______________________________
"  | #SOLUTIONS                    |  |_ optional: multiple solutions
"  |     [# solutions]             |  |
"  | #PACKING                      |  1st solution
"  | #CONTAINERS                   |
"  |   [container type of batch 0] |  1st batch of containers
"  |   [# in batch 0]              |
"  |     [container 0]             |
"  |     [container 1]             |
"  |     ...                       |
"  |   [container type of batch 1] |  2nd batch of containers
"  |   [# in batch 1]              |
"  |     [container 0]             |
"  |     [container 1]             |
"  |     ...                       |
"  |   ...                         |
"  | #CONTENT                      |  content of container 0
"  |   [item type of batch 0]      |  1st batch of items
"  |   [# in batch 0]              |
"  |     [item 0]                  |
"  |     [item 1]                  |
"  |     ...                       |
"  |   [item type of batch 1]      |  2nd batch of items
"  |   [# in batch 1]              |
"  |     [item 2]                  |
"  |     [item 3]                  |
"  |     ...                       |
"  |   ...                         |
"  | #CONTENT                      |  content of container 1
"  |   [item type of batch 0]      |
"  |   [# in batch 0]              |
"  |     [item 0]                  |
"  |     [item 1]                  |
"  |     ...                       |
"  |   ...                         |
"  | #REMAINING                    |  |
"  |   [item type of batch 0]      |  |
"  |   [# in batch 0]              |  |- optional: loose items
"  |     [item 0]                  |  |  that are not contained
"  |     [item 1]                  |  |
"  |     ...                       |  |
"  |   ...                         |  |
"  | #PACKING                      |  2nd solution
"  | ...                           |
"   -------------------------------
"
"  EXAMPLE 1
"   _______________________________
"  | #PACKING                      |
"  | #CONTAINERS                   |
"  | Circle                        |
"  | 1                             |  <- exactly 1 rectangle must follow
"  | 20.0 0.0 0.0                  |
"  | #CONTENT                      |
"  | Rectangle                     |
"  | 2                             |  <- exactly 2 rectangles must follow
"  | 1.0 2.0 -5.0 0.0              |     and be used in the packing
"  | 1.0 2.0 5.0 0.0               |
"   -------------------------------
"
"  EXAMPLE 2 : equivalent to example 1
"   _______________________________
"  | #PACKING                      |
"  | #CONTAINERS                   |
"  | Circle 1 20.0 0.0 0.0         |
"  | #CONTENT                      |
"  | Rectangle 1 1.0 2.0 -5.0 0.0  |  
"  | Rectangle 1 1.0 2.0 5.0 0.0   |
"   -------------------------------
"
"  EXAMPLE 3 : min and max quantities
"   _______________________________
"  | #PACKING                      |
"  | #CONTAINERS                   |  optional quantities:
"  | Circle                        |
"  | 1                             |
"  | {3,5} 20.0 0.0 0.0            |  <- use at least 3, max 5 copies
"  | #CONTENT                      |
"  | Circle                        |
"  | 2                             |  
"  | {4} 4.0 0.0 0.0               |  <- use exactly 4 copies
"  | {2} 8.0 0.0 0.0               |  <- use exactly 2 copies
"  | Rectangle                     |
"  | 2                             |  
"  | {1,2} 1.0 2.0 -5.0 0.0        |  <- at least 1, max 2 copies 
"  | {2,3} 1.0 2.0 5.0 0.0         |  <- at least 2, max 3 copies
"   -------------------------------
"
"  EXAMPLE 4 : annotations / shape names 
"   _______________________________
"  | #PACKING                      |
"  | #CONTAINERS                   |
"  | Circle                        |
"  | 1                             |
"  | 'sheet 1' 20.0 0.0 0.0        |  <- names are enclosed in single quotes
"  | #CONTENT                      |
"  | Circle                        |
"  | 2                             |
"  | {1,2} 'part A1' 1.0 -5.0 0.0  |  <- name and quantifier
"  | 'part B'  {3}   1.0  5.0 0.0  |     order doesn't matter
"   -------------------------------


"-----------------------------------------------------------------------------
" SHP File Format (only shapes)
"-----------------------------------------------------------------------------
"
"   _____________________________        _________________________________ 
"  | [shape type A]              |      | [type A] 1 [shape A0]           |
"  | [# of shapes]               |      | [type A] 1 [shape A1]           |
"  |   [shape A0]                |      | [type B] 1 [shape B0]           |
"  |   [shape A1]                |      |   ...                           |
"  |   ...                       |      | [type C] 1 [shape C0]           |
"  |   ...                       |      | [type A] 1 {2} [shape A2]       |
"  | [shape type B] 'annotation' |      | [type B] 1 [shape B1]           |
"  | [# of shapes]               |      | [type B] 1 'txt' {3} [shape B2] |
"  |   [shape B0]                |      |   ...                           |
"  |   [shape B1]                |      | [type A] 'myname' [shape A3]    |
"  |   ...                       |      |   ...                           |
"  |   ...                       |       --------------------------------- 
"   -----------------------------                  ^-- group size 1     



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
syn match   pacQuantifier   "\({\s*[0-9]\+\s*}\)\|\({\s*[0-9]\+\s*,\s*[0-9]\+\s*}\)" 

syn match   pacAnnotation   "'[^']*'"


syn keyword pacEntityType
  \ NONE None none
  \ Line line
  \
  \ Circle circle
  \ Ring ring Annulus annulus
  \ Ellipse ellipse
  \ EllipticalRing ellipticalring
  \ SquareAA SquareAxisAligned AxisAlignedSquare
  \ squareaa squareaxisaligned axisalignedsquare
  \ Square Rectangle square rectangle
  \ Rect RectangleAA RectangleAxisAligned AxisAlignedRectangle
  \ rect rectangleaa rectangleaxisaligned axisalignedrectangle
  \ RoundedRectangle roundedrectangle
  \ Pill pill Capsule Capsule2d capsule capsule2d
  \
  \ SmallestCircle smallestcircle MinCircle mincircle
  \ SmallestEllipse smallestellipse MinEllipse minellipse
  \ SmallestSquare smallestsquare MinSquare minsquare
  \ SmallestRectangle smallestrectangle MinRectangle minrectangle
  \ SmallestRect smallestrect MinRect minrect
  \
  \ SmallestRoundedSquare smallestroundedsquare
  \ SmallestRoundedRectangle SmallestRoundedRect smallestroundedrectangle smallestroundedrect
  \
  \ SmallestStrip SmallestRectStrip SmallestRectangleStrip SmallestRectangularStrip
  \ ShortestStrip ShortestRectStrip ShortestRectangleStrip ShortestRectangularStrip
  \ smalleststrip smallestrectanglestrip smallestrectangularstrip
  \ shorteststrip shortestrectanglestrip shortestrectangularstrip
  \
  \ Frame RectFrame RectangleFrame RectangularFrame
  \ frame rectframe rectangleframe rectangularframe
  \ RoundedFrame RoundedRectFrame RoundedRectangleFrame RoundedRectangularFrame
  \ roundedframe roundedrectframe roundedrectangleframe roundedrectangularframe
  \
  \ Tri Triangle tri triangle
  \ RightTriangle IsoTriangle IsoscelesTriangle
  \ righttriangle isotriangle isoscelestriangle
  \ EquiTriangle equitriangle 
  \ EquilateralTriangle equilateraltriangle 
  \ LLATriangle llatriangle
  \
  \ RegularTriangle RegularPentagon RegularHexagon 
  \ regulartriangle regularpentagon regularhexagon 
  \ RegularHeptagon RegularOctagon RegularNonagon RegularDecagon
  \ regularheptagon regularoctagon regularnonagon regulardecagon
  \ Pentagon Hexagon Heptagon Octagon Nonagon Decagon
  \ pentagon hexagon heptagon octagon nonagon decagon
  \
  \ Diamond diamond
  \ Parallelogram parallelogram
  \ Trapezoid trapezoid
  \ Dart dart Kite kite
  \ House house Spear spear Chevron chevron Arrow arrow
  \ Cross StraightH StraightL StraightT StraightU
  \ cross straighth straightl straightt straightu
  \ ChamferedRectangle chamferedrectangle
  \ ChamferedFrame chamferedframe
  \ IBeam Ibeam ibeam
  \ Star RegularStar star regularstar
  \ SawBladeStar SawbladeStar sawbladestar
  \ SawBlade Sawblade sawblade
  \ NGon Ngon RegularNGon RegularNgon regularngon
  \
  \ Paper Sheet Envelope PaperSheet
  \ paper sheet envelope papersheet
  \ ISO216 ISO217 ISO269
  \ iso216 iso217 iso269
  \
  \ Poly Polygon poly polygon
  \ PolyRing polyring PolygonRing polygonring
  \ Bezier bezier BezierPath bezierpath
  \ NURBS Nurbs nurbs Spline spline
  \ Path path
  \ PathShell pathshell PathRing pathring
  \
  \ Sphere HyperSphere4d HyperSphere5d
  \ sphere hypersphere4d hypersphere5d
  \ Ellipsoid ellipsoid
  \ Box CubeAA Cube CuboidAA Cuboid
  \ box cubeaa cube cuboidaa cuboid
  \ RoundedBox RoundedCube roundedbox roundedcube
  \ RegularTetrahedron RegularPyramid
  \ regulartetrahedron regularpyramid
  \ Points points PointCloud pointcloud
  \ Mesh mesh TriangleMesh trianglemesh


syn keyword pacSpecialValue
  \ A0 A1 A2 A3 A4 A5 A6 A7 A8 A9 A10
  \ B0 B1 B2 B3 B4 B5 B6 B7 B8 B9 B10
  \ C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10
  \ RA0 RA1 RA2 RA3 RA4 
  \ SRA0 SRA1 SRA2 SRA3 SRA4 
  \ Letter USLetter Legal USLegal Tabloid USTabloid
  \ letter usletter legal uslegal tabloid ustabloid


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
hi def link pacQuantifier   Macro
hi def link pacAnnotation   Comment
hi def link pacSpecialValue String


let b:current_syntax = "pac"
