import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class AppRemoteDataSource {
  Future<Either> versionCheck();
}

class AppRemoteDataSourceImpl extends AppRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  AppRemoteDataSourceImpl(this.firebaseFirestore);

  @override
  Future<Either> versionCheck() async {
    try {
      DocumentSnapshot snapshot =
          await firebaseFirestore.collection('appInfo').doc('appVersion').get();

      if (snapshot.exists) {
        String version = snapshot['version'];
        return Right(version);
      } else {
        return const Left('No such document found.');
      }
    } catch (e) {
      return const Left('An unknown error has occurred.');
    }
  }
}
