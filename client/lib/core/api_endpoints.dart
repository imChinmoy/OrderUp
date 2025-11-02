class ApiConfig {

  static const String devBaseUrl = "https://localhost:3000/api";
  static const String stagingBaseUrl = "https://staging.yourapi.com/api";
  static const String prodBaseUrl = "https://productionUrl.com/api";

  static const String baseUrl = devBaseUrl; 
}

class ApiEndpoints {

  // 🔐 AUTH ENDPOINTS
  static const String login = "/auth/login";
  static const String signup = "/auth/signup";

  // 🍽️ MENU ENDPOINTS
  static const String menu = "/menu";
  static const String trending = "/menu/trending";

  // For fetching menu item by ID
  static String menuById(String id) => "/menu/$id";

  // 🛒 ORDER ENDPOINTS
  static const String order = "/order";
  static String orderById(String id) => "/order/$id";

  // ⚙️ ADMIN ENDPOINTS
  static const String adminMenu = "/admin/menu";
  static String adminMenuById(String id) => "/admin/menu/$id";
}
