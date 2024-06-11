import 'package:flutter/material.dart';
import "package:flutter_localizations/flutter_localizations.dart";
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:paged_data_table_test/post.dart';
import 'package:paged_data_table_test/table_test_page.dart';
import 'package:paged_datatable/l10n/generated/l10n.dart';

import 'generated/l10n.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeDateFormatting("en");

  PostsRepository.generate(500);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
        PagedDataTableLocalization.delegate,
        FormBuilderLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    const String overriddenLocale = "de";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(S.of(context).language),
            Text(PagedDataTableLocalization.of(context).nextPageButtonText),
            Localizations.override(
              context: context,
              // NOTE: if you change this line to "en", "it" or "es" then the text is shown in the correct language
              // "de" is not working
              locale: const Locale(overriddenLocale),
              child: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      const Text("With overridden context and locale set to: $overriddenLocale"),
                      Text(S.of(context).language),
                      Text(PagedDataTableLocalization.of(context).nextPageButtonText),
                      Text(FormBuilderLocalizations.of(context).emailErrorText),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TableTestPage()),
              ),
              child: const Text("table test page"),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
