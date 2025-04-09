import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth;

  AuthenticationProvider(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request credential from Apple
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      print("Apple Authorization Code: ${appleCredential.authorizationCode}");

      // Create an OAuthCredential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in with Firebase
      final authResult =
          await _firebaseAuth.signInWithCredential(oauthCredential);
      final firebaseUser = authResult.user;

      // Extract user info
      final displayName =
          '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
              .trim();
      final userEmail = appleCredential.email ?? firebaseUser?.email;

      // Update Firebase profile only if new data is available
      if (displayName.isNotEmpty) {
        await firebaseUser?.updateDisplayName(displayName);
      }

      if (userEmail != null && firebaseUser?.email == null) {
        await firebaseUser?.updateEmail(userEmail);
      }

      print("User Name: $displayName");
      print("User Email: $userEmail ${firebaseUser?.email}");
      print(isAppleRelayEmail(userEmail));

      return firebaseUser;
    } catch (exception) {
      print("Apple Sign-In Error: $exception");
      return null;
    }
  }

  bool isAppleRelayEmail(email) {
    return email.endsWith("@privaterelay.appleid.com");
  }
}
