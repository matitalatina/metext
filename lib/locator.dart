import 'package:get_it/get_it.dart';
import 'package:metext/service/ad_mob.dart';

GetIt getIt = GetIt.instance;


initializeServiceLocator() {
  getIt.registerLazySingleton<AdService>(() => AdService()..initialize());
}