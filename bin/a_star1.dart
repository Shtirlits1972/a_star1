import 'dart:collection';
import 'package:a_star1/a_star_2d.dart';
import 'package:a_star1/post_object.dart';
import 'package:a_star1/resultPost.dart';
import 'package:a_star1/step.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart';

void main(List<String> arguments) async {
  print('START !');

  Request request = http.Request(
      'GET', Uri.parse('https://flutter.webspark.dev/flutter/api'));
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String result = await response.stream.bytesToString();
    //  print(result);
    List<post_object> listPost = [];

    dynamic responseObj = (json.decode(result) as dynamic);

    if (responseObj != null) {
      if (responseObj['error'] == false && responseObj['message'] == "OK") {
        List<dynamic> data = responseObj['data'];

        for (int i = 0; i < data.length; i++) {
          String id = data[i]['id'];

          dynamic start = data[i]['start'];
          dynamic goal = data[i]['end'];

          List<String> field = [];

          List<dynamic> dynField = data[i]["field"];

          for (int j = 0; j < dynField.length; j++) {
            field.add(dynField[j].toString());
          }

          int p = 0;

          for (int i = 0; i < field.length; i++) {
            if (i == start['y']) {
              List<String> strTmp = field[i].split('');

              field[i] = '';

              for (int j = 0; j < strTmp.length; j++) {
                if (j == start['x']) {
                  strTmp[j] = 's';
                }
                field[i] += strTmp[j];
              }
            }

            if (i == goal['y']) {
              List<String> strTmp = field[i].split('');

              field[i] = '';

              for (int j = 0; j < strTmp.length; j++) {
                if (j == goal['x']) {
                  strTmp[j] = 'g';
                }
                field[i] += strTmp[j];
              }
            }
          }

          String textMap = "";

          for (int i = 0; i < field.length; i++) {
            textMap += field[i] + "\n";
          }

          Maze maze = new Maze.parse(textMap);
          Queue<Tile> solution = aStar2D(maze);
          print(solution);

          List<step> listStep = [];
          String path = '';

          solution.forEach((element) {
            step st = step(element.x, element.y);
            listStep.add(st);
            path += '(${st.x}.${st.y})->';
          });

          resultz rz = resultz(listStep, path.substring(0, path.length - 2));

          post_object postO = post_object(id, rz);
          listPost.add(postO);
        }

        var headers = {'Content-Type': 'application/json'};
        Request request = http.Request(
            'POST', Uri.parse('https://flutter.webspark.dev/flutter/api'));

        String body = json.encode(listPost);

        request.body = body;

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          print(await response.stream.bytesToString());
        } else {
          print(response.reasonPhrase);
        }
      }
    } else {
      print('Error');
    }
  } else {
    print(response.reasonPhrase);
  }
}
