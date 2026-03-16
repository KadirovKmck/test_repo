import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'sdd_metric.dart';

enum SortType { name, coverageHigh, coverageLow }

class SddProvider extends ChangeNotifier {
  List<SddMetric> _metrics = [];
  List<SddMetric> _filteredMetrics = [];
  bool _isLoading = false;
  
  String _searchQuery = '';
  SortType _currentSort = SortType.name;

  List<SddMetric> get metrics => _filteredMetrics;
  bool get isLoading => _isLoading;

Future<void> fetchMetrics() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://gist.githubusercontent.com/KadirovKmck/339268085ba90c7bbfb661cbed3313b1/raw/fcc51fb93cc0d15ac54a5ac3c7ae7f4040cad61e/Raw'));
      
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _metrics = data.map((json) => SddMetric.fromJson(json)).toList();
        _applyFiltersAndSort();
      } else {
        debugPrint("Ошибка сервера: код ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Ошибка загрузки данных: $e");
      _metrics = [
        SddMetric(id: '1', name: 'Auth Module', module: 'Core', coverage: 85.5),
        SddMetric(id: '2', name: 'Payment Gateway', module: 'Finance', coverage: 42.0),
        SddMetric(id: '3', name: 'User Profile', module: 'UI', coverage: 99.0),
      ];
      _applyFiltersAndSort();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    _applyFiltersAndSort();
  }

  void sort(SortType type) {
    _currentSort = type;
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    _filteredMetrics = _metrics.where((m) {
      return m.name.toLowerCase().contains(_searchQuery) || 
             m.module.toLowerCase().contains(_searchQuery);
    }).toList();

    switch (_currentSort) {
      case SortType.name:
        _filteredMetrics.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.coverageHigh:
        _filteredMetrics.sort((a, b) => b.coverage.compareTo(a.coverage));
        break;
      case SortType.coverageLow:
        _filteredMetrics.sort((a, b) => a.coverage.compareTo(b.coverage));
        break;
    }
    notifyListeners();
  }
}