import 'package:a_star1/step.dart';

class resultz {
  List<step> steps = [];
  String path = '';

  resultz(this.steps, this.path);

  Map toJson() => {'steps': steps, 'path': path};

  @override
  String toString() {
    return 'steps = $steps , path = $path';
  }
}
