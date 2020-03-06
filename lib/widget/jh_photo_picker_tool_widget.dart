import 'package:flutter/material.dart';
import 'package:photo/photo.dart';

//import 'package:photo_manager/photo_manager.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

const double itemSpace = 10.0;
const double space = 5.0; //上下左右间距
const double deleBtnWH = 20.0;
const Color bgColor = Colors.yellow;

typedef CallBack = void Function(List imgData);

/// 多图选择器
class JhPhotoPickerTool extends StatefulWidget {
  final double lfPaddingSpace; //外部设置的左右间距
  final CallBack callBack;

  JhPhotoPickerTool({
    this.lfPaddingSpace,
    this.callBack,
  });

  @override
  _JhPhotoPickerToolState createState() => _JhPhotoPickerToolState();
}

class _JhPhotoPickerToolState extends State<JhPhotoPickerTool> {
  List imgData = List(); //图片list
//  List<AssetEntity> imgPicked = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgData.add("selectPhoto_add"); //先添加 加号按钮 的图片
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    List data = List();
    data.addAll(imgData);
    data.removeAt(imgData.length - 1);
    widget.callBack(data);
  }

  @override
  Widget build(BuildContext context) {
    var kScreenWidth = MediaQuery.of(context).size.width;

    var lfPadding = widget.lfPaddingSpace == null ? 0.0 : widget.lfPaddingSpace;
    var ninePictureW = (kScreenWidth - space * 2 - 2 * itemSpace - lfPadding);
    var itemWH = ninePictureW / 3;
    int columnCount = imgData.length > 6 ? 3 : imgData.length <= 3 ? 1 : 2;

    return Container(
//        color: bgColor,
      width: kScreenWidth - lfPadding,
      height: columnCount * itemWH + space * 2 + (columnCount - 1) * itemSpace,
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //可以直接指定每行（列）显示多少个Item
            //一行的Widget数量
            crossAxisCount: 3,
            crossAxisSpacing: itemSpace, //水平间距
            mainAxisSpacing: itemSpace, //垂直间距
            childAspectRatio: 1.0, //子Widget宽高比例
          ),
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(space),
          //GridView内边距
          itemCount: imgData.length,
          itemBuilder: (context, index) {
            if (index == imgData.length - 1) {
              return addBtn(context, setState, imgData, null);
            } else {
              return imgItem(index, setState, imgData, null);
            }
          }),
    );
  }
}

/** 添加按钮 */
Widget addBtn(context, setState, imgData, imgPicked) {
  return GestureDetector(
    child: Image.asset(
      "imgs/add.png",
      width: 60,
      height: 60,
    ),
    onTap: () async {
      //点击添加按钮
      String type = await _selectPhoto(context);
      if (type == 'camera') {
        var image = await ImagePicker.pickImage(source: ImageSource.camera);
        print(image);
        imgData.insert(imgData.length - 1, image.absolute.path);
//            imgPicked.add(image);
        setState(() {});
      }
      if (type == 'gallery') {
        pickAsset(context, setState, imgData, imgPicked);
      }
//      JhBottomSheet.showText(context, dataArr: ["拍照", "相册"], title: "请选择",
//          clickCallback: (index, str) async {
//        if (index == 0) {
//          var image = await ImagePicker.pickImage(source: ImageSource.camera);
//          print(image);
//          imgData.insert(imgData.length - 1, image.absolute.path);
////            imgPicked.add(image);
//          setState(() {});
//        }
//        if (index == 1) {
//          pickAsset(context, setState, imgData, imgPicked);
//        }
//      });
    },
  );
}

Future<String> _selectPhoto(BuildContext context) async {
  String type = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("选择图片方式"),
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(),
              child: SimpleDialogOption(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text("相机"),
                ),
                onPressed: () {
                  Navigator.of(context).pop("camera");
                },
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(),
              child: SimpleDialogOption(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text("相册"),
                ),
                onPressed: () {
                  Navigator.of(context).pop("gallery");
                },
              ),
            )
          ],
        );
      });
  return type;
}

/** 图片和删除按钮 */
Widget imgItem(index, setState, imgData, imgPicked) {
  return GestureDetector(
    child: Container(
      color: Colors.transparent,
      child: Stack(alignment: Alignment.topRight, children: <Widget>[
        ConstrainedBox(
//                child:Image.file(imgData[index], fit: BoxFit.cover),
          child: Image.file(File(imgData[index]), fit: BoxFit.cover),
          constraints: BoxConstraints.expand(),
        ),
        GestureDetector(
          child: Image.asset(
            "imgs/cross.png",
            width: 30,
            height: 30,
          ),
          onTap: () {
            //点击删除按钮
            setState(() {
              imgData.removeAt(index);
//                    imgPicked.removeAt(index);
            });
          },
        )
      ]),
    ),
    onTap: () {
      print("点击第${index}张图片");
    },
  );
}

/** 多图选择 */
void pickAsset(context, setState, imgData, imgPicked) async {
  final result = await PhotoPicker.pickAsset(
      context: context,
//    pickedAssetList: imgPicked,
      maxSelected: 10 - imgData.length,
      pickType: PickType.onlyImage);

  if (result != null && result.isNotEmpty) {
    for (var e in result) {
      var file = await e.file;
//      print(file.absolute.path)
      if (!imgData.contains(file.absolute.path)) {
        imgData.insert(imgData.length - 1, file.absolute.path);
      }

//      imgData.insert(imgData.length-1, file);
//      if (!imgData.contains(file)) {
//        imgData.insert(imgData.length-1, file);
//      }

    }
  }
  setState(() {});
}
