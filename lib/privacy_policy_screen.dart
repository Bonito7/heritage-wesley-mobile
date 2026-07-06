import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFb45309),
        foregroundColor: Colors.white,
        title: const Text(
          'Politique de confidentialité',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFb45309), Color(0xFFd97706)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFb45309).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.privacy_tip_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'La Famille Wesley',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Dernière mise à jour : Juillet 2025',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Introduction
            _buildSection(
              icon: Icons.info_outline_rounded,
              title: '1. Introduction',
              content:
                  'Bienvenue dans l\'application "La Famille Wesley". Nous respectons votre vie privée et nous nous engageons à protéger vos données personnelles. '
                  'Cette politique de confidentialité vous informe sur la façon dont nous traitons vos données lorsque vous utilisez notre application mobile.',
            ),

            _buildSection(
              icon: Icons.person_outline_rounded,
              title: '2. Responsable du traitement',
              content:
                  'L\'application "La Famille Wesley" est gérée dans le cadre d\'un projet familial à but non commercial, dédié à la diffusion de biographies, sermons et cantiques de tradition méthodiste wesleyenne.',
            ),

            _buildSection(
              icon: Icons.data_usage_rounded,
              title: '3. Données collectées',
              content:
                  'Notre application ne collecte aucune donnée personnelle directement. '
                  'L\'application fonctionne principalement comme un navigateur web intégré (WebView) qui charge le site heritage-wesley.netlify.app.\n\n'
                  'Les seules données techniques pouvant être générées sont :\n'
                  '• Les journaux de diagnostic en cas d\'erreur réseau (non transmis)\n'
                  '• L\'état de la connectivité réseau (vérification locale uniquement)',
            ),

            _buildSection(
              icon: Icons.wifi_rounded,
              title: '4. Connectivité réseau',
              content:
                  'L\'application vérifie l\'état de votre connexion Internet uniquement pour vous informer lorsque vous êtes hors ligne et pour recharger automatiquement le contenu lorsque la connexion est rétablie. '
                  'Ces vérifications sont effectuées localement sur votre appareil et aucune donnée de connexion n\'est transmise à des serveurs externes.',
            ),

            _buildSection(
              icon: Icons.web_rounded,
              title: '5. Contenu web et cookies',
              content:
                  'Le contenu affiché dans l\'application provient du site web externe heritage-wesley.netlify.app. '
                  'Ce site peut utiliser des cookies ou des technologies de stockage local (LocalStorage) pour améliorer l\'expérience de navigation. '
                  'Nous vous invitons à consulter la politique de confidentialité de Netlify pour plus d\'informations sur leur gestion des données.',
            ),

            _buildSection(
              icon: Icons.security_rounded,
              title: '6. Sécurité des données',
              content:
                  'Nous prenons au sérieux la sécurité de vos informations. L\'application utilise des connexions HTTPS pour charger le contenu web. '
                  'Aucune donnée personnelle n\'est stockée sur nos serveurs, car nous n\'en possédons pas dans le cadre de cette application.',
            ),

            _buildSection(
              icon: Icons.child_care_rounded,
              title: '7. Protection des mineurs',
              content:
                  'Notre application est destinée à un public général souhaitant s\'informer sur la tradition méthodiste et wesleyenne. '
                  'Nous ne collectons sciemment aucune donnée provenant d\'enfants de moins de 13 ans.',
            ),

            _buildSection(
              icon: Icons.update_rounded,
              title: '8. Modifications de cette politique',
              content:
                  'Nous nous réservons le droit de modifier cette politique de confidentialité à tout moment. '
                  'En cas de modification substantielle, la date de "dernière mise à jour" en haut de ce document sera actualisée. '
                  'Nous vous encourageons à consulter régulièrement cette politique.',
            ),

            _buildSection(
              icon: Icons.mail_outline_rounded,
              title: '9. Nous contacter',
              content:
                  'Si vous avez des questions concernant cette politique de confidentialité ou le traitement de vos données, '
                  'vous pouvez nous contacter via le site web : heritage-wesley.netlify.app',
            ),

            const SizedBox(height: 16),

            // Pied de page
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5EDE4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFb45309).withValues(alpha: 0.2),
                ),
              ),
              child: const Text(
                '© 2025 La Famille Wesley — Application dédiée à la tradition méthodiste wesleyenne.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF78350F),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFb45309).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFb45309),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
