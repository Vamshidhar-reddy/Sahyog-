import 'dart:async';
import 'dart:convert';
import 'package:sahyog/location.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

class Job {
  final int id;
  final String position;
  final String company;
  final String description;

  Job({this.id, this.position, this.company, this.description});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      position: json['position'],
      company: json['company'],
      description: json['description'],
    );
  }
}

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
                IconSlideAction(
                  caption: 'Share',
                  color: Colors.blueAccent,
                  icon: Icons.share,
                  // onTap: share(context, job),

                  // onTap: () => {}
                  // onTap: () => showSnackBar('Archive'),
                ),
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

share(BuildContext context, Job job) {
  final RenderBox box = context.findRenderObject();

  Share.share("${job.position} - ${job.company}",
      subject: job.description,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
}
