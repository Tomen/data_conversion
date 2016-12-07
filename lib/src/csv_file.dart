part of data_conversion;

class CsvFile {

  static saveTable(Table table, String filename, {String separator: ","}){
    String csv = "";
    if(table.header != null){
      csv += _detokenize(table.header, separator) + "\r\n";
    }

    for(List<String> line in table.contents){
      csv += _detokenize(line, separator) + "\r\n";
    }

    File contactsFile = new File(filename);
    contactsFile.writeAsStringSync(csv);
  }

  static String _detokenize(List<String> cells, String separator){
    String result = "";
    for(String cell in cells){
      result += _escape(cell, separator) + separator;
    }
    return result;
  }

  static String _escape(String escapable, String separator){

    escapable = escapable == null ? "" : escapable;
    //escaping for shy people -> just avoid it
    escapable = escapable.replaceAll("\n", " ");
    escapable = escapable.replaceAll("\r", " ");

    escapable = escapable.replaceAll('"', '""');

    if(escapable.contains(separator)){
      escapable = '"$escapable"';
    }

    return escapable;
  }

  static Table loadTable(String filename, bool firstRowIsHeader, {int rowOffset: 0, String separator: ","}){
    File contactsFile = new File(filename);
    var csv = contactsFile.readAsStringSync();

    TableBuilder builder = new TableBuilder();

    List lines = LineSplitter.split(csv).toList();

    if(firstRowIsHeader){
      List<String> cells = _tokenize(lines[rowOffset], separator);
      builder.table.header = cells;
      rowOffset++;
    }

    for(int i = rowOffset; i < lines.length; i++){
      String line = lines[i];
      List<String> cells = _tokenize(line, separator);
      builder.addRow(cells);
    }

    return builder.table;
  }

  static _tokenize(String line, String separator){

    List result = [];
    String currentToken = "";
    bool escaping = false;
    bool lastCharWasDoubleQuote = false;

    for(int i = 0; i < line.length; i++){
      String currentChar = line[i];

      // check for possible escape character
      if(currentChar == '"'){
        if(lastCharWasDoubleQuote){
          currentToken += '"';
          lastCharWasDoubleQuote = false;
        }
        else{
          lastCharWasDoubleQuote = true;
        }

        escaping = !escaping; //if we get 2 double quotes, this will cancel itself out. else it will correctly toggle escape :)
      }
      // no escape character
      else {
        lastCharWasDoubleQuote = false;

        if(currentChar == separator){
          if(escaping){
            currentToken += separator;
          }
          else {
            result.add(currentToken);
            currentToken = "";
          }
        }
        else {
          currentToken += currentChar;
        }
      }
    }

    result.add(currentToken);


    return result;
  }
}
