import 'package:base_flutter_template/services/remote_config/remote_config_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RemoteConfigDataRecord {
  // record survery data

  static void recordSurveyData({
    required SurveyData surveyData,
    required String answer,
  }) async {
    /// store is cloud firestore

    final firestore = FirebaseFirestore.instance;

    await firestore
        .collection('survey')
        .doc('survery_${surveyData.version}')
        .collection('answers')
        .add({
          'choice_one': surveyData.choiceOne,
          'choice_two': surveyData.choiceTwo,
          'choice_three': surveyData.choiceThree,
          'choice_answer': answer,
          'survey_question': surveyData.surveyQuestion,
          'survey_title': surveyData.surveyTitle,
          'version': surveyData.version,
          'email': FirebaseAuth.instance.currentUser?.email,
          'uid': FirebaseAuth.instance.currentUser?.uid,
          'name': FirebaseAuth.instance.currentUser?.displayName,
          'photoUrl': FirebaseAuth.instance.currentUser?.photoURL,
          'timestamp': FieldValue.serverTimestamp(),
        });

    // record survey data
  }
}
