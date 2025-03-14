/// Configuration class for Cloudinary settings
class CloudinaryConfig {
  /// Your Cloudinary cloud name
  /// This can be found in your Cloudinary dashboard
  static const String cloudName = 'YOUR_CLOUD_NAME';

  /// Your upload preset for unsigned uploads
  /// Create this in your Cloudinary dashboard under Settings > Upload > Upload presets
  static const String uploadPreset = 'YOUR_UPLOAD_PRESET';

  /// The base URL for Cloudinary resources
  static const String baseUrl = 'https://res.cloudinary.com/$cloudName';

  /// Default folder to upload files to
  static const String defaultFolder = 'app_uploads';

  /// Enable cache for Cloudinary operations
  static const bool useCache = true;
}
