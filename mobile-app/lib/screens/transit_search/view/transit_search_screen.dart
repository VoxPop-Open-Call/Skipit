import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';
import 'package:lisbon_travel/logic/bloc/transit_option/transit_option_bloc.dart';
import 'package:lisbon_travel/logic/repository/transit_option_repository.dart';
import 'package:lisbon_travel/models/responses/transit_option.dart';
import 'package:lisbon_travel/screens/transit_search/widgets/transit_details.dart';
import 'package:lisbon_travel/screens/transit_search/widgets/transit_search_bar.dart';

class TransitSearchScreen extends StatelessWidget {
  const TransitSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransitOptionBloc(
        transitOptionsRepository: GetIt.I<TransitOptionRepository>(),
      ),
      child: const TransitSearchView(),
    );
  }
}

class TransitSearchView extends StatefulWidget {
  const TransitSearchView({super.key});

  @override
  State<TransitSearchView> createState() => _TransitSearchViewState();
}

class _TransitSearchViewState extends State<TransitSearchView> {
  TransitOption? selectedTransit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.transitSearch.tr()),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            TransitDetails(transit: selectedTransit),
            TransitSearchBar(
              onTransitSelected: (transit) =>
                  setState(() => selectedTransit = transit),
            ),
          ],
        ),
      ),
    );
  }
}
