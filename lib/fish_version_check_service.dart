import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';


class AppInfoService {
  static String _appName = 'xoirn';
  static String _version = '1.0.1';
  static String _versionCode = '1';
  static String _packageName = 'one.firststeptechnologyservice.shop';

  static Future<void> initialize() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _appName = packageInfo.appName;
      _version = packageInfo.version;
      _versionCode = packageInfo.buildNumber;
      _packageName = packageInfo.packageName;
    } catch (e) {
      print('Failed to get app info: $e');
    }
  }

  static String get appName => _appName;
  static String get version => _version;
  static String get versionCode => _versionCode;
  static String get packageName => _packageName;

  static String get ostype {
    if (Platform.isAndroid) {
      return '0';
    } else if (Platform.isIOS) {
      return '1';
    } else {
      return '0';
    }
  }
}


class VersionCheckService {
  static const String _apiUrl = 'http://47.120.15.111:8044/api/checkappversion';

  static Future<Map<String, dynamic>> checkVersion() async {
    try {
      // Initialize app info
      await AppInfoService.initialize();

      final params = {
        'appname': AppInfoService.appName,
        'boxname': AppInfoService.packageName,
        'ostype': AppInfoService.ostype,
        'version': AppInfoService.version,
        'versionCode': AppInfoService.versionCode,
      };

      print('=== VERSION CHECK START ===');
      print('API URL: $_apiUrl');
      print('Request params: $params');

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('=== VERSION CHECK END ===');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
      
        // final updateurl = data['data']['updateurl'];
        // return data['success'] == true;
           return {
      'success': data['success'] == true,
      'updateurl': data['data']['updateurl'] ?? '',
     };
       }

      return {
      'success': false,
      'updateurl': '',
     };
    } catch (e) {
      print('Version check failed: $e');
      return {
      'success': false,
      'updateurl': '',
     };
    }
   
  }
}
