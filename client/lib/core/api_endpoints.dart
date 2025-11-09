class ApiConfig {

  static const String devBaseUrl = "http://localhost:3000/api";
  static const String stagingBaseUrl = "https://staging.yourapi.com/api";
  static const String prodBaseUrl = "https://orderup-3xkw.onrender.com/api";
  static const String socketUrl = "https://orderup-3xkw.onrender.com";

  static const String baseUrl = prodBaseUrl; 
}

class ApiEndpoints {

  // 🔐 AUTH ENDPOINTS
  static const String login = "/auth/login";
  static const String signup = "/auth/register";

  // 🍽️ MENU ENDPOINTS
  static const String menu = "/items";
  static const String trending = "/items/trending";
  static const String availableItems = "/items/available";

  // For fetching menu item by ID
  static String menuById(String id) => "/menu/$id";

  // 🛒 ORDER ENDPOINTS
  static const String order = "/orders";
  static String orderById(String id) => "/orders/$id";

  static const String payment = "/payment";
  static const String createOrder = "/payment/create-order";
  static const String verifyPayment = "/payment/verify-payment";

  // ⚙️ ADMIN ENDPOINTS
  static const String adminMenu = "/admin/menu";
  static String adminMenuById(String id) => "/admin/menu/$id";

  static const String chatEndpoint = '/ml/chat';
}
