import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_catalog_helm/core/routes/app_router.dart';
import 'package:uts_catalog_helm/features/cart/data/models/cart_model.dart';
import 'package:uts_catalog_helm/features/cart/presentation/providers/cart_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().fetchCart();
    });
  }

  String _formatPrice(double price) {
    final str = price.toInt().toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  Future<void> _confirmClearCart(
    BuildContext context,
    CartProvider cartProv,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kosongkan Keranjang'),
        content: const Text(
          'Apakah kamu yakin ingin menghapus semua item dari keranjang?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus Semua'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      await cartProv.clearCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final accentColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'KERANJANG SAYA',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProv, _) {
              final hasItems =
                  cartProv.cart != null && cartProv.cart!.items.isNotEmpty;
              if (!hasItems) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(Icons.delete_sweep_outlined, color: textColor),
                tooltip: 'Hapus Semua',
                onPressed: () => _confirmClearCart(context, cartProv),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProv, _) {
          if (cartProv.status == CartStatus.loading ||
              cartProv.status == CartStatus.initial) {
            return Center(child: CircularProgressIndicator(color: accentColor));
          }

          if (cartProv.status == CartStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(cartProv.error ?? 'Terjadi kesalahan', style: TextStyle(color: textColor)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    onPressed: () => cartProv.fetchCart(),
                  ),
                ],
              ),
            );
          }

          final cart = cartProv.cart;
          if (cart == null || cart.items.isEmpty) {
            return _EmptyCartView();
          }

          return Column(
            children: [
              const Divider(height: 1),
              Expanded(
                child: RefreshIndicator(
                  color: accentColor,
                  onRefresh: () => cartProv.fetchCart(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    itemCount: cart.items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 24),
                    itemBuilder: (ctx, i) => _CartItemCard(
                      item: cart.items[i],
                      formatPrice: _formatPrice,
                      onRemove: () => cartProv.removeItem(cart.items[i].id),
                      onDecrease: () {
                        final qty = cart.items[i].quantity - 1;
                        if (qty <= 0) {
                          cartProv.removeItem(cart.items[i].id);
                        } else {
                          cartProv.updateItem(cart.items[i].id, qty);
                        }
                      },
                      onIncrease: () => cartProv.updateItem(
                        cart.items[i].id,
                        cart.items[i].quantity + 1,
                      ),
                    ),
                  ),
                ),
              ),
              _CartBottomBar(
                total: cart.totalPrice,
                formatPrice: _formatPrice,
                onCheckout: () {
                  Navigator.pushNamed(context, AppRouter.checkout);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: textColor.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Keranjang masih kosong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yuk tambahkan produk ke keranjang!',
            style: TextStyle(
              fontSize: 14,
              color: textColor.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final String Function(double) formatPrice;
  final VoidCallback onRemove;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _CartItemCard({
    required this.item,
    required this.formatPrice,
    required this.onRemove,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final accentColor = Theme.of(context).colorScheme.primary;
    final imgBgColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0);
    final ctrlBgColor = isDark ? const Color(0xFF333333) : const Color(0xFFF0F0F0);

    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar produk
          Container(
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              color: imgBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item.imageUrl.isNotEmpty
                  ? Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => _placeholder(context),
                    )
                  : _placeholder(context),
            ),
          ),
          const SizedBox(width: 16),
          // Info produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Hapus Item Ikon
                    GestureDetector(
                      onTap: onRemove,
                      child: Icon(Icons.delete_outline, size: 22, color: accentColor),
                    ),
                  ],
                ),
                Text(
                  formatPrice(item.price),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: accentColor,
                  ),
                ),
                // Color/Size info placeholder (Mockup: Warna Black, Ukuran XL)
                Text(
                  'Kategori: Helm',
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.6),
                  ),
                ),
                
                // Quantity control
                Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: ctrlBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _QtyButton(icon: Icons.remove, onTap: onDecrease, color: textColor),
                      SizedBox(
                        width: 32,
                        child: Text(
                          '${item.quantity}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      _QtyButton(icon: Icons.add, onTap: onIncrease, color: textColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Icon(
      Icons.image_outlined,
      color: isDark ? Colors.white24 : Colors.black12,
      size: 40,
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

// ── Cart Bottom Bar ────────────────────────────────────────
class _CartBottomBar extends StatelessWidget {
  final double total;
  final String Function(double) formatPrice;
  final VoidCallback onCheckout;

  const _CartBottomBar({
    required this.total,
    required this.formatPrice,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final btnColor = isDark ? Theme.of(context).colorScheme.primary : Colors.black;
    final btnTextColor = isDark ? Colors.black : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'TOTAL',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: textColor.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    formatPrice(total),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
                width: 180,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor,
                    foregroundColor: btnTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // Kotak sesuai desain
                    ),
                    elevation: 0,
                  ),
                  onPressed: onCheckout,
                  child: const Text(
                    'CHECKOUT',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.0),
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
