import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService {
  final String key = 'AIzaSyBbVXSEwwPKi-XOvtqSwaPtYTWNe9qZPfU';

  // currently not being used, this function is just for reference
  Future<Map<String, dynamic>> getPlaceID(String input) async {
    const String url =
        'https://maps.googleapis.com/maps/api/place/details/output?parameters'; // example url

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;
    return results;
  }

  Future<Map> getSearchResults(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${input}&key=${key}';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var results = {
      'length': json['predictions'].length,
      'results': json['predictions']
    };

    return results;
  }

  Future<String>? getDistanceInMiles(var directions) async {
    if (directions['distanceInMiles'] == "") {
      return "0 mi";
    }
    return directions['distanceInMiles'];
  }

  Future<String>? getDurationToReachDestination(var directions) async {
    if (directions['durationToReachDestination'] == "") {
      return "0 mi";
    }
    return directions['durationToReachDestination'];
  }
}
