import 'package:all_the_formulars/old/core/formula/formula2.dart';
import 'package:all_the_formulars/old/core/formula/units.dart';
import 'package:all_the_formulars/old/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'formula_page.dart';
import 'formula_page_home.dart';

class MathFormulas {
  static FormulaSubCategoryBase surfaceSubCategory = FormulaSubCategoryBase(
    name: L.string('surfaceBody'),
    color: Colors.red,
    icon: FaIcon(FontAwesomeIcons.shapes),
    data: [
      Item(
          formula: Formula2('A = a^2'),
          name: L.string('square'),
          title: L.string('area'),
          meanings: [
            L.string('area'),
            L.string('side_length'),
          ],
          units: [
            'm²',
            'm'
          ],
          subItems: [
            Item(
              formula: Formula2('U = 4 * a'),
              title: L.string('perimeter'),
              meanings: [L.string('perimeter'), L.string('side_length')],
              units: ['m', 'm'],
            )
          ]),
      Item(
          formula: Formula2('A = a * b'),
          name: L.string('rectangle'),
          title: L.string('area'),
          meanings: [
            L.string('area'),
            L.string('side_length'),
            L.string('side_length')
          ],
          units: [
            'm²',
            'm',
            'm'
          ],
          subItems: [
            Item(
              formula: Formula2('U = 2a + 2b'),
              title: L.string('perimeter'),
              meanings: [
                L.string('area'),
                L.string('side_length'),
                L.string('side_length')
              ],
              units: ['m', 'm', 'm'],
            )
          ]),
      Item(
          formula: Formula2('A = :{ g * h }/{ 2 }'),
          name: L.string('triangle'),
          title: L.string('area'),
          meanings: [
            L.string('area'),
            L.string('baseline'),
            L.string('height')
          ],
          units: [
            'm²',
            'm',
            'm'
          ],
          subItems: [
            Item(
              formula: Formula2('U = a + b + c'),
              title: L.string('perimeter'),
              meanings: [
                L.string('perimeter'),
                L.string('side_length'),
                L.string('side_length'),
                L.string('side_length')
              ],
              units: ['m', 'm', 'm', 'm'],
            )
          ]),
      Item(
          formula: Formula2('A = l * b'),
          name: L.string('rhombus'),
          title: L.string('area'),
          meanings: [
            L.string('area'),
            L.string('side_length'),
            L.string('height')
          ],
          units: [
            'm²',
            'm',
            'm'
          ],
          subItems: [
            Item(
              formula: Formula2('U = 4 * l'),
              title: L.string('perimeter'),
              meanings: ['Perimeter', L.string('side_length')],
              units: ['m', 'm'],
            )
          ]),
      Item(
          formula: Formula2('A = :{ pi * d }/{ 4 }'),
          name: L.string('circle'),
          title: L.string('area'),
          meanings: [
            L.string('area'),
            L.string('diameter')
          ],
          units: [
            'm²',
            'm'
          ],
          subItems: [
            Item(
              formula: Formula2('U = pi * d'),
              title: L.string('perimeter'),
              meanings: [L.string('perimeter'), L.string('diameter')],
              units: ['m', 'm'],
            ),
            Item(
              formula:
                  Formula2('l_B = :{ pi * d * alpha }/{ 360 }'), // TODO: 360°
              title: L.string('arc_length'),
              meanings: [
                L.string('arc_length'),
                L.string('diameter'),
                L.string('center_angle')
              ],
              units: ['m', 'm', '°'],
            )
          ]),
      Item(
          formula: Formula2('A = l_m * b'),
          name: L.string('trapez'),
          title: L.string('area'),
          meanings: [
            L.string('area'),
            L.string('average_length'),
            L.string('width')
          ],
          units: [
            'm²',
            'm',
            'm'
          ],
          subItems: [
            Item(
              formula: Formula2('l_m = :{ l_1 + l_2 }/{ 2 }'),
              title: L.string('average_length'),
              meanings: [
                L.string('average_length'),
                L.string('short_length'),
                L.string('long_length')
              ],
              units: ['m', 'm', 'm'],
            ),
          ]),
      Item(
          formula: Formula2('A = :{ n * l * d }/{ 4 }'),
          name: L.string('regular_polygons'),
          title: L.string('area'),
          meanings: [
            L.string('area'),
            L.string('corner_number'),
            L.string('side_length'),
            L.string('inner_circle_diameter')
          ],
          units: [
            'm²',
            Units.NONE,
            'm',
            'm'
          ],
          subItems: [
            Item(
              formula: Formula2('d = √{ D^2 - l^2 }'),
              title: L.string('inner_circle_diameter'),
              meanings: [
                L.string('inner_circle_diameter'),
                L.string('outer_circle_diameter'),
                L.string('side_length')
              ],
              units: ['m', 'm', 'm'],
            ),
            Item(
              formula: Formula2('D = √{ d^2 + l^2 }'),
              title: L.string('outer_circle_diameter'),
              meanings: [
                L.string('outer_circle_diameter'),
                L.string('inner_circle_diameter'),
                L.string('side_length')
              ],
              units: ['m', 'm', 'm'],
            ),
            Item(
              formula:
                  Formula2('l = D * sin[ :{ 180 }/{ n } ]', changedFormulas: {
                'D': 'D = :{ l }/{ sin[ :{ 180 }/{ n } ] }',
                'n': 'n = :{ 180 }/{ asin[ :{ l }/{ D } ] }'
              }), // TODO: 180°
              title: L.string('side_length'),
              meanings: [
                L.string('side_length'),
                L.string('outer_circle_diameter'),
                L.string('corner_number')
              ],
              units: ['m', 'm', 'm'],
            ),
          ])
    ],
  );

  static FormulaSubCategoryBase bodySubCategory = FormulaSubCategoryBase(
    name: L.string('body'),
    color: Colors.deepPurple,
    icon: FaIcon(FontAwesomeIcons.cube),
    data: [
      Item(
          formula: Formula2('V = a^3'),
          name: L.string('cube'),
          title: L.string('volume'),
          meanings: [
            L.string('volume2'),
            L.string('side_length')
          ],
          units: [
            'm³',
            'm'
          ],
          subItems: [
            Item(
              formula: Formula2('A_O = 6 * l^2'),
              title: L.string('area'),
              meanings: [L.string('area'), L.string('side_length')],
              units: ['m²', 'm'],
            )
          ]),
      Item(
          formula: Formula2('V = l * b * h'),
          name: L.string('cuboid'),
          title: L.string('volume'),
          meanings: [
            L.string('volume2'),
            L.string('length'),
            L.string('width'),
            L.string('height')
          ],
          units: [
            'm³',
            'm',
            'm',
            'm'
          ],
          subItems: [
            Item(
              formula: Formula2('A_O = 2 ( l * b + l * h + b * h )'),
              title: L.string('area'),
              meanings: [
                L.string('area'),
                L.string('length'),
                L.string('width'),
                L.string('height')
              ],
              units: ['m²', 'm', 'm', 'm'],
            )
          ]),
      Item(
          formula: Formula2('V = :{ l * b * h }/{ 3 }'),
          name: L.string('pyramid'),
          title: L.string('volume'),
          meanings: [
            L.string('volume2'),
            L.string('side_length_basearea'),
            L.string('side_width_basearea'),
            L.string('height')
          ],
          units: [
            'm³',
            'm',
            'm',
            'm'
          ],
          subItems: [
            Item(
              formula: Formula2('l_1 = √{ h_s^2 + :{ b^2 }/{ 4 } }'),
              subtitle: L.string('edgeLength'),
              meanings: [
                L.string('edgeLength'),
                L.string('mantleHeight'),
                L.string('side_width_basearea')
              ],
              units: ['m', 'm', 'm'],
            ),
            Item(
              formula: Formula2('h_s = √{ h^2 + :{ l^2 }/{ 4 } }'),
              subtitle: L.string('mantleHeight'),
              meanings: [
                L.string('mantleHeight'),
                L.string('height'),
                L.string('side_length_basearea')
              ],
              units: ['m', 'm', 'm'],
            )
          ]),
      Item(
          formula: Formula2('V = :{ pi * d^2 }/{ 4 } * h'),
          name: L.string('cylinder'),
          title: L.string('volume'),
          meanings: [
            L.string('volume2'),
            L.string('diameter'),
            L.string('height')
          ],
          units: [
            'm³',
            'm',
            'm'
          ],
          subItems: [
            Item(
              formula: Formula2('A_O = pi * d * h + 2 * :{ pi * d^2 }/{ 4 }'),
              title: L.string('area'),
              meanings: [
                L.string('area'),
                L.string('diameter'),
                L.string('height')
              ],
              units: ['m²', 'm', 'm'],
            )
          ]),
      Item(
        formula: Formula2('V = :{ h }/{ 3 } * ( A_1 + A_2 + √{ A_1 * A_2 } )'),
        name: L.string('pyramid_truncated'),
        title: L.string('volume'),
        meanings: [
          L.string('volume2'),
          L.string('height'),
          L.string('basearea'),
          L.string('deckarea')
        ],
        units: ['m³', 'm', 'm²', 'm²'],
      ),
      Item(
        formula: Formula2('V = :{ pi * d^2 }/{ 4 } * :{ h }/{ 3 }'),
        name: L.string('cone'),
        title: L.string('volume'),
        meanings: [
          L.string('volume2'),
          L.string('diameter'),
          L.string('height')
        ],
        units: ['m³', 'm', 'm'],
      ),
      Item(
        formula: Formula2('V = :{ pi * h }/{ 12 } * ( D^2 + d^2 + D + d )'),
        name: L.string('cone_truncated'),
        title: L.string('volume'),
        meanings: [
          L.string('volume2'),
          L.string('height'),
          L.string('diameter_big'),
          L.string('diameter_small')
        ],
        units: ['m³', 'm', 'm', 'm'],
      ),
      Item(
          formula: Formula2('V = :{ pi * d^3 }/{ 6 }'),
          name: L.string('ball'),
          title: L.string('volume'),
          meanings: [
            L.string('volume2'),
            L.string('diameter')
          ],
          units: [
            'm³',
            'm'
          ],
          subItems: [
            Item(
              formula: Formula2('A_O = pi * d^2'),
              title: L.string('area'),
              meanings: [L.string('area'), L.string('diameter')],
              units: ['m²', 'm'],
            )
          ]),
    ],
  );

  static FormulaSubCategoryBase pythagorasSubCategory = FormulaSubCategoryBase(
    name: L.string('pythagoras'),
    color: Colors.blue,
    icon: FaIcon(FontAwesomeIcons.squareRootAlt),
    data: [
      Item(
          formula: Formula2('c = √{ a^2 + b^2 }'),
          name: L.string('pythagoras'),
          meanings: [
            L.string('hypotenuse'),
            L.string('cathete'),
            L.string('cathete')
          ]),
      Item(
          formula: Formula2('h = √{ p * q }'),
          name: L.string('altitude_theorem'),
          meanings: [
            L.string('height'),
            L.string('section_of_base'),
            L.string('section_of_base')
          ]),
      Item(
          formula: Formula2('sin[alpha] = :{ O }/{ H }'),
          name: L.string('trigonometry'),
          title: L.string('sines'),
          meanings: [
            L.string('angle'),
            L.string('oppositeC'),
            L.string('hypotenuse')
          ],
          units: [
            '°',
            'm',
            'm'
          ],
          subItems: [
            Item(
              formula: Formula2('cos[alpha] = :{ A }/{ H }'),
              title: L.string('cosines'),
              meanings: [
                L.string('angle'),
                L.string('adjacentC'),
                L.string('hypotenuse')
              ],
              units: ['°', 'm', 'm'],
            ),
            Item(
              formula: Formula2('tan[alpha] = :{ O }/{ A }'),
              title: L.string('tangents'),
              meanings: [
                L.string('angle'),
                L.string('oppositeC'),
                L.string('adjacentC')
              ],
              units: ['°', 'm', 'm'],
            ),
          ]),
    ],
  );
}
