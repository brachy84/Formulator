import 'package:all_the_formulars/core/formula/formula2.dart';
import 'package:all_the_formulars/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'formula_page.dart';
import 'formula_page_home.dart';

class PhysicFormulas {
  static FormulaSubCategoryBase movementSubCategory = FormulaSubCategoryBase(
    name: L.string('movement'),
    color: Colors.red,
    icon: FaIcon(FontAwesomeIcons.tachometerAlt),
    data: [
      Item(
          formula: Formula2('v=:{s}/{t}'),
          name: L.string('constMovement'),
          title: L.string('linearMovement'),
          meanings: [
            L.string('speed'),
            L.string('distance'),
            L.string('time'),
          ],
          units: [
            'm/s',
            'm',
            's'
          ],
          subItems: [
            Item(
                formula: Formula2('v=pi*d*n'),
                title: L.string('circularMotion'),
                subtitle: L.string('circumferentialSpeed'),
                meanings: [
                  L.string('circumferentialSpeed'),
                  L.string('diameter'),
                  L.string('rotationSpeed')
                ],
                units: [
                  'm/s',
                  'm',
                  L.string('rpm')
                ]),
            Item(
                formula: Formula2('v = omega * :{d}/{2}'),
                //title: loc.string('circularMotion'),
                subtitle: L.string('circumferentialSpeed'),
                meanings: [
                  L.string('circumferentialSpeed'),
                  L.string('angularVelocity'),
                  L.string('diameter')
                ],
                units: [
                  'm/s',
                  L.string('rps'),
                  'm'
                ]),
            Item(
                formula: Formula2('omega = 2 * pi * n'),
                //title: loc.string('circularMotion'),
                subtitle: L.string('angularVelocity'),
                meanings: [
                  L.string('angularVelocity'),
                  L.string('rotationSpeed')
                ],
                units: [
                  L.string('rps'),
                  L.string('rpm')
                ]),
          ]),
      Item(
          formula: Formula2('v = a*t'),
          name: L.string('accel_delayMovement'),
          subtitle: L.string('end/beginnSpeed'),
          meanings: [
            L.string('end/beginnSpeed'),
            L.string('acceleration'),
            L.string('time')
          ],
          units: [
            'm/s',
            'm/s²',
            's'
          ],
          subItems: [
            Item(
              formula: Formula2('v = √{2*a*s}'),
              meanings: [
                L.string('end/beginnSpeed'),
                L.string('acceleration'),
                L.string('distance')
              ],
              units: ['m/s', 'm/s²', 'm'],
            ),
            Item(
              formula: Formula2('s=:{1}/{2} * v * t'),
              subtitle: L.string('accel_delayDistance'),
              meanings: [
                L.string('distance'),
                L.string('end/beginnSpeed'),
                L.string('time'),
              ],
              units: ['m', 'm/s', 's'],
            ),
            Item(
              formula: Formula2('s=:{1}/{2} * a * t^2'),
              meanings: [
                L.string('distance'),
                L.string('acceleration'),
                L.string('time'),
              ],
              units: ['m', 'm/s²', 's'],
            ),
            Item(
              formula: Formula2('s=:{v^2}/{2*a}'),
              meanings: [
                L.string('distance'),
                L.string('end/beginnSpeed'),
                L.string('acceleration'),
              ],
              units: ['m', 'm/s', 'm/s²'],
            ),
          ]),
    ],
  );

  static FormulaSubCategoryBase forceSubCategory = FormulaSubCategoryBase(
    name: L.string('forces'),
    color: Colors.indigo,
    icon: FaIcon(FontAwesomeIcons.compressAlt),
    data: [
      Item(
          formula: Formula2('F_G = m * 9.81'),
          name: L.string('weight_force'),
          meanings: [L.string('weight_force'), L.string('mass')],
          units: ['N', 'kg']),
      Item(
          formula: Formula2('F = m * a'),
          name: L.string('acceleration_force'),
          meanings: [
            L.string('acceleration_force'),
            L.string('mass'),
            L.string('acceleration')
          ],
          units: [
            'N',
            'kg',
            'm/s²'
          ]),
      Item(
          formula: Formula2('F_Z = m * r * omega^2'),
          name: L.string('centrifugal') + ' & ' + L.string('centripetal'),
          meanings: [
            L.string('centrifugal') + ', ' + L.string('centripetal'),
            L.string('mass'),
            L.string('radius'),
            L.string('angularVelocity')
          ],
          units: [
            'N',
            'kg',
            'm',
            'm/s'
          ],
          subItems: [
            Item(
              formula: Formula2('F_Z = :{m * v^2}/{r}'),
              name: L.string('centrifugal') + ' & ' + L.string('centripetal'),
              meanings: [
                L.string('centrifugal') + ', ' + L.string('centripetal'),
                L.string('mass'),
                L.string('circumferential speed'),
                L.string('radius')
              ],
              units: ['N', 'kg', 'm/s', 'm'],
            )
          ])
    ],
  );
}
