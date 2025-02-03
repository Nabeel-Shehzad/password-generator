import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../utils/password_generator.dart';

class PasswordDisplayCard extends StatelessWidget {
  final String password;
  final Animation<double> animation;
  final double passwordLength;

  const PasswordDisplayCard({
    super.key,
    required this.password,
    required this.animation,
    required this.passwordLength,
  });

  @override
  Widget build(BuildContext context) {
    final strength = PasswordGenerator.getStrength(passwordLength);
    final strengthColor = PasswordGenerator.getStrengthColor(strength);
    final theme = Theme.of(context);

    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        width: double.infinity,
        child: Column(
          children: [
            Text(
              'Your Password',
              style: theme.textTheme.titleMedium!.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                ),
              ),
              child: ScaleTransition(
                scale: animation,
                child: Text(
                  password.isEmpty ? AppConstants.selectOptionsBelow : password,
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontFamily: 'monospace',
                    letterSpacing: 1.2,
                    color: password.isEmpty 
                        ? theme.colorScheme.onSurface.withOpacity(0.5)
                        : theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (password.isNotEmpty) ...[  
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStrengthIndicator(strengthColor),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: strengthColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: strengthColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          strength,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: strengthColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthIndicator(Color strengthColor) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: strengthColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
