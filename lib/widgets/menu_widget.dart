import 'package:flutter/material.dart';
import 'package:pomo/app_localizations.dart';
import 'package:pomo/models/user.dart';

class MenuWidget extends StatelessWidget {
  final User? currentUser;
  final String currentLanguage;
  final bool isDarkMode;
  final bool isMenuOpen;
  final AppLocalizations localizations;
  final VoidCallback onToggleMenu;
  final Function(String, String) onLogin;
  final Function(String, String, String) onRegister;
  final VoidCallback onLogout;
  final Function(String) onChangeLanguage;
  final VoidCallback onToggleTheme;
  final Function(User) onUpdateUserProfile;

  const MenuWidget({
    super.key,
    required this.currentUser,
    required this.currentLanguage,
    required this.isDarkMode,
    required this.isMenuOpen,
    required this.localizations,
    required this.onToggleMenu,
    required this.onLogin,
    required this.onRegister,
    required this.onLogout,
    required this.onChangeLanguage,
    required this.onToggleTheme,
    required this.onUpdateUserProfile,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAccountSection(),
            const SizedBox(height: 20),
            _buildLanguageSection(),
            const SizedBox(height: 20),
            _buildThemeSection(),
            const SizedBox(height: 20),
            if (currentUser != null) ...[
              _buildProfileSettingsSection(context),
              const SizedBox(height: 20),
            ],
            _buildAuthButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currentUser != null ? localizations.account : localizations.guest,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          currentUser?.username ?? localizations.notLoggedIn,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.language,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildLanguageButton('Eng', 'en'),
            const SizedBox(width: 8),
            _buildLanguageButton('Рус', 'ru'),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageButton(String text, String languageCode) {
    final isSelected = currentLanguage == languageCode;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => onChangeLanguage(languageCode),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : null,
          foregroundColor: isSelected ? Colors.white : null,
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildThemeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.theme,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: Text(localizations.darkMode),
          value: isDarkMode,
          onChanged: (value) => onToggleTheme(),
        ),
      ],
    );
  }

  Widget _buildProfileSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.profileSettings,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(localizations.editProfile),
          onTap: () {
            _showProfileSettings(context);
          },
        ),
      ],
    );
  }

  Widget _buildAuthButtons(BuildContext context) {
    if (currentUser != null) {
      return ElevatedButton(
        onPressed: onLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
        ),
        child: Text(localizations.logout),
      );
    } else {
      return Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _showLoginDialog(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text(localizations.login),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              _showRegisterDialog(context);
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text(localizations.register),
          ),
        ],
      );
    }
  }

  void _showLoginDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.login),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: localizations.email),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: localizations.password),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              onLogin(emailController.text, passwordController.text);
              Navigator.pop(context);
            },
            child: Text(localizations.login),
          ),
        ],
      ),
    );
  }

  void _showRegisterDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.register),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: localizations.email),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: localizations.username),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: localizations.password),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              onRegister(
                emailController.text,
                passwordController.text,
                usernameController.text,
              );
              Navigator.pop(context);
            },
            child: Text(localizations.register),
          ),
        ],
      ),
    );
  }

  void _showProfileSettings(BuildContext context) {
    final usernameController = TextEditingController(text: currentUser?.username);
    final birthDateController = TextEditingController(
      text: currentUser?.birthDate?.toString().split(' ').first ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.editProfile),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: localizations.username),
            ),
            TextField(
              controller: birthDateController,
              decoration: InputDecoration(labelText: localizations.birthDate),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              DateTime? birthDate;
              try {
                birthDate = DateTime.parse(birthDateController.text);
              } catch (e) {
                // Оставляем null если дата невалидная
              }
              
              onUpdateUserProfile(
                currentUser!.copyWith(
                  username: usernameController.text,
                  birthDate: birthDate,
                  isDarkMode: isDarkMode,
                ),
              );
              Navigator.pop(context);
            },
            child: Text(localizations.save),
          ),
        ],
      ),
    );
  }
}