// Core Exports
export 'core/config/app_config.dart';
export 'core/config/firebase_options.dart';
export 'core/constants/app_constants.dart';
export 'core/theme/app_theme.dart';
export 'core/utils/app_router.dart';

// Shared Models
export 'shared/models/user_model.dart';
export 'shared/models/cart_model.dart';
export 'shared/models/restaurant_model.dart';
export 'shared/models/notification_model.dart';

// Shared Providers
export 'shared/providers/app_provider.dart';
export 'shared/providers/auth_provider.dart';
export 'shared/providers/cart_provider.dart';
export 'shared/providers/location_provider.dart';
export 'shared/providers/notification_provider.dart';
export 'shared/providers/network_provider.dart';

// Shared Services
export 'shared/services/api_service.dart';
export 'shared/services/admin_api_service.dart';
export 'shared/services/data_repository.dart';
export 'shared/services/notification_service.dart';

// Shared Widgets
export 'shared/widgets/custom_button.dart';
export 'shared/widgets/custom_text_field.dart';
export 'shared/widgets/otp_input_field.dart';
export 'shared/widgets/social_login_button.dart';
export 'shared/widgets/cached_image.dart';
export 'shared/widgets/loading_widgets.dart';
export 'shared/widgets/empty_error_states.dart';
export 'shared/widgets/custom_app_bar.dart';
export 'shared/widgets/bottom_sheet_handle.dart';

// Features
export 'features/auth/presentation/screens/login_screen.dart';
export 'features/auth/presentation/screens/register_screen.dart';
export 'features/auth/presentation/screens/otp_screen.dart';
export 'features/home/presentation/screens/home_screen.dart';
export 'features/restaurant/presentation/screens/restaurant_screen.dart';
export 'features/restaurant/presentation/screens/product_detail_screen.dart';
export 'features/cart/presentation/screens/checkout_screen.dart';
export 'features/order/presentation/screens/order_tracking_screen.dart';
export 'features/profile/presentation/screens/profile_screen.dart';
export 'features/notifications/presentation/screens/notifications_screen.dart';
export 'features/support/presentation/screens/support_screen.dart';