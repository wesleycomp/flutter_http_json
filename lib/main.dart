import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ListView - Http e Json'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  List data;

  // Função para obter os dados JSON
  Future<String> getJSONData() async {
    var response = await http.get(
        // codifiga a url
        Uri.encodeFull("https://unsplash.com/napi/photos/Q14J2k8VE3U/related"),
        // Aceita somente resposta JSON
        headers: {"Accept": "application/json"}
    );

    setState(() {
      // Pega os dados JSON
      data = json.decode(response.body)['results'];
    });

    return "Dados obtidos com sucesso";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _criaListView(),
    );
}

Widget _criaListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (context, index) {
        return _criaImagemColuna(data[index]);
      }
    );
}

Widget _criaImagemColuna(dynamic item) => Container(
      decoration: BoxDecoration(
        color: Colors.white54
      ),
      margin: const EdgeInsets.all(4),
      child: Column(
        children: [
          new CachedNetworkImage(
            imageUrl: item['urls']['small'],
            placeholder: (context, url) => new CircularProgressIndicator(),
            errorWidget: (context, url, error) => new Icon(Icons.error),
            fadeOutDuration: new Duration(seconds: 1),
            fadeInDuration: new Duration(seconds: 3),
          ),
          _criaLinha(item)
        ],
      ),
    );

Widget _criaLinha(dynamic item) {
    return ListTile(
      title: Text(
        item['description'] == null ? '': item['description'],
      ),
      subtitle: Text("Likes: " + item['likes'].toString()),
    );
  }
  @override
  void initState() {
    super.initState();
    // Chama o método getJSONData() quando a app inicializa
    this.getJSONData();
  }
}


  