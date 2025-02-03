import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class PasswordOptions extends StatelessWidget {
  final double passwordLength;
  final bool useUppercase;
  final bool useLowercase;
  final bool useNumbers;
  final bool useSpecialChars;
  final ValueChanged<double> onLengthChanged;
  final ValueChanged<bool> onUppercaseChanged;
  final ValueChanged<bool> onLowercaseChanged;
  final ValueChanged<bool> onNumbersChanged;
  final ValueChanged<bool> onSpecialCharsChanged;

  const PasswordOptions({
    super.key,
    required this.passwordLength,
    required this.useUppercase,
    required this.useLowercase,
    required this.useNumbers,
    required this.useSpecialChars,
    required this.onLengthChanged,
    required this.onUppercaseChanged,
    required this.onLowercaseChanged,
    required this.onNumbersChanged,
    required this.onSpecialCharsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Password Length',
                style: theme.textTheme.titleMedium,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${passwordLength.round()}',
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: theme.colorScheme.primary,
            inactiveTrackColor: theme.colorScheme.primary.withOpacity(0.2),
            thumbColor: theme.colorScheme.primary,
            overlayColor: theme.colorScheme.primary.withOpacity(0.1),
            trackHeight: 4,
          ),
          child: Slider(
            value: passwordLength,
            min: AppConstants.minLength,
            max: AppConstants.maxLength,
            divisions: (AppConstants.maxLength - AppConstants.minLength).round(),
            label: passwordLength.round().toString(),
            onChanged: onLengthChanged,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Character Types',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: (MediaQuery.of(context).size.width - 60) / 2,
              child: _buildOptionCard(
                context: context,
                icon: Icons.text_fields,
                label: 'Uppercase',
                sublabel: 'A-Z',
                selected: useUppercase,
                onChanged: onUppercaseChanged,
              ),
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width - 60) / 2,
              child: _buildOptionCard(
                context: context,
                icon: Icons.text_fields_outlined,
                label: 'Lowercase',
                sublabel: 'a-z',
                selected: useLowercase,
                onChanged: onLowercaseChanged,
              ),
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width - 60) / 2,
              child: _buildOptionCard(
                context: context,
                icon: Icons.numbers,
                label: 'Numbers',
                sublabel: '0-9',
                selected: useNumbers,
                onChanged: onNumbersChanged,
              ),
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width - 60) / 2,
              child: _buildOptionCard(
                context: context,
                icon: Icons.tag,
                label: 'Special',
                sublabel: '#@!',
                selected: useSpecialChars,
                onChanged: onSpecialCharsChanged,
              ),
            ),

          ],
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String sublabel,
    required bool selected,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!selected),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primary.withOpacity(0.1)
                : theme.cardTheme.color,
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.1),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.7),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: selected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      sublabel,
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: selected
                            ? theme.colorScheme.primary.withOpacity(0.8)
                            : theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
