import 'package:flutter/material.dart';
import 'package:groc_pos_app/view/checkout/checkout_functionalities_implementations/live_feed_object_detection/helper_widgets/object_detection_live_detector_widget.dart';

class LiveFeedObjectDetectionFunctionalityWidget extends StatefulWidget {
  LiveFeedObjectDetectionFunctionalityWidget(
      {super.key, required this.checkOutAs});
  final String checkOutAs;

  @override
  State<LiveFeedObjectDetectionFunctionalityWidget> createState() =>
      _LiveFeedObjectDetectionFunctionalityWidgetState();
}

class _LiveFeedObjectDetectionFunctionalityWidgetState
    extends State<LiveFeedObjectDetectionFunctionalityWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: liveDetectorWidget(checkOutAs: widget.checkOutAs),
    );
  }
}
