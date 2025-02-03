class AppConstants {
  static const String appName = 'Password Generator';
  static const String selectOptionsBelow = 'Select options below';
  static const String copiedToClipboard = 'Password copied to clipboard';
  static const String generateNewPassword = 'Generate New Password';
  static const String copyToClipboard = 'Copy Password';
  static const String ok = 'OK';

  // Password character sets
  static const String uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String numbers = '0123456789';
  static const String special = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  // Password strength
  static const String weak = 'Weak';
  static const String medium = 'Medium';
  static const String strong = 'Strong';

  // Password length
  static const double minLength = 6;
  static const double maxLength = 32;
  static const double defaultLength = 12;

  // Animation duration
  static const int animationDuration = 300;
}
