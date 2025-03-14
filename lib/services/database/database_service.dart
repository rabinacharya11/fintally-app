import 'package:cloud_firestore/cloud_firestore.dart';

/// Provides Firestore database functionality with CRUD operations
class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get a document by ID from a collection
  ///
  /// [collectionPath] The path to the collection
  /// [documentId] The ID of the document to retrieve
  /// Returns a DocumentSnapshot
  Future<DocumentSnapshot> getDocument(
    String collectionPath,
    String documentId,
  ) async {
    try {
      return await _firestore.collection(collectionPath).doc(documentId).get();
    } catch (e) {
      throw Exception('Failed to get document: ${e.toString()}');
    }
  }

  /// Get all documents from a collection
  ///
  /// [collectionPath] The path to the collection
  /// Returns a QuerySnapshot containing all documents
  Future<QuerySnapshot> getCollection(String collectionPath) async {
    try {
      return await _firestore.collection(collectionPath).get();
    } catch (e) {
      throw Exception('Failed to get collection: ${e.toString()}');
    }
  }

  /// Stream a document for real-time updates
  ///
  /// [collectionPath] The path to the collection
  /// [documentId] The ID of the document to stream
  /// Returns a Stream of DocumentSnapshot
  Stream<DocumentSnapshot> streamDocument(
    String collectionPath,
    String documentId,
  ) {
    return _firestore.collection(collectionPath).doc(documentId).snapshots();
  }

  /// Stream a collection for real-time updates
  ///
  /// [collectionPath] The path to the collection
  /// Returns a Stream of QuerySnapshot
  Stream<QuerySnapshot> streamCollection(String collectionPath) {
    return _firestore.collection(collectionPath).snapshots();
  }

  /// Add a new document to a collection with auto-generated ID
  ///
  /// [collectionPath] The path to the collection
  /// [data] The document data as a Map
  /// Returns the DocumentReference of the created document
  Future<DocumentReference> addDocument(
    String collectionPath,
    Map<String, dynamic> data,
  ) async {
    try {
      return await _firestore.collection(collectionPath).add(data);
    } catch (e) {
      throw Exception('Failed to add document: ${e.toString()}');
    }
  }

  /// Create or update a document with a specific ID
  ///
  /// [collectionPath] The path to the collection
  /// [documentId] The ID for the document
  /// [data] The document data as a Map
  /// [merge] Whether to merge with existing data (default: true)
  Future<void> setDocument(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data, {
    bool merge = true,
  }) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(documentId)
          .set(data, SetOptions(merge: merge));
    } catch (e) {
      throw Exception('Failed to set document: ${e.toString()}');
    }
  }

  /// Update specific fields of an existing document
  ///
  /// [collectionPath] The path to the collection
  /// [documentId] The ID of the document to update
  /// [data] The document data to update as a Map
  Future<void> updateDocument(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).update(data);
    } catch (e) {
      throw Exception('Failed to update document: ${e.toString()}');
    }
  }

  /// Delete a document
  ///
  /// [collectionPath] The path to the collection
  /// [documentId] The ID of the document to delete
  Future<void> deleteDocument(String collectionPath, String documentId) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: ${e.toString()}');
    }
  }

  /// Query documents with filters
  ///
  /// [collectionPath] The path to the collection
  /// [field] The field to filter on
  /// [isEqualTo] Value that the field should equal
  /// [isNotEqualTo] Value that the field should not equal
  /// [isLessThan] Value that the field should be less than
  /// [isLessThanOrEqualTo] Value that the field should be less than or equal to
  /// [isGreaterThan] Value that the field should be greater than
  /// [isGreaterThanOrEqualTo] Value that the field should be greater than or equal to
  /// [arrayContains] Value that should be in an array field
  /// [limit] Maximum number of documents to return
  /// [orderBy] Field to order results by
  /// [descending] Whether to order in descending order
  Future<QuerySnapshot> queryDocuments({
    required String collectionPath,
    String? field,
    dynamic isEqualTo,
    dynamic isNotEqualTo,
    dynamic isLessThan,
    dynamic isLessThanOrEqualTo,
    dynamic isGreaterThan,
    dynamic isGreaterThanOrEqualTo,
    dynamic arrayContains,
    int? limit,
    String? orderBy,
    bool descending = false,
  }) async {
    try {
      Query query = _firestore.collection(collectionPath);

      if (field != null) {
        if (isEqualTo != null) {
          query = query.where(field, isEqualTo: isEqualTo);
        }
        if (isNotEqualTo != null) {
          query = query.where(field, isNotEqualTo: isNotEqualTo);
        }
        if (isLessThan != null) {
          query = query.where(field, isLessThan: isLessThan);
        }
        if (isLessThanOrEqualTo != null) {
          query = query.where(field, isLessThanOrEqualTo: isLessThanOrEqualTo);
        }
        if (isGreaterThan != null) {
          query = query.where(field, isGreaterThan: isGreaterThan);
        }
        if (isGreaterThanOrEqualTo != null) {
          query = query.where(
            field,
            isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
          );
        }
        if (arrayContains != null) {
          query = query.where(field, arrayContains: arrayContains);
        }
      }

      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      return await query.get();
    } catch (e) {
      throw Exception('Failed to query documents: ${e.toString()}');
    }
  }

  /// Perform a batch write operation
  ///
  /// [operations] List of batch operations, each containing:
  /// - 'type': String - 'set', 'update', or 'delete'
  /// - 'collectionPath': String - the collection path
  /// - 'documentId': String - the document ID
  /// - 'data': Map<String, dynamic>? - the data (for set/update)
  Future<void> batchWrite(List<Map<String, dynamic>> operations) async {
    try {
      final batch = _firestore.batch();

      for (final operation in operations) {
        final type = operation['type'] as String;
        final collectionPath = operation['collectionPath'] as String;
        final documentId = operation['documentId'] as String;
        final docRef = _firestore.collection(collectionPath).doc(documentId);

        switch (type) {
          case 'set':
            final data = operation['data'] as Map<String, dynamic>;
            final merge = operation['merge'] as bool? ?? true;
            batch.set(docRef, data, SetOptions(merge: merge));
            break;
          case 'update':
            final data = operation['data'] as Map<String, dynamic>;
            batch.update(docRef, data);
            break;
          case 'delete':
            batch.delete(docRef);
            break;
          default:
            throw Exception('Invalid batch operation type: $type');
        }
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to execute batch write: ${e.toString()}');
    }
  }

  /// Run a transaction that reads and writes data
  ///
  /// [updateFunction] Function that defines the transaction operations
  /// Returns the result of the transaction
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) updateFunction,
  ) async {
    try {
      return await _firestore.runTransaction(updateFunction);
    } catch (e) {
      throw Exception('Transaction failed: ${e.toString()}');
    }
  }

  /// Get documents with pagination
  ///
  /// [collectionPath] The path to the collection
  /// [limit] Number of documents per page
  /// [startAfterDocument] Document to start after (for pagination)
  /// [orderBy] Field to order results by
  /// [descending] Whether to order in descending order
  Future<QuerySnapshot> getPaginatedDocuments({
    required String collectionPath,
    required int limit,
    DocumentSnapshot? startAfterDocument,
    String? orderBy,
    bool descending = false,
  }) async {
    try {
      Query query = _firestore.collection(collectionPath);

      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }

      if (startAfterDocument != null) {
        query = query.startAfterDocument(startAfterDocument);
      }

      return await query.limit(limit).get();
    } catch (e) {
      throw Exception('Failed to get paginated documents: ${e.toString()}');
    }
  }
}
