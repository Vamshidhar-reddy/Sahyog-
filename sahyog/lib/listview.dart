import 'dart:async';
import 'dart:convert';
import 'package:sahyog/location.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'global.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
      future: _fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Job> data = snapshot.data;
          return _jobsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Job>> _fetchJobs() async {
    final jobsAPIUrl = 'https://mock-json-service.glitch.me/';
    final response = await http.get(jobsAPIUrl);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  void initState() {
    super.initState();
    _fetchJobs();
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3.0,
            child: Slidable(
              // dismissal: SlidableDismissal(
              //   child: SlidableDrawerDismissal(),
              //   onDismissed: (actionType) {
              //     setState(() {
              //       data.removeAt(index);
              //     });
              //   },
              // ),
              // key: Key(data[index]),
              actionPane: SlidableDrawerActionPane(),
              child: ListTile(
                title: Text(data[index].position,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    )),
                subtitle: Text(data[index].company),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Location())),
              ),
              secondaryActions: <Widget>[
                Button(),
                // IconSlideAction(
                //   caption: 'Share',
                //   color: Colors.blueAccent,
                //   icon: Icons.share,
                //   onTap: () {
                //     final RenderBox box = context.findRenderObject();

                //     Share.share(
                //         "${data[index].position} - ${data[index].company}",
                //         // subject: data[index].description,
                //         sharePositionOrigin:
                //             box.localToGlobal(Offset.zero) & box.size);
                //   },
                // ),

                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    setState(() {
                      data.removeAt(index);
                    });
                  },
                  // onTap: () => _showSnackBar('Share'),
                ),
              ],
            ),
          );
        });
  }
}

class Button extends StatelessWidget {
  const Button({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconSlideAction(
      caption: 'Share',
      color: Colors.blueAccent,
      icon: Icons.share,
      onTap: () {
        final RenderBox box = context.findRenderObject();

        Share.share('''${data[index].position} , ${data[index].company}''',
            // subject: data[index].description,
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      },
    );
  }
}
