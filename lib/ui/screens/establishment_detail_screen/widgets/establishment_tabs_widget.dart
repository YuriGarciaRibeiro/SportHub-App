import 'package:flutter/material.dart';

import '../../../../models/establishment.dart';
import '../tabs/tabs.dart';

class EstablishmentTabsWidget extends StatefulWidget {
  final Establishment establishment;
  final VoidCallback onCheckAvailability;
  final VoidCallback onWriteReview;
  final VoidCallback onGetDirections;

  const EstablishmentTabsWidget({
    super.key,
    required this.establishment,
    required this.onCheckAvailability,
    required this.onWriteReview,
    required this.onGetDirections,
  });

  @override
  State<EstablishmentTabsWidget> createState() => _EstablishmentTabsWidgetState();
}

class _EstablishmentTabsWidgetState extends State<EstablishmentTabsWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.surface,
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Visão Geral'),
              Tab(text: 'Quadras'),
              Tab(text: 'Avaliações'),
              Tab(text: 'Localização'),
            ],
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              OverviewTabWidget(establishment: widget.establishment),
              CourtsTabWidget(
                courts: widget.establishment.courts,
                onBookCourt: (_) => widget.onCheckAvailability(),
              ),
              ReviewsTabWidget(onWriteReview: widget.onWriteReview),
              LocationTabWidget(
                address: widget.establishment.address,
                onGetDirections: widget.onGetDirections,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
