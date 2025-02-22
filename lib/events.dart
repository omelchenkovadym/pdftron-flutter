part of pdftron;

const _exportAnnotationCommandChannel =
    const EventChannel('export_annotation_command_event');
const _exportBookmarkChannel = const EventChannel('export_bookmark_event');
const _documentLoadedChannel = const EventChannel('document_loaded_event');
const _documentErrorChannel = const EventChannel('document_error_event');
const _annotationChangedChannel =
    const EventChannel('annotation_changed_event');
const _annotationsSelectedChannel =
    const EventChannel('annotations_selected_event');
const _formFieldValueChangedChannel =
    const EventChannel('form_field_value_changed_event');

typedef void ExportAnnotationCommandListener(dynamic xfdfCommand);
typedef void ExportBookmarkListener(dynamic bookmarkJson);
typedef void DocumentLoadedListener(dynamic filePath);
typedef void DocumentErrorListener();
typedef void AnnotationChangedListener(dynamic action, dynamic annotations);
typedef void AnnotationsSelectedListener(dynamic annotationWithRects);
typedef void FormFieldValueChangedListener(dynamic fields);
typedef void CancelListener();

enum eventSinkId {
  exportAnnotationId,
  exportBookmarkId,
  documentLoadedId,
  documentErrorId,
  annotationChangedId,
  annotationsSelectedId,
  formFieldValueChangedId
}

CancelListener startExportAnnotationCommandListener(
    ExportAnnotationCommandListener listener) {
  var subscription = _exportAnnotationCommandChannel
      .receiveBroadcastStream(eventSinkId.exportAnnotationId.index)
      .listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startExportBookmarkListener(ExportBookmarkListener listener) {
  var subscription = _exportBookmarkChannel
      .receiveBroadcastStream(eventSinkId.exportBookmarkId.index)
      .listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startDocumentLoadedListener(DocumentLoadedListener listener) {
  var subscription = _documentLoadedChannel
      .receiveBroadcastStream(eventSinkId.documentLoadedId.index)
      .listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startDocumentErrorListener(DocumentErrorListener listener) {
  var subscription = _documentErrorChannel
      .receiveBroadcastStream(eventSinkId.documentErrorId.index)
      .listen((stub) {
    listener();
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startAnnotationChangedListener(
    AnnotationChangedListener listener) {
  var subscription = _annotationChangedChannel
      .receiveBroadcastStream(eventSinkId.annotationChangedId.index)
      .listen((annotationsWithActionString) {
    dynamic annotationsWithAction = jsonDecode(annotationsWithActionString);
    String action = annotationsWithAction[EventParameters.action];
    List<dynamic> annotations =
        annotationsWithAction[EventParameters.annotations];
    List<Annot> annotList = new List<Annot>();
    for (dynamic annotation in annotations) {
      annotList.add(new Annot.fromJson(annotation));
    }
    listener(action, annotList);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startAnnotationsSelectedListener(
    AnnotationsSelectedListener listener) {
  var subscription = _annotationsSelectedChannel
      .receiveBroadcastStream(eventSinkId.annotationsSelectedId.index)
      .listen((annotationWithRectsString) {
    List<dynamic> annotationWithRects = jsonDecode(annotationWithRectsString);
    List<AnnotWithRect> annotWithRectList = new List<AnnotWithRect>();
    for (dynamic annotationWithRect in annotationWithRects) {
      annotWithRectList.add(new AnnotWithRect.fromJson(annotationWithRect));
    }
    listener(annotWithRectList);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startFormFieldValueChangedListener(
    FormFieldValueChangedListener listener) {
  var subscription = _formFieldValueChangedChannel
      .receiveBroadcastStream(eventSinkId.formFieldValueChangedId.index)
      .listen((fieldsString) {
    List<dynamic> fields = jsonDecode(fieldsString);
    List<Field> fieldList = new List<Field>();
    for (dynamic field in fields) {
      fieldList.add(new Field.fromJson(field));
    }
    listener(fieldList);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}
