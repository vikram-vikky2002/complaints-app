import 'package:complaint_app/components/basePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComplaintDetails extends StatefulWidget {
  const ComplaintDetails({super.key, required this.data});

  final Map data;

  @override
  State<ComplaintDetails> createState() => _ComplaintDetailsState();
}

class _ComplaintDetailsState extends State<ComplaintDetails> {
  @override
  Widget build(BuildContext context) {
    var titleStyle = const TextStyle(
      color: Colors.white,
      fontFamily: 'Fonarto',
      fontSize: 22,
    );

    var descStyle = const TextStyle(
      color: Colors.white,
      // fontFamily: 'Fonarto',
      fontSize: 16,
    );

    var timeStyle = const TextStyle(
      color: Colors.white,
      // fontFamily: 'Fonarto',
      fontSize: 15,
    );

    return BackgroundPage(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(),
            const SizedBox(height: 40),
            Text(
              '${widget.data['title']}',
              style: titleStyle,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Text(
                '${widget.data['description']}',
                textAlign: TextAlign.justify,
                style: descStyle,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      Text(
                        '  Location',
                        textAlign: TextAlign.justify,
                        style: timeStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                      child: Text(
                        '${widget.data['location'] ?? "..."}',
                        textAlign: TextAlign.justify,
                        style: timeStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Text(
                'Submitted on : ${DateFormat('dd/MM/yyyy hh:mm a').format(widget.data['date'].toDate())}',
                textAlign: TextAlign.justify,
                style: timeStyle,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: widget.data['status'] ? Colors.greenAccent : Colors.grey,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      widget.data['status']
                          ? const Icon(Icons.check)
                          : const Icon(Icons.close),
                      Text(widget.data['status'] ? "Checked" : "Not Checked"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
