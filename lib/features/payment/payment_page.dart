import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage>
    with SingleTickerProviderStateMixin {
  int _selectedMethod = 0; // 0=QRIS, 1=BCA, 2=Mandiri, 3=BNI
  bool _isLoading = false;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 0,
      'type': 'qris',
      'label': 'QRIS',
      'sublabel': 'Semua e-wallet & m-banking',
      'icon': Icons.qr_code_2_rounded,
      'color': Color(0xFF1DB8E8),
    },
    {
      'id': 1,
      'type': 'va',
      'bank': 'BCA',
      'label': 'Virtual Account BCA',
      'sublabel': 'Transfer via BCA Mobile / ATM',
      'icon': Icons.account_balance_rounded,
      'color': Color(0xFF0066AE),
    },
    {
      'id': 2,
      'type': 'va',
      'bank': 'Mandiri',
      'label': 'Virtual Account Mandiri',
      'sublabel': 'Transfer via Livin\' Mandiri / ATM',
      'icon': Icons.account_balance_rounded,
      'color': Color(0xFF003087),
    },
    {
      'id': 3,
      'type': 'va',
      'bank': 'BNI',
      'label': 'Virtual Account BNI',
      'sublabel': 'Transfer via BNI Mobile / ATM',
      'icon': Icons.account_balance_rounded,
      'color': Color(0xFFFF8000),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn));
    _slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _processPayment(Map<String, dynamic> args) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;
    setState(() => _isLoading = false);
    // 70% success, 30% failed simulation
    final success = DateTime.now().second % 10 < 7;
    Navigator.of(context).pushReplacementNamed(
      success ? AppRoutes.paymentSuccess : AppRoutes.paymentFailed,
      arguments: {
        ...args,
        'method': _paymentMethods[_selectedMethod]['label'],
        'type': _paymentMethods[_selectedMethod]['type'],
        'bank': _paymentMethods[_selectedMethod]['bank'],
        'va': '8277${(100000000 + (args['priceNum'] ?? 0) as int).toString()}',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    final planName = args['planName'] ?? '6 Bulan';
    final price = args['price'] ?? 'Rp 149.400';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Pembayaran'),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order summary
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.workspace_premium,
                                color: Colors.amber, size: 40),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Misik Premium',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Paket $planName',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              price,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        'Metode Pembayaran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Payment method cards
                      ..._paymentMethods.map((m) => _methodCard(m)),

                      const SizedBox(height: 20),

                      // Detail
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _selectedMethod == 0
                            ? _qrisDetail()
                            : _vaDetail(args),
                      ),
                    ],
                  ),
                ),
              ),

              // Pay button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: ElevatedButton(
onPressed: _isLoading
    ? null
    : () => _processPayment(Map<String, dynamic>.from(args)),                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28)),
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(
                          'Bayar Sekarang — $price',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _methodCard(Map<String, dynamic> m) {
    final isSelected = _selectedMethod == m['id'] as int;
    final color = m['color'] as Color;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = m['id'] as int),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 1.8,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(m['icon'] as IconData, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m['label'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    m['sublabel'] as String,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? color : AppColors.textMuted,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: color),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _qrisDetail() {
    return Container(
      key: const ValueKey('qris'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Scan QR Code',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2),
              ],
            ),
            child: const Icon(Icons.qr_code_2_rounded,
                size: 140, color: AppColors.background),
          ),
          const SizedBox(height: 16),
          Text(
            'Scan menggunakan aplikasi e-wallet atau m-banking yang mendukung QRIS',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.55),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.access_time, color: AppColors.primary, size: 14),
                SizedBox(width: 6),
                Text(
                  'Berlaku 15 menit',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vaDetail(Map args) {
    final method = _paymentMethods[_selectedMethod];
    final bank = method['bank'] ?? '';
    final vaNumber = '8277${DateTime.now().millisecond}12345678';
    final color = method['color'] as Color;

    return Container(
      key: ValueKey('va_$_selectedMethod'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.account_balance_rounded, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                'Virtual Account $bank',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Nomor Virtual Account',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    vaNumber,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Nomor VA berhasil disalin'),
                        duration: Duration(seconds: 2)),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Salin',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _vaStep(
              '1', 'Buka aplikasi $bank Mobile atau ATM $bank'),
          _vaStep('2', 'Pilih menu Transfer > Virtual Account'),
          _vaStep('3', 'Masukkan nomor VA di atas'),
          _vaStep('4', 'Pastikan jumlah sesuai, lalu konfirmasi'),
        ],
      ),
    );
  }

  Widget _vaStep(String num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                num,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
