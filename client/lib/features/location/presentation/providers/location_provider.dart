import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/location_datasource.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/usecases/get_location_usecase.dart';

// DataSource Provider
final locationDataSourceProvider = Provider<LocationDataSource>((ref) {
  return LocationDataSourceImpl();
});

// Repository Provider
final locationRepositoryProvider = Provider((ref) {
  return LocationRepositoryImpl(ref.read(locationDataSourceProvider));
});

// UseCase Provider
final getLocationUseCaseProvider = Provider((ref) {
  return GetLocationUseCase(ref.read(locationRepositoryProvider));
});

// Location State Provider
final locationProvider = FutureProvider<LocationEntity>((ref) async {
  final useCase = ref.read(getLocationUseCaseProvider);
  return await useCase();
});