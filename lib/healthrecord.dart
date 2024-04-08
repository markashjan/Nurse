import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HealthRecordsPage extends StatefulWidget {
  @override
  _HealthRecordsPageState createState() => _HealthRecordsPageState();
}

class _HealthRecordsPageState extends State<HealthRecordsPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  List<dynamic> records = []; // Placeholder for health records
  dynamic selectedRecord;

  @override
  void initState() {
    super.initState();
    fetchHealthrecords(); // Fetch records when the page initializes
  }

  Future<void> fetchHealthrecords() async {
    try {
      final Uri uri = Uri.parse('http://127.0.0.1/Mysql/healthrecord.php');
      final response = await http.get(uri);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isNotEmpty) {
          final decodedBody = json.decode(responseBody);
          if (decodedBody != null && decodedBody is List<dynamic>) {
            setState(() {
              records = decodedBody;
            });
            print('Health records fetched successfully');
          } else {
            throw Exception('Invalid JSON data');
          }
        } else {
          throw Exception('Response body is empty');
        }
      } else {
        throw Exception('Failed to load health records: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pharmacy: $e');
      // Display user-friendly error message (e.g., snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching health record')),
      );
    }
  }

  Future<void> fetchHealthrecordById(String id) async {
    try {
      final Uri uri = Uri.parse('http://127.0.0.1/Mysql/healthrecord.php?id=$id');
      final response = await http.get(uri);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isNotEmpty) {
          final decodedBody = json.decode(responseBody);
          if (decodedBody != null && decodedBody is List<dynamic>) {
            setState(() {
              selectedRecord = decodedBody[0];
            });
            print('Health record fetched successfully');
          } else {
            throw Exception('Invalid JSON data');
          }
        } else {
          throw Exception('Response body is empty');
        }
      } else {
        throw Exception('Failed to load health record: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching health record: $e');
    }
  }

  Future<void> addHealthRecord(String fullName, String id, String bloodType, String details) async {
    try {
      final Uri uri = Uri.parse('http://127.0.0.1/Mysql/addhealthrecord.php');
      final response = await http.post(uri, body: {
        'id': id,
        'fullname': fullName,
        'details': details,
        'bloodtype': bloodType,
      });

      if (response.statusCode == 200) {
        fetchHealthrecords(); // Refresh records after adding
        setState(() {});
      } else {
        throw Exception('Failed to add health record: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding health record: $e');
    }
  }

  Future<void> updateHealthRecord(String fullName, String id, String bloodType, String details) async {
    try {
      final Uri uri = Uri.parse('http://127.0.0.1/Mysql/updatehealthrecord.php');
      final response = await http.post(uri, body: {
        'id': id,
        'fullname': fullName,
        'details': details,
        'bloodtype': bloodType,
      });

      if (response.statusCode == 200) {
        fetchHealthrecords(); // Refresh records after updating
        setState(() {});
      } else {
        throw Exception('Failed to update health record: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating health record: $e');
    }
  }

  Future<void> deleteHealthRecord(String id) async {
    try {
      final Uri uri = Uri.parse('http://127.0.0.1/Mysql/deletehealthrecord.php');
      final response = await http.post(uri, body: {
        'id': id,
      });

      if (response.statusCode == 200) {
        fetchHealthrecords(); // Refresh records after deleting
        setState(() {});
      } else {
        throw Exception('Failed to delete health record: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting health record: $e');
    }
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Health Record'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _bloodTypeController,
                decoration: const InputDecoration(
                  labelText: 'Blood Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  labelText: 'Details',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                if (_idController.text.isEmpty ||
                    _fullNameController.text.isEmpty ||
                    _bloodTypeController.text.isEmpty ||
                    _detailsController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all the fields.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                await addHealthRecord(
                  _fullNameController.text,
                  _idController.text,
                  _bloodTypeController.text,
                  _detailsController.text,
                ).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Health Record added successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  setState(() {
                    _fullNameController.text = '';
                    _idController.text = '';
                    _bloodTypeController.text = '';
                    _detailsController.text = '';
                    selectedRecord = null;
                  });
                });
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateDialog(BuildContext context) {
    if (selectedRecord == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please search for a record to update.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Health Record'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: selectedRecord['fullname'],
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  selectedRecord['fullname'] = value;
                },
              ),const SizedBox(height: 10.0),
              TextFormField(
                initialValue: selectedRecord['id'],
                decoration: const InputDecoration(
                  labelText: 'ID',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  selectedRecord['id'] = value;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                initialValue: selectedRecord['bloodtype'],
                decoration: const InputDecoration(
                  labelText: 'Blood Type',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  selectedRecord['bloodtype'] = value;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                initialValue: selectedRecord['details'],
                decoration: const InputDecoration(
                  labelText: 'Details',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  selectedRecord['details'] = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Update the health record here
                updateHealthRecord(
                  selectedRecord['fullname'],
                  selectedRecord['id'],
                  selectedRecord['bloodtype'],
                  selectedRecord['details'],
                ).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Health Record updated successfully!'))
                  );
                  setState(() {
                    fetchHealthrecords();
                    selectedRecord = null;
                    _fullNameController.text='';
                    _idController.text='';
                    _bloodTypeController.text='';
                    _detailsController.text='';
                  });
                });
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    if (selectedRecord == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please search for a record to delete.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Health Record'),
          content: const Text('Are you sure you want to delete this health record?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Delete the health record here
                deleteHealthRecord(
                  selectedRecord['id'],
                ).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Health Record deleted successfully!'))
                  );
                  setState(() {
                    fetchHealthrecords();
                    selectedRecord = null;
                    _fullNameController.text='';
                    _idController.text='';
                    _bloodTypeController.text='';
                    _detailsController.text='';
                  });
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<List<dynamic>> fetchSearchResults(String id) async {
    try {
      final Uri uri = Uri.parse('http://127.0.0.1/Mysql/healthrecord.php?id=$id');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isNotEmpty) {
          final decodedBody = json.decode(responseBody);
          if (decodedBody != null && decodedBody is List<dynamic>){
            return decodedBody;
          } else {
            throw Exception('Invalid JSON data');
          }
        } else {
          throw Exception('Response body is empty');
        }
      } else {
        throw Exception('Failed to load health records: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching health records: $e');
      rethrow;
    }
  }

  void _showSearchResultsDialog(BuildContext context) async {
    if (_idController.text.isNotEmpty) {
      final List<dynamic> searchResults = await fetchSearchResults(_idController.text);

      if (searchResults.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Search Results'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: searchResults.map<Widget>(
                        (record) => Column(
                      children: [
                        ListTile(
                          title: Text(record['fullname']),
                          subtitle: Text(record['details']),
                          trailing: Text(record['bloodtype']),
                          onTap: () {
                            setState(() {
                              selectedRecord = record;
                              _fullNameController.text = record['fullname'];
                              _idController.text = record['id'];
                              _bloodTypeController.text = record['bloodtype'];
                              _detailsController.text = record['details'];
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        const Divider(),
                      ],
                    ),
                  ).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No record found with this ID.')),
        );
        _fullNameController.text = '';
        _bloodTypeController.text = '';
        _detailsController.text = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Records'),
        leading: BackButton(
          onPressed: ()=>Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 50),
          SizedBox(
            height: 50,
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'Search by ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _showSearchResultsDialog(context);
                  },
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...records.map<Widget>(
                (record) => Card(
              elevation: 4,
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(record['fullname']),
                subtitle: Text(record['details']),
                trailing: Text(record['bloodtype']),
                onTap: () {
                  setState(() {
                    selectedRecord = record;
                    _fullNameController.text = record['fullname'];
                    _idController.text = record['id'];
                    _bloodTypeController.text = record['bloodtype'];
                    _detailsController.text = record['details'];
                  });
                },
              ),
            ),
          ).toList(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showAddDialog(context);
                },
                child: const Text('Add'),
              ),
              ElevatedButton(
                onPressed: () {
                  _showUpdateDialog(context);
                },
                child: const Text('Update'),
              ),
              ElevatedButton(
                onPressed: () {
                  _showDeleteDialog(context);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}