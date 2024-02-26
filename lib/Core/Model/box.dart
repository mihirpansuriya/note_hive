import 'package:hive/hive.dart';

import 'note_model.dart';

class Boxes{
  static Box<NotesModel> getdata() => Hive.box<NotesModel>("notes");
}