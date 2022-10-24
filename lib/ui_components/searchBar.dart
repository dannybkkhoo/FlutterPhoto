import 'package:flutter/material.dart';
import '../providers/pagestatus_provider.dart';

class SearchBar extends StatefulWidget {
  PagestatusProvider pageStatus;

  SearchBar({Key? key, required this.pageStatus}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(bottom: 9.0),
        hintText: "Search...",
        hintStyle: Theme.of(context).textTheme.headline6?.copyWith(color: Theme.of(context).colorScheme.surfaceTint),
        prefixIcon: Icon(Icons.search, size: 30.0, color: Theme.of(context).colorScheme.inverseSurface,),
        suffixIcon: IconButton(
          alignment: Alignment.center,
          icon: Icon(Icons.close, size: 30.0, color: Theme.of(context).colorScheme.inverseSurface,),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            _textController.clear();
            widget.pageStatus.searchKeyword = "";
          },
          padding: EdgeInsets.zero,
        ),
      ),
      onChanged: (String text) {
        widget.pageStatus.searchKeyword = text;
      },
      style: Theme.of(context).textTheme.headline6,
      textAlign: TextAlign.left,
      textAlignVertical: TextAlignVertical.bottom,
    );
  }
}
