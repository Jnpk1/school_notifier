import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_notifier/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

class PicturePage extends StatefulWidget {
  static const String routeName = '/picture_add';
  const PicturePage({Key? key}) : super(key: key);

  @override
  _PicturePageState createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  var storage = FirebaseStorage.instance;
  late List<AssetImage> listofImages;
  bool clicked = false;
  List<String> listofStrings = [];
  String? images;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getImages();
  }

  void getImages() {
    listofImages = [];
    for (int i = 1; i < 4; i++) {
      listofImages.add(AssetImage('assets/example' + i.toString() + '.png'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Insert Picture"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context
                .read<AuthenticationBloc>()
                .add(AuthenticationLogoutRequested()),
          )
        ],
      ),
      body: Container(
          child: Column(children: <Widget>[
        GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            itemCount: listofImages.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 3.0, crossAxisSpacing: 3.0),
            itemBuilder: (BuildContext context, int index) {
              return GridTile(
                  child: Material(
                      child: GestureDetector(
                          child: Stack(children: <Widget>[
                            this.images == listofImages[index].assetName ||
                                    listofStrings
                                        .contains(listofImages[index].assetName)
                                ? Positioned.fill(
                                    child: Opacity(
                                    opacity: 0.7,
                                    child: Image.asset(
                                        listofImages[index].assetName,
                                        fit: BoxFit.fill),
                                  ))
                                : Positioned.fill(
                                    child: Opacity(
                                    opacity: 1.0,
                                    child: Image.asset(
                                      listofImages[index].assetName,
                                      fit: BoxFit.fill,
                                    ),
                                  )),
                            this.images == listofImages[index].assetName ||
                                    listofStrings
                                        .contains(listofImages[index].assetName)
                                ? Positioned(
                                    left: 0,
                                    bottom: 0,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ))
                                : Visibility(
                                    child: Icon(
                                      Icons.check_circle_outlined,
                                      color: Colors.black,
                                    ),
                                  )
                          ]),
                          onTap: () {
                            setState(() {
                              if (listofStrings
                                  .contains(listofImages[index].assetName)) {
                                this.clicked = false;
                                listofStrings
                                    .remove(listofImages[index].assetName);
                                this.images = null;
                              } else {
                                this.images = listofImages[index].assetName;

                                listofStrings.add(this.images!);
                                this.clicked = true;
                              }
                            });
                          })));
            }),
        Builder(builder: (context) {
          return ElevatedButton(
              child: Text("Save Images"),
              onPressed: () {
                setState(() {
                  this.isLoading = true;
                });
                listofStrings.forEach((images) async {
                  String img = images
                      .substring(
                          images.lastIndexOf("/"), images.lastIndexOf("."))
                      .replaceAll("/", "");
                  final Directory systemTempDir = Directory.systemTemp;
                  final byteData = await rootBundle.load(img);

                  final file = File('${systemTempDir.path}/$img.png');
                  await file.writeAsBytes(byteData.buffer.asUint8List(
                      byteData.offsetInBytes, byteData.lengthInBytes));
                  TaskSnapshot snapshot =
                      await storage.ref().child("assets/$img").putFile(file);
                  if (snapshot.state == TaskState.success) {
                    final String downloadUrl =
                        await snapshot.ref.getDownloadURL();
                    await FirebaseFirestore.instance
                        .collection("images")
                        .add({"url": downloadUrl, "name": img});
                    setState(() {
                      isLoading = false;
                    });
                    final snackBar = SnackBar(content: Text('Yay! Success'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    print('Error from image repo ${snapshot.state.toString()}');
                    throw ('This file is not an image');
                  }
                });
              });
        })
      ])),
    );
  }
}
