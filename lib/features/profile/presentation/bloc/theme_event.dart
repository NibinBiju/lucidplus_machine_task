abstract class ThemeEvent {}

class LoadThemeEvent extends ThemeEvent {
  final String userId;
  LoadThemeEvent(this.userId);
}

class ToggleThemeEvent extends ThemeEvent {
  final String userId;
  final bool isDarkMode;
  ToggleThemeEvent({
    required this.userId,
    required this.isDarkMode,
  });
}
