import 'package:flutter/material.dart';
import 'package:sporthub/models/establishment.dart';
import '../../../core/app_export.dart';
import 'all_establishments_view_model.dart';
import 'widgets/widgets.dart';

class AllEstablishmentsScreen extends StatefulWidget {
  final List<Establishment> establishments;
  final String title;

  const AllEstablishmentsScreen({
    super.key,
    required this.establishments,
    required this.title,
  });

  @override
  State<AllEstablishmentsScreen> createState() => _AllEstablishmentsScreenState();
}

class _AllEstablishmentsScreenState extends State<AllEstablishmentsScreen> {
  late AllEstablishmentsViewModel viewModel;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel = AllEstablishmentsViewModel();
    viewModel.initializeWithEstablishments(widget.establishments);
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    viewModel.updateSearchQuery(searchController.text);
  }

  bool _isEstablishmentOpen(Establishment e) {
    return viewModel.isEstablishmentOpen(e);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EstablishmentsAppBar(
        title: widget.title,
        viewModel: viewModel,
        onFilterPressed: () => _showFilterBottomSheet(context),
      ),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, child) {
          return _buildBody(context);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        EstablishmentsSearchBar(
          controller: searchController,
        ),
        Expanded(
          child: EstablishmentsList(
            viewModel: viewModel,
            isEstablishmentOpen: _isEstablishmentOpen,
          ),
        ),
      ],
    );
  }


  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheet(
        viewModel: viewModel,
        searchController: searchController,
      ),
    );
  }
}