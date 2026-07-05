import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'privacy_policy_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Masquer la barre d'état système pour une expérience plus immersive si désiré,
  // ou simplement configurer les couleurs de la barre d'état.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFb45309), // Couleur ambre foncée
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const WesleyApp());
}

class WesleyApp extends StatelessWidget {
  const WesleyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La Famille Wesley',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFb45309), // Couleur ambre #b45309
          primary: const Color(0xFFb45309),
          surface: Colors.white,
        ),
      ),
      home: const WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? _webViewController;
  final String _initialUrl = "https://heritage-wesley.netlify.app/";

  // États de l'application
  double _progress = 0;
  bool _isLoading = true;
  bool _isOffline = false;

  // Gestion de la connectivité
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
    _subscribeToConnectivityChanges();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  // Vérifier la connexion initiale
  Future<void> _checkInitialConnectivity() async {
    try {
      final List<ConnectivityResult> results = await _connectivity
          .checkConnectivity();
      _updateConnectionStatus(results);
    } on PlatformException catch (e) {
      debugPrint("Impossible de vérifier la connectivité: $e");
    }
  }

  // S'abonner aux changements de connexion
  void _subscribeToConnectivityChanges() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _updateConnectionStatus(results);
    });
  }

  // Mettre à jour l'état hors-ligne
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final bool offline =
        results.isEmpty || results.contains(ConnectivityResult.none);
    setState(() {
      _isOffline = offline;
    });

    // Si on retrouve la connexion, on recharge la WebView
    if (!offline && _webViewController != null) {
      _webViewController?.reload();
    }
  }

  // Tenter de recharger la page
  Future<void> _retryConnection() async {
    await _checkInitialConnectivity();
    if (!_isOffline && _webViewController != null) {
      _webViewController?.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        final controller = _webViewController;
        if (controller != null && await controller.canGoBack()) {
          // Naviguer vers l'arrière dans la WebView
          controller.goBack();
        } else {
          // Quitter l'application si on ne peut plus revenir en arrière
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF8F5), // Fond crème chaud premium
        appBar: AppBar(
          backgroundColor: const Color(0xFFb45309),
          foregroundColor: Colors.white,
          title: const Text(
            'La Famille Wesley',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
              onSelected: (value) {
                if (value == 'privacy') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyScreen(),
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'privacy',
                  child: Row(
                    children: [
                      Icon(
                        Icons.privacy_tip_rounded,
                        color: Color(0xFFb45309),
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text('Règles de confidentialité'),
                    ],
                  ),
                ),
              ],
            ),
          ],
          elevation: 0,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              // 1. La WebView
              if (!_isOffline)
                InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri(_initialUrl)),
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    domStorageEnabled:
                        true, // Crucial pour les fonctionnalités PWA / cache local
                    databaseEnabled: true,
                    useShouldOverrideUrlLoading: true,
                    mediaPlaybackRequiresUserGesture: false,
                    mixedContentMode:
                        MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                    allowFileAccessFromFileURLs: true,
                    allowUniversalAccessFromFileURLs: true,
                    cacheMode: CacheMode
                        .LOAD_DEFAULT, // Utilise le cache HTTP standard + Service Workers
                    supportZoom: false,
                  ),
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                  onProgressChanged: (controller, progress) {
                    setState(() {
                      _progress = progress / 100.0;
                      if (progress >= 100) {
                        _isLoading = false;
                      }
                    });
                  },
                  onLoadStop: (controller, url) async {
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  onReceivedError: (controller, request, error) {
                    // Si l'erreur concerne la perte de connexion internet
                    if (error.type ==
                            WebResourceErrorType.CANNOT_CONNECT_TO_HOST ||
                        error.type == WebResourceErrorType.HOST_LOOKUP ||
                        error.type == WebResourceErrorType.TIMEOUT ||
                        error.type ==
                            WebResourceErrorType.NETWORK_CONNECTION_LOST ||
                        error.type ==
                            WebResourceErrorType.NOT_CONNECTED_TO_INTERNET) {
                      setState(() {
                        _isOffline = true;
                      });
                    }
                  },
                ),

              // 2. Écran de chargement initial (Splash Loader)
              if (_isLoading && !_isOffline)
                Positioned.fill(
                  child: Container(
                    color: const Color(
                      0xFFb45309,
                    ), // Couleur ambre de la marque
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icône Croix minimaliste (comme le SVG d'origine)
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.church_rounded, // Icône église/foi appropriée
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "La Famille Wesley",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Bibliothèque méthodiste",
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                        const SizedBox(height: 48),
                        // Barre de progression ou spinner linéaire
                        SizedBox(
                          width: 150,
                          height: 4,
                          child: LinearProgressIndicator(
                            value: _progress > 0 ? _progress : null,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // 3. Écran Hors-ligne Premium
              if (_isOffline)
                Positioned.fill(
                  child: Container(
                    color: const Color(0xFFFDF8F5), // Fond crème chaleureux
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFEE2E2), // Rouge clair doux
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.wifi_off_rounded,
                            size: 50,
                            color: Color(0xFFEF4444), // Rouge
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          "Connexion perdue",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Veuillez vérifier votre connexion Internet pour consulter les dernières biographies, sermons et cantiques.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4B5563),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: _retryConnection,
                          icon: const Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Réessayer",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFb45309,
                            ), // Couleur ambre de la marque
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
