import 'package:flutter/foundation.dart';
import '../../../../../../../models/establishment.dart';
import '../../../../../../../services/establishment_service.dart';

class EstablishmentSearchController extends ChangeNotifier {
  final EstablishmentService _establishmentService = EstablishmentService();
  
  List<Establishment> _allEstablishments = [];
  List<Establishment> get allEstablishments => _allEstablishments;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  
  bool _disposed = false;
  bool get disposed => _disposed;
  
  List<Establishment> get filteredEstablishments {
    if (_disposed || _searchQuery.isEmpty) return [];
    
    final query = _searchQuery.toLowerCase();
    return _allEstablishments.where((establishment) {
      return establishment.name.toLowerCase().contains(query) ||
          establishment.description.toLowerCase().contains(query) ||
          establishment.sports.any((sport) => sport.name.toLowerCase().contains(query));
    }).toList();
  }
  
  Future<void> loadEstablishments() async {
    if (_disposed) return;
    
    try {
      _isLoading = true;
      if (!_disposed) notifyListeners();
      
      _allEstablishments = await _establishmentService.getAllEstablishments();
    } catch (e) {
      // Handle error if needed
    } finally {
      _isLoading = false;
      if (!_disposed) notifyListeners();
    }
  }
  
  void updateSearchQuery(String query) {
    if (_disposed) return;
    _searchQuery = query;
    notifyListeners();
  }
  
  void clearSearch() {
    if (_disposed) return;
    _searchQuery = '';
    notifyListeners();
  }
  
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
