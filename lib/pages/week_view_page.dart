import 'package:flutter/material.dart';
import 'package:uni_schudle_try1/services/processor.dart';

class WeekViewPage extends StatefulWidget {
  final int secNumber;
  final DateTime selectedDate;
  final Processor _processor;
   const WeekViewPage({super.key, required this.secNumber, required this.selectedDate, required this._processor, });
  @override
  State<WeekViewPage> createState() => _WeekViewPageState();

}

class _WeekViewPageState extends State<WeekViewPage> {
  @override
    void initState() {
      super.initState();
   }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          SizedBox(height: 200),
          _WeekViewHeader(),
          Expanded(child: _WeekviewBody()),


        ],

      ),





    );
  }
}
// HEADER

class _WeekViewHeader extends StatelessWidget {
  const _WeekViewHeader();

  @override
  Widget build(BuildContext context) {
    return  Row(
      spacing: 8,
      children: [
      IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
      Text('startweek to endweek'),
      IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward)),
      TextButton(onPressed: () {}, child: Text('Change Section'),)
    ]
    );
  }
}

// HEADER
//=======================================================
//WeekView
class _WeekviewBody extends StatelessWidget {

  const _WeekviewBody();

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: 7,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Row(
              children: [
                CircleAvatar(child: Text('$index'))
              ],
          ),
        );
      },
     
    );
  }
}