import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bloc_event.dart';
part 'bloc_state.dart';

class BlocBloc extends Bloc<BlocEvent, BlocState> {
  BlocBloc() : super(BlocInitial()) {
    on<BlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
