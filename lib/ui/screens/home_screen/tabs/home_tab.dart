import 'package:flutter/material.dart';
import 'package:sporthub/models/sport.dart';
import 'package:sporthub/services/sports_service.dart';
import '../../../../services/establishment_service.dart';
import '../../../../models/establishment.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final EstablishmentService _establishmentService = EstablishmentService();
  List<Establishment> _establishments = [];
  List<Establishment> _filteredEstablishments = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedSportFilter = 'Todos';
  
  // Lista de esportes para filtro
  final List<Map<String, dynamic>> _sportsFilter = [
    {'name': 'Todos', 'icon': Icons.apps},
  ];

  @override
  void initState() {
    super.initState();
    _loadEstablishments();
    _makeSportFilter();
  }

  Future<void> _makeSportFilter() async {
    final sports = await _loadSports();

    // Atualizar a lista de filtros de esportes
    setState(() {
      _sportsFilter.addAll(sports.map((sport) {
        return {
          'name': sport.name,
          'icon': Icons.sports,
        };
      }));
    });
  }

  Future<List<Sport>> _loadSports() async {
    try {
      return await SportsService().getAllSports();
    } catch (e) {
      throw Exception('Failed to load sports: $e');
    }
  }

  Future<void> _loadEstablishments() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final establishments = await _establishmentService.getAllEstablishments();
      
      setState(() {
        _establishments = establishments;
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar estabelecimentos: $e';
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    if (_selectedSportFilter == 'Todos') {
      _filteredEstablishments = List.from(_establishments);
    } else {
      _filteredEstablishments = _establishments.where((establishment) {
        return establishment.sports.any((sport) => 
          sport.name.toLowerCase().contains(_selectedSportFilter.toLowerCase())
        );
      }).toList();
    }
  }

  void _onSportFilterChanged(String sport) {
    setState(() {
      _selectedSportFilter = sport;
      _applyFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadEstablishments,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saudação
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF3F51B5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bem-vindo ao SportHub!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Encontre os melhores estabelecimentos esportivos',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Filtros por esporte
            const Text(
              'Filtrar por Esporte',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 12),
            
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _sportsFilter.length,
                itemBuilder: (context, index) {
                  final sport = _sportsFilter[index];
                  final isSelected = _selectedSportFilter == sport['name'];
                  
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => _onSportFilterChanged(sport['name']),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? const Color(0xFF1A237E)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: isSelected 
                                    ? const Color(0xFF1A237E)
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              sport['icon'],
                              color: isSelected ? Colors.white : Colors.grey[600],
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            sport['name'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected 
                                  ? const Color(0xFF1A237E)
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Título da seção
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedSportFilter == 'Todos' 
                      ? 'Estabelecimentos Próximos'
                      : 'Estabelecimentos - $_selectedSportFilter',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navegar para lista completa
                  },
                  child: const Text('Ver todos'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Lista de estabelecimentos
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.grey[400],
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadEstablishments,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_filteredEstablishments.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.store_outlined,
                        color: Colors.grey[400],
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedSportFilter == 'Todos'
                            ? 'Nenhum estabelecimento encontrado'
                            : 'Nenhum estabelecimento encontrado para $_selectedSportFilter',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      if (_selectedSportFilter != 'Todos') ...[
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => _onSportFilterChanged('Todos'),
                          child: const Text('Ver todos os estabelecimentos'),
                        ),
                      ],
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredEstablishments.length,
                itemBuilder: (context, index) {
                  final establishment = _filteredEstablishments[index];
                  return _buildEstablishmentCard(establishment);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstablishmentCard(Establishment establishment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showEstablishmentDetails(establishment);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do estabelecimento
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 160,
                width: double.infinity,
                color: Colors.grey[200],
                child: establishment.imageUrl.isNotEmpty
                    ? Image.network(
                        establishment.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage();
                        },
                      )
                    : _buildPlaceholderImage(),
              ),
            ),
            
            // Informações do estabelecimento
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    establishment.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    establishment.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          establishment.address.shortAddress,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        establishment.phoneNumber,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Esportes disponíveis
                  if (establishment.sports.isNotEmpty) ...[
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: establishment.sports.take(3).map((sport) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A237E).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            sport.name,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                        );
                      }).toList()
                        ..addAll(
                          establishment.sports.length > 3
                              ? [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '+${establishment.sports.length - 3}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ]
                              : [],
                        ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          Icons.store,
          size: 48,
          color: Colors.grey[500],
        ),
      ),
    );
  }

  void _showEstablishmentDetails(Establishment establishment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Nome
                Text(
                  establishment.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Descrição
                Text(
                  establishment.description,
                  style: const TextStyle(fontSize: 16),
                ),
                
                const SizedBox(height: 16),
                
                // Endereço
                _buildDetailRow(
                  Icons.location_on_outlined,
                  'Endereço',
                  establishment.address.fullAddress,
                ),
                
                const SizedBox(height: 12),
                
                // Telefone
                _buildDetailRow(
                  Icons.phone_outlined,
                  'Telefone',
                  establishment.phoneNumber,
                ),
                
                const SizedBox(height: 12),
                
                // Email
                if (establishment.email.isNotEmpty)
                  _buildDetailRow(
                    Icons.email_outlined,
                    'Email',
                    establishment.email,
                  ),
                
                const SizedBox(height: 12),
                
                // Website
                if (establishment.website.isNotEmpty)
                  _buildDetailRow(
                    Icons.web_outlined,
                    'Website',
                    establishment.website,
                  ),
                
                const SizedBox(height: 24),
                
                // Botões de ação
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implementar ligação
                        },
                        icon: const Icon(Icons.phone),
                        label: const Text('Ligar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implementar navegação
                        },
                        icon: const Icon(Icons.directions),
                        label: const Text('Rota'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A237E),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
