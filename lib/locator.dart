import 'package:get_it/get_it.dart';
import 'package:metext/service/ad_mob.dart';
import 'package:firebase_core/firebase_core.dart';

GetIt getIt = GetIt.instance;

initializeServiceLocator() async {
  getIt.registerLazySingleton<AdService>(() => AdService()..initialize());
  await Firebase.initializeApp();
}