import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                languageProvider.translate('settings'),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    _buildSettingsCard(
                      context,
                      languageProvider.translate('app'),
                      [
                        ListTile(
                          title: Text(languageProvider.translate('theme_mode')),
                          subtitle: Consumer<ThemeProvider>(
                            builder: (context, themeProvider, child) {
                              return Text(themeProvider
                                  .getThemeModeName(themeProvider.themeMode));
                            },
                          ),
                          trailing: Icon(
                            Icons.brightness_6,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                          onTap: () => _showThemePicker(context),
                        ),
                        ListTile(
                          title: Text(languageProvider.translate('language')),
                          subtitle: Text(languageProvider.getLanguageName(
                              languageProvider.currentLanguage)),
                          trailing: Icon(
                            Icons.language,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                          onTap: () => _showLanguagePicker(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSettingsCard(
                      context,
                      languageProvider.translate('support'),
                      [
                        ListTile(
                          title: Text(languageProvider.translate('contact_us')),
                          subtitle: Text(
                              languageProvider.translate('contact_subtitle')),
                          trailing: Icon(
                            Icons.mail_outline,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(languageProvider
                                      .translate('coming_soon'))),
                            );
                          },
                        ),
                        ListTile(
                          title: Text(languageProvider.translate('about_app')),
                          subtitle: Text(
                              '${languageProvider.translate('version')} 1.0.0'),
                          trailing: Icon(
                            Icons.info_outline,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(languageProvider
                                      .translate('coming_soon'))),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSettingsCard(
                      context,
                      languageProvider.translate('legal'),
                      [
                        ListTile(
                          title:
                              Text(languageProvider.translate('terms_of_use')),
                          trailing: Icon(
                            Icons.description_outlined,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(languageProvider
                                      .translate('coming_soon'))),
                            );
                          },
                        ),
                        ListTile(
                          title: Text(
                              languageProvider.translate('privacy_policy')),
                          trailing: Icon(
                            Icons.privacy_tip_outlined,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(languageProvider
                                      .translate('coming_soon'))),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingsCard(
      BuildContext context, String title, List<Widget> children) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black12 : Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getIconForTitle(title),
                  size: 20,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children.map((child) {
            if (child is ListTile) {
              return ListTile(
                leading: child.leading,
                title: DefaultTextStyle(
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: child.title is Text
                        ? (child.title as Text).style?.fontSize ?? 16
                        : 16,
                  ),
                  child: child.title ?? const SizedBox(),
                ),
                subtitle: child.subtitle != null
                    ? DefaultTextStyle(
                        style: TextStyle(
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontSize: child.subtitle is Text
                              ? (child.subtitle as Text).style?.fontSize ?? 14
                              : 14,
                        ),
                        child: child.subtitle!,
                      )
                    : null,
                trailing: IconTheme(
                  data: IconThemeData(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    size: 24,
                  ),
                  child: child.trailing ?? const SizedBox(),
                ),
                onTap: child.onTap,
              );
            }
            return child;
          }).toList(),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Uygulama':
        return Icons.settings;
      case 'Destek':
        return Icons.help_outline;
      case 'Yasal':
        return Icons.gavel;
      default:
        return Icons.folder_outlined;
    }
  }

  void _showThemePicker(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer2<ThemeProvider, LanguageProvider>(
          builder: (context, themeProvider, languageProvider, child) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    languageProvider.translate('select_theme'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...ThemeMode.values.map((mode) {
                    final isSelected = mode == themeProvider.themeMode;
                    return RadioListTile<ThemeMode>(
                      title: Text(
                        themeProvider.getThemeModeName(mode),
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      value: mode,
                      groupValue: themeProvider.themeMode,
                      activeColor: Theme.of(context).primaryColor,
                      selected: isSelected,
                      onChanged: (value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                          Navigator.pop(context);
                        }
                      },
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            final languages = ['tr', 'en'];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    languageProvider.translate('select_language'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...languages.map((language) {
                    final isSelected =
                        language == languageProvider.currentLanguage;
                    return RadioListTile<String>(
                      title: Text(
                        languageProvider.getLanguageName(language),
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      value: language,
                      groupValue: languageProvider.currentLanguage,
                      activeColor: Theme.of(context).primaryColor,
                      selected: isSelected,
                      onChanged: (value) {
                        if (value != null) {
                          languageProvider.setLanguage(value);
                          Navigator.pop(context);
                        }
                      },
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
