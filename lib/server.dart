import 'dart:io';
import 'dart:async';
import 'package:http_server/http_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

VirtualDirectory _virDir;
String appDocPath;

void _directoryHandler(dir, request) {
    //获取文件的路径
    var indexUri = new Uri.file(dir.path).resolve('index.html');
    //返回指定的文件
    _virDir.serveFile(new File(indexUri.toFilePath()), request);
}

void startServer() async {
    appDocPath = (await getApplicationDocumentsDirectory()).path;
    var file = await _getLocalFile();
    // 将静态的html写入到文件目录
    await file.writeAsString(await _loadAsset());

    // 允许查看文件列表
    _virDir = new VirtualDirectory(appDocPath)
        ..allowDirectoryListing = true;

    //  启动服务器并将请求交给virDir处理
    var server = await HttpServer.bind('0.0.0.0', 7777);
    server.listen(_virDir.serveRequest);
    print('server start success!');
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
