import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../models/establishment.dart';
import '../../services/establishment_service.dart';

class EstablishmentScreen extends StatefulWidget {
	final String? establishmentId;
	final Establishment? establishment;

	const EstablishmentScreen({
		super.key,
		this.establishmentId,
		this.establishment,
	}) : assert(establishmentId != null || establishment != null,
						'Provide either establishmentId or establishment');

	@override
	State<EstablishmentScreen> createState() => _EstablishmentScreenState();
}

class _EstablishmentScreenState extends State<EstablishmentScreen> {
	final _service = EstablishmentService();
	Establishment? _data;
	bool _loading = false;
	String? _error;

	@override
	void initState() {
		super.initState();
		_data = widget.establishment;
		if (_data == null) {
			_fetch();
		}
	}

	Future<void> _fetch() async {
		if (widget.establishmentId == null) return;
		setState(() {
			_loading = true;
			_error = null;
		});
		try {
			final est = await _service.getEstablishmentById(widget.establishmentId!);
			setState(() {
				_data = est ?? _data;
			});
		} catch (e) {
			setState(() {
				_error = 'Falha ao carregar estabelecimento';
			});
		} finally {
			if (mounted) {
				setState(() {
					_loading = false;
				});
			}
		}
	}

	@override
	Widget build(BuildContext context) {
		final est = _data;

		return Scaffold(
			appBar: AppBar(
				title: Text(est?.name ?? 'Estabelecimento'),
			),
			body: SafeArea(
				child: _loading && est == null
						? const Center(child: CircularProgressIndicator())
						: _error != null && est == null
								? _ErrorView(message: _error!, onRetry: _fetch)
								: _Content(establishment: est!),
			),
			floatingActionButton: est == null
					? null
					: FloatingActionButton.extended(
							onPressed: () {
								// TODO: Navegar para fluxo de reserva quando existir
								ScaffoldMessenger.of(context).showSnackBar(
									const SnackBar(content: Text('Fluxo de reserva em breve')), 
								);
							},
							icon: const Icon(Icons.event_available),
							label: const Text('Reservar'),
						),
		);
	}
}

class _Content extends StatelessWidget {
	final Establishment establishment;
	const _Content({required this.establishment});

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		return SingleChildScrollView(
			child: Padding(
				padding: EdgeInsets.all(4.w),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						// Header image + title
						_Header(establishment: establishment),
						SizedBox(height: 2.h),

						// Sports chips
						if (establishment.sports.isNotEmpty) ...[
							Wrap(
								spacing: 2.w,
								runSpacing: 1.h,
								children: establishment.sports
										.map((s) => Chip(
													label: Text(s.name),
													backgroundColor:
															theme.primaryColor.withOpacity(0.08),
													labelStyle: theme.textTheme.bodySmall?.copyWith(
														color: theme.primaryColor,
														fontWeight: FontWeight.w600,
													),
												))
										.toList(),
							),
							SizedBox(height: 2.h),
						],

						// Description
						Text('Sobre', style: theme.textTheme.titleLarge),
						SizedBox(height: 0.8.h),
						Text(
							establishment.description.isNotEmpty
									? establishment.description
									: 'Sem descrição.',
							style: theme.textTheme.bodyMedium,
						),

						SizedBox(height: 2.4.h),

						// Address
						Text('Endereço', style: theme.textTheme.titleLarge),
						SizedBox(height: 0.8.h),
						_InfoTile(
							icon: Icons.location_on_outlined,
							title: establishment.address.fullAddress.isNotEmpty
									? establishment.address.fullAddress
									: 'Endereço não informado',
						),

						SizedBox(height: 1.2.h),

						// Contacts
						Text('Contato', style: theme.textTheme.titleLarge),
						SizedBox(height: 0.8.h),
						Column(
							children: [
								_InfoTile(
									icon: Icons.phone_outlined,
									title: establishment.phoneNumber.isNotEmpty
											? establishment.phoneNumber
											: 'Telefone não informado',
								),
								SizedBox(height: 0.8.h),
								_InfoTile(
									icon: Icons.email_outlined,
									title: establishment.email.isNotEmpty
											? establishment.email
											: 'Email não informado',
								),
								SizedBox(height: 0.8.h),
								_InfoTile(
									icon: Icons.language_outlined,
									title: establishment.website.isNotEmpty
											? establishment.website
											: 'Website não informado',
								),
							],
						),

						SizedBox(height: 2.4.h),

						// Courts list
						Text('Quadras', style: theme.textTheme.titleLarge),
						SizedBox(height: 0.8.h),
						if (establishment.courts.isEmpty)
							Text(
								'Informações de quadras indisponíveis.',
								style: theme.textTheme.bodySmall,
							)
						else
							Column(
								children: establishment.courts
										.map((c) => Container(
													margin: EdgeInsets.only(bottom: 1.h),
													padding: EdgeInsets.all(3.w),
													decoration: BoxDecoration(
														color: Theme.of(context).colorScheme.surface,
														borderRadius: BorderRadius.circular(12),
														boxShadow: [
															BoxShadow(
																color: Theme.of(context)
																		.shadowColor
																		.withOpacity(0.05),
																blurRadius: 8,
																offset: const Offset(0, 3),
															),
														],
													),
													child: Row(
														children: [
															Icon(Icons.sports_tennis,
																	color: Theme.of(context).primaryColor),
															SizedBox(width: 3.w),
															Expanded(
																child: Column(
																	crossAxisAlignment: CrossAxisAlignment.start,
																	children: [
																		Text(
																			c.name,
																			style: theme.textTheme.titleMedium
																					?.copyWith(fontWeight: FontWeight.w600),
																		),
																		SizedBox(height: 0.3.h),
																		Text(
																			'Funcionamento: ${c.workingHours}',
																			style: theme.textTheme.bodySmall,
																		),
																	],
																),
															),
														],
													),
												))
										.toList(),
							),

						SizedBox(height: 8.h), // espaço para o FAB
					],
				),
			),
		);
	}
}

class _Header extends StatelessWidget {
	final Establishment establishment;
	const _Header({required this.establishment});

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final hasImage = establishment.imageUrl.isNotEmpty;

		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				ClipRRect(
					borderRadius: BorderRadius.circular(16),
					child: AspectRatio(
						aspectRatio: 16 / 9,
						child: hasImage
								? Image.network(
										establishment.imageUrl,
										fit: BoxFit.cover,
										errorBuilder: (context, error, stack) => Container(
											color: Theme.of(context).colorScheme.surfaceContainerHighest,
											child: const Center(
												child: Icon(Icons.image_not_supported_outlined, size: 48),
											),
										),
									)
								: Container(
										color: Theme.of(context).colorScheme.surfaceContainerHighest,
										child: const Center(
											child: Icon(Icons.business_outlined, size: 48),
										),
									),
					),
				),
				SizedBox(height: 1.6.h),
				Text(
					establishment.name,
					style: theme.textTheme.headlineMedium,
				),
				SizedBox(height: 0.6.h),
				Row(
					children: [
						Icon(Icons.location_on,
								size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
						SizedBox(width: 1.w),
						Expanded(
							child: Text(
								establishment.address.shortAddress.isNotEmpty
										? establishment.address.shortAddress
										: 'Local não informado',
								style: theme.textTheme.bodySmall
										?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
								maxLines: 1,
								overflow: TextOverflow.ellipsis,
							),
						),
					],
				),
			],
		);
	}
}

class _InfoTile extends StatelessWidget {
	final IconData icon;
	final String title;
	const _InfoTile({required this.icon, required this.title});

	@override
	Widget build(BuildContext context) {
		return Container(
			width: double.infinity,
			padding: EdgeInsets.all(3.w),
			decoration: BoxDecoration(
				color: Theme.of(context).colorScheme.surface,
				borderRadius: BorderRadius.circular(12),
				boxShadow: [
					BoxShadow(
						color: Theme.of(context).shadowColor.withOpacity(0.06),
						blurRadius: 8,
						offset: const Offset(0, 3),
					),
				],
			),
			child: Row(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Icon(icon, color: Theme.of(context).primaryColor),
					SizedBox(width: 3.w),
					Expanded(
						child: Text(
							title,
							style: Theme.of(context).textTheme.bodyMedium,
						),
					),
				],
			),
		);
	}
}

class _ErrorView extends StatelessWidget {
	final String message;
	final VoidCallback onRetry;
	const _ErrorView({required this.message, required this.onRetry});

	@override
	Widget build(BuildContext context) {
		return Center(
			child: Padding(
				padding: const EdgeInsets.all(24.0),
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						Icon(Icons.error_outline,
								size: 56,
								color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
						const SizedBox(height: 12),
						Text(message, textAlign: TextAlign.center),
						const SizedBox(height: 12),
						ElevatedButton(onPressed: onRetry, child: const Text('Tentar novamente')),
					],
				),
			),
		);
	}
}

