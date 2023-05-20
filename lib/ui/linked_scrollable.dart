part of turbocal;

class LinkedScrollableControlPoint {
  double offset = 0;
  final StreamController<double> _streamController =
      StreamController.broadcast();

  Stream<double> getStream() {
    return _streamController.stream;
  }

  void update(double newOffset) {
    offset = newOffset;
    _streamController.add(newOffset);
  }
}

class LinkedScrollable extends StatefulWidget {
  final Column child;
  final bool isLinked;
  final LinkedScrollableControlPoint controlPoint;

  const LinkedScrollable({
    required this.child,
    required this.isLinked,
    required this.controlPoint,
    super.key,
  });
  @override
  State<LinkedScrollable> createState() => LinkedScrollableState();
}

class LinkedScrollableState extends State<LinkedScrollable> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController(
      initialScrollOffset: widget.controlPoint.offset,
    );
    widget.controlPoint.getStream().listen((double newOffset) {
      setState(() {
        scrollController.jumpTo(newOffset);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (widget.isLinked) {
          Future.delayed(const Duration(microseconds: 10), () {
            widget.controlPoint.update(scrollController.offset);
          });
        }
        return true;
      },
      child: SingleChildScrollView(
        controller: scrollController,
        child: widget.child,
      ),
    );
  }
}
