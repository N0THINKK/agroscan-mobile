import 'package:shared_preferences/shared_preferences.dart';
import '../../features/scan/data/datasources/local_datasource.dart';
import '../../features/scan/data/datasources/ml_datasource.dart';
import '../../features/scan/data/repositories/scan_repository_impl.dart';
import '../../features/scan/domain/repositories/scan_repository.dart';
import '../../features/scan/domain/usecases/detect_plant_disease.dart';
import '../../features/scan/domain/usecases/get_scan_history.dart';
import '../../features/scan/domain/usecases/save_scan_result.dart';
import '../../features/scan/presentation/bloc/scan_bloc.dart';

class DI {
  static SharedPreferences? _prefs;
  static MLDataSource? _mlDataSource;
  static LocalDataSource? _localDataSource;
  static ScanRepository? _scanRepository;
  static ScanBloc? _scanBloc;

  static SharedPreferences get prefs => _prefs!;
  static MLDataSource get mlDataSource => _mlDataSource!;
  static LocalDataSource get localDataSource => _localDataSource!;
  static ScanRepository get scanRepository => _scanRepository!;
  static ScanBloc get scanBloc => _scanBloc!;
}

Future<void> setupDependencies() async {
  DI._prefs = await SharedPreferences.getInstance();
  DI._mlDataSource = MLDataSourceImpl();
  DI._localDataSource = LocalDataSourceImpl(DI.prefs);
  DI._scanRepository = ScanRepositoryImpl(
    mlDataSource: DI.mlDataSource,
    localDataSource: DI.localDataSource,
  );

  await DI.mlDataSource.initialize();

  DI._scanBloc = ScanBloc(
    detectPlantDisease: DetectPlantDisease(DI.scanRepository),
    getScanHistory: GetScanHistory(DI.scanRepository),
    saveScanResult: SaveScanResult(DI.scanRepository),
  );
}
