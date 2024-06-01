import 'dart:async';

StreamTransformer<String, String> phoneTransformer =
    StreamTransformer.fromHandlers(handleData: (s, sink) {
  if (s.trim().isEmpty ||
      (s.length == 10 && (s[0] == '9' || s[0] == '8' || s[0] == '7'))) {
    sink.add(s);
  } else {
    sink.addError('Invalid mobile number');
  }
});
StreamTransformer<String, String> nameTransformer =
    StreamTransformer.fromHandlers(handleData: (s, sink) {
  if ((s == null || s.isEmpty) || s.split(' ').length == 2) {
    sink.add(s);
  } else {
    sink.addError('First and last name is required');
  }
});

StreamTransformer<String, String> titleTransformer =
    StreamTransformer.fromHandlers(handleData: (s, sink) {
  if (s.trim().isEmpty || s.trim().length > 6) {
    sink.add(s);
  } else {
    sink.addError('Product name must have atleast 6 characters');
  }
});
StreamTransformer<String, String> sellingPriceTransformer =
    StreamTransformer.fromHandlers(handleData: (s, sink) {
  if (s.trim().isEmpty || s.trim().length > 2) {
    sink.add(s);
  } else {
    sink.addError('Provide valid selling price');
  }
});
StreamTransformer<String, String> localityTransformer =
    StreamTransformer.fromHandlers(handleData: (s, sink) {
  if (s.trim().isEmpty || s.trim().length > 3) {
    sink.add(s);
  } else {
    sink.addError('Locality name invalid');
  }
});

StreamTransformer<String, String> detailsTransformer =
    StreamTransformer.fromHandlers(handleData: (s, sink) {
  if (s.trim().isEmpty || s.trim().length > 30) {
    sink.add(s);
  } else {
    sink.addError('Please describe your product in details');
  }
});

StreamTransformer<String, String> emailTransformer =
    StreamTransformer.fromHandlers(handleData: (s, sink) {
  if ((s == null || s.isEmpty) || (s.contains('@') && s.contains('.'))) {
    sink.add(s);
  } else {
    sink.addError('invalid email id format');
  }
});
