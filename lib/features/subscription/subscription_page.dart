import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage>
    with SingleTickerProviderStateMixin {
  int _selectedPlan = 1; // 0=1bulan, 1=6bulan, 2=1tahun
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  final List<Map<String, dynamic>> _plans = [
    {  
      'id': 0,
      'duration': '1 Bulan',
      'price': 'Rp 29.900',
      'priceNum': 29900,
      'perMonth': 'Rp 29.900 / bulan',
      'badge': null,
      'color': const Color.fromARGB(255, 0, 255, 55),
      'description': 'Cocok untuk mencoba',
    },
    {
      'id': 1,
      'duration': '6 Bulan',
      'price': 'Rp 149.400',
      'priceNum': 149400,
      'perMonth': 'Rp 24.900 / bulan',
      'badge': 'TERPOPULER',
      'color': AppColors.primary,
      'description': 'Hemat 17% dari harga normal',
    },
    {
      'id': 2,
      'duration': '1 Tahun',
      'price': 'Rp 249.000',
      'priceNum': 249000,
      'perMonth': 'Rp 20.750 / bulan',
      'badge': 'TERBAIK',
      'color': Color(0xFF6C4FD6),
      'description': 'Hemat 31% dari harga normal',
    },
  ];

  final List<String> _features = [
    'Musik tanpa iklan',
    'Download untuk didengar offline',
    'Kualitas audio HD (320 kbps)',
    'Dengarkan di mana saja & kapan saja',
    'Skip lagu tanpa batas',
    'Mode shuffle & repeat',
    'Akses jutaan lagu & podcast',
    'Playlist tidak terbatas',
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A2540), AppColors.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.6],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SafeArea(
            child: Column(
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Header
                        const Icon(Icons.workspace_premium,
                            color: Colors.amber, size: 52),
                        const SizedBox(height: 14),
                        const Text(
                          'Misik Premium',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Nikmati pengalaman musik terbaik',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Plans
                        ...List.generate(_plans.length, (i) => _planCard(i)),

                        const SizedBox(height: 32),

                        // Features
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Yang kamu dapatkan:',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ..._features.map(
                                (f) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.15),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.check,
                                            color: AppColors.primary, size: 14),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          f,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          '* Harga sudah termasuk PPN. Langganan diperpanjang otomatis.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.4),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // CTA
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final plan = _plans[_selectedPlan];
                          Navigator.of(context).pushNamed(
                            AppRoutes.payment,
                            arguments: {
                              'planName': plan['duration'],
                              'price': plan['price'],
                              'priceNum': plan['priceNum'],
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28)),
                          backgroundColor: _plans[_selectedPlan]['color'] as Color,
                          elevation: 0,
                        ),
                        child: Text(
                          'Berlangganan ${_plans[_selectedPlan]['duration']} — ${_plans[_selectedPlan]['price']}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _planCard(int i) {
    final plan = _plans[i];
    final isSelected = _selectedPlan == i;
    final planColor = plan['color'] as Color;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? planColor.withOpacity(0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? planColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Radio
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? planColor : AppColors.textMuted,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: planColor,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        plan['duration'] as String,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (plan['badge'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: planColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            plan['badge'] as String,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    plan['description'] as String,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    plan['perMonth'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? planColor : AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Price
            Text(
              plan['price'] as String,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isSelected ? planColor : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
