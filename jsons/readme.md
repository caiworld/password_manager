https://github.com/flutterchina/json_model/blob/master/README-ZH.md
json生成dart model：
1.引入依赖包
dev_dependencies:
  json_model: #最新版本
  build_runner: ^1.0.0
  json_serializable: ^2.0.0
2.在工程根目录下创建一个名为 "jsons" 的目录;
3.创建或拷贝Json文件到"jsons" 目录中 ;
4.工程目录下运行
    flutter packages pub run json_model
  命令生成Dart model类，生成的文件默认在"lib/models"目录下

5.json文件案例：
{
  "name":"wendux",
  "father":"$user", //可以通过"$"符号引用其它model类
  "friends":"$[]user", // 可以通过"$[]"来引用数组
  "keywords":"$[]String", // 同上
  "age":20
}