import 'package:app2/themes.dart';
import 'package:flutter/material.dart';
import 'screen.dart';
import 'images.dart';
import 'strings.dart';
import 'theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'top_level_providers.dart';

class TestPage extends ConsumerWidget {
  late String text;
  late String image;
  TestPage({this.text = Strings.defaultError, this.image = Images.defaultError}) {Screen().portrait();}

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme= watch(themeProvider);
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