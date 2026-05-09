import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class PaymentFailedPage extends StatefulWidget {
  const PaymentFailedPage({super.key});

  @override
  State<PaymentFailedPage> createState() => _PaymentFailedPageState();
}

class _PaymentFailedPageState extends State<PaymentFailedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: const Interval(0.3, 1.0));
    Future.delayed(const Duration(milliseconds: 150), _ctrl.forward);
  }

  @override
  void dispose() {
    _ctrl.dispose();
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
            colors: [Color(0xFF2A0A0A), AppColors.background],
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

                // Animated X
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.error, width: 2.5),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.error,
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
                        'Pembayaran Gagal',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Transaksimu tidak berhasil diproses.\nSilakan coba kembali.',
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

                // Info card
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
                        _infoRow('Paket', 'Premium $planName'),
                        const SizedBox(height: 12),
                        _infoRow('Metode', method),
                        const SizedBox(height: 12),
                        _infoRow('Total', price),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.error.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  color: AppColors.error, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Kemungkinan penyebab: saldo tidak cukup, koneksi terputus, atau waktu pembayaran habis.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.6),
                                    height: 1.5,
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

                const Spacer(flex: 2),

                FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 54),
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh_rounded,
                                color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Coba Lagi',
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
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.main,
                            (route) => false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 54),
                          side: BorderSide(
                              color: Colors.white.withOpacity(0.2), width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28)),
                        ),
                        child: const Text(
                          'Kembali ke Beranda',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Hubungi Bantuan',
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

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 13, color: AppColors.textMuted)),
        Text(
          value,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
      ],
    );
  }
}
