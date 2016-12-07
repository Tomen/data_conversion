part of data_conversion;

class JsonFile {

  static saveObject(object, String filename){
    var json = JSON.encode(object);
    File contactsFile = new File(filename);
    contactsFile.writeAsStringSync(json);
  }

  static Map loadObject(String filename){
    File contactsFile = new File(filename);
    var json = contactsFile.readAsStringSync();
    return JSON.decode(json);
  }
}
