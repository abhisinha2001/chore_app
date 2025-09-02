import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/housemate.dart';
import '../widgets/activity_tile.dart';
import '../widgets/custom_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Activity> activities = [];
  List<Housemate> housemates = [];

  final List<Color> housemateColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  void _showAddHousemateDialog() {
    final _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Housemate'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  final alreadyExists = housemates.any(
                      (h) => h.name.toLowerCase() == name.toLowerCase());
                  if (alreadyExists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Housemate "$name" already exists')),
                    );
                    return;
                  }
                  final color = housemateColors[
                      housemates.length % housemateColors.length];
                  setState(() {
                    housemates.add(Housemate(name: name, color: color));
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddActivityDialog() {
    final _activityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Activity'),
          content: TextField(
            controller: _activityController,
            decoration: InputDecoration(
              labelText: 'Activity Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = _activityController.text.trim();
                if (title.isNotEmpty) {
                  final alreadyExists = activities.any(
                      (a) => a.title.toLowerCase() == title.toLowerCase());
                  if (alreadyExists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Activity "$title" already exists')),
                    );
                    return;
                  }
                  setState(() {
                    activities.add(Activity(title: title));
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _onActivityTap(Activity activity) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tapped on ${activity.title}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '👋 Hi there!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    text: 'Add Housemate',
                    onPressed: _showAddHousemateDialog,
                    backgroundColor: Colors.green,
                  ),
                  CustomButton(
                    text: 'Add Activity',
                    onPressed: _showAddActivityDialog,
                    backgroundColor: Colors.blue,
                  ),
                ],
              ),

              SizedBox(height: 20),

              Expanded(
                child: activities.isEmpty
                    ? Center(child: Text('No activities yet.'))
                    : GridView.builder(
                        itemCount: activities.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1, // square tiles
                        ),
                        itemBuilder: (context, index) {
                          final activity = activities[index];
                          return GestureDetector(
                            onTap: () => _onActivityTap(activity),
                            child: ActivityTile(activity: activity),
                          );
                        },
                      ),
              ),

              SizedBox(height: 20),

              if (housemates.isNotEmpty)
                Text(
                  'Housemates:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

              SizedBox(height: 8),

              if (housemates.isNotEmpty)
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: housemates.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final h = housemates[index];
                      return Chip(
                        avatar: CircleAvatar(backgroundColor: h.color, radius: 12),
                        label: Text(
                          h.name,
                          style: TextStyle(fontSize: 12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
