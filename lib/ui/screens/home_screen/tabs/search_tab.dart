import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/app_export.dart';
import '../../../../services/establishment_service.dart';
import '../../../../models/establishment.dart';
import '../../establishment_detail_screen/establishment_detail_screen.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final EstablishmentService _establishmentService = EstablishmentService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Establishment> _allEstablishments = [];
  List<Establishment> _filteredEstablishments = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadEstablishments();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEstablishments() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final establishments = await _establishmentService.getAllEstablishments();
      
      setState(() {
        _allEstablishments = establishments;
        _filteredEstablishments = establishments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar estabelecimentos: $e';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredEstablishments = _allEstablishments;
      } else {
        _filteredEstablishments = _allEstablishments.where((establishment) {
          return establishment.name.toLowerCase().contains(query) ||
                 establishment.description.toLowerCase().contains(query) ||
                 establishment.sports.any((sport) => 
                   sport.name.toLowerCase().contains(query));
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar estabelecimentos...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
          ),
          SizedBox(height: 3.h),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            SizedBox(height: 2.h),
            Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: _loadEstablishments,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_searchController.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 80,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            SizedBox(height: 2.h),
            Text(
              'Digite para pesquisar estabelecimentos',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_filteredEstablishments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            SizedBox(height: 2.h),
            Text(
              'Nenhum estabelecimento encontrado',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _filteredEstablishments.length,
      itemBuilder: (context, index) {
        final establishment = _filteredEstablishments[index];
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 20.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        ),
                        child: establishment.imageUrl.isNotEmpty
                            ? Image.network(
                                establishment.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.image_not_supported,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  );
                                },
                              )
                            : Icon(
                                Icons.business,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                size: 30,
                              ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            establishment.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            establishment.description,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.h),
                          if (establishment.sports.isNotEmpty) ...[
                            Wrap(
                              spacing: 1.w,
                              runSpacing: 0.5.h,
                              children: establishment.sports.take(3).map((sport) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    sport.name,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${establishment.address.city}, ${establishment.address.state}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EstablishmentDetailScreen(
                              establishment: establishment,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                      ),
                      child: Text(
                        'Ver mais',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
