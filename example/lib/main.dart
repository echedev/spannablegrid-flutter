import 'package:flutter/material.dart';
import 'package:spannable_grid/spannable_grid.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpannableGrid Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.amber,
      ),
      home: MyHomePage(title: 'SpannableGrid Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpannableGrid(
              columns: 4,
              rows: 4,
              cells: _getCells(),
              spacing: 2.0,
              onCellChanged: (cell) { print('Cell ${cell.id} changed'); },
//              showGrid: true,
//              emptyCellView: Container(color: Colors.amberAccent,),
//              editingOnLongPress: false,
            ),
          ],
        ),
      ),
    );
  }

  List<SpannableGridCellData> _getCells() {
    List<SpannableGridCellData> result = List();
    result.add(SpannableGridCellData(
      column: 1,
      row: 1,
      columnSpan: 2,
      rowSpan: 2,
      id: "Test Cell 1",
      child: Container(
        color: Colors.lime,
        child: Center(
          child: Text("Tile 2x2",
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    ));
    result.add(SpannableGridCellData(
      column: 4,
      row: 1,
      columnSpan: 1,
      rowSpan: 1,
      id: "Test Cell 2",
      child: Container(
        color: Colors.lime,
        child: Center(
          child: Text("Tile 1x1",
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    ));
    result.add(SpannableGridCellData(
      column: 1,
      row: 4,
      columnSpan: 3,
      rowSpan: 1,
      id: "Test Cell 3",
      child: Container(
        color: Colors.lightBlueAccent,
        child: Center(
          child: Text("Tile 3x1",
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    ));
    result.add(SpannableGridCellData(
      column: 4,
      row: 3,
      columnSpan: 1,
      rowSpan: 2,
      id: "Test Cell 4",
      child: Container(
        color: Colors.lightBlueAccent,
        child: Center(
          child: Text("Tile 1x2",
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    ));
    return result;
  }
}
