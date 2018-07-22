import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf.dart';
import 'package:flutter/services.dart' show rootBundle;

String appDocPath;


const String HOST = '0.0.0.0';
const int PORT = 7777;

void startServer() async {
    // // 获取文件路径
    // appDocPath = (await getApplicationDocumentsDirectory()).path;
    // // 获取文件
    // var file = await _getLocalFile();
    // // 将静态的html写入到文件目录
    // await file.writeAsString(await _loadAsset());

    // // 允许查看文件列表
    // _virDir = new VirtualDirectory(appDocPath)
    //     ..allowDirectoryListing = true;

    var indexFile = await _loadAsset();

    //  启动服务器并将请求交给virDir处理
    var server = await HttpServer.bind(HOST, PORT);
    
    server.listen((HttpRequest request) {
        HttpResponse res = request.response;
        if (request.uri.path == '/') {
            res.headers.contentType = new ContentType("text", "html", charset: "utf-8");
            res.write(indexFile);
        }
        if (request.uri.path == '/upload') {
            res.headers.add("Access-Control-Allow-Origin", "*");
            print(request.contentLength);
        }
        res.close();
        print(request.uri);
    });

}

// _loadAsset方法，以字符串的形式加载静态的文件
Future<String> _loadAsset() async {
    return await rootBundle.loadString('web/index.html');
}

// _getLocalFile函数，获取本地文件目录
Future<File> _getLocalFile() async {
    // 获取本地文档目录
    String dir = (await getApplicationDocumentsDirectory()).path;
    // 创建一个本地文件
    File file = new File('$dir/index.html');
    return file;
}
