part of 'bloc_bloc.dart';

abstract class BlocState extends Equatable {
  const BlocState();
  
  @override
  List<Object> get props => [];
}

class BlocInitial extends BlocState {}
