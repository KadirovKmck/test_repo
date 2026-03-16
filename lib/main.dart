import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/sdd_metric.dart';
import 'sdd_provider.dart';
import 'theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SddProvider()..fetchMetrics()),
      ],
      child: const SddNavigatorApp(),
    ),
  );
}

class SddNavigatorApp extends StatelessWidget {
  const SddNavigatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'SDD Navigator',
          theme: themeProvider.currentTheme,
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sddProvider = Provider.of<SddProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SDD Navigator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          PopupMenuButton<SortType>(
            onSelected: (type) => sddProvider.sort(type),
            itemBuilder: (context) => [
              const PopupMenuItem(value: SortType.name, child: Text('По имени')),
              const PopupMenuItem(value: SortType.coverageHigh, child: Text('Покрытию (Убыв.)')),
              const PopupMenuItem(value: SortType.coverageLow, child: Text('Покрытию (Возр.)')),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск по модулю или названию...',
                hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                prefixIcon: const Icon(Icons.search , ),
                prefixIconColor: Theme.of(context).textTheme.bodyLarge?.color,
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => sddProvider.search(val),
            ),
          ),
          Expanded(
            child: sddProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: sddProvider.metrics.length,
                    itemBuilder: (context, index) {
                      final metric = sddProvider.metrics[index];
                      return MetricCard(metric: metric);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final SddMetric metric;

  const MetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = metric.coverage > 80 ? Colors.green : 
                  (metric.coverage > 50 ? Colors.orange : Colors.redAccent);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  metric.name,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${metric.coverage}%',
                  style: theme.textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Module: ${metric.module}',
              style: theme.textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: metric.coverage / 100,
                backgroundColor: color.withOpacity(0.2),
                color: color,
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}