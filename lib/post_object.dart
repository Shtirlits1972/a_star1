import 'package:a_star1/resultPost.dart';
import 'package:a_star1/step.dart';

import 'resultPost.dart';

class post_object {
  String id = '';
  resultz result;

  post_object(this.id, this.result);

  @override
  String toString() {
    return 'id = $id, result = $result';
  }

  Map toJson() => {'id': id, 'result': result};
}
