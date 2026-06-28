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
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['FULL FACE', 'HALF FACE'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
      context.read<CartProvider>().fetchCart();
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
    
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final textColor = isDark ? Colors.white : Colors.black;
    final accentColor = color.primary; // This is Crimson Red or Amber based on AppColors changes
    final cardColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0);

    // Filter products by selected category
    final filteredProducts = product.products.where((p) {
      if (_selectedCategoryIndex == 0) return p.category.toLowerCase().contains('full');
      if (_selectedCategoryIndex == 1) return p.category.toLowerCase().contains('half');
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'The Helmets',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Row(
                    children: [
                      // Cart Icon with badge
                      Consumer<CartProvider>(
                        builder: (context, cartProv, _) {
                          final count = cartProv.itemCount;
                          return Stack(
                            children: [
                              IconButton(
                                icon: Icon(Icons.shopping_cart_outlined, color: textColor),
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
                                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                                    decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
                                    child: Text(
                                      '$count',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      // Logout Icon instead of profile
                      IconButton(
                        icon: Icon(Icons.logout, color: textColor),
                        onPressed: () async {
                          await auth.logout();
                          if (!mounted) return;
                          Navigator.pushReplacementNamed(context, AppRouter.login);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // THEME TOGGLE (Optional visual)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(isDark ? 'Mode Gelap' : 'Mode Terang', style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 14)),
                  Switch(
                    value: isDark,
                    onChanged: (_) => context.read<ThemeProvider>().toggle(),
                    activeColor: accentColor,
                  ),
                ],
              ),
            ),

            // CATEGORY TABS
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategoryIndex = index),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _categories[index],
                            style: TextStyle(
                              color: isSelected ? textColor : textColor.withOpacity(0.4),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (isSelected)
                            Container(
                              height: 3,
                              width: 30,
                              decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // PRODUCT GRID
            Expanded(
              child: switch (product.status) {
                ProductStatus.initial || ProductStatus.loading => Center(
                  child: CircularProgressIndicator(color: accentColor),
                ),
                ProductStatus.error => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
                      const SizedBox(height: 16),
                      Text(product.error ?? 'Terjadi kesalahan', style: TextStyle(color: textColor)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                        onPressed: () => product.fetchProducts(),
                        child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                ProductStatus.loaded => RefreshIndicator(
                  color: accentColor,
                  onRefresh: () => product.fetchProducts(),
                  child: filteredProducts.isEmpty
                    ? Center(child: Text('Tidak ada produk.', style: TextStyle(color: textColor)))
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemCount: filteredProducts.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemBuilder: (context, index) {
                          final p = filteredProducts[index];
                          
                          return Container(
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image area
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: cardColor,
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                      child: Image.network(
                                        p.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported, size: 40, color: textColor.withOpacity(0.5)),
                                      ),
                                    ),
                                  ),
                                ),
                                
                                // Text area
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Rp ${p.price.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            color: accentColor,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const Spacer(),
                                        // Belanja Button
                                        SizedBox(
                                          width: double.infinity,
                                          height: 36,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: cardColor, // Neutral button background
                                              foregroundColor: textColor,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () async {
                                              await context.read<CartProvider>().addToCart(p.id, 1);
                                              if (!mounted) return;
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('${p.name} ditambahkan'),
                                                  backgroundColor: accentColor,
                                                  duration: const Duration(seconds: 1),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Belanja',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                            ),
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
      ),
    );
  }
}

