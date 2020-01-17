import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class EditData extends StatefulWidget {
  final List list;
  final int index;
  EditData({this.list, this.index});
  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  TextEditingController namaController = new TextEditingController();
  TextEditingController posisiController = new TextEditingController();
  TextEditingController gajiController = new TextEditingController();
  void editData() {
    var url = "http://192.168.42.22/pegawai/editPegawai.php";
    http.post(url, body: {
      "id": widget.list[widget.index]['id'],
      "namaPegawai": namaController.text,
      "posisiPegawai": posisiController.text,
      "gajiPegawai": gajiController.text
    });
  }

  @override
  void initState() {
    namaController =
        new TextEditingController(text: widget.list[widget.index]['nama']);
    posisiController =
        new TextEditingController(text: widget.list[widget.index]['posisi']);
    gajiController =
        new TextEditingController(text: widget.list[widget.index]['gaji']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Edit Data Pegawai'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Padding(padding: new EdgeInsets.only(top: 15.0)),
                new TextField(
                    controller: namaController,
                    decoration: new InputDecoration(
                        hintText: "Input Nama Pegawai",
                        labelText: "Nama Pegawai",
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(20.0)))),
                new Padding(padding: new EdgeInsets.all(5.0)),
                new TextField(
                    controller: posisiController,
                    decoration: new InputDecoration(
                        hintText: "Input Posisi Pegawai",
                        labelText: "Posisi Pegawai",
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(20.0)))),
                new Padding(padding: new EdgeInsets.all(5.0)),
                new TextField(
                    controller: gajiController,
                    decoration: new InputDecoration(
                        hintText: "Input Gaji Pegawai",
                        labelText: "Input Gaji",
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(20.0)))),
                new Padding(padding: const EdgeInsets.all(5.0)),
                new RaisedButton(
                  child: new Text("Edit Data"),
                  color: Colors.blueAccent,
                  onPressed: () {
                    editData();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new Login()));
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
