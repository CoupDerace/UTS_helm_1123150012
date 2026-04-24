import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/providers/theme_provider.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Halo, ${auth.firebaseUser?.displayName ?? 'User'}!',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();

              if (!mounted) return;

              Navigator.pushReplacementNamed(
                context,
                AppRouter.login,
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          /// SWITCH THEME
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isDark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      size: 20,
                      color: isDark
                          ? Colors.amber
                          : Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isDark
                          ? 'Mode Gelap'
                          : 'Mode Terang',
                    ),
                  ],
                ),
                Switch(
                  value: isDark,
                  onChanged: (_) {
                    context
                        .read<ThemeProvider>()
                        .toggle();
                  },
                ),
              ],
            ),
          ),

          /// CONTENT
          Expanded(
            child: switch (product.status) {
              ProductStatus.initial ||
              ProductStatus.loading =>
                const Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Memuat produk...'),
                    ],
                  ),
                ),

              ProductStatus.error => Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        product.error ??
                            'Terjadi kesalahan',
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon:
                            const Icon(Icons.refresh),
                        label:
                            const Text('Coba Lagi'),
                        onPressed: () {
                          product.fetchProducts();
                        },
                      ),
                    ],
                  ),
                ),

              ProductStatus.loaded =>
                RefreshIndicator(
                  onRefresh: () =>
                      product.fetchProducts(),
                  child: GridView.builder(
                    padding:
                        const EdgeInsets.all(16),
                    itemCount:
                        product.products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder:
                        (context, index) {
                      final p =
                          product.products[index];

                      return Card(
                        elevation: 2,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.vertical(
                                top: Radius.circular(
                                  12,
                                ),
                              ),
                              child:
                                  Image.network(
                                p.imageUrl,
                                height: 120,
                                width:
                                    double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) {
                                  return Container(
                                    height: 120,
                                    color: Colors
                                        .grey
                                        .shade200,
                                    child:
                                        const Icon(
                                      Icons
                                          .image_not_supported,
                                      size: 40,
                                    ),
                                  );
                                },
                              ),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.all(
                                10,
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    p.name,
                                    maxLines: 2,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                      fontSize:
                                          14,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 4,
                                  ),

                                  Text(
                                    'Rp ${p.price.toStringAsFixed(0)}',
                                    style:
                                        const TextStyle(
                                      color: Color(
                                        0xFF1565C0,
                                      ),
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 4,
                                  ),

                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal:
                                          8,
                                      vertical:
                                          2,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color: Colors
                                          .blue
                                          .shade50,
                                      borderRadius:
                                          BorderRadius.circular(
                                        20,
                                      ),
                                    ),
                                    child: Text(
                                      p.category,
                                      style:
                                          const TextStyle(
                                        fontSize:
                                            11,
                                        color:
                                            Color(
                                          0xFF1565C0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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