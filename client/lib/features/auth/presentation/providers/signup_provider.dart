import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupState {
  final bool isLoading;
  final String? error;

  SignupState({
    this.isLoading = false,
    this.error,
  });

  SignupState copyWith({bool? isLoading, String? error}) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class SignupNotifier extends StateNotifier<SignupState> {
  SignupNotifier() : super(SignupState());

  Future<void> signup(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);


    await Future.delayed(const Duration(seconds: 1));//intentional delya bas abhi ke liye
    


    state = state.copyWith(isLoading: false);
  }
}

final signupProvider =
    StateNotifierProvider<SignupNotifier, SignupState>((ref) {
  return SignupNotifier();
});
