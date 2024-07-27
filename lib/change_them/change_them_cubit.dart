import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scholar_chat/change_them/change_them_states.dart';

class ChangeThemCubit extends Cubit<ChangeThemStates> {
  ChangeThemCubit() : super(LightModeState());

  void changeThem() {
    if (state is DarkModeState) {
      emit(LightModeState());
    } else if (state is LightModeState) {
      emit(DarkModeState());
    }
  }

}