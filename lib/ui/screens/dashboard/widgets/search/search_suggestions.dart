import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../../models/establishment.dart';

class SearchSuggestions extends StatelessWidget {
  final List<Establishment> suggestions;
  final Function(Establishment) onEstablishmentSelected;

  const SearchSuggestions({
    super.key,
    required this.suggestions,
    required this.onEstablishmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(top: 1.h),
      constraints: BoxConstraints(maxHeight: 40.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final establishment = suggestions[index];
          return ListTile(
            leading: const Icon(Icons.business),
            title: Text(establishment.name),
            subtitle: Text(
              establishment.sports.isNotEmpty 
                  ? establishment.sports.first.name 
                  : establishment.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => onEstablishmentSelected(establishment),
          );
        },
      ),
    );
  }
}
