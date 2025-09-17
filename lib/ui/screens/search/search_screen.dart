import 'package:go_router/go_router.dart';
import 'search_view_model.dart';
import '../../../core/app_export.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/empty_state_widget.dart';
import 'widgets/error_state_widget.dart';
import 'widgets/establishment_list_widget.dart';

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
      
      // Capturar query parameters da rota atual
      final GoRouterState routerState = GoRouterState.of(context);
      final Map<String, String?> queryParams = routerState.uri.queryParameters;
      
      // Inicializar com parâmetros se existirem
      if (queryParams.isNotEmpty) {
        viewModel.initializeWithParameters(queryParams);
        
        // Atualizar o controller de busca se houver query
        if (queryParams['query'] != null && queryParams['query']!.isNotEmpty) {
          _searchController.text = queryParams['query']!;
        }
      } else {
        viewModel.initializeSearch();
      }
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
              SearchBarWidget(
                searchController: _searchController,
                viewModel: viewModel,
                onClearSearch: () {
                  _searchController.clear();
                  viewModel.updateSearchQuery('');
                },
              ),
              
              Expanded(
                child: viewModel.isLoading && viewModel.filteredEstablishments.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.hasError
                        ? ErrorStateWidget(
                            message: viewModel.errorMessage,
                            onRetry: () => viewModel.refreshSearch(),
                          )
                        : RefreshIndicator(
                            onRefresh: () => viewModel.refreshSearch(),
                            child: viewModel.filteredEstablishments.isEmpty
                                ? const EmptyStateWidget()
                                : EstablishmentListWidget(
                                    establishments: viewModel.filteredEstablishments,
                                    onRefresh: () => viewModel.refreshSearch(),
                                  ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

}
