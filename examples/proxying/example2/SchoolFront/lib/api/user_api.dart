import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../dataclasses/config.dart';
import '../dataclasses/user.dart';
import '../service/jwt_work.dart';
import 'api_client.dart';
import 'api_interface.dart';

class UserApi extends Api {
  final ApiClient _apiClient;

  UserApi() : _apiClient = ApiClient('${Config.baseUrl}/api/user');

  Future<User?> getUser(String email) async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return null;
    }
    try {
      final result = await _apiClient.getRequest(
        'get',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        queryParams: {'email': email},
      );

      if (result != null) {
        return User(
          email: result['email'],
          firstName: result['firstName'],
          lastName: result['lastName'],
          surname: result['surname'],
        );
      } else {
        logError('Failed to get user', result);
      }
    } catch (e) {
      print('Error occurred while fetching user: $e');
    }
    return null;
  }

  Future<bool> updateUserProfile(User user) async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return false;
    }

    try {
      final result = await _apiClient.putRequest(
        'update',
        body: {
          'firstName': user.firstName,
          'lastName': user.lastName,
          'surname': user.surname,
          'email': user.email,
          'password': user.password,
        },
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
      );

      if (result != null) {
        print('Profile updated successfully');
        return true;
      } else {
        logError('Failed to update profile', result);
        return false;
      }
    } catch (e) {
      print('Error occurred while updating profile: $e');
    }
    return false;
  }
}
