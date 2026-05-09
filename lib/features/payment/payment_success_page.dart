import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class PaymentSuccessPage extends StatefulWidget {
  const PaymentSuccessPage({super.key});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage>
    with TickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late AnimationController _fadeCtrl;
  late AnimationController _bounceCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();

    _scaleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _bounceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn),
    );
    _bounceAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.bounceOut),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _scaleCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _fadeCtrl.forward();
      _bounceCtrl.forward();
    });
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _fadeCtrl.dispose();
    _bounceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    final planName = args['planName'] ?? '6 Bulan';
    final price = args['price'] ?? 'Rp 149.400';
    final method = args['method'] ?? 'QRIS';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A2A1A), AppColors.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Animated checkmark
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.success, width: 2.5),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.success,
                      size: 60,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    children: [
                      const Text(
                        'Pembayaran Berhasil!',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Selamat! Kamu sekarang menjadi\nanggota Misik Premium',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // Receipt card
                FadeTransition(
                  opacity: _fadeAnim,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _receiptRow('Paket', 'Premium $planName'),
                        const SizedBox(height: 12),
                        _receiptRow('Metode', method),
                        const SizedBox(height: 12),
                        _receiptRow('Total', price, highlight: true),
                        const SizedBox(height: 12),
                        Divider(color: Colors.white.withOpacity(0.1)),
                        const SizedBox(height: 12),
                        _receiptRow(
                          'Tanggal',
                          _formatDate(DateTime.now()),
                        ),
                        const SizedBox(height: 8),
                        _receiptRow(
                          'ID Transaksi',
                          '#MSK${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                          small: true,
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Confetti-like particles (simple circles)
                FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.main,
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 54),
                          backgroundColor: AppColors.success,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.music_note_rounded,
                                color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Mulai Mendengarkan',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Lihat Detail Transaksi',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value,
      {bool highlight = false, bool small = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: small ? 12 : 13,
            color: AppColors.textMuted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: small ? 12 : 14,
            fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
            color: highlight ? AppColors.success : Colors.white,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${dt.day} ${months[dt.month]} ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
