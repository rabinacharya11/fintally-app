import 'dart:io';
import 'dart:typed_data';
import 'package:cloudinary_public/cloudinary_public.dart';
import '../../config/cloudinary_config.dart';

/// Provides Cloudinary functionality for file operations
class CloudinaryService {
  late final CloudinaryPublic _cloudinary;

  /// Initialize Cloudinary service
  CloudinaryService() {
    _cloudinary = CloudinaryPublic(
      CloudinaryConfig.cloudName,
      CloudinaryConfig.uploadPreset,
      cache: CloudinaryConfig.useCache,
    );
  }

  /// Upload a file to Cloudinary
  ///
  /// [file] The file to upload
  /// [folder] Optional folder to upload the file to (default is defined in CloudinaryConfig)
  /// [publicId] Optional public ID for the file
  /// [resourceType] Type of resource (image, video, raw)
  /// [tags] Optional tags to associate with the file
  /// [onProgress] Optional callback for upload progress
  /// Returns a Future with the URL of the uploaded file
  Future<String> uploadFile({
    required File file,
    String? folder,
    String? publicId,
    CloudinaryResourceType resourceType = CloudinaryResourceType.Auto,
    List<String>? tags,
    Function(int count, int total)? onProgress,
  }) async {
    try {
      final cloudinaryFile = CloudinaryFile.fromFile(
        file.path,
        folder: folder ?? CloudinaryConfig.defaultFolder,
        resourceType: resourceType,
        publicId: publicId,
        tags: tags,
      );

      final response = await _cloudinary.uploadFile(
        cloudinaryFile,
        onProgress: onProgress,
      );

      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload file: ${e.toString()}');
    }
  }

  /// Upload multiple files to Cloudinary
  ///
  /// [files] List of files to upload
  /// [folder] Optional folder to upload the files to (default is defined in CloudinaryConfig)
  /// [resourceType] Type of resource (image, video, raw)
  /// [tags] Optional tags to associate with the files
  /// Returns a Future with a list of URLs of the uploaded files
  Future<List<String>> uploadMultipleFiles({
    required List<File> files,
    String? folder,
    CloudinaryResourceType resourceType = CloudinaryResourceType.Auto,
    List<String>? tags,
  }) async {
    try {
      // Create a list of Future<CloudinaryFile> as required by multiUpload
      final cloudinaryFiles =
          files
              .map(
                (file) => Future.value(
                  CloudinaryFile.fromFile(
                    file.path,
                    folder: folder ?? CloudinaryConfig.defaultFolder,
                    resourceType: resourceType,
                    tags: tags,
                  ),
                ),
              )
              .toList();

      final responses = await _cloudinary.multiUpload(cloudinaryFiles);

      return responses.map((response) => response.secureUrl).toList();
    } catch (e) {
      throw Exception('Failed to upload files: ${e.toString()}');
    }
  }

  /// Upload bytes data to Cloudinary
  ///
  /// [bytes] The bytes data to upload
  /// [folder] Optional folder to upload the file to (default is defined in CloudinaryConfig)
  /// [fileName] Name for the file
  /// [resourceType] Type of resource (image, video, raw)
  /// [tags] Optional tags to associate with the file
  /// [onProgress] Optional callback for upload progress
  /// Returns a Future with the URL of the uploaded file
  Future<String> uploadBytes({
    required Uint8List bytes,
    String? folder,
    required String fileName,
    CloudinaryResourceType resourceType = CloudinaryResourceType.Auto,
    List<String>? tags,
    Function(int count, int total)? onProgress,
  }) async {
    try {
      final cloudinaryFile = CloudinaryFile.fromByteData(
        bytes.buffer.asByteData(),
        folder: folder ?? CloudinaryConfig.defaultFolder,
        resourceType: resourceType,
        identifier: fileName,
        tags: tags,
      );

      final response = await _cloudinary.uploadFile(
        cloudinaryFile,
        onProgress: onProgress,
      );

      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload bytes: ${e.toString()}');
    }
  }

  /// Get a download URL for a file in Cloudinary
  ///
  /// [publicId] The public ID of the file
  /// [folder] Optional folder where the file is stored
  /// [transformation] Optional transformation parameters (e.g., width, height, crop)
  /// Returns a URL string for the file
  String getDownloadURL({
    required String publicId,
    String? folder,
    Map<String, dynamic>? transformation,
  }) {
    String path = publicId;

    // Add folder if provided
    if (folder != null && folder.isNotEmpty) {
      path = '$folder/$publicId';
    }

    // Generate base URL
    String url = '${CloudinaryConfig.baseUrl}/image/upload/';

    // Add transformations if provided
    if (transformation != null && transformation.isNotEmpty) {
      final transformationString = transformation.entries
          .map((entry) => '${entry.key}_${entry.value}')
          .join(',');
      url += '$transformationString/';
    }

    // Add public ID
    url += path;

    return url;
  }

  /// Create a Cloudinary image URL with transformations
  ///
  /// [publicId] The public ID of the image
  /// [width] Optional width for resizing
  /// [height] Optional height for resizing
  /// [crop] Optional crop mode (fill, fit, etc.)
  /// [gravity] Optional gravity for cropping (face, center, etc.)
  /// [quality] Optional quality (1-100)
  /// [format] Optional format (jpg, png, etc.)
  /// [customTransformations] Optional additional custom transformations
  /// Returns a URL with the specified transformations
  String getImageUrl({
    required String publicId,
    int? width,
    int? height,
    String? crop,
    String? gravity,
    int? quality,
    String? format,
    Map<String, dynamic>? customTransformations,
  }) {
    final Map<String, dynamic> transformations = {};

    if (width != null) transformations['w'] = width;
    if (height != null) transformations['h'] = height;
    if (crop != null) transformations['c'] = crop;
    if (gravity != null) transformations['g'] = gravity;
    if (quality != null) transformations['q'] = quality;

    // Add custom transformations
    if (customTransformations != null) {
      transformations.addAll(customTransformations);
    }

    // Get the base URL with transformations
    String url = getDownloadURL(
      publicId: publicId,
      transformation: transformations,
    );

    // Add format if specified
    if (format != null) {
      final extension = url.split('.').last;
      url = url.replaceAll('.$extension', '.$format');
    }

    return url;
  }

  /// Get a Cloudinary instance
  CloudinaryPublic get cloudinary => _cloudinary;
}
