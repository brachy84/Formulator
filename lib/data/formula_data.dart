import 'package:all_the_formulars/data/formula.dart';

class Formulas {
  static List<Formula> _formulas = [];
  static _add(Formula formula) => _formulas.add(formula);
  static List<Formula> get all => _formulas;

  // area of triangle
  static Formula triangleArea =
      const Formula(name: '', description: '', defaultResult: 'A', varData: {
    'A': ['A = :{ g * h }/{ 2 }', 'area', 'm²'],
    'g': ['g = :{ A * 2 }/{ h }', 'base_length', 'm'],
    'h': ['h = :{ A * 2 }/{ g }', 'height', 'm']
  });

  static const List<FormulaBase> formulaData = [
    FormulaCategory(name: 'math', description: '', content: [
      FormulaCategory(name: 'geometry', description: '', content: [
        FormulaCategory(name: 'shapes', description: '', content: [
          FormulaCategory(name: 'square', description: '', content: [
            Formula(
                name: 'area',
                description: '',
                defaultResult: 'A',
                varData: {
                  'A': ['A = a^2', 'area', 'm²'],
                  'a': ['a = √{ A }', 'side_length', 'm']
                }),
            Formula(
                name: 'perimeter',
                description: '',
                defaultResult: 'U',
                varData: {
                  'U': ['U = 4a', 'perimeter', 'm'],
                  'a': ['a = :{ U }/{ 4 }', 'side_length', 'm']
                }),
          ]),
          FormulaCategory(name: 'rectangle', description: '', content: [
            Formula(
                name: 'area',
                description: '',
                defaultResult: 'A',
                varData: {
                  'A': ['A = a * b', 'area', 'm²'],
                  'a': ['a = :{ A }/{ b }', 'side_length', 'm'],
                  'b': ['b = :{ A }/{ a }', 'side_width', 'm']
                }),
            Formula(
                name: 'perimeter',
                description: '',
                defaultResult: 'U',
                varData: {
                  'U': ['U = 2a + 2b', 'perimeter', 'm'],
                  'a': ['a = :{ U - 2b }/{ 2 }', 'side_length', 'm'],
                  'b': ['b = :{ U - 2a }/{ 2 }', 'side_width', 'm']
                }),
          ]),
          FormulaCategory(name: 'triangle', description: '', content: [
            Formula(
                name: 'area',
                description: '',
                defaultResult: 'A',
                varData: {
                  'A': ['A = :{ g * h }/{ 2 }', 'area', 'm²'],
                  'g': ['g = :{ A * 2 }/{ h }', 'base_length', 'm'],
                  'h': ['h = :{ A * 2 }/{ g }', 'height', 'm']
                }),
            Formula(
                name: 'perimeter',
                description: '',
                defaultResult: 'U',
                varData: {
                  'U': ['U = a + b + c', 'perimeter', 'm'],
                  'a': ['a = U - b - c', 'side_length', 'm'],
                  'b': ['a = U - a - c', 'side_length', 'm'],
                  'c': ['a = U - a - b', 'side_length', 'm']
                }),
          ]),
          FormulaCategory(name: 'regular_polygon', description: '', content: [
            Formula(
                name: 'area',
                description: '',
                defaultResult: 'A',
                varData: {
                  'A': ['A = :{ n * l * d }/{ 4 }', 'area', 'm²'],
                  'n': ['n = :{ A * 4 }/{ n * d }', 'corners', 'm'],
                  'l': ['l = :{ A * 4 }/{ l * d }', 'side_length', 'm'],
                  'd': ['d = :{ A * 4 }/{ n * l }', 'inner_diameter', 'm'],
                }),
            Formula(
                name: 'inner_and_outer_diameter',
                description: '',
                defaultResult: 'd',
                varData: {
                  'd': ['d = √{ D^2 - l^2 }', 'inner_diameter', 'm'],
                  'D': ['D = √{ d^2 + l^2 }', 'outer_diameter', 'm'],
                  'l': ['l = √{ D^2 - l^2 }', 'side_length', 'm']
                }),
            Formula(
                name: 'side_length',
                description: '',
                defaultResult: 'l',
                varData: {
                  // TODO: implement sin etc
                  'l': ['l = D * sin[ :{ 180 }/{ n } ]', 'side_length', 'm'],
                  'D': [
                    'D = :{ l }/{ sin[ :{ 180 }/{ n } ] }',
                    'outer_diameter',
                    'm'
                  ],
                }),
          ]),
          FormulaCategory(name: 'circle', description: '', content: [
            Formula(
                name: 'area',
                description: '',
                defaultResult: 'A',
                varData: {
                  'A': ['A = :{ pi * d^2 }/{ 4 }', 'area', 'm²'],
                  'd': ['d = √{ :{ A * 4 }/{ pi } }', 'diameter', 'm']
                }),
            Formula(
                name: 'perimeter',
                description: '',
                defaultResult: 'U',
                varData: {
                  'U': ['U = pi * d', 'perimeter', 'm'],
                  'd': ['a = :{ U }/{ pi }', 'diameter', 'm']
                }),
            FormulaCategory(name: 'circle_cut_out', description: '', content: [
              Formula(
                  name: 'area',
                  description: '',
                  defaultResult: 'A',
                  varData: {
                    'A': ['A = :{ l_B * d }/{ 4 }', 'area', 'm²'],
                    'd': ['d = :{ A * 4 }/{ l_B } ', 'diameter', 'm'],
                    'l_B': ['l_B = :{ A * 4 }/{ d } ', 'arc_length', 'm']
                  }),
              Formula(
                  name: 'arc_length',
                  description: '',
                  defaultResult: 'l_B',
                  varData: {
                    'l_B': [
                      'l_B = :{ pi * d * alpha }/{ 360 }',
                      'arc_length',
                      'm'
                    ], // TODO: test this
                    'd': [
                      'd = :{ l_B * 360  }/{ pi * alpha }',
                      'diameter',
                      'm'
                    ],
                    'alpha': [
                      'alpha = :{ l_B * 360  }/{ pi * d }',
                      'opening_angle',
                      '°' // TODO: implement radiants
                    ],
                  }),
            ]),
            FormulaCategory(name: 'circle_cut_off', description: '', content: [
              Formula(
                  name: 'area',
                  description: '',
                  defaultResult: 'A',
                  varData: {
                    'A': [
                      'A = :{ pi * d^2 }/{ 4 } * :{ alpha }/{ 360 } - :{ l * ( r - b ) }/{ 2 }',
                      'area',
                      'm²'
                    ],
                  }),
              Formula(
                  name: 'width',
                  description: '',
                  defaultResult: 'b',
                  varData: {
                    'b': ['b = b_{unimplemented}', 'width', 'm'],
                  }),
            ]),
            // TODO: kreisabschnitt
          ]),
        ]),
        FormulaCategory(name: 'bodys', description: '', content: [
          FormulaCategory(name: 'cube', description: '', content: [
            Formula(
                name: 'volume',
                description: '',
                defaultResult: 'V',
                varData: {
                  'V': ['V = a^3', 'area', 'm³'],
                  'a': ['a = ^3√{ A }', 'side_length', 'm']
                }),
            Formula(
                name: 'surface',
                description: '',
                defaultResult: 'O',
                varData: {
                  'O': ['O = 6 * a^2', 'surface', 'm²'],
                  'a': ['a = √{ :{ O }/{ 6 } }', 'side_length', 'm']
                }),
          ]),
          FormulaCategory(name: 'cuboid', description: '', content: [
            Formula(
                name: 'volume',
                description: '',
                defaultResult: 'V',
                varData: {
                  'V': ['V = a * b * c', 'area', 'm³'],
                  'a': ['a = :{ V }/{ b * c }', 'side_length', 'm'],
                  'b': ['b = :{ V }/{ a * c }', 'side_length', 'm'],
                  'c': ['c = :{ V }/{ a * b }', 'side_length', 'm']
                }),
            Formula(
                name: 'surface',
                description: '',
                defaultResult: 'O',
                varData: {
                  'O': ['O = 2 * ( a * b + a * c + b * c )', 'surface', 'm²']
                }),
          ]),
          FormulaCategory(name: 'cylinder', description: '', content: [
            Formula(
                name: 'volume',
                description: '',
                defaultResult: 'V',
                varData: {
                  'V': ['V = pi * d^2 * h', 'area', 'm³'],
                  'd': ['d = √{ :{ V }/{ pi * h } }', 'diameter', 'm'],
                  'h': ['h = :{ V }/{ pi * d^2 }', 'height', 'm'],
                }),
            Formula(
                name: 'surface',
                description: '',
                defaultResult: 'O',
                varData: {
                  'O': [
                    'O = 2 * :{ pi * d^2 }/{ 4 } + pi * d * h',
                    'surface',
                    'm²'
                  ],
                  'h': [
                    'h = :{ O * 4 }/{ 2 * pi * d^2 + pi * d }',
                    'side_length',
                    'm'
                  ],
                }),
          ]),
          FormulaCategory(name: 'pyramid', description: '', content: [
            Formula(
                name: 'volume',
                description: '',
                defaultResult: 'V',
                varData: {
                  'V': ['V = :{ l * b * h }/{ 3 }', 'area', 'm³'],
                  'l': ['l = :{ V * 3 }/{ b * h }', 'side_length', 'm'],
                  'b': ['b = :{ V * 3 }/{ l * h }', 'width', 'm'],
                  'h': ['h = :{ V * 3 }/{ l * b }', 'height', 'm']
                }),
          ]),
          FormulaCategory(name: 'ball', description: '', content: [
            Formula(
                name: 'volume',
                description: '',
                defaultResult: 'V',
                varData: {
                  'V': ['A = :{ pi * d^3 }/{ 6 }', 'area', 'm³'],
                  'd': ['d = ^3√{ :{ V * 6 }/{ pi } }', 'diameter', 'm']
                }),
            Formula(
                name: 'surface',
                description: '',
                defaultResult: 'O',
                varData: {
                  'O': ['O = pi * d^2', 'surface', 'm²'],
                  'd': ['a = √{ :{ O }/{ pi } }', 'diameter', 'm']
                }),
            FormulaCategory(
                name: 'spherical_section',
                description: '',
                content: [
                  Formula(
                      name: 'volume',
                      description: '',
                      defaultResult: 'V',
                      varData: {
                        'V': [
                          'A = pi * h^2 * ( :{ d }/{ 2 } - :{ d }/{ 3 })',
                          'volume',
                          'm³'
                        ]
                      }),
                  Formula(
                      name: 'surface',
                      description: '',
                      defaultResult: 'O',
                      varData: {
                        'O': ['O = pi * h * ( 2 * d - h)', 'surface', 'm²']
                      }),
                ]),
          ]),
        ])
      ]),
      FormulaCategory(name: 'phytagoras', description: '', content: []),
      FormulaCategory(name: 'trigonometry', description: '', content: [])
    ]),
    FormulaCategory(name: 'physic', description: '', content: [])
  ];
}
