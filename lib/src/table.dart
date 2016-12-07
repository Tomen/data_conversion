part of data_conversion;




class TableBuilder {
  Table table = new Table();
  List<String> currentRow;

  static _newRow(){
    return <String>[];
  }

  List<String> addRow([List<String> row]){
    if(row == null){
      row = _newRow();
    }

    table.contents.add(row);
    currentRow = row;

    return row;
  }

  addCell([String content]){
    if(currentRow == null){
      currentRow = addRow();
    }

    currentRow.add(content);
  }
}

class Table {
  List<String> header;
  List<List<String>> contents = <List<String>>[];
}