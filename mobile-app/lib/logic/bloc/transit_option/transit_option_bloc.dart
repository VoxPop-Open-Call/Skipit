import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';
import 'package:lisbon_travel/logic/repository/transit_option_repository.dart';
import 'package:lisbon_travel/models/responses/transit_option.dart';

part 'transit_option_bloc.freezed.dart';

part 'transit_option_event.dart';

part 'transit_option_state.dart';

class TransitOptionBloc extends Bloc<TransitOptionEvent, TransitOptionState> {
  final TransitOptionRepository _transitOptionRepository;

  TransitOptionBloc({
    required TransitOptionRepository transitOptionsRepository,
  })  : _transitOptionRepository = transitOptionsRepository,
        super(const TransitOptionState.initial()) {
    on<_Query>(_query);
    on<_GetTransitOptions>(_getTransitOptions);
  }

  Future<void> _query(
    _Query event,
    Emitter<TransitOptionState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(const TransitOptionState.initial());
      return;
    }

    emit(const TransitOptionState.searching());
    final response = await _transitOptionRepository.getList(
      nameContains: event.query.trim(),
      nameCaseInsensitive: true,
    );
    if (response.isRight && response.right.data != null) {
      emit(TransitOptionState.returned(response.right.data!));
    } else {
      emit(TransitOptionState.error(
        response.left.responseData?['message'] ??
            LocaleKeys.cError_oopsTryAgain.tr(),
      ));
    }
  }

  Future<void> _getTransitOptions(
    _GetTransitOptions event,
    Emitter<TransitOptionState> emit,
  ) async {
    if (event.transitNames.isEmpty) {
      emit(const TransitOptionState.initial());
      return;
    }

    emit(const TransitOptionState.searching());
    final response = await _transitOptionRepository.getList(
      nameIn: event.transitNames,
      nameCaseInsensitive: true,
    );
    if (response.isRight && response.right.data != null) {
      final searchResult = response.right.data!.toList();
      emit(TransitOptionState.returned(searchResult));
    } else {
      emit(TransitOptionState.error(response.left.responseData?['message']));
    }
  }
}
