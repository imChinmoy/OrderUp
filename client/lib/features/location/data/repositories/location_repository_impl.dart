import 'package:client/features/location/data/datasources/location_datasource.dart';

import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';


class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<LocationEntity> getCurrentLocation() async {
    final locationData = await dataSource.getCurrentCityAndCountry();
    return LocationEntity(
      city: locationData['city'] ?? 'Unknown',
      country: locationData['country'] ?? '',
    );
  }
}