import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Privacy Policy',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last updated: February 3, 2025',
            style: TextStyle(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Welcome to Password Generator. This Privacy Policy explains how we handle your information when you use our password generation and management application.',
          ),
          _buildSection(
            '1. Information Collection',
            'Password Generator is designed with your privacy in mind. We:',
            [
              'Do not collect any personal information',
              'Do not track your usage',
              'Store all passwords locally on your device only',
              'Never transmit your passwords over the internet',
            ],
          ),
          _buildSection(
            '2. Local Storage',
            'All passwords you choose to save are:',
            [
              'Stored exclusively on your device using SQLite database',
              'Never synchronized with any cloud services',
              'Accessible only through the app on your device',
            ],
          ),
          _buildSection(
            '3. Password Generation',
            'Our password generation process:',
            [
              'Occurs entirely on your device',
              'Uses secure random number generation',
              'Does not store generated passwords unless you explicitly save them',
            ],
          ),
          _buildSection(
            '4. Data Security',
            'To protect your saved passwords, we:',
            [
              'Use your device\'s built-in security features',
              'Never export passwords automatically',
              'Allow you to delete saved passwords at any time',
            ],
          ),
          _buildSection(
            '5. Third-Party Services',
            'Password Generator:',
            [
              'Does not integrate with any third-party services',
              'Does not include any advertising',
              'Does not use analytics services',
            ],
          ),
          _buildSection(
            '6. Children\'s Privacy',
            'Our application is suitable for all ages and does not collect any personal information from children or adults.',
            [],
          ),
          _buildSection(
            '7. Changes to This Policy',
            'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
            [],
          ),
          Container(
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '8. Contact Us',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'If you have any questions about this Privacy Policy, please contact us:',
                ),
                const SizedBox(height: 8),
                Text(
                  '• By email: support@apptreo.com',
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    text: '• By visiting our GitHub repository: ',
                    children: const [
                      TextSpan(
                        text:
                            'https://github.com/Nabeel-Shehzad/password-generator',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String description, List<String> bullets) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(description),
          if (bullets.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...bullets.map((bullet) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(child: Text(bullet)),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}
