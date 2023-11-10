import 'package:pdf/widgets.dart' as pw;

class BulletText extends pw.StatelessWidget {
  final String property;
  final String? instance;
  final List<String>? instances;
  final List<BulletText>? bullets;
  double bottomPadding;

  BulletText.simple({
    required this.property,
    required this.instance,
    this.bottomPadding = 10.0,
  })  : assert(instance != null),
        instances = null,
        bullets = null;

  BulletText.list({
    required this.property,
    required this.instances,
    this.bottomPadding = 10.0,
  })  : assert(instances != null),
        instance = null,
        bullets = null;

  BulletText.bullets({
    required this.property,
    required this.bullets,
    this.bottomPadding = 10.0,
  })  : assert(bullets != null),
        instance = null,
        instances = null;

  @override
  pw.Widget build(pw.Context context) {
    pw.Widget instR = pw.SizedBox.shrink();
    List<pw.Widget> instC = [];
    if (instance != null) {
      instR = pw.Text(instance!);
    } else if (instances != null) {
      instC = instances!
          .map((i) => pw.Padding(
                padding: const pw.EdgeInsets.only(left: 20.0),
                child: pw.Text('- $i'),
              ))
          .toList();
    } else if (bullets != null) {
      instC = bullets!.map((b) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(left: 15.0),
          child: b..bottomPadding = 0.0,
        );
      }).toList();
    }

    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: bottomPadding),
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                '$property: ',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              instR,
            ],
          ),
          ...instC,
        ],
      ),
    );
  }
}
