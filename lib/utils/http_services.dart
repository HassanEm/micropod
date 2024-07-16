import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  // Fetch the IP address
  Future<String?> getIpAddress() async {
    final response =
        await http.get(Uri.parse('https://api.ipify.org?format=json'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['ip'];
    } else {
      print("Can't get your IP address");
      return null;
    }
  }

  // Fetch geolocation information based on IP address
  Future<Map<String, dynamic>?> getGeolocation() async {
    final ipAddress = await getIpAddress();
    print("ipAddress==>$ipAddress");
    if (ipAddress != null) {
      final response = await http
          .get(Uri.parse('https://ipinfo.io/$ipAddress?token=32abe0650dda87'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      }
    }
    print("Can't get your location");
    return null;
  }
}
