import 'package:app2/themes.dart';
import 'package:flutter/material.dart';
import 'screen.dart';
import 'images.dart';
import 'strings.dart';
import 'theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'top_level_providers.dart';
import 'userdata.dart';
import 'firestore_storage.dart';


class TestPage extends ConsumerWidget {
  late String text;
  late String image;
  TestPage({Key? key, this.text = Strings.defaultError, this.image = Images.defaultError}) : super(key:key) {Screen().portrait();}

  Userdata user = Userdata(
    id:"123",
    name:"ABC",
    createdAt: DateTime.now().toString(),
    version: DateTime.now().toString(),
  );

  Folderdata fold = Folderdata(
    id:"123",
    name:"ABC",
    createdAt: DateTime.now().toString(),
    updatedAt: DateTime.now().toString(),
    link: "DEF",
    description: "GHI",
    imagelist: ["HMMM","LOL"]
  );

  Imagedata imag = Imagedata(
    id: "123",
    name: "ABC",
    createdAt: DateTime.now().toString(),
  );

  void test() {
    final userz = user.copyWith(images: {imag.id:imag});
    final serial = userz.toJson();
    final deserial = Folderdata.fromJson(serial);
    print(serial);
    print(deserial);
  }

  void upload(String uid) async {
    final userz = user.copyWith(folders:{fold.id:fold},images: {imag.id:imag});
    final data = userz.toJson();
    await FirestoreStorage().writeData("UserData", uid, "collection", "main_collection", data);
  }

  void download(String uid) async {
    final data = await FirestoreStorage().readData("UserData", uid, "collection", "main_collection");
    if(data != null){
      final deserial = Userdata.fromJson(data);
      print("Data is:\n${deserial}");
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme= watch(themeProvider);
    final firebaseAuth = context.read(firebaseAuthProvider);
    final uid = firebaseAuth.firebaseUser?.uid;
    return Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
              builder: (context,constraints) {
                return Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  color: Theme.of(context).colorScheme.background,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(image, width: constraints.maxHeight*0.15, height: constraints.maxHeight*0.15, fit: BoxFit.contain),
                      Container(height: constraints.maxHeight*0.05),
                      Text(this.text, style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center,),
                      Container(height: constraints.maxHeight*0.05, width: constraints.maxHeight*0.05, padding: EdgeInsets.all(constraints.maxHeight*0.02)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: () => theme.changeTheme(ThemeType.Light), child: Text("Light")),
                          ElevatedButton(onPressed: () => theme.changeTheme(ThemeType.Dark), child: Text("Dark")),
                          ElevatedButton(onPressed: () => theme.changeTheme(ThemeType.Purple), child: Text("Purple"))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: test, child: Text("Print")),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: () => upload(uid??""), child: Text("Upload")),
                          ElevatedButton(onPressed: () => download(uid??""), child: Text("Download")),
                        ],
                      )
                    ],
                  ),
                );
              }
          ),
        )
    );
  }
}