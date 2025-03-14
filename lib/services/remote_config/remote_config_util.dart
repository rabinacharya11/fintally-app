import 'package:base_flutter_template/services/analytics/analytics_service.dart';
import 'package:base_flutter_template/services/remote_config/remote_config_data_record.dart';
import 'package:base_flutter_template/services/remote_config/remote_shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageData {
  final int version;
  final String title;
  final String description;

  MessageData({
    required this.version,
    required this.title,
    required this.description,
  });
}

class MaintenanceData {
  final int version;
  final String title;
  final String description;

  MaintenanceData({
    required this.version,
    required this.title,
    required this.description,
  });
}

class SurveyData {
  final int version;
  final String surveyQuestion;
  final String surveyTitle;
  final String choiceOne;
  final String choiceTwo;
  final String choiceThree;

  SurveyData({
    required this.version,
    required this.surveyQuestion,
    required this.surveyTitle,
    required this.choiceOne,
    required this.choiceTwo,
    required this.choiceThree,
  });
}

class PromotionData {
  final int version;
  final String promotionTitle;
  final String promotionDescription;
  final String promotionURL;
  final String promotionImageURL;

  PromotionData({
    required this.version,
    required this.promotionTitle,
    required this.promotionDescription,
    required this.promotionURL,
    required this.promotionImageURL,
  });
}

class RemoteConfigUtil {
  static messageDialog(BuildContext context, {required MessageData data}) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      data.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(data.description, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        RemoteSharedPreference.storeMessageVersion(
                          data.version,
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            'Okay',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    RemoteSharedPreference.storeMessageVersion(data.version);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Dialog for survey
  static surveyDialog(BuildContext context, {required SurveyData data}) {
    showDialog(
      context: context,
      builder: (context) {
        String answer = '';
        return Dialog(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      data.surveyTitle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),

                    Text(data.surveyQuestion, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 16),

                    TextFormField(
                      readOnly: true,
                      onTap: () => answer = data.choiceOne,
                      decoration: InputDecoration(
                        hintText: data.choiceOne,
                        hintStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      onTap: () => answer = data.choiceTwo,
                      decoration: InputDecoration(
                        hintText: data.choiceTwo,
                        hintStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      onTap: () => answer = data.choiceThree,
                      decoration: InputDecoration(
                        hintText: data.choiceThree,
                        hintStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          RemoteSharedPreference.storeSurveyVersion(
                            data.version,
                          );
                          RemoteConfigDataRecord.recordSurveyData(
                            surveyData: data,
                            answer: answer,
                          );
                          AnalyticsService().logEvent(
                            name: 'survey_submitted',
                            parameters: {
                              'survey_title': data.surveyTitle,
                              'survey_question': data.surveyQuestion,
                              'answer': answer,
                            },
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .8,
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    RemoteSharedPreference.storePromotionVersion(data.version);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Dialog for promotion
  static promotionDialog(BuildContext context, {required PromotionData data}) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      data.promotionTitle,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      height: 144.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.grey.shade100,
                        image: DecorationImage(
                          image: NetworkImage(data.promotionImageURL),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      data.promotionDescription,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 32.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        // NAVIGATE TO URL
                        RemoteSharedPreference.storePromotionVersion(
                          data.version,
                        );
                        AnalyticsService().logEvent(
                          name: 'promotion_clicked',
                          parameters: {
                            'promotion_title': data.promotionTitle,
                            'promotion_description': data.promotionDescription,
                          },
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            'Okay',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    RemoteSharedPreference.storePromotionVersion(data.version);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static maintenanceDialog(
    BuildContext context, {
    required MaintenanceData data,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      data.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(data.description, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        RemoteSharedPreference.storeMaintenanceVersion(
                          data.version,
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.413,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            'Okay',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    RemoteSharedPreference.storePromotionVersion(data.version);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
