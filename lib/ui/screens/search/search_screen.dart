import 'package:sizer/sizer.dart';
import 'search_view_model.dart';
import '../../../core/app_export.dart';
import '../../../models/sport.dart';
import '../../../widgets/shared/establishment_card_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<SearchViewModel>(context, listen: false);
      viewModel.initializeSearch();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar estabelecimentos...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  viewModel.updateSearchQuery('');
                                },
                                icon: const Icon(Icons.clear),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => viewModel.updateSearchQuery(value),
                    ),
                    
                    SizedBox(height: 2.h),
                    
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildSportFilter(viewModel),
                          SizedBox(width: 2.w),
                          
                          FilterChip(
                            label: const Text('Abertos agora'),
                            selected: viewModel.isOpen,
                            onSelected: (selected) => viewModel.updateOpenFilter(selected),
                          ),
                          SizedBox(width: 2.w),
                          
                          if (viewModel.searchQuery.isNotEmpty || 
                              viewModel.selectedSport != null || 
                              viewModel.isOpen)
                            ActionChip(
                              label: const Text('Limpar'),
                              onPressed: () {
                                _searchController.clear();
                                viewModel.clearFilters();
                              },
                            ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${viewModel.filteredEstablishments.length} estabelecimentos',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        DropdownButton<String>(
                          value: viewModel.sortBy,
                          underline: Container(),
                          items: const [
                            DropdownMenuItem(value: 'distance', child: Text('Distância')),
                            DropdownMenuItem(value: 'rating', child: Text('Avaliação')),
                            DropdownMenuItem(value: 'name', child: Text('Nome')),
                          ],
                          onChanged: (value) {
                            if (value != null) viewModel.updateSortBy(value);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: viewModel.isLoading && viewModel.filteredEstablishments.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.hasError
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Erro ao carregar estabelecimentos',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  viewModel.errorMessage ?? 'Erro desconhecido',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 2.h),
                                ElevatedButton(
                                  onPressed: () => viewModel.refreshSearch(),
                                  child: const Text('Tentar novamente'),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => viewModel.refreshSearch(),
                            child: viewModel.filteredEstablishments.isEmpty
                                ? _buildEmptyState()
                                : ListView.builder(
                                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                                    itemCount: viewModel.filteredEstablishments.length,
                                    itemBuilder: (context, index) {
                                      final establishment = viewModel.filteredEstablishments[index];
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 2.h),
                                        child: EstablishmentCardWidget(
                                          establishment: establishment,
                                          getEstablishmentDistance: (est) => '2.5 km',
                                          getEstablishmentPrice: (est) => 'R\$ ${est.startingPrice?.toStringAsFixed(2) ?? "50,00"}',
                                        ),
                                      );
                                    },
                                  ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSportFilter(SearchViewModel viewModel) {
    return PopupMenuButton<Sport?>(
      child: Chip(
        label: Text(viewModel.selectedSport?.name ?? 'Todos os esportes'),
        avatar: Icon(
          viewModel.selectedSport != null ? Icons.sports : Icons.filter_list,
          size: 16.sp,
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem<Sport?>(
          value: null,
          child: Text('Todos os esportes'),
        ),
        ...viewModel.availableSports.map(
          (sport) => PopupMenuItem<Sport?>(
            value: sport,
            child: Text(sport.name),
          ),
        ),
      ],
      onSelected: (sport) => viewModel.updateSportFilter(sport),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).hintColor,
          ),
          SizedBox(height: 2.h),
          Text(
            'Nenhum estabelecimento encontrado',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Tente ajustar os filtros de busca',
            style: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }
}
