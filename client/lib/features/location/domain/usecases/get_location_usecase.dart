import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class GetLocationUseCase {
  final LocationRepository repository;

  GetLocationUseCase(this.repository);

  Future<LocationEntity> call() async {
    return await repository.getCurrentLocation();
  }
}