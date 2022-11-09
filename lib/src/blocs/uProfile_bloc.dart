import 'dart:io';

import 'package:demo_project/src/models/uProfile_model.dart';
import 'package:demo_project/src/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class UprofileBloc {
  final _uProfileBlocController = PublishSubject<UprofileModel>();

  Stream<UprofileModel> get uProfileStream => _uProfileBlocController.stream;

  Future<UprofileModel> uProfileSink(
      String email,
      String username,
      String userID,
      String mobile,
      String address,
      String city,
      String country,
      File? image) async {
    return await Repository().uProfile(
        email, username, userID, mobile, address, city, country, image);
  }

  dispose() {
    _uProfileBlocController.close();
  }
}

final uProfileBloc = UprofileBloc();

// import 'package:demo_project/src/models/uProfile_model.dart';
// import 'package:demo_project/src/repository/repository.dart';
// import 'package:file/file.dart';
// import 'package:rxdart/rxdart.dart';

// class UprofileBloc {
//   final _uprofileBlocController = PublishSubject<UprofileModel>();

//   Stream<UprofileModel> get uprofileStream => _uprofileBlocController.stream;

//   Future<UprofileModel> uProfileSink(
//     String email,
//     String username,
//     String userID,
//     String mobile,
//     String address,
//     String city,
//     String country,
//     File image,
//   ) async {
//     return await Repository().uProfile(email, username, userID,mobile,address,city,country,image);
//   }

//   dispose() {
//     _uprofileBlocController.close();
//   }
// }

// final uProfileBloc = UprofileBloc();
