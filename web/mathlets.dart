//import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:mathlets/conditionalconvergence.dart';

class MathletsModule extends Module {
  MathletsModule() {
    bind(ConditionalConvergence);
  }
}


void main() {
  applicationFactory().addModule(new MathletsModule()).run();
}