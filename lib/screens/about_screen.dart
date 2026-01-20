import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'About Developer',
          style: GoogleFonts.outfit(color: theme.textTheme.bodyMedium?.color),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor.withOpacity(0.5),
                          theme.primaryColor,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: theme.scaffoldBackgroundColor,
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: theme.iconTheme.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Developed by Maulana Hidayat',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            Text(
              'UAS Pemrograman Mobile',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    Icons.badge_outlined,
                    'NPM',
                    '2410020091',
                  ),
                  _buildDivider(theme),
                  _buildInfoRow(
                    context,
                    Icons.class_outlined,
                    'Kelas',
                    'SI 5A Nonreg Banjarbaru',
                  ),
                  _buildDivider(theme),
                  _buildInfoRow(
                    context,
                    Icons.contact_mail_outlined,
                    'Kontak',
                    '+62898 400 3000',
                  ),
                  _buildDivider(theme),
                  _buildInfoRow(
                    context,
                    Icons.location_on_outlined,
                    'Alamat',
                    'Martapura Kab. Banjar Kalsel',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              '© 2026 Al Quran Elektronik',
              style: GoogleFonts.inter(
                color: theme.textTheme.bodySmall?.color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: theme.textTheme.bodySmall?.color,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.outfit(
                  color: theme.textTheme.bodyMedium?.color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(color: theme.dividerColor.withOpacity(0.1), height: 1);
  }
}
