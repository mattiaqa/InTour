import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/appbar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageTitle(title:'Privacy Policy'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informativa sulla Privacy',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Data di entrata in vigore: 20/06/2024',
              style: TextStyle(
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              '1. Introduzione',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Benvenuto su InTour ("Azienda", "noi", "nostro"). Siamo impegnati a proteggere le tue informazioni personali e il tuo diritto alla privacy. Se hai domande o preoccupazioni riguardanti questa informativa sulla privacy o le nostre pratiche relative alle tue informazioni personali, contattaci all\'indirizzo contact@intour.com .',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20.0),
            Text(
              'Quando visiti il nostro sito web intour.com ("Sito") e utilizzi i nostri servizi, ci affidi le tue informazioni personali. Prendiamo molto seriamente la tua privacy. In questa informativa sulla privacy, descriviamo le nostre pratiche sulla privacy. Cerchiamo di spiegarti nel modo più chiaro possibile quali informazioni raccogliamo, come le usiamo e quali diritti hai in relazione ad esse. Speriamo che tu prenda un po\' di tempo per leggerla attentamente, poiché è importante.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20.0),
            Text(
              '2. Informazioni che Raccogliamo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Raccogliamo informazioni personali che ci fornisci volontariamente quando ti registri sul Sito, esprimi interesse nell\'ottenere informazioni su di noi o sui nostri prodotti e servizi, quando partecipi ad attività sul Sito, o altrimenti quando ci contatti.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20.0),
            Text(
              'Le informazioni personali che raccogliamo dipendono dal contesto in cui interagisci con noi e dal Sito, dalle scelte che fai e dai prodotti e funzioni che utilizzi. Le informazioni personali che raccogliamo possono includere quanto segue:',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- Dati personali: nome, cognome, indirizzo email, numero di telefono e altre informazioni di contatto simili.'),
                  Text('- Dati di accesso: informazioni di accesso come nome utente e password, suggerimenti e informazioni di sicurezza simili utilizzate per l\'autenticazione e l\'accesso all\'account.'),
                  Text('- Dati di utilizzo: informazioni su come utilizzi il nostro Sito, prodotti e servizi.'),
                  Text('- Dati di comunicazione: informazioni che fornisci quando ci contatti per assistenza, feedback o altre comunicazioni.'),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              '3. Come Utilizziamo le Tue Informazioni',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Utilizziamo le informazioni personali raccolte tramite il nostro Sito per una serie di scopi aziendali descritti di seguito. Trattiamo le tue informazioni personali per questi scopi in base ai nostri legittimi interessi aziendali, per stipulare o eseguire un contratto con te, con il tuo consenso e/o per ottemperare ai nostri obblighi legali. Gli scopi per i quali utilizziamo le informazioni includono:',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- Fornire, gestire e mantenere il nostro Sito.'),
                  Text('- Migliorare, personalizzare e ampliare il nostro Sito.'),
                  Text('- Comprendere e analizzare come utilizzi il nostro Sito, prodotti e servizi.'),
                  Text('- Sviluppare nuovi prodotti, servizi, caratteristiche e funzionalità.'),
                  Text('- Elaborare le tue transazioni e gestire i pagamenti.'),
                  Text('- Comunicare con te, direttamente o tramite uno dei nostri partner, anche per il servizio clienti, per fornirti aggiornamenti e altre informazioni relative al Sito, e per scopi di marketing e promozionali.'),
                  Text('- Prevenire attività fraudolente e migliorare la sicurezza del nostro Sito.'),
                  Text('- Rispondere a richieste legali e prevenire danni.'),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              '4. Condivisione delle Tue Informazioni',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Potremmo condividere le tue informazioni personali con terze parti nei seguenti casi:',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- Fornitori di servizi: con fornitori di servizi di terze parti che ci forniscono servizi di supporto operativo.'),
                  Text('- Trasferimenti aziendali: in relazione o durante negoziazioni di fusioni, vendita di attività aziendali, finanziamenti o acquisizione della totalità o di una parte della nostra attività da parte di un\'altra azienda.'),
                  Text('- Requisiti legali: se richiesto dalla legge, per ottemperare a un procedimento giudiziario, a un\'ordinanza del tribunale o ad altri processi legali, come in risposta a un\'ordinanza di tribunale o a una citazione (anche in risposta a autorità pubbliche per soddisfare requisiti di sicurezza nazionale o di applicazione della legge).'),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              '5. Sicurezza delle Informazioni',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Utilizziamo misure di sicurezza tecniche e organizzative adeguate per proteggere le informazioni personali che trattiamo. Tuttavia, ricorda che nessun sistema di trasmissione o archiviazione dei dati può essere garantito come sicuro al 100%. Pertanto, non possiamo garantire la sicurezza assoluta delle tue informazioni.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20.0),
            Text(
              '6. I Tuoi Diritti',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Hai determinati diritti riguardo le tue informazioni personali, tra cui:',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- Il diritto di accedere, correggere, aggiornare o richiedere la cancellazione delle tue informazioni personali.'),
                  Text('- Il diritto di opporti al trattamento delle tue informazioni personali, di chiederci di limitare il trattamento delle tue informazioni personali o di richiedere la portabilità delle tue informazioni personali.'),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              '7. Modifiche a Questa Informativa sulla Privacy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Potremmo aggiornare questa informativa sulla privacy di tanto in tanto per riflettere, ad esempio, modifiche alle nostre pratiche o per altri motivi operativi, legali o normativi. Ti informeremo di eventuali modifiche pubblicando la nuova informativa sulla privacy su questa pagina. Ti consigliamo di rivedere periodicamente questa informativa per restare informato su come proteggiamo le tue informazioni.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20.0),
            Text(
              '8. Contatti',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Se hai domande o commenti su questa informativa, contattaci all\'indirizzo:',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('InTour'),
                  Text('Via Torino, 155, 30170 Mestre, Venezia VE'),
                  Text('contact@intour.com'),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Grazie per aver dedicato del tempo a leggere la nostra informativa sulla privacy.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10.0),
            Text(
              'InTour',
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
