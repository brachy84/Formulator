
import 'dart:io';
import 'dart:convert';
import 'package:all_the_formulars/core/utils.dart';
import 'package:all_the_formulars/formulas_category/formula_page_home.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveData {

  static Future<void> readAll() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Future<void> fillMap() async{
      saveValues.forEach((key, value) async {
        saveValues[key] =  await sharedPreferences.get(key);
      });
    }
    await fillMap();
  }

  static Map<String, dynamic> saveValues = {
    'THEME_INDEX' : null,
    'ACCENT_INDEX' : null,
    'PRIMARY_INDEX' : null,
    'LAST_VERSION_LOGIN' : '1.0.0',
    'FIRST_CREATE_FORMULA' : true
  };

  static Future saveData(String key, dynamic value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(value is int) {
      await sharedPreferences.setInt(key, value);
    } else
    if(value is String) {
      await sharedPreferences.setString(key, value);
    } else
    if(value is double) {
      await sharedPreferences.setDouble(key, value);
    } else
    if(value is bool) {
      await sharedPreferences.setBool(key, value);
    } else
    if(value is List<String>) {
      await sharedPreferences.setStringList(key, value);
    }
    logcat('Saved Data with key $key and value $value');
  }

  static Future<dynamic> readData(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    dynamic value = await sharedPreferences.get(key);
    logcat('Read Data with key $key and value $value');
    return value;
  }

  static Future clearData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}

class JsonSetup {

  File jsonFile;
  Directory dir;
  String fileName;
  bool fileExists = false;
  List<dynamic> fileContent;
  bool initialized = false;

  JsonSetup({@required this.fileName}) {
    //initJson();
  }

  Future<void> initJson() async {
    await getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      jsonFile = File(dir.path + r'/' + fileName);
      fileExists = await jsonFile.exists();
      logcat('Exists: $fileExists at ${dir.path + r'/' + fileName} ');
      if(fileExists) {
        fileContent = json.decode( await jsonFile.readAsString());
      }
    });
    initialized = true;
  }

  Future<bool> exists(File file) async {
    return await file.exists();
  }

  void createFile(List<Map<String, String>> content, {Directory directory, String fileName}) {
    if(initialized) {
      fileName ??= this.fileName;
      directory ??= this.dir;
      logcat('Creating JSON file');
      //File file = File(directory.path + r'\' + fileName);
      jsonFile.createSync();
      fileExists = true;
      jsonFile.writeAsStringSync(json.encode(content));
      //jsonFile = file;
    }
  }

  void writeToFile(String key, Map<String, String> values) {
    if(initialized) {
      logcat('Writing JSON file');
      List<Map<String, String>> content = [values];
      logcat('Write $content');
      if(fileExists) {
        logcat('File exists.');
        var tempFileContent = json.decode(jsonFile.readAsStringSync());
        tempFileContent.addAll(content);
        jsonFile.writeAsStringSync(json.encode(tempFileContent));
        logcat('File: $tempFileContent');
      } else {
        createFile(content, directory: dir, fileName: fileName);
      }
    }
  }

  Future<List<dynamic>> readFromFile() async {
    if(initialized) {
      logcat('Reading JSON file');
      if(fileExists) {
        logcat('File exists');
        return json.decode( await jsonFile.readAsString());
      }
    }
    return [];
  }

  Future<void> deleteEntry(Item item) async {
    logcat('Deleting entry');
    if(initialized) {
      List<dynamic> content = json.decode( await jsonFile.readAsString());
      logcat('Item to remove: ${item.name}, ${item.title}, ${item.formula.raw}');
      logcat('Content: $content');
      //logcat('Entry found: ${content[item.id]}');

      content.forEach((value) {
        logcat('$value');
      });
      logcat('Item to remove(${item.id}): {content[item.id]}');

      content.removeAt(item.id);
      jsonFile.writeAsStringSync(json.encode(content));
    }
  }
}