import 'package:flutter/material.dart';
import 'package:editable/widgets/table_header.dart';
import 'package:editable/commons/helpers.dart';

class Editable2 extends StatefulWidget {
  Editable2(
      {Key? key,
      this.columns,
      this.rows,
      this.columnRatio = 0.20,
      this.onSubmitted,
      this.onRowSaved,
      this.columnCount = 0,
      this.rowCount = 0,
      this.borderColor = Colors.grey,
      this.tdPaddingLeft = 8.0,
      this.tdPaddingTop = 8.0,
      this.tdPaddingRight = 8.0,
      this.tdPaddingBottom = 12.0,
      this.thPaddingLeft = 8.0,
      this.thPaddingTop = 0.0,
      this.thPaddingRight = 8.0,
      this.thPaddingBottom = 0.0,
      this.trHeight = 50.0,
      this.borderWidth = 0.5,
      this.thWeight = FontWeight.w600,
      this.thSize = 18,
      this.showSaveIcon = false,
      this.saveIcon = Icons.save,
      this.saveIconColor = Colors.black12,
      this.saveIconSize = 18,
      this.tdAlignment = TextAlign.start,
      this.tdStyle,
      this.tdEditableMaxLines = 1,
      this.thAlignment = TextAlign.start,
      this.thStyle,
      this.thVertAlignment = CrossAxisAlignment.center,
      this.showCreateButton = false,
      this.createButtonAlign = CrossAxisAlignment.start,
      this.createButtonIcon,
      this.createButtonColor,
      this.createButtonShape,
      this.createButtonLabel,
      this.stripeColor1 = Colors.white,
      this.stripeColor2 = Colors.black12,
      this.zebraStripe = false,
      this.focusedBorder}) : super(key: key);

  final List? columns;
  final List? rows;
  final int rowCount;
  final int columnCount;
  final double columnRatio;
  final Color borderColor;
  final double borderWidth;
  final double tdPaddingLeft;
  final double tdPaddingTop;
  final double tdPaddingRight;
  final double tdPaddingBottom;
  final TextAlign tdAlignment;
  final TextStyle? tdStyle;
  final int tdEditableMaxLines;
  final double thPaddingLeft;
  final double thPaddingTop;
  final double thPaddingRight;
  final double thPaddingBottom;
  final TextAlign thAlignment;
  final TextStyle? thStyle;
  final FontWeight thWeight;
  final CrossAxisAlignment thVertAlignment;
  final double thSize;
  final double trHeight;
  final bool showSaveIcon;
  final IconData saveIcon;
  final Color saveIconColor;
  final double saveIconSize;
  final bool showCreateButton;
  final CrossAxisAlignment createButtonAlign;
  final Icon? createButtonIcon;
  final Color? createButtonColor;
  final BoxShape? createButtonShape;
  final Widget? createButtonLabel;
  final Color stripeColor1;
  final Color stripeColor2;
  final bool zebraStripe;
  final InputBorder? focusedBorder;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<dynamic>? onRowSaved;

  @override
  Editable2State createState() => Editable2State(
      rows: this.rows,
      columns: this.columns,
      rowCount: this.rowCount,
      columnCount: this.columnCount);
}

class Editable2State extends State<Editable2> {
  List? rows, columns;
  int? columnCount;
  int? rowCount;
  ///Get all edited rows
  List get editedRows => _editedRows;

  ///Create a row after the last row
  createRow() => addOneRow(columns, rows);
  Editable2State({this.rows, this.columns, this.columnCount, this.rowCount});

  /// Temporarily holds all edited rows
  List _editedRows = [];

  @override
  Widget build(BuildContext context) {
    /// initial Setup of columns and row, sets count of column and row
    rowCount = rows == null || rows!.isEmpty ? widget.rowCount : rows!.length;
    columnCount =
        columns == null || columns!.isEmpty ? columnCount : columns!.length;
    columns = columns ?? columnBlueprint(columnCount, columns);
    rows = rows ?? rowBlueprint(rowCount!, columns, rows);

    /// Builds saveIcon widget
    Widget _saveIcon(index) {
      return Flexible(
        fit: FlexFit.loose,
        child: Visibility(
          visible: widget.showSaveIcon,
          child: IconButton(
            padding: EdgeInsets.only(right: widget.tdPaddingRight),
            hoverColor: Colors.transparent,
            icon: Icon(
              widget.saveIcon,
              color: widget.saveIconColor,
              size: widget.saveIconSize,
            ),
            onPressed: () {
              int rowIndex = editedRows.indexWhere(
                  (element) => element['row'] == index ? true : false);
              if (rowIndex != -1) {
                widget.onRowSaved!(editedRows[rowIndex]);
              } else {
                widget.onRowSaved!('no edit');
              }
            },
          ),
        ),
      );
    }

    /// Generates table columns
    List<Widget> _tableHeaders() {
      return List<Widget>.generate(columnCount! + 1, (index) {
        return columnCount! + 1 == (index + 1)
            ? iconColumn(widget.showSaveIcon, widget.thPaddingTop,
                widget.thPaddingBottom)
            : THeader(
                widthRatio: columns![index]['widthFactor'] != null
                    ? columns![index]['widthFactor'].toDouble()
                    : widget.columnRatio,
                thAlignment: widget.thAlignment,
                thStyle: widget.thStyle,
                thPaddingLeft: widget.thPaddingLeft,
                thPaddingTop: widget.thPaddingTop,
                thPaddingBottom: widget.thPaddingBottom,
                thPaddingRight: widget.thPaddingRight,
                headers: columns,
                thWeight: widget.thWeight,
                thSize: widget.thSize,
                index: index);
      });
    }

    /// Generates table rows
    List<Widget> _tableRows() {
      return List<Widget>.generate(rowCount!, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(columnCount! + 1, (rowIndex) {
            var ckeys = [];
            var cwidths = [];
            var ceditable = <bool>[];
            columns!.forEach((e) {
              ckeys.add(e['key']);
              cwidths.add(e['widthFactor'] ?? widget.columnRatio);
              ceditable.add(e['editable'] ?? true);
            });
            var list = rows![index];
            return columnCount! + 1 == (rowIndex + 1)
                ? _saveIcon(index)
                : RowBuilder2(
                    index: index,
                    col: ckeys[rowIndex],
                    trHeight: widget.trHeight,
                    borderColor: widget.borderColor,
                    borderWidth: widget.borderWidth,
                    cellData: list[ckeys[rowIndex]],
                    tdPaddingLeft: widget.tdPaddingLeft,
                    tdPaddingTop: widget.tdPaddingTop,
                    tdPaddingBottom: widget.tdPaddingBottom,
                    tdPaddingRight: widget.tdPaddingRight,
                    tdAlignment: widget.tdAlignment,
                    tdStyle: widget.tdStyle,
                    tdEditableMaxLines: widget.tdEditableMaxLines,
                    onSubmitted: widget.onSubmitted,
                    widthRatio: cwidths[rowIndex].toDouble(),
                    isEditable: ceditable[rowIndex],
                    zebraStripe: widget.zebraStripe,
                    focusedBorder: widget.focusedBorder,
                    stripeColor1: widget.stripeColor1,
                    stripeColor2: widget.stripeColor2,
                    onChanged: (value) {
                      ///checks if row has been edited previously
                      var result = editedRows.indexWhere((element) {
                        return element['row'] != index ? false : true;
                      });

                      ///adds a new edited data to a temporary holder
                      if (result != -1) {
                        editedRows[result][ckeys[rowIndex]] = value;
                      } else {
                        var temp = {};
                        temp['row'] = index;
                        temp[ckeys[rowIndex]] = value;
                        editedRows.add(temp);
                      }
                    },
                  );
          }),
        );
      });
    }
    Widget createButton() {
      return Visibility(
        visible: widget.showCreateButton,
        child: Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 4),
          child: InkWell(
            onTap: () {
              rows = addOneRow(columns, rows);
              rowCount = rowCount! + 1;
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: widget.createButtonColor ?? Colors.white,
                boxShadow: [
                  BoxShadow(blurRadius: 2, color: Colors.grey.shade400)
                ],
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
              ),
              child: widget.createButtonIcon ?? Icon(Icons.add),
            ),
          ),
        ),
      );
    }
    return Material(
      color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:
              Column(crossAxisAlignment: widget.createButtonAlign, children: [
              //Table Header
              createButton(),
              Container(
                padding: EdgeInsets.only(bottom: widget.thPaddingBottom),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: widget.borderColor,
                            width: widget.borderWidth))),
                child: Row(
                    crossAxisAlignment: widget.thVertAlignment,
                    mainAxisSize: MainAxisSize.min,
                    children: _tableHeaders()),
              ),
              Expanded(child: SingleChildScrollView(child: Column(children: _tableRows())))
            ]),
          ),
        ),
      );
  }
}

class RowBuilder2 extends StatefulWidget {
  ///Builds row elements for the table
  /// its properties are not nullable
  const RowBuilder2({
    Key? key,
    required this.tdAlignment,
    required this.tdStyle,
    required double trHeight,
    required Color borderColor,
    required double borderWidth,
    required this.cellData,
    required this.index,
    required this.col,
    required this.tdPaddingLeft,
    required this.tdPaddingTop,
    required this.tdPaddingBottom,
    required this.tdPaddingRight,
    required this.tdEditableMaxLines,
    required this.onSubmitted,
    required this.onChanged,
    required this.widthRatio,
    required this.isEditable,
    required this.stripeColor1,
    required this.stripeColor2,
    required this.zebraStripe,
    required this.focusedBorder,
  })   
  : 
   _trHeight = trHeight,
  _borderColor = borderColor,
  _borderWidth = borderWidth,
  super(key: key);

  /// Table row height
  final double _trHeight;
  final Color _borderColor;
  final double _borderWidth;
  final cellData;
  final double? widthRatio;
  final bool isEditable;
  final TextAlign tdAlignment;
  final TextStyle? tdStyle;
  final int index;
  final col;
  final double tdPaddingLeft;
  final double tdPaddingTop;
  final double tdPaddingBottom;
  final double tdPaddingRight;
  final int tdEditableMaxLines;
  final Color stripeColor1;
  final Color stripeColor2;
  final bool zebraStripe;
  final InputBorder? focusedBorder;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String> onChanged;  

  _RowBuilderState2 createState() => _RowBuilderState2();
}

class _RowBuilderState2 extends State<RowBuilder2> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Flexible(
      fit: FlexFit.loose,
      flex: 6,
      child: Container(
        height: widget._trHeight < 40 ? 40 : widget._trHeight,
        width: width * widget.widthRatio!,
        decoration: BoxDecoration(
            color: !widget.zebraStripe
                ? null
                : (widget.index % 2 == 1.0
                    ? widget.stripeColor2
                    : widget.stripeColor1),
            border: Border.all(
                color: widget._borderColor, width: widget._borderWidth)),
        child: widget.isEditable
            ? TextFormField(
                textAlign: widget.tdAlignment,
                style: widget.tdStyle,
                initialValue: widget.cellData.toString(),
                onFieldSubmitted: widget.onSubmitted,
                onChanged: widget.onChanged,
                textAlignVertical: TextAlignVertical.center,
                maxLines: widget.tdEditableMaxLines,
                keyboardType: TextInputType.datetime,
                //inputFormatters: [],
                decoration: InputDecoration(
                  filled: widget.zebraStripe,
                  fillColor: widget.index % 2 == 1.0
                      ? widget.stripeColor2
                      : widget.stripeColor1,
                  contentPadding: EdgeInsets.only(
                      left: widget.tdPaddingLeft,
                      right: widget.tdPaddingRight,
                      top: widget.tdPaddingTop,
                      bottom: widget.tdPaddingBottom),
                  border: InputBorder.none,
                  focusedBorder: widget.focusedBorder,
                ),
              )
            : Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  left: widget.tdPaddingLeft,
                  right: widget.tdPaddingRight,
                  // top: widget.tdPaddingTop,
                  // bottom: widget.tdPaddingBottom,
                ),
                decoration: BoxDecoration(
                  color: !widget.zebraStripe
                      ? null
                      : (widget.index % 2 == 1.0
                          ? widget.stripeColor2
                          : widget.stripeColor1),
                ),
                child: Text(
                  widget.cellData.toString(),
                  textAlign: widget.tdAlignment,
                  style: widget.tdStyle ??
                      TextStyle(
                          // fontSize: Theme.of(context).textTheme.bodyText1.fontSize), // returns 14?
                          fontSize: 16),
                ),
              ),
      ),
    );
  }
}

