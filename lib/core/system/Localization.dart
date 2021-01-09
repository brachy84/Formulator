import 'dart:io';

import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

import '../utils.dart';

class Localization {
  static String langCode = 'null';

  //Localization2(this.langCode);

  static Map<String, String> _localizedString = {};

  static bool loaded = false;
  static bool startLoading = false;

  static Future<bool> init() async {
    if (!loaded && _localizedString.length == 0) {
      langCode = Platform.localeName.split('_')[0];
      logcat('langcode: $langCode');
      String langFilePath = 'assets/lang/';
      switch (langCode) {
        case 'de':
          langFilePath += 'de_DE.xml';
          break;
        case 'en':
          langFilePath += 'en_US.xml';
          break;
        default:
          langFilePath += 'en_US.xml';
      }
      String fileContent = await rootBundle.loadString(langFilePath);
      XmlDocument document = XmlDocument.parse(fileContent);
      var elements = document.findAllElements('string');

      await Future.forEach(elements, (element) {
        String string = element.firstChild.toString();
        if (string.contains('&amp;')) {
          string = string.replaceRange(
              string.indexOf('&'), string.indexOf(';') + 1, '&');
        }
        _localizedString.addAll({element.getAttribute('name'): string});
      });
      loaded = true;
    }
    return true;
  }

  static Future fillMap(XmlDocument document) async {
    var elements = document.findAllElements('string');
    await Future.forEach(elements, (element) {
      _localizedString.addAll(
          {element.getAttribute('name'): element.firstChild.toString()});
    });
    loaded = true;
    return;
  }

  String string(String key) {
    if (_localizedString[key] == null || _localizedString[key].isEmpty) {
      return 'e:(value[$key])';
    }
    return _localizedString[key];
  }
}

/*
class Localization {

  //Saved translation map
  static Map<String, String> _localizedString;

  static init(String languageCode) async {
    //loading json data
    switch (languageCode) {
      case 'en' :
        _localizedString = english;
        break;
      case 'de' :
        _localizedString = german;
        break;
      default:
        _localizedString = english;
    }
  }

  String string(String key) {
    if (_localizedString[key] == null ||
        _localizedString[key].isEmpty) {
      return 'error(value[$key] is empty)';
    }
    return _localizedString[key];
  }

  static Map<String, String> english = {
    //General UI strings
    'appName': 'All the Formulas',
    'title' : 'Title',
    'subtitle' : 'Subtitle',
    'Lorem ipsum' : 'Lorem ipsum',
    'changeTo' : 'change to',
    'value' : 'Value',
    'calc' : 'calculate',
    'hasMultiple' : 'The formula has multiple of this variable and can\'t be changed correctly!',
    'choose_color' : 'Choose a color',
    'cancel' : 'Cancel',
    'save' : 'Save',
    'notValid' : 'Please press \'Verify Formula\' first, before you save.',
    'emptyName' : 'The name must not be empty!',
    'preview' : 'Preview',
    'verify' : 'Verify Formula',
    'errorMsg' : 'Error message',
    'divide' : 'Divide',
    'root' : 'Root',
    'formatRulesTitle' : 'Formatting rules',
    'formatRules' : '1. The formula must contain exactly one \'=\'.'
        '\n2. All brace types must have the same amount of opening and closing braces (can be 0).'
        '\n3. Don\'t use \'²\', instead use \'^2\'.'
        '\n4. Don\'t use \'/\' or \'÷\', instead use the Divide button.'
        '\n5. The Divider contains 2 two Brace sets. In the first one goes what should be above the divide line. The second one is below the line.'
        '\n6. If you want to use cubic root, do it like this: \'^3√{ }\''
        '\n7. Spacing does not matter.',
    'nameInfoTitle' : 'Name info',
    'nameInfo' : 'The Name should be unique. If there are multiple Formulas with the same name, they will be grouped together.',
    'titleInfoTitle' : 'Title info',
    'titleInfo' : 'The Title is only useful when you have multiple Formulas with the same name.',
    'gotit' : 'GOT IT',
    'bsp' : 'Examples:',
    'converter' : 'Converter',
    'formulas' : 'Formulas',
    'mathSubtitle' : 'Geometry, Pythagoras, Trigonometry, etc.',
    'physicSubtitle' : 'Motion, Forces, etc.',
    'industSubtitle' : '-, etc.',
    'customSubtitle' : 'Create your own Formulas',
    'myFormulas' : 'My Formulas',
    'createFormula' : 'Create Formula',
    'tutorialDialogTitle' : 'Tutorial',
    'tutorialDialog' : 'Looks like it\'s you first time here. I will help you create your first Formula.'
        '\nFirst tab on the first text field, labeled \'Name\'.',
    'tutorialName' : 'Good, now type any fitting name. For more information to the name, click on the \'i\' next to the Text field.'
        '\n \n After you typed the name, click the second text field, labeled \'Titel\'.',
    'tutorialTitle' : 'You can left this field empty. A title is usefull when another Formula has the same name.'
        '\n \n After you\'re done tab on the third text field \'Formula\'.',
    'tutorialFormula' : 'To see what the formula has to look like, tab on the blue \'i\' next to the text field. There you can find rules and examples.'
        '\n \nUnder this text field are a few buttons. They are supposed to make the process easier. Test them out.'
        '\n \nIn every brace belongs a value. This can be a single variable or multiple with operators with even more braces.'
        '\n \nIf you think you typed the formula correctly (preferably compare them to the examples), tab on \'Verify Formula\'.',
    'tutorialVerify' : 'Sehr gut. Wenn das Feld neben diesem Button grün wird hast du alles richtig gemcht, wird es rot solltest lesen was dort steht und den entsprechenden Fehler korrigieren.'
        '\n Sobald das Feld grün wird kannst du in der Vorschau sehen wie sie angezeigt wird. Drücke auf Speichern. Fertig.'
        '\n \nDu kannst das Tutorial jederzeit wieder abspielen indem du ganz oben rechts auf das \'i\' drückst.',

    //Settings
    'settings' : 'Settings',
    'accent' : 'Accent color',
    'primary' : 'Main color',
    'colorSettings' : 'Color Settings',
    'themeSettings' : 'Theme Settings',
    'bright' : 'Bright',
    'dark' : 'Dark',
    'warm' : 'Warm',
    'cold' : 'Cold',
    'languageSettings' : 'Language Settings',
    'useDefault' : 'use default',

    //Formulas Categories
    'math' : 'Mathematics',
    'industrial' : 'Industrial',
    'physic' : 'Physic',

    'formulasMath' : 'Formulas - Math',
    'formulasPhysic' : 'Formulas - Physic',
    'formulasIndustrial' : 'Formulas - Industrial',

    //Math Formula Categories
    'surfaceBody' : 'Areas',
    'body' : 'Bodys',
    'triangles' : 'Pythagoras & Trigonometry',
    'pythagoras' : 'Pythagoras',
    'trigonometry' : 'Trigonometry',

    //Physic Formulas
    'movement' : 'Movement',
    'constMovement' : 'Constant movement',
    'accel_delayMovement' : 'Accelerated & delayed movement',
    'linearMovement' : 'linear movement',
    'circularMotion' : 'circular motion',
    'end/beginnSpeed' : 'end/start speed',
    'accel_delayDistance' : 'Acceleration/Delay distance',

    //Physic values
    'speed' : 'speed',
    'time' : 'time',
    'distance' : 'distance',
    'circumferentialSpeed' : 'circumferential speed',
    'rotationSpeed' : 'rotational speed',
    'angularVelocity' : 'angular Velocity',
    'acceleration' : 'acceleration',

    //Errors
    'E:highValue' : 'Value is to high!',

    'unitConvert' : 'Unit converter',
    'formulaCategory' : 'Formula category',
    'formulas' : 'Formulas',

    'lengthSurfaceVolume' : 'Length, Surfaces & Volumes',
    'lengths' : 'Lengths',
    'surface' : 'Surfaces',
    'volume' : 'Volumes',
    //Längen
    'kiloM' : 'kilometer',
    'meter' : 'meter',
    'centiM' : 'centimeter',
    'milliM' : 'millimeter',
    'mile' : 'mile',
    'foot' : 'foot',
    'yard' : 'yard',
    'inch' : 'inch',
    //Flächen
    'SqMeter' : 'square meter',
    'SqKiloM' : 'square kilometer',
    'SqCentiM' : 'square centimeter',
    'SqMilliM' : 'square millimeter',
    'SqMile' : 'square mile',
    'SqFoot' : 'square foot',
    'SqYard' : 'square yard',
    'SqInch' : 'square inch',
    'hectar' : 'hectar',
    //Volumen
    'CuMeter' : 'cubic meter',
    'CuKiloM' : 'cubic kilometer',
    'CuCentiM' : 'cubic centimeter',
    'CuMilliM' : 'cubic millimeter',
    'CuMile' : 'cubic mile',
    'CuFoot' : 'cubic foot',
    'CuYard' : 'cubic yard',
    'CuInch' : 'cubic inch',
    'liter' : 'liter',

    'speed' : 'Speed',
    'kmh' : 'Kilometer / hour',
    'ms' : 'Meter / second',
    'mileh' : 'Mile / hour',
    'foots' : 'Foot / second',

    'weight' : 'Weight',
    'tonne' : 'tonne',
    'kiloG' : 'kilogram',
    'gramm' : 'grams',
    'milliG' : 'milligram',
    'pound' : 'pound',
    'ounce' : 'ounce',

    'temperatur' : 'Temperature',
    'celsius' : 'degree Celsius',
    'fahrenheit' : 'degree Fahrenheit',
    'kelvin' : 'degree Kelvin',

    'time' : 'Time',
    'year' : 'Year',
    'month' : 'Month',
    'week' : 'Week',
    'day' : 'Day',
    'hour' : 'Hour',
    'minute' : 'Minute',
    'second' : 'Second',

    'angle' : 'Angle',
    'degree' : 'degree',
    'radiant' : 'radiant',

    'pressure' : 'Pressure',
    'bar' : 'bar',
    'pascal' : 'pascal',
    'n/mm²' : 'newton / square millimeter',
    'n/cm²' : 'newton / square centimeter',
    'n/m²' : 'newton / square meter',

    //Surfaces
    'square' : 'Square',
    'rectangle' : 'Rectangle',
    'triangle' : 'Triangle',
    'circle' : 'Circle',
    'parallelogram' : 'Parallelogram',
    'trapez' : 'Trapezoid',
    'rhombus' : 'Rhombus',

    //Bodys
    'cube' : 'Cube',
    'cuboid' : 'Cuboid',
    'pyramid' : 'Pyramid',
    'pyramid_truncated' : 'Truncated pyramid',
    //'prism' : 'Prism',
    'ball' : 'Ball',
    'cone' : 'Cone',
    'cone_truncated' : 'Truncated cone',
    'cylinder' : 'Cylinder',

    //
    'area' : 'Surface area',
    'side_length' : 'Side length',
    'side_width' : 'Side width',
    'length' : 'Length',
    'width' : 'Width',
    'side_length_basearea' : 'Length of base area',
    'side_width_basearea' : 'Width of base area',
    'height' : 'Height',
    'baseline' : 'length of baseline',
    'diameter' : 'diameter Ø',
    'volume2' : 'Volume',
    'basearea' : 'base area',
    'deckarea' : 'deck area',
    'diameter_small' : 'small Diameter',
    'diameter_big' : 'big Diameter',
    'perimeter' : 'Perimeter',
    'edgeLength' : 'Edge Length',
    'mantleSurface' : 'Mantle Surface',
    'mantleHeight' : 'Mantle Height',
    'cathete' : 'Cathete',
    'oppositeC' : 'Opposite Cathete',
    'adjacentC' : 'Adjacent Cathete',
    'hypotenuse' : 'Hypotenuse',
    'sines' : 'Sines',
    'cosines' : 'Cosines',
    'tangents' : 'Tangents',
  };

  static Map<String, String> german = {
    //General UI strings
    'appName' : 'Formelsammlung',
    'title' : 'Titel',
    'subtitle' : 'Untertitel',
    'Lorem ipsum' : 'Lorem ipsum',
    'changeTo' : 'Umstellen nach',
    'value' : 'Wert',
    'calc' : 'Berechnen',
    'hasMultiple' : 'Diese Formel beinhalted diese Variable mehr als ein mal und kann nicht korrekt umgestellt werden!',
    'choose_color' : 'Wähle eine Farbe',
    'cancel' : 'Abbrechen',
    'save' : 'Speichen',
    'preview' : 'Vorschau',
    'verify' : 'Formel überprüfen',
    'errorMsg' : 'Fehlernachricht',
    'divide' : 'Teilen',
    'root' : 'Wurzeln',
    'notValid' : 'Bitte drücke erst auf \'Formel überprüfen\' bevor du speicherst.',
    'emptyName' : 'Der Name darf nicht leer sein!',
    'formatRulesTitle' : 'Formattierungsregeln',
    'formatRules' : '1. Die Formel muss genau ein \'=\' enthalten.'
        '\n2. Alle Klammertypen müssen die gleiche Anzahl von Öffnern und Schließern haben (darf 0 sein).'
        '\n3. Benutze \'^2\' anstelle von \'²\'.'
        '\n4. Benutze den \'Teilen\' Button anstelle von \'/\' oder \'÷\'.'
        '\n5. Der Teiler enthält zwei Klammersets. In den ersten gehört was über den Bruchstrich soll. In den zweiten kommt was drunter soll.'
        '\n6. Wenn du Kubikwurzel benutzen willst, mach es so: \'^3√{ }\''
        '\n7. Leerzeichen sind egal.',
    'gotit' : 'Alles klar',
    'bsp' : 'Beispiele:',
    'converter' : 'Konvertierer',
    'formulas' : 'Formeln',
    'mathSubtitle' : 'Geometrie, Pythagoras, Trigonometrie, etc.',
    'physicSubtitle' : 'Bewegung, Kräfte, etc.',
    'industSubtitle' : '-, etc.',
    'customSubtitle' : 'Erstellen deine eigenen Formeln',
    'myFormulas' : 'Meine Formeln',
    'nameInfoTitle' : 'Info zun Name',
    'nameInfo' : 'Der Name sollte einzigartig sein. Falls mehrere Formeln den gleichen Namen haben werden sie zusammen gruppiert.',
    'titleInfoTitle' : 'Info zum Titel',
    'titleInfo' : 'Der Titel ist nützlich wenn mehrere Formeln den gleichen Namen teilen.',
    'createFormula' : 'Formel erstellen',
    'tutorialDialogTitle' : 'Tutorial',
    'tutorialDialog' : 'Sieht aus als wärst du das erste Mal hier. Ich helfe dir deine erste Formel zu erstellen.'
        '\nZuerst tippe auf das erste Textfeld \'Name\'.',
    'tutorialName' : 'Gut, jetzt gib irgendeinen Namen ein. Für mehr information zum Name, klicke auf das \'i\' neben dem Textfeld.'
        '\n \n Nachdem du einen Namen eingegeben hast klicke uf das zweite Textfeld \'Titel\'.',
    'tutorialTitle' : 'Dieses Feld kannst du leer lassen. Es ist nur sinnvoll einen Titel zu haben wenn mehrere Formeln den gleichen Namen haben.'
        '\n \n Klicke danach auf das dritte Textfeld \'Formel\'.',
    'tutorialFormula' : 'Um zu sehen wie die Formel auszusehen hat klicke auf das blaue \'i\' neben dem Textfeld. Dort findest du Regeln und Beispiele.'
        '\n \nUnter diesem Textfeld sind ein paar buttons. Sie sollen das eingeben der Formel vereinfachen. Probier sie einfach mal aus.'
        '\n \nÜberall wo Klammern sind gehört ein Wert rein. Dies kann eine Variable oder mehrere Variablen mit Operatoren sein.'
        '\n \nWenn du glaubst du hast deine Formel richtig eingegeben (Vergleiche sie am besten mit den Beispielen), dann klicke auf \'Formel überprüfen\'.',
    'tutorialVerify' : 'Sehr gut. Wenn das Feld neben diesem Button grün wird hast du alles richtig gemacht, wird es rot solltest lesen was dort steht und den entsprechenden Fehler korrigieren.'
        '\n Sobald das Feld grün wird kannst du in der Vorschau sehen wie sie angezeigt wird. Drücke auf Speichern. Fertig.'
        '\n \nDu kannst das Tutorial jederzeit wieder abspielen indem du ganz oben rechts auf das \'i\' drückst.',

    //Settings
    'settings' : 'Einstellungen',
    'accent' : 'Akzentfarbe',
    'primary' : 'Hauptfarbe',
    'colorSettings' : 'Farb Einstellungen',
    'themeSettings' : 'Thema Einstellungen',
    'bright' : 'Hell',
    'dark' : 'Dunkel',
    'warm' : 'Warm',
    'cold' : 'Kalt',
    'languageSettings' : 'Sprach Einstellungen',
    'useDefault' : 'Standart benutzen',

    //Formulas
    'math' : 'Mathematik',
    'industrial' : 'Industrietechnik',
    'physic' : 'Physik',

    'formulasMath' : 'Formeln - Mathe',
    'formulasPhysic' : 'Formeln - Physik',
    'formulasIndustrial' : 'Formeln - Industrietechnik',


    //Math Formulas Categories
    'surfaceBody' : 'Flächen',
    'body' : 'Körper',
    'pythagoras' : 'Pythagoras',
    'triangles' : 'Pythagoras & Trigonometrie',
    'trigonometry' : 'Trigonometrie',

    //Physic Formulas
    'movement' : 'Bewegung',
    'constMovement' : 'Konstante Bewegung',
    'accel_delayMovement' : 'Beschleunigte & verzögerte Bewegung',
    'linearMovement' : 'Geradlinige Bewegung',
    'circularMotion' : 'Kreisförmige Bewegung',
    'end/beginnSpeed' : 'End- / Anfangsgeschwindigkeit',
    'accel_delayDistance' : 'Beschleunigungs-/Verzögerungsweg',

    //Physic values
    'speed' : 'Geschwindigkeit',
    'time' : 'Zeit',
    'distance' : 'Weg',
    'circumferentialSpeed' : 'Umfangsgeschwindigkeit',
    'rotationSpeed' : 'Drehzahl',
    'angularVelocity' : 'Winkelgeschwindigkeit',
    'acceleration' : 'Beschleunigung',

    //Errors
    'E:highValue' : 'Wert ist zu groß!',

    'unitConvert' : 'Einheiten Umrechner',
    'formulaCategory' : 'Formel Kategorien',
    'formulas' : 'Formeln',

    'lengthSurfaceVolume' : 'Längen, Flächen & Volumen',
    'lengths' : 'Längen',
    'surface' : 'Flächen',
    'volume' : 'Volumen',
    //Längen
    'kiloM' : 'Kilometer',
    'centiM' : 'Zentimeter',
    'meter' : 'Meter',
    'milliM' : 'Millimeter',
    'mile' : 'Meile',
    'foot' : 'Fuß',
    'inch' : 'Zoll',
    //Flächen
    'SqMeter' : 'Quadratmeter',
    'SqKiloM' : 'Quadratkilometer',
    'SqCentiM' : 'Quadratzentimeter',
    'SqMilliM' : 'Quadratmilliemeter',
    'SqMile' : 'Quadratmeile',
    'SqFoot' : 'Quadratfuß',
    'SqInch' : 'Quadratzoll',
    'hectar' : 'Hektar',
    //Volumen
    'CuMeter' : 'Kubikmeter',
    'CuKiloM' : 'Kubikkilometer',
    'CuCentiM' : 'Kubikzentimeter',
    'CuMilliM' : 'Kubikmilliemeter',
    'CuMile' : 'Kubikmeile',
    'CuFoot' : 'Kubikfuß',
    'CuInch' : 'Kubikzoll',
    'liter' : 'Liter',

    'speed' : 'Geschwindigkeiten',
    'kmh' : 'Kilometer / Stunde',
    'ms' : 'Meter / Sekunde',
    'mileh' : 'Meile / Stunde',
    'foots' : 'Fuß / Sekunde',

    'weight' : 'Gewicht',
    'tonne' : 'Tonne',
    'kiloG' : 'Kilogramm',
    'gramm' : 'Gramm',
    'milliG' : 'Milligramm',
    'pound' : 'Pfund',
    'ounce' : 'Unze',

    'temperatur' : 'Temperatur',
    'celsius' : 'Grad Celsius',
    'fahrenheit' : 'Grad Fahrenheit',
    'kelvin' : 'Grad Kelvin',

    'time' : 'Zeit',
    'year' : 'Jahr',
    'month' : 'Monat',
    'week' : 'Woche',
    'day' : 'Tag',
    'hour' : 'Stunde',
    'minute' : 'Minute',
    'second' : 'Sekunde',

    'angle' : 'Winkel',
    'degree' : 'Grad',
    'radiant' : 'Radiant',

    'pressure' : 'Druck',
    'bar' : 'bar',
    'pascal' : 'Pascal',
    'n/mm²' : 'Newton / Quadratmillimeter',
    'n/cm²' : 'Newton / Quadratcentimeter',
    'n/m²' : 'Newton / Quadratmeter',

    //Surfaces
    'square' : 'Quadrat',
    'rectangle' : 'Rechteck',
    'triangle' : 'Dreieck',
    'circle' : 'Kreis',
    'parallelogram' : 'Parallelogramm',
    'trapez' : 'Trapez',
    'rhombus' : 'Raute',

    //Bodys
    'cube' : 'Würfel',
    'cuboid' : 'Quader',
    'pyramid' : 'Pyramide',
    'pyramid_truncated' : 'Pyramidenstumpf !M',
    //'prism' : 'Prisma',
    'ball' : 'Kugel',
    'cone' : 'Kegel',
    'cone_truncated' : 'Kegelstumpf !M',
    'cylinder' : 'Zylinder !2',

    //
    'area' : 'Oberfläche',
    'side_length' : 'Seitenlänge',
    'side_width' : 'Seitenbreite',
    'length' : 'Länge',
    'width' : 'Breite',
    'side_length_basearea' : 'Seitenlänge der Grundfläche',
    'side_width_basearea' : 'Seitenbreite der Grundfläche',
    'height' : 'Höhe',
    'baseline' : 'Länge der Grundlinie',
    'diameter' : 'Durchmesser Ø',
    'volume2' : 'Volumen',
    'basearea' : 'Grundfläche',
    'deckarea' : 'Deckfläche',
    'diameter_small' : 'kleiner Durchmesser',
    'diameter_big' : 'großer Durchmesser',
    'perimeter' : 'Umfang',
    'edgeLength' : 'Kantenlänge',
    'mantleSurface' : 'Mantelfläche',
    'mantleHeight' : 'Mantelhöhe',
    'cathete' : 'Kathete',
    'oppositeC' : 'Gegenkathete',
    'adjacentC' : 'Ankathete',
    'hypotenuse' : 'Hypotenuse',
    'sines' : 'Sinus',
    'cosines' : 'Cosinus',
    'tangents' : 'Tangens',
  };
}

 */
