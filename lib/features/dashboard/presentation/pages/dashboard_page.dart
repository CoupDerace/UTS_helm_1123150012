import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_catalog_helm/features/cart/presentation/providers/cart_provider.dart';

import '../../../../core/providers/theme_provider.dart';
import '../../../../core/routes/app_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/product_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final product = context.watch<ProductProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    final isDark = themeProvider.isDark;

    final theme = Theme.of(context);
    final color = theme.colorScheme;

    final surface = color.surface;
    final onSurface = color.onSurface;
    final primary = color.primary;
    final outline = color.outlineVariant;
    final error = color.error;

    return Scaffold(
      backgroundColor: surface,

      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard', style: TextStyle(fontSize: 18, color: onSurface)),

            Text(
              'Halo, ${auth.firebaseUser?.displayName ?? 'User'}!',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: onSurface.withOpacity(0.75),
              ),
            ),
          ],
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProv, _) {
              final count = cartProv.itemCount;

              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    tooltip: 'Keranjang',
                    onPressed: () async {
                      await Navigator.pushNamed(context, AppRouter.cart);

                      if (context.mounted) {
                        context.read<CartProvider>().fetchCart();
                      }
                    },
                  ),

                  if (count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$count',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();

              if (!mounted) return;

              Navigator.pushReplacementNamed(context, AppRouter.login);
            },
          ),
        ],
      ),

      body: Column(
        children: [
          /// SWITCH THEME
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      size: 20,
                      color: isDark ? Colors.amber : primary,
                    ),

                    const SizedBox(width: 10),

                    Text(
                      isDark ? 'Mode Gelap' : 'Mode Terang',
                      style: TextStyle(color: onSurface),
                    ),
                  ],
                ),

                Switch(
                  value: isDark,
                  onChanged: (_) {
                    context.read<ThemeProvider>().toggle();
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: switch (product.status) {
              ProductStatus.initial || ProductStatus.loading => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),

                    const SizedBox(height: 16),

                    Text(
                      'Memuat produk...',
                      style: TextStyle(color: onSurface),
                    ),
                  ],
                ),
              ),

              ProductStatus.error => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: error),

                    const SizedBox(height: 16),

                    Text(
                      product.error ?? 'Terjadi kesalahan',
                      style: TextStyle(color: onSurface),
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                      onPressed: () {
                        product.fetchProducts();
                      },
                    ),
                  ],
                ),
              ),

              ProductStatus.loaded => RefreshIndicator(
                onRefresh: () => product.fetchProducts(),

                child: GridView.builder(
                  padding: const EdgeInsets.all(16),

                  itemCount: product.products.length,

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,

                    childAspectRatio: 0.60,

                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),

                  itemBuilder: (context, index) {
                    final p = product.products[index];

                    return Card(
                      color: surface,
                      elevation: 3,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(14),
                            ),

                            child: Image.network(
                              p.imageUrl,

                              height: 110,

                              width: double.infinity,

                              fit: BoxFit.cover,

                              errorBuilder: (_, __, ___) {
                                return Container(
                                  height: 110,
                                  color: outline,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),

                              child: Column(
                                mainAxisSize: MainAxisSize.min,

                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    p.name,

                                    maxLines: 2,

                                    overflow: TextOverflow.ellipsis,

                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,

                                      fontSize: 14,

                                      color: onSurface,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    'Rp ${p.price.toStringAsFixed(0)}',

                                    style: TextStyle(
                                      color: primary,

                                      fontWeight: FontWeight.w700,

                                      fontSize: 15,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,

                                      vertical: 4,
                                    ),

                                    decoration: BoxDecoration(
                                      color: primary.withOpacity(0.12),

                                      borderRadius: BorderRadius.circular(20),
                                    ),

                                    child: Text(
                                      p.category,

                                      style: TextStyle(
                                        fontSize: 11,

                                        color: primary,
                                      ),
                                    ),
                                  ),

                                  const Spacer(),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 42,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.shopping_cart_outlined,
                                        size: 18,
                                      ),
                                      label: const Text('Belanja'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await context
                                            .read<CartProvider>()
                                            .addToCart(p.id, 1);

                                        if (!mounted) return;

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${p.name} ditambahkan ke keranjang',
                                            ),
                                            duration: const Duration(
                                              seconds: 2,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            },
          ),
        ],
      ),
    );
  }
}
