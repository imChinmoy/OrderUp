import '../entities/menu_item_entity.dart';
import '../repository/menu_repo.dart';

class GetAvailableItemsUseCase {
  final MenuRepository repository;

  GetAvailableItemsUseCase(this.repository);

  Future<List<MenuItemEntity>> call() async {
    return await repository.getAvailableMenuItems();
  }
}