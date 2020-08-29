import 'dart:async';
import 'dart:convert';
import 'package:sahyog/location.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'global.dart';

List<Job> data;
String position;
String company;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isloading;
  List<Job> data = List<Job>();

  @override
  Widget build(BuildContext context) {
    if (isloading == true) {
      return CircularProgressIndicator();
    } else {
      return _jobsListView(data);
    }
    // isloading != true ? _jobsListView(data) : CircularProgressIndicator();
    // return FutureBuilder<List<Job>>(
    //   future: _fetchJobs(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       return _jobsListView(data);
    //     } else if (snapshot.hasError) {
    //       return Text("${snapshot.error}");
    //     }
    //     return CircularProgressIndicator();
    //   },
    // );
  }

  Future<List<Job>> _fetchJobs() async {
    setState(() {
      isloading = true;
    });
    final jobsAPIUrl = 'https://mock-json-service.glitch.me/';
    final response = await http.get(jobsAPIUrl);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      data = jsonResponse.map((job) => new Job.fromJson(job)).toList();
      setState(() {
        isloading = false;
      });
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
                Button(xyz: data[index]),
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
                ),
              ],
            ),
          );
        });
  }
}

class Button extends StatelessWidget {
  Job xyz;
  Button({
    this.xyz,
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
        Share.share('''${xyz.position} , ${xyz.company}''',
            subject: xyz.description,
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      },
    );
  }
}
