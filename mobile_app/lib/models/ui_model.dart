class UIModel<T>{
  final T? data;
  final Object? error;
  final UIState state;

  UIModel.success(this.data):
        error = null,
        state = UIState.success;

  UIModel.error(this.error):
      data = null,
      state = UIState.error;

  UIModel.loading():
      data = null,
      error = null,
      state = UIState.loading;
}

enum UIState{
  success,
  error,
  loading,
}