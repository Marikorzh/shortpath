import 'package:flutter/material.dart';

import '../http/model.dart';

class PreviewScreen extends StatefulWidget {
  final List<String> field;
  final List<Map<String, int>> path;
  final Coordinates start;
  final Coordinates end;

  const PreviewScreen(this.field, this.path, this.start, this.end, {super.key});
  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {


  Color isColor(bool isBlack, bool isStart, bool isEnd,isPath){
    if(isBlack) {
      return Colors.black;
    } else if(isStart) {return const Color(0xFF64FFDA);}
    else if(isEnd) {return const Color(0xFF009688);}
    else if(isPath) {return const Color(0xFF4CAF50);}
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.field[0].length,
              ),
              itemCount: widget.field.length * widget.field[0].length,
              itemBuilder: (context, index) {
                int row = index ~/ widget.field[0].length;
                int col = index % widget.field[0].length;

                bool isPath = widget.path.any((step) => step['x'] == row && step['y'] == col);
                bool isObstacle = widget.field[row][col] == 'X';
                bool isStart = (row == widget.start.x) && (col == widget.start.y);
                bool isEnd = (row == widget.end.x) && (col == widget.end.y);

                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color:
                      isColor(isObstacle,isStart,isEnd,isPath)

                  ),
                  child: Center(
                    child: Text(
                      '$row,$col)',
                      style: TextStyle(
                        color: isObstacle ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Text(widget.path.map((step) => "(${step['x']},${step['y']})").join("->")),
        ],
      ),
    );
  }
}