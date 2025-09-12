import 'package:flutter/material.dart';

import '../../../../models/establishment.dart';
import '../tabs/tabs.dart';

class EstablishmentTabsWidget extends StatefulWidget {
  final Establishment establishment;
  final VoidCallback onCheckAvailability;
  final Future<void> Function() onWriteReview;
  final VoidCallback onGetDirections;
  final VoidCallback onCall;
  final VoidCallback onEmail;
  final VoidCallback onWebsite;

  const EstablishmentTabsWidget({
    super.key,
    required this.establishment,
    required this.onCheckAvailability,
    required this.onWriteReview,
    required this.onGetDirections,
    required this.onCall,
    required this.onEmail,
    required this.onWebsite,
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
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: const [
              Tab(text: 'Visão Geral'),
              Tab(text: 'Quadras'),
              Tab(text: 'Avaliações'),
              Tab(text: 'Localização'),
            ],
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorColor: theme.colorScheme.primary,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ),
        Expanded(
          child: Container(
            color: theme.scaffoldBackgroundColor,
            child: TabBarView(
              controller: _tabController,
              children: [
                OverviewTabWidget(
                  establishment: widget.establishment, 
                  onCall: widget.onCall,
                  onEmail: widget.onEmail,
                  onWebsite: widget.onWebsite,
                ),
                CourtsTabWidget(
                  courts: widget.establishment.courts,
                  onBookCourt: (_) => widget.onCheckAvailability(),
                ),
                ReviewsTabWidget(
                  onWriteReview: widget.onWriteReview,
                  establishmentId: widget.establishment.id,
                  reviews: widget.establishment.reviews,
                  averageRating: widget.establishment.averageRating,
                ),
                LocationTabWidget(
                  address: widget.establishment.address,
                  onGetDirections: widget.onGetDirections,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
