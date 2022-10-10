import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DropDownButton extends StatefulWidget {
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
  final bool enableDropdown;              //To define if the dropdown button is enabled or not    [default: true]
  final bool required;                    //To define if the dropdownfield is required to fill in [default: false]
  final bool strict;                      //To define if user must only select from dropdownlist  [default: false]
  final int maxItemsVisibleInDropdown;    //Max number of items visible in dropdown               [default: 3]
  final double? buttonHeight;             //Height of dropdownTab when dropdown is not shown      [default: textTheme.bodyText1.fontSize]
  final double? dropdownHeight;           //Height of each row of visible text in dropdown        [default: textTheme.bodyText1.fontSize]
  final List<String> items;               //By default will have empty string list                [default: []]
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldSetter<String>? onSaved; //To save the value in the textformfield to a variable  [default: null]
  final bool Function(String)? validator; //To define the validator when user input text          [default: null]

  DropDownButton(
    {
      Key? key,
      this.initialValue = "",
      this.icon,
      this.labelStyle,
      this.labelText = "",
      this.hintStyle,
      this.hintText = "",
      this.errorStyle,
      this.errorText = "",
      this.keyboardType = TextInputType.text,
      this.enabled = true,
      this.enableDropdown = true,
      this.required = false,
      this.strict = false,
      this.maxItemsVisibleInDropdown = 3,
      this.buttonHeight,
      this.dropdownHeight,
      this.items = const <String>[],
      this.inputFormatters,
      this.onSaved = null,
      this.validator = null,
    }
    ) : super(key: key);

  @override
  _DropDownButtonState createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  late TextStyle? labelStyle;
  late TextStyle? hintStyle;
  late TextStyle? errorStyle;
  late double buttonHeight;
  late double dropdownHeight;
  bool _hasError = false;
  bool _showdropdown = false;
  int _itemsVisibleInDropdown = 0;
  String _errorText = "";
  TextEditingController _textController = TextEditingController();

  ListTile _getListTile(String text) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {
          _textController.text = text;
          _showdropdown = false;
        });
      },
      title: Text(
        text,
        style: labelStyle,
      ),
      visualDensity: VisualDensity(vertical: -3),
    );
  }

  ListTile _notFoundTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(
        "No match found...",
        style: errorStyle,
      ),
      visualDensity: VisualDensity(vertical: -3),
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    labelStyle = widget.labelStyle??Theme.of(context).textTheme.bodyText1?.copyWith(color: Theme.of(context).colorScheme.inverseSurface);
    hintStyle = widget.hintStyle??Theme.of(context).textTheme.bodyText1?.copyWith(color: Theme.of(context).colorScheme.surfaceTint);
    errorStyle = widget.errorStyle??Theme.of(context).textTheme.bodyText1?.copyWith(color: Theme.of(context).colorScheme.error);
    // buttonHeight = widget.buttonHeight??Theme.of(context).textTheme.bodyText1?.fontSize??48.0;
    if(widget.buttonHeight != null) {
      buttonHeight = widget.buttonHeight!;
    }
    else if(Theme.of(context).textTheme.bodyText1?.fontSize != null) {
      buttonHeight = Theme.of(context).textTheme.bodyText1!.fontSize!*3.5;
    }
    else {
      buttonHeight = 49.0;
    }
    if(widget.dropdownHeight != null) {
      dropdownHeight = widget.dropdownHeight!;
    }
    else if(Theme.of(context).textTheme.bodyText1?.fontSize != null) {
      dropdownHeight = Theme.of(context).textTheme.bodyText1!.fontSize!*2.5;
    }
    else {
      dropdownHeight = 35.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(buttonHeight);
    print(dropdownHeight);
    final ScrollController _scrollController = ScrollController();
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
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
                    errorStyle: errorStyle,
                    enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.inverseSurface, width: 3.0)
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.inverseSurface, width: 3.0)
                    ),
                    hintText: widget.hintText,
                    hintStyle: hintStyle,
                    icon: widget.icon,
                    isDense: false,
                    labelText: widget.required?widget.labelText+"*":widget.labelText,
                    labelStyle: labelStyle,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(widget.enableDropdown) ... [
                          IconButton(
                            color: Theme.of(context).colorScheme.inverseSurface,
                            icon: Icon(Icons.arrow_drop_down, size: 30.0),
                            onPressed: () {
                              setState(() {
                                _showdropdown = !_showdropdown;
                              });
                            },
                          )
                        ],
                        IconButton(
                          color: Theme.of(context).colorScheme.inverseSurface,
                          icon: Icon(Icons.close, size: 30.0),
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
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
                        _errorText = "This field is required, must not be empty!";
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
                    constraints: BoxConstraints(
                      maxHeight: widget.maxItemsVisibleInDropdown * buttonHeight
                    ),
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
                    height: (_itemsVisibleInDropdown < widget.maxItemsVisibleInDropdown? _itemsVisibleInDropdown:widget.maxItemsVisibleInDropdown) * dropdownHeight,
                    width: constraints.maxWidth,
                    padding: EdgeInsets.only(right: 3.0),
                  )
                ]
              ],
            ),
            constraints: BoxConstraints(
              minHeight: buttonHeight,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.inverseSurface),
              borderRadius: BorderRadius.all(Radius.circular(13.0)),
              color: Theme.of(context).colorScheme.surface,
            ),
            margin: EdgeInsets.fromLTRB(3.0, 1.0, 3.0, 1.0),
          );
        }
      ),
    );
  }
}