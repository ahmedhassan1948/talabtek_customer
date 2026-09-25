import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFFF6B35);
  static const Color primaryLight = Color(0xFFFF8A5B);
  static const Color primaryDark = Color(0xFFE85D2D);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color secondaryLight = Color(0xFF66BB6A);
  static const Color secondaryDark = Color(0xFF43A047);
  static const Color accentColor = Color(0xFF2196F3);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color infoColor = Color(0xFF2196F3);
  
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color surfaceVariantColor = Color(0xFFF5F5F5);
  static const Color outlineColor = Color(0xFFE0E0E0);
  static const Color dividerColor = Color(0xFFEEEEEE);
  
  static const Color onPrimaryColor = Color(0xFFFFFFFF);
  static const Color onSecondaryColor = Color(0xFFFFFFFF);
  static const Color onBackgroundColor = Color(0xFF1A1A2E);
  static const Color onSurfaceColor = Color(0xFF1A1A2E);
  static const Color onSurfaceVariantColor = Color(0xFF616161);
  
  static const Color shadowColor = Color(0x1A000000);
  
  static const Color gradientStart = Color(0xFFFF6B35);
  static const Color gradientEnd = Color(0xFFFF8A5B);
  
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      primaryContainer: primaryLight.withOpacity(0.1),
      onPrimaryContainer: primaryDark,
      secondary: secondaryColor,
      onSecondary: onSecondaryColor,
      secondaryContainer: secondaryLight.withOpacity(0.1),
      onSecondaryContainer: secondaryDark,
      tertiary: accentColor,
      onTertiary: onPrimaryColor,
      tertiaryContainer: accentColor.withOpacity(0.1),
      onTertiaryContainer: accentColor,
      error: errorColor,
      onError: onPrimaryColor,
      errorContainer: errorColor.withOpacity(0.1),
      onErrorContainer: errorColor,
      surface: surfaceColor,
      onSurface: onSurfaceColor,
      surfaceContainerHighest: surfaceVariantColor,
      onSurfaceVariant: onSurfaceVariantColor,
      outline: outlineColor,
      outlineVariant: dividerColor,
      shadow: shadowColor,
      scrim: shadowColor,
      inverseSurface: onBackgroundColor,
      onInverseSurface: surfaceColor,
      inversePrimary: primaryLight,
    );
    
    final TextTheme textTheme = TextTheme(
      displayLarge: GoogleFonts.tajawal(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: onBackgroundColor,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.tajawal(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: onBackgroundColor,
        height: 1.3,
      ),
      displaySmall: GoogleFonts.tajawal(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: onBackgroundColor,
        height: 1.3,
      ),
      headlineLarge: GoogleFonts.tajawal(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: onBackgroundColor,
        height: 1.4,
      ),
      headlineMedium: GoogleFonts.tajawal(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onBackgroundColor,
        height: 1.4,
      ),
      headlineSmall: GoogleFonts.tajawal(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: onBackgroundColor,
        height: 1.4,
      ),
      titleLarge: GoogleFonts.tajawal(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: onBackgroundColor,
        height: 1.5,
      ),
      titleMedium: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: onBackgroundColor,
        height: 1.5,
      ),
      titleSmall: GoogleFonts.tajawal(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: onSurfaceVariantColor,
        height: 1.5,
      ),
      bodyLarge: GoogleFonts.tajawal(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: onBackgroundColor,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: onBackgroundColor,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.tajawal(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: onSurfaceVariantColor,
        height: 1.5,
      ),
      labelLarge: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: onPrimaryColor,
        height: 1.5,
      ),
      labelMedium: GoogleFonts.tajawal(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: onSurfaceVariantColor,
        height: 1.5,
      ),
      labelSmall: GoogleFonts.tajawal(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: onSurfaceVariantColor,
        height: 1.5,
      ),
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: GoogleFonts.tajawal().fontFamily,
      scaffoldBackgroundColor: backgroundColor,
      canvasColor: surfaceColor,
      dividerColor: dividerColor,
      shadowColor: shadowColor,
      indicatorColor: primaryColor,
      
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        backgroundColor: surfaceColor,
        foregroundColor: onBackgroundColor,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(
          color: onBackgroundColor,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: onBackgroundColor,
          size: 24,
        ),
        shape: const Border(
          bottom: BorderSide(color: dividerColor, width: 1),
        ),
      ),
      
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 8,
        surfaceTintColor: Colors.transparent,
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: onSurfaceVariantColor,
        selectedLabelStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      
      navigationBarTheme: NavigationBarThemeData(
        elevation: 8,
        surfaceTintColor: Colors.transparent,
        backgroundColor: surfaceColor,
        indicatorColor: primaryColor.withOpacity(0.1),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: primaryColor,
            );
          }
          return textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w400,
            color: onSurfaceVariantColor,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: primaryColor, size: 24);
          }
          return IconThemeData(color: onSurfaceVariantColor, size: 24);
        }),
      ),
      
      cardTheme: CardThemeData(
        elevation: 2,
        surfaceTintColor: Colors.transparent,
        color: surfaceColor,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: dividerColor, width: 1),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          backgroundColor: primaryColor,
          foregroundColor: onPrimaryColor,
          disabledBackgroundColor: outlineColor,
          disabledForegroundColor: onSurfaceVariantColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge,
          shadowColor: shadowColor,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return primaryDark.withOpacity(0.1);
            }
            return Colors.transparent;
          }),
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          disabledForegroundColor: onSurfaceVariantColor,
          side: BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            color: primaryColor,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          disabledForegroundColor: onSurfaceVariantColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          minimumSize: const Size(88, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            color: primaryColor,
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariantColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: outlineColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: outlineColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: dividerColor, width: 1),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: onSurfaceVariantColor,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: onSurfaceVariantColor.withOpacity(0.6),
        ),
        errorStyle: textTheme.bodySmall?.copyWith(
          color: errorColor,
        ),
        floatingLabelStyle: textTheme.bodySmall?.copyWith(
          color: primaryColor,
          fontWeight: FontWeight.w500,
        ),
        prefixIconColor: onSurfaceVariantColor,
        suffixIconColor: onSurfaceVariantColor,
      ),
      
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariantColor,
        disabledColor: surfaceVariantColor.withOpacity(0.5),
        selectedColor: primaryColor.withOpacity(0.1),
        secondarySelectedColor: secondaryColor.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: onBackgroundColor,
        ),
        secondaryLabelStyle: textTheme.bodyMedium?.copyWith(
          color: primaryColor,
        ),
        brightness: Brightness.light,
        elevation: 0,
        pressElevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: outlineColor, width: 1),
        ),
        selectedShadowColor: primaryColor.withOpacity(0.3),
      ),
      
      dialogTheme: DialogThemeData(
        elevation: 8,
        surfaceTintColor: Colors.transparent,
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: textTheme.bodyMedium,
        actionsAlignment: MainAxisAlignment.end,
      ),
      
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 8,
        surfaceTintColor: Colors.transparent,
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        modalBackgroundColor: surfaceColor,
        constraints: const BoxConstraints(maxWidth: double.infinity),
        showDragHandle: true,
        dragHandleColor: outlineColor,
        dragHandleSize: const Size(36, 4),
      ),
      
      snackBarTheme: SnackBarThemeData(
        elevation: 8,
        surfaceTintColor: Colors.transparent,
        backgroundColor: onBackgroundColor,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: surfaceColor,
        ),
        actionTextColor: primaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.all(16),
      ),
      
      tabBarTheme: TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: onSurfaceVariantColor,
        indicatorColor: primaryColor,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        dividerColor: Colors.transparent,
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return primaryColor.withOpacity(0.1);
          }
          return Colors.transparent;
        }),
      ),
      
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        titleTextStyle: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: onSurfaceVariantColor,
        ),
        leadingAndTrailingTextStyle: textTheme.bodyMedium,
        iconColor: onSurfaceVariantColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: primaryColor.withOpacity(0.05),
        selectedColor: primaryColor,
      ),
      
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        surfaceTintColor: Colors.transparent,
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        extendedTextStyle: textTheme.labelLarge,
        extendedIconLabelSpacing: 8,
      ),
      
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
        indent: 16,
        endIndent: 16,
      ),
      
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: primaryColor.withOpacity(0.1),
        circularTrackColor: primaryColor.withOpacity(0.1),
        refreshBackgroundColor: surfaceColor,
      ),
      
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: primaryColor.withOpacity(0.1),
        thumbColor: primaryColor,
        overlayColor: primaryColor.withOpacity(0.1),
        valueIndicatorColor: primaryColor,
        valueIndicatorTextStyle: textTheme.bodySmall?.copyWith(
          color: onPrimaryColor,
        ),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      ),
      
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return outlineColor;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withOpacity(0.3);
          }
          return outlineColor.withOpacity(0.5);
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return outlineColor;
        }),
      ),
      
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(onPrimaryColor),
        side: BorderSide(color: outlineColor, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return onSurfaceVariantColor;
        }),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: onBackgroundColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: surfaceColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        preferBelow: true,
        verticalOffset: 8,
      ),
      
      datePickerTheme: DatePickerThemeData(
        surfaceTintColor: Colors.transparent,
        backgroundColor: surfaceColor,
        headerBackgroundColor: primaryColor,
        headerForegroundColor: onPrimaryColor,
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.transparent;
        }),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return onPrimaryColor;
          }
          return onBackgroundColor;
        }),
        todayBackgroundColor: WidgetStateProperty.all(primaryColor.withOpacity(0.1)),
        todayForegroundColor: WidgetStateProperty.all(primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      timePickerTheme: TimePickerThemeData(
        backgroundColor: surfaceColor,
        hourMinuteTextColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return onPrimaryColor;
          }
          return onBackgroundColor;
        }),
        hourMinuteColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.transparent;
        }),
        dayPeriodTextColor: WidgetStateProperty.all(onBackgroundColor),
        dayPeriodColor: WidgetStateProperty.all(Colors.transparent),
        dialHandColor: primaryColor,
        dialBackgroundColor: primaryColor.withOpacity(0.1),
        entryModeIconColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      popupMenuTheme: PopupMenuThemeData(
        surfaceTintColor: Colors.transparent,
        color: surfaceColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: textTheme.bodyMedium,
        padding: EdgeInsets.zero,
      ),
      
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: surfaceColor,
        collapsedBackgroundColor: surfaceColor,
        textColor: onBackgroundColor,
        collapsedTextColor: onBackgroundColor,
        iconColor: onSurfaceVariantColor,
        collapsedIconColor: onSurfaceVariantColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: dividerColor, width: 1),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: dividerColor, width: 1),
        ),
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      colorScheme: lightTheme.colorScheme.copyWith(
        brightness: Brightness.dark,
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
        onSurface: const Color(0xFFFFFFFF),
        onBackground: const Color(0xFFFFFFFF),
        surfaceContainerHighest: const Color(0xFF2C2C2C),
        onSurfaceVariant: const Color(0xFFB0B0B0),
        outline: const Color(0xFF3D3D3D),
        outlineVariant: const Color(0xFF2D2D2D),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardTheme: lightTheme.cardTheme.copyWith(
        color: const Color(0xFF1E1E1E),
        shadowColor: const Color(0x33000000),
      ),
      dividerColor: const Color(0xFF2D2D2D),
      inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(
        fillColor: const Color(0xFF2C2C2C),
        hintStyle: lightTheme.inputDecorationTheme.hintStyle?.copyWith(
          color: const Color(0xFF888888),
        ),
      ),
      bottomNavigationBarTheme: lightTheme.bottomNavigationBarTheme.copyWith(
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      navigationBarTheme: lightTheme.navigationBarTheme.copyWith(
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: const Color(0xFFFFFFFF),
      ),
      bottomSheetTheme: lightTheme.bottomSheetTheme.copyWith(
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      dialogTheme: lightTheme.dialogTheme.copyWith(
        backgroundColor: const Color(0xFF1E1E1E),
      ),
    );
  }
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  Color get primaryColor => colorScheme.primary;
  Color get onPrimaryColor => colorScheme.onPrimary;
  Color get secondaryColor => colorScheme.secondary;
  Color get onSecondaryColor => colorScheme.onSecondary;
  Color get backgroundColor => colorScheme.surface;
  Color get onBackgroundColor => colorScheme.onSurface;
  Color get surfaceColor => colorScheme.surface;
  Color get onSurfaceColor => colorScheme.onSurface;
  Color get errorColor => colorScheme.error;
  Color get onErrorColor => colorScheme.onError;
  Color get outlineColor => colorScheme.outline;
  Color get dividerColor => Theme.of(this).dividerColor;
  
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  bool get isRTL => Directionality.of(this) == TextDirection.rtl;
}