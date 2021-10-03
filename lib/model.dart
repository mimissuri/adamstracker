import 'dart:developer';

import 'package:adamstracker/start.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:adamstracker/home.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mysql1/mysql1.dart';
// Globals
import 'globals.dart' as gl;

class WModel extends Model {
  var database;
  var conn;
  // ANCHOR Initializer
  void init() async {
    log("Initializing model");

    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..userInteractions = false
      ..dismissOnTap = false;
    sessionmanager();
  }

// ANCHOR DB MANAGER
  void dbmanager() async {
    bool newdb = false;
    var settings = new ConnectionSettings(
      host: 'remotemysql.com',
      port: 3306,
      user: 'wZyIb4RyoP',
      password: 'ThNJXqwqDn',
      db: 'wZyIb4RyoP',
    );
    conn = await MySqlConnection.connect(settings);
    database = await openDatabase(
      join(await getDatabasesPath(), 'logs.db'),
      onCreate: (db, version) async {
        log("CREATING DB");
        db.execute(
          "CREATE TABLE `logs` (`id` INTEGER PRIMARY KEY, `exercise` INTEGER  , `w1` INTEGER  , `r1` INTEGER  , `w2` INTEGER  , `r2` INTEGER  , `w3` INTEGER  , `r3` INTEGER  , `datetime` TINYTEXT)",
        );
        newdb = true;
      },
      version: 1,
    );
    if (newdb) {
      try {
        var results = await conn.query(
            'select * from logs where g_id = ? ORDER BY id ASC', [user?.id]);
        for (var row in results) {
          await database.transaction((txn) async {
            await txn.rawInsert(
              'INSERT INTO logs(exercise, w1, r1, w2, r2, w3, r3, datetime) VALUES(?,?,?,?,?,?,?,?)',
              [
                row.fields["exercise"],
                row.fields["w1"],
                row.fields["r1"],
                row.fields["w2"],
                row.fields["r2"],
                row.fields["w3"],
                row.fields["r3"],
                row.fields["datetime"].toString(),
              ],
            );
          });
        }
      } catch (err) {
        EasyLoading.showError("Error en model newdb: " + err.toString());
      }
    }
    newdb = false;
  }

  void deleteDB() async {
    await deleteDatabase(join(await getDatabasesPath(), 'logs.db'));
  }

  // ANCHOR User and Login
  var logInListener;
  GoogleSignInAccount? user;
  GoogleSignIn googleSignIn = GoogleSignIn();
  void sessionmanager() async {
    logInListener = googleSignIn.onCurrentUserChanged.listen(
      (GoogleSignInAccount? account) async {
        log("LoginListener");
        user = account;
        if (user == null) {
          Get.off(() => Start());
        } else {
          dbmanager();
          Get.off(() => Home());
        }
      },
    );
    googleSignIn.signInSilently();
    if (!await googleSignIn.isSignedIn()) {
      Get.off(() => Start());
    }
  }
}
