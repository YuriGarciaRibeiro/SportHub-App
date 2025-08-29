import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/establishment.dart';

class OverviewTabWidget extends StatelessWidget {
  final Establishment establishment;
  const OverviewTabWidget({super.key, required this.establishment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Descrição', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 1.h),
          Text(
            establishment.description.isNotEmpty
                ? establishment.description
                : 'Descrição não disponível.',
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: 2.h),

          Text('Contato', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 1.h),
          _contactItem(
            context, 
            Icons.phone_outlined,
            establishment.phoneNumber.isNotEmpty ? establishment.phoneNumber : 'Telefone não informado',
            establishment.phoneNumber.isNotEmpty ? () async {
              final Uri phoneUri = Uri.parse('tel:${establishment.phoneNumber}');
              try {
                await launchUrl(phoneUri);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Não foi possível fazer a ligação'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            } : null,
          ),
          _contactItem(
            context, 
            Icons.email_outlined,
            establishment.email.isNotEmpty ? establishment.email : 'Email não informado',
            establishment.email.isNotEmpty ? () async {
              final Uri emailUri = Uri.parse('mailto:${establishment.email}');
              try {
                await launchUrl(emailUri);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Não foi possível abrir o email'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            } : null,
          ),
          _contactItem(
            context, 
            Icons.language_outlined,
            establishment.website.isNotEmpty ? establishment.website : 'Website não informado',
            establishment.website.isNotEmpty ? () async {
              final Uri websiteUri = Uri.parse(establishment.website.startsWith('http')
                  ? establishment.website
                  : 'https://${establishment.website}');
              try {
                await launchUrl(websiteUri, mode: LaunchMode.externalApplication);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Não foi possível abrir o website'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            } : null,
          ),
          SizedBox(height: 1.5.h),

          Text('Endereço', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 1.h),
          InkWell(
            onTap: establishment.address.fullAddress.isNotEmpty ? () async {
              // Criar URL para navegação usando o endereço completo
              final address = establishment.address;
              final fullAddress = '${address.street}, ${address.number}, ${address.neighborhood}, ${address.city}, ${address.state}';
              final encodedAddress = Uri.encodeComponent(fullAddress);
              final Uri mapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedAddress');

              try {
                await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Não foi possível abrir o mapa'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            } : null,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: establishment.address.fullAddress.isNotEmpty ? theme.primaryColor : null,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      establishment.address.fullAddress.isNotEmpty
                          ? establishment.address.fullAddress
                          : 'Endereço não informado',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: establishment.address.fullAddress.isNotEmpty ? theme.primaryColor : null,
                      ),
                    ),
                  ),
                  if (establishment.address.fullAddress.isNotEmpty) ...[
                    SizedBox(width: 1.w),
                    Icon(
                      Icons.open_in_new,
                      size: 16,
                      color: theme.primaryColor.withOpacity(0.7),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactItem(BuildContext context, IconData icon, String text, [VoidCallback? onTap]) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.3.h),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 20),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: onTap != null ? Theme.of(context).primaryColor : null,
                ),
              ),
            ),
            if (onTap != null) ...[
              Icon(
                Icons.open_in_new,
                size: 16,
                color: Theme.of(context).primaryColor.withOpacity(0.7),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
