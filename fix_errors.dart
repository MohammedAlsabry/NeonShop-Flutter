import 'dart:io';

void main() {
  final directory = Directory('lib');
  
  if (directory.existsSync()) {
    final files = directory.listSync(recursive: true);
    for (var entity in files) {
      if (entity is File && entity.path.endsWith('.dart')) {
        String content = entity.readAsStringSync();
        bool changed = false;
        
        if (content.contains('AppColors.neonCyan')) {
          content = content.replaceAll('AppColors.neonCyan', 'AppColors.cyan');
          changed = true;
        }
        if (content.contains('AppDurations.medium')) {
          content = content.replaceAll('AppDurations.medium', 'AppDurations.normal');
          changed = true;
        }
        if (content.contains('.withOpacity(')) {
          content = content.replaceAll('.withOpacity(', '.withValues(alpha: ');
          changed = true;
        }
        
        if (changed) {
          entity.writeAsStringSync(content);
          print('Fixed ${entity.path}');
        }
      }
    }
  }

  final testFile = File('test/widget_test.dart');
  if (testFile.existsSync()) {
    String content = testFile.readAsStringSync();
    if (content.contains('MyApp')) {
      content = content.replaceAll('MyApp', 'NeonShopApp');
      content = content.replaceAll("import 'package:ecommerce_app/main.dart';", "import 'package:ecommerce_app/main.dart';\nimport 'package:flutter/material.dart';");
      testFile.writeAsStringSync(content);
      print('Fixed test/widget_test.dart');
    }
  }
}
