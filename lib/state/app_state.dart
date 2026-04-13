import 'package:flutter/material.dart';
import '../models/form_data.dart';

class AppState extends ChangeNotifier {
  String view    = 'landing';
  String lang    = 'en';
  String? role;
  Map<String, dynamic>? selectedApp;
  int    formStep          = 1;
  String reviewDecision    = '';
  String reviewRisk        = 'High';
  String statusFilter      = 'All';
  String riskFilter        = 'All';
  String loginRole         = 'applicant';
  String? formValidationError;

  final FormData formData = FormData();
  RiskResult? submittedResult;

  // ── Navigation ─────────────────────────────────────────────────────────
  void go(String v) {
    if (v == 'apply') formStep = 1;
    view = v;
    notifyListeners();
  }

  void toggleLang() { lang = lang == 'en' ? 'ar' : 'en'; notifyListeners(); }
  void logout()     { role = null; view = 'landing'; notifyListeners(); }

  void setLoginRole(String r) { loginRole = r; notifyListeners(); }

  void doLogin() {
    role = loginRole;
    view = role == 'applicant' ? 'dash' : 'regdash';
    notifyListeners();
  }

  void selectApp(Map<String, dynamic> app, String dest) {
    selectedApp      = app;
    reviewDecision   = '';
    reviewRisk       = app['risk'] as String;
    go(dest);
  }

  // ── Form navigation with validation ────────────────────────────────────
  /// Returns true if navigation was allowed.
  bool formNext() {
    final err = formData.validateStep(formStep);
    if (err != null) {
      formValidationError = err;
      notifyListeners();
      return false;
    }
    formValidationError = null;
    if (formStep < 5) formStep++;
    notifyListeners();
    return true;
  }

  void formPrev() {
    formValidationError = null;
    if (formStep > 1) formStep--;
    notifyListeners();
  }

  void clearValidationError() {
    formValidationError = null;
    notifyListeners();
  }

  // ── Regulator dashboard filters (persist across navigation) ───────────
  void setSF(String f) { statusFilter = f; notifyListeners(); }
  void setRF(String f) { riskFilter   = f; notifyListeners(); }

  // ── Review actions ─────────────────────────────────────────────────────
  void setDecision(String d)   { reviewDecision = d; notifyListeners(); }
  void setReviewRisk(String r) { reviewRisk = r; notifyListeners(); }
  void submitReview() { if (reviewDecision.isNotEmpty) go('reviewdone'); }

  // ── Form field toggles ─────────────────────────────────────────────────
  void toggleAiType(String t) {
    formData.selectedAiTypes.contains(t)
        ? formData.selectedAiTypes.remove(t)
        : formData.selectedAiTypes.add(t);
    notifyListeners();
  }

  void toggleDataType(String t) {
    formData.selectedDataTypes.contains(t)
        ? formData.selectedDataTypes.remove(t)
        : formData.selectedDataTypes.add(t);
    notifyListeners();
  }

  void toggleRisk(String r) {
    formData.selectedRisks.contains(r)
        ? formData.selectedRisks.remove(r)
        : formData.selectedRisks.add(r);
    notifyListeners();
  }

  void setStage(String s)               { formData.selectedStage          = s; notifyListeners(); }
  void setMakesDecisions(bool v)        { formData.makesDecisions          = v; notifyListeners(); }
  void setHumanOversight(bool v)        { formData.hasHumanOversight       = v; notifyListeners(); }
  void setProcessesSensitiveData(bool v){ formData.processesSensitiveData  = v; notifyListeners(); }

  void setUploadedFile(String docType, String fileName) {
    formData.uploadedFiles[docType] = fileName;
    notifyListeners();
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────
  void resetForm() {
    formData.reset();
    formStep            = 1;
    formValidationError = null;
    notifyListeners();
  }

  void submitForm() {
    submittedResult = RiskScorer.score(formData);
    go('success');
  }

  @override
  void dispose() {
    formData.dispose();
    super.dispose();
  }
}
