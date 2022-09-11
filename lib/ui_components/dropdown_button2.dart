import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DropDownField extends StatefulWidget {
  final dynamic initialValue;        //To define default filled in value of dropdownfield    [default: ""]
  final Widget? icon;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final bool required;        //To define if the dropdownfield is required to fill in [default: false]
  final bool enabled;         //To define if the dropdownfield is enabled or not      [default: true]
  final List<dynamic>? items;  //By default will have empty string list
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldSetter<dynamic>? setter;
  final ValueChanged<dynamic>? onValueChanged;
  final bool strict;          //To define if user must only select from dropdownlist  [default: false]
  final int? itemsVisibleInDropdown; //total number of items visible in dropdown

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  TextEditingController? controller;

  DropDownField(
    {Key? key,
      this.controller,
      this.initialValue: "",
      this.required: false,
      this.icon,
      this.hintText,
      this.hintStyle: const TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 18.0),
      this.labelText,
      this.labelStyle: const TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 18.0),
      this.errorText,
      this.errorStyle: const TextStyle(fontWeight: FontWeight.normal, color: Colors.red, fontSize: 18.0),
      this.inputFormatters,
      this.items: const <String>[],
      this.setter,
      this.onValueChanged,
      this.itemsVisibleInDropdown,
      this.enabled: true,
      this.strict: true
    }
  ) :
  super(key: key){
    if(controller == null){ //if user did not pass in a controller, then auto create one
      controller = TextEditingController(text: ""); //default value in formfield is ""
    }
  }

  @override
  _DropDownFieldState createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  late TextEditingController _controller;
  bool _showdropdown = false;
  bool _isSearching = false;
  String _searchText = "";
  int _itemsVisibleInDropdown = 3;

  @override
  DropDownField get widget => super.widget;
  TextEditingController get _formfieldController => widget.controller ?? _controller;
  List<String> get _items => widget.items?.map((dynamic item) => item as String).toList()??<String>[];

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    }

    _formfieldController.addListener(_handleControllerChanged);

    if(widget.itemsVisibleInDropdown != null && widget.itemsVisibleInDropdown!>0){
      _itemsVisibleInDropdown = widget.itemsVisibleInDropdown as int;
    }
    else if (widget.itemsVisibleInDropdown == null && widget.items != null && widget.items!.length > 0 && widget.items!.length < 3){
      _itemsVisibleInDropdown = widget.items!.length;
    }
    print(_itemsVisibleInDropdown);
    _searchText = _formfieldController.text;
  }

  @override
  void didUpdateWidget(DropDownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      // if (oldWidget.controller != null && widget.controller == null)
      //   //_controller = TextEditingController.fromValue(oldWidget.controller?.value??"");
      //   _controller = TextEditingController.fromValue("");
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    setState(() {
      _formfieldController.text = widget.initialValue as String;
    });
  }

  void clearValue() {
    setState(() {
      _formfieldController.text = '';
    });
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_formfieldController.text.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchText = "";
      });
    } else {
      setState(() {
        _isSearching = true;
        _searchText = _formfieldController.text;
        _showdropdown = true;
      });
    }
  }

  ListTile _getListTile(String text) {
    return ListTile(
      dense: true,
      title: Text(
        text,
      ),
      onTap: () {
        setState(() {
          _formfieldController.text = text;
          _handleControllerChanged();
          _showdropdown = false;
          _isSearching = false;
          if (widget.onValueChanged != null) {
            widget.onValueChanged!(text);
          }
        });
      },
    );
  }

  List<ListTile> _getChildren(List<String> items) {
    List<ListTile> childItems = [];
    for (var item in items) {
      if (_searchText.isNotEmpty) {
        if (item.toUpperCase().contains(_searchText.toUpperCase()))
          childItems.add(_getListTile(item));
      } else {
        childItems.add(_getListTile(item));
      }
    }
    return childItems;
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                onChanged: (text) {
                  print("Hmm");
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _formfieldController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true,
                  icon: widget.icon,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.arrow_drop_down, size: 30.0, color: Colors.black),
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {
                        _showdropdown = !_showdropdown;
                      });
                    }),
                  hintStyle: widget.hintStyle,
                  labelStyle: widget.labelStyle,
                  hintText: widget.hintText,
                  labelText: widget.labelText,
                  errorStyle: widget.errorStyle,
                  errorText: widget.errorText,
                  counterText: "",    //counterText displays number of characters in the textformfield [default: disabled]
                ),
                style: widget.labelStyle,
                textAlign: TextAlign.start,
                autofocus: false,
                obscureText: false,
                maxLength: 30,        //maximum number of characters in the textformfield [default: 30]
                maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                maxLines: 1,          //maximum number of lines in textformfield  [default: 1]
                validator: (String? text) {
                  if (widget.required) {
                    if (text == null || text.isEmpty)
                      return 'This field cannot be empty!';
                  }

                  //Items null check added since there could be an initial brief period of time
                  //when the dropdown items will not have been loaded
                  if (widget.items != null) {
                    if (widget.strict && text != null && text.isNotEmpty && !widget.items!.contains(text))
                      return 'Invalid value in this field!';
                  }

                  return null;
                },
                onSaved: widget.setter,
                enabled: widget.enabled,
                inputFormatters: widget.inputFormatters,
              )
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                if (!widget.enabled) return;
                clearValue();
                setState(() {
                  FocusManager.instance.primaryFocus?.unfocus();
                  _showdropdown = !_showdropdown;
                });
              },
            )
          ],
        ),
        if(_showdropdown) ...[
          Container(
            alignment: Alignment.topLeft,
            //height: widget.itemsVisibleInDropdown??0.0 * 48.0,
            height: _itemsVisibleInDropdown * 48.0,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              cacheExtent: 0.0,
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              padding: EdgeInsets.only(left: 20.0),
              children: widget.items?.isNotEmpty??false?  //if items is null/empty -> empty list, if items is not empty -> listtile
                ListTile.divideTiles(context: context, tiles: _getChildren(widget.items as List<String>).toList()) as List<Widget>
                :
                <String>[] as List<Widget>,
            ),
          )
        ]
      ],
    );
  }
}
