import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DropDownField extends StatefulWidget {
  final String initialValue;              //To define default filled in value of dropdownfield    [default: ""]
  final Widget? icon;                     //Icon in front of the tab                              [default: null]
  final TextStyle? labelStyle;
  final String labelText;
  final TextStyle? hintStyle;
  final String hintText;
  final TextStyle? errorStyle;
  final String errorText;
  final TextInputType keyboardType;       //To define the type of keyboard the user can use       [default: TextInputType.text]
  final bool enabled;                     //To define if the dropdownfield is enabled or not      [default: true]
  final bool required;                    //To define if the dropdownfield is required to fill in [default: false]
  final bool strict;                      //To define if user must only select from dropdownlist  [default: false]
  final int? maxItemsVisibleInDropdown;   //Max number of items visible in dropdown               [default: 3]
  final double normalHeight;              //Height of dropdownTab when dropdown is not shown
  final List<String> items;               //By default will have empty string list                [default: []]
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldSetter<String>? onSaved; //To save the value in the textformfield to a variable  [default: null]
  final bool Function(String)? validator; //To define the validator when user input text          [default: null]

  DropDownField(
      {
        Key? key,
        this.initialValue = "",
        this.icon,
        this.labelStyle = const TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 18.0),
        this.labelText = "",
        this.hintStyle = const TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 18.0),
        this.hintText = "",
        this.errorStyle = const TextStyle(fontWeight: FontWeight.normal, color: Colors.red, fontSize: 18.0),
        this.errorText = "",
        this.keyboardType = TextInputType.text,
        this.enabled = true,
        this.required = false,
        this.strict = false,
        this.maxItemsVisibleInDropdown,
        this.normalHeight = 100,
        this.items = const <String>[],
        this.inputFormatters,
        this.onSaved = null,
        this.validator = null,
      }
      ) : super(key: key);

  @override
  _DropDownFieldState createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  bool _showdropdown = false;
  bool _hasError = false;
  String _errorText = "";
  int _itemsVisibleInDropdown = 0;
  TextEditingController _textController = TextEditingController();
  List test = <String>[];

  ListTile _getListTile(String text) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(
        text,
        style: widget.labelStyle,
      ),
      onTap: () {
        setState(() {
          _textController.text = text;
          _showdropdown = false;
        });
      },
      focusColor: Colors.blue,
    );
  }

  ListTile _notFoundTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(
        "No match found...",
        style: widget.errorStyle,
      ),
    );
  }

  List<ListTile> _getChildren(List<String> items) {
    List<ListTile> childItems = [];
    for (var item in items) {
      if (_textController.text.isNotEmpty) {
        if (item.toUpperCase().contains(_textController.text.toUpperCase())) {
          childItems.add(_getListTile(item));
        }
      }
      else {
        childItems.add(_getListTile(item));
      }
    }

    if(childItems.isEmpty) {
      childItems.add(_notFoundTile());
    }

    _itemsVisibleInDropdown = childItems.length;
    return childItems;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _textController.text = widget.initialValue;
    _textController.addListener((){
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    return SafeArea(
      child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.inverseSurface),
                borderRadius: BorderRadius.all(Radius.circular(13.0)),
                color: Theme.of(context).colorScheme.surface,
              ),
              margin: EdgeInsets.fromLTRB(3.0, 1.0, 3.0, 1.0),
              child: Column(
                children: [
                  TextFormField(
                    autofocus: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _textController,
                    decoration: InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.only(left: 10.0),
                        errorText: _hasError?_errorText:null,
                        errorStyle: widget.errorStyle,
                        enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(13.0),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.inverseSurface, width: 3.0)
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(13.0),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.inverseSurface, width: 3.0)
                        ),
                        hintText: widget.hintText,
                        hintStyle: widget.hintStyle,
                        icon: widget.icon,
                        isDense: true,
                        labelText: widget.labelText,
                        labelStyle: widget.labelStyle,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              color: Theme.of(context).colorScheme.inverseSurface,
                              icon: Icon(Icons.arrow_drop_down, size: 30.0),
                              onPressed: () {
                                setState(() {
                                  _showdropdown = !_showdropdown;
                                });
                              },
                            ),
                            IconButton(
                              color: Theme.of(context).colorScheme.inverseSurface,
                              icon: Icon(Icons.close, size: 30.0),
                              onPressed: () {
                                setState(() {
                                  _textController.text = "";
                                });
                              },
                            ),
                          ],
                        )
                    ),
                    inputFormatters: widget.inputFormatters,
                    keyboardType: widget.keyboardType,
                    onSaved: widget.onSaved,
                    validator: (String? text) {
                      //If user states "Required", check if field is empty or not
                      if (widget.required) {
                        if (text == null || text.isEmpty) {
                          _hasError = true;
                          _errorText = "This field must not be empty!";
                          return _errorText;
                        }
                      }

                      //Items null check added since there could be an initial brief period of time when the dropdown items will not have been loaded
                      if (widget.items != null) {
                        if (widget.strict && text != null && text.isNotEmpty && !widget.items.contains(text)) {
                          _hasError = true;
                          _errorText = "Invalid value in this field!";
                          return _errorText;
                        }
                      }

                      //If user defined a validator, check against it
                      if (widget.validator != null) {
                        if (!widget.validator!(text!)){
                          _hasError = true;
                          _errorText = widget.errorText;
                          return _errorText;
                        }
                      }

                      //If all validator passed, return null
                      _hasError = false;
                      _errorText = "";
                      return null;
                    },
                  ),
                  if(_showdropdown) ... [
                    Container(
                      alignment: Alignment.center,
                      child: Scrollbar(
                        child: ListView(
                          cacheExtent: 0.0,
                          children: _getChildren(widget.items),
                          controller: _scrollController,
                          padding: EdgeInsets.only(left:20.0),
                          scrollDirection: Axis.vertical,
                        ),
                        controller: _scrollController,
                        thickness: 3.0,
                        thumbVisibility: true,
                      ),
                      height: _itemsVisibleInDropdown * widget.normalHeight * 0.85,
                      width: constraints.maxWidth,
                      padding: EdgeInsets.only(right: 3.0),
                    )
                  ]
                ],
              ),
            );
          }
      ),
    );
  }
}
