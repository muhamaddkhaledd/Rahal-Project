import 'package:sqflite/sqflite.dart';
Database? database;
List<Map> datas =[];
void createdatabase()async
{
  database = await openDatabase(
    'database.db',
    version: 1,
    onCreate: (db, version) {
      db.execute('CREATE TABLE data (id INTEGER PRIMARY KEY,name TEXT)')
          .then((value) {
        print('Table created');
      });
    },
    onOpen: (db) {
      getdatafromdatabase(database).then((value)
      {
        datas=value;
        print(value);
      });
      print('database opened');
    },
  );
}
Future insertdatabase(String name) async
{
  return await database!.transaction((txn) async
  {
    await txn.rawInsert('INSERT INTO data(name) VALUES($name)').then((value) {print('data added');});
    return null;
  });
}
Future<List<Map>> getdatafromdatabase(database)async
{
  return await database!.rawQuery('SELECT * FROM data');

}

