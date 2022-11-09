import 'package:demo_project/src/models/Store_By_ID.dart';
import 'package:demo_project/src/repository/repository.dart';
import 'package:rxdart/rxdart.dart';


class Store_By_Id_Block{
  final _Store_By_Id_BlockController = PublishSubject<Store_By_ID>();


  Stream <Store_By_ID> get Store_By_ID_Stream => _Store_By_Id_BlockController.stream;

  Future Store_By_IdSink(String id) async {
  Store_By_ID store_details_by_id = await Repository().Store_By_IDApiRepository(id);
    _Store_By_Id_BlockController.sink.add(store_details_by_id);
  }

  dispose() {
    _Store_By_Id_BlockController.close();
  }
}

final homeBloc = Store_By_Id_Block();
