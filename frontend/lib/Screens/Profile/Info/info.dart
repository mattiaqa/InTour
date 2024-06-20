import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/appbar.dart';
import 'package:frontend/Screens/Common/bottomMenu.dart';
import 'package:frontend/Screens/Profile/Info/countdownDialog.dart';
import 'package:frontend/utils/auth_service.dart';
import 'package:go_router/go_router.dart';

class UserInfoPage extends StatelessWidget {
  final String username;
  final String registrationDate;

  UserInfoPage({
    required this.username,
    required this.registrationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageTitle(title: 'Informazioni'),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            'Versione 1.1.0', // Stringa della versione dell'app
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 39, 85, 4),
            ),
          ),
          _buildInfoItem('Username', username),
          _buildInfoItem('Utente dal', _formatDate(registrationDate)),
          _buildPrivacyPolicyItem(context),
          _buildDeleteAccountButton(context),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(value),
    );
  }

  Widget _buildPrivacyPolicyItem(BuildContext context) {
    return ListTile(
      title: Text(
        'Privacy Policy',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Icon(Icons.arrow_forward),
      onTap: () => context.push('/privacy_policy')
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return ListTile(
      title: Text(
        'Richiedi la cancellazione del tuo account',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      onTap: () {
        ShowBottomMenu(context, 'Eliminazione account', 
          [
            BottomMenuButton(
              icon: Icons.check, 
              text: "Sono sicuro", 
              action: () {
                Future.delayed(Durations.short2).then((value) => 
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CountdownDialog();
                    },
                  )
                );
              }
            ),

            BottomMenuButton(
              icon: Icons.arrow_back_rounded, 
              text: "Annulla", 
              action: (){}
            ),
          ]
        );
      },
    );
  }

  String _formatDate(String date) {
    // Dividi la stringa della data usando il separatore "-"
    List<String> parts = date.split('-');

    // Assegna le parti dell'anno, del mese e del giorno
    String year = parts[0];
    String month = parts[1];
    String day = parts[2];

    // Ritorna la data nel nuovo formato "DD/MM/AAAA"
    return '$day/$month/$year';
  }
}
