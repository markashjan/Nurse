import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Appointment extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<Appointment> {
  TextEditingController _idController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _docnameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();

  List<dynamic> appointments = []; // List to store appointments
  dynamic selectedappointment;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      final Uri uri = Uri.parse('http://127.0.0.1/Mysql/upcomingapp.php'); // Replace with your appointment script URL
      final response = await http.get(uri);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isNotEmpty) {
          final decodedBody = json.decode(responseBody);
          if (decodedBody != null && decodedBody is List<dynamic>) {
            setState(() {
              appointments = decodedBody;
            });
            print('Appointments fetched successfully');
          } else {
            throw Exception('Invalid JSON data');
          }
        } else {
          throw Exception('Response body is empty');
        }
      } else {
        throw Exception('Failed to load appointments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
      // Display user-friendly error message (e.g., snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching appointments')),
      );
    }
  }

  Future<void> fetchAppointmentById(String id) async {
    try {
      final Uri uri = Uri.parse(
          'http://127.0.0.1/Mysql/upcomingapp.php?id=$id');
      final response = await http.get(uri);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isNotEmpty) {
          final decodedBody = json.decode(responseBody);
          if (decodedBody != null && decodedBody is List<dynamic>) {
            setState(() {
              selectedappointment = decodedBody[0];
            });
            print('Appointment fetched successfully');
          } else {
            throw Exception('Invalid JSON data');
          }
        } else {
          throw Exception('Response body is empty');
        }
      } else {
        throw Exception('Failed to load appointment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching appointment: $e');
    }
  }

  Future<void> updateAppointment(String id, String fullname, String docname,
      String date, String time, String details) async {
    try {
      final response = await http.post(
          Uri.parse('http://127.0.0.1/Mysql/updateappointment.php'),
          body: {
            "id": id,
            "fullname": fullname,
            "docname": docname,
            "date": date,
            "time": time,
            "details": details,
          });
      if (response.statusCode == 200) {
        fetchAppointments(); // Refresh appointments after update
        setState(() {});
      } else {
        throw Exception(
            'Failed to update appointment :${response.statusCode} ');
      }
    } catch (e) {
      print('Error updating appointment :$e');
    }
  }

  Future<void> deleteAppointment(String id) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/Mysql/deleteappointment.php'),
        body: {"id": id},
      );

      if (response.statusCode == 200) {
        fetchAppointments();
        setState(() {});
      } else {
        throw Exception(
            'Failed to delete appointment:${response.statusCode} ');
      }
    } catch (e) {
      print('Error deleting appointment : $e');
    }
  }

  Future<void> addAppointment(String id, String fullname, String docname,
      String date, String time, String details) async {
    try {
      final Uri uri = Uri.parse(
          'http://127.0.0.1/Mysql/addappointment.php'); // Replace with your add appointment script URL
      final response = await http.post(uri,
          body: {
            "id": id,
            "fullname": fullname,
            "docname": docname,
            "date": date,
            "time": time,
            "details": details,
          });
      if (response.statusCode == 200) {
        fetchAppointments();
        setState(() {});
      } else {
        throw Exception(
            'Failed to add appointment:${response.statusCode} ');
      }
    } catch (e) {
      print('Error adding appointment: $e');
    }
  }
  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Appointment'),
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
                controller: _docnameController,
                decoration: const InputDecoration(
                  labelText: 'Doctor Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Time',
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
                    _docnameController.text.isEmpty ||
                    _dateController.text.isEmpty
                    || _timeController.text.isEmpty ||
                    _detailsController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all the fields.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                await addAppointment(
                    _idController.text,
                    _fullNameController.text,
                    _docnameController.text,
                    _dateController.text,
                    _timeController.text,
                    _detailsController.text
                ).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Appointment added successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  setState(() {
                    _idController.text = '';
                    _fullNameController.text = '';
                    _docnameController.text = '';
                    _dateController.text = '';
                    _timeController.text = '';
                    _detailsController.text = '';
                    selectedappointment = null;
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
    if (selectedappointment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please search for a record to update.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Appointment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: selectedappointment['id'],
                decoration: const InputDecoration(
                  labelText: 'ID',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  selectedappointment['id'] = value;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                initialValue: selectedappointment['fullname'],
                decoration: const InputDecoration(
                  labelText: 'Fullname',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  selectedappointment['fullname'] = value;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                initialValue: selectedappointment['docname'],
                decoration: const InputDecoration(
                  labelText: 'Doctor Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  selectedappointment['docname'] = value;
                },
              ),

              const SizedBox(height: 10.0),
              TextFormField(
                initialValue: selectedappointment['date'],
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  selectedappointment['date'] = value;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                initialValue: selectedappointment['time'],
                decoration: const InputDecoration(
                  labelText: 'time',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  selectedappointment['time'] = value;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                initialValue: selectedappointment['details'],
                decoration: const InputDecoration(
                  labelText: 'Details',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  selectedappointment['details'] = value;
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
                updateAppointment(
                  selectedappointment['id'],
                  selectedappointment['fullname'],
                  selectedappointment['docname'],
                  selectedappointment['date'],
                  selectedappointment['time'],
                  selectedappointment['details'],
                ).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(
                          'Appointment updated successfully!'))
                  );
                  setState(() {
                    fetchAppointments();
                    _idController.text = '';
                    _fullNameController.text = '';
                    _docnameController.text = '';
                    _dateController.text = '';
                    _timeController.text = '';
                    _detailsController.text = '';
                    selectedappointment = null;
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
    if (selectedappointment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please search for a record to delete.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Appointment'),
          content: const Text(
              'Are you sure you want to delete this appointment?'),
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
                deleteAppointment(
                  selectedappointment['id'],
                ).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(
                          'Appointment deleted successfully!'))
                  );
                  setState(() {
                    fetchAppointments();
                    selectedappointment = null;
                    _idController.text = '';
                    _fullNameController.text = '';
                    _docnameController.text = '';
                    _dateController.text = '';
                    _timeController.text = '';
                    _detailsController.text = '';
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
      final Uri uri = Uri.parse(
          'http://127.0.0.1/Mysql/upcomingapp.php?id=$id');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isNotEmpty) {
          final decodedBody = json.decode(responseBody);
          if (decodedBody != null && decodedBody is List<dynamic>) {
            return decodedBody;
          } else {
            throw Exception('Invalid JSON data');
          }
        } else {
          throw Exception('Response body is empty');
        }
      } else {
        throw Exception(
            'Failed to load appointments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
      rethrow;
    }
  }
  void _showSearchResultsDialog(BuildContext context) async {
    if (_idController.text.isNotEmpty) {
      final List<dynamic> searchResults = await fetchSearchResults(
          _idController.text);

      if (searchResults.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Search Results'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: searchResults.map<Widget>(
                        (record) =>
                        Column(
                          children: [
                            ListTile(
                              title: Text(record['fullname']),
                              subtitle: Text(record['details']),
                              trailing: Text(record['docname']),
                              onTap: () {
                                setState(() {
                                  selectedappointment = record;
                                  _idController.text = record['id'];
                                  _fullNameController.text = record['fullname'];
                                  _docnameController.text = record['docname'];
                                  _dateController.text = record['date'];
                                  _timeController.text = record['time'];
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
        _idController.text = '';
        _fullNameController.text = '';
        _docnameController.text = '';
        _dateController.text = '';
        _timeController.text = '';
        _detailsController.text = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment'),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 50),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
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
            )
          ),
          const SizedBox(height: 10),
          ...appointments.map<Widget>(
                (record) =>
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(record['id']),
                    subtitle: Text(record['fullname']),
                    trailing: Text(record['docname']),
                    onTap: () {
                      setState(() {
                        selectedappointment = record;
                        _idController.text = record['id'];
                        _fullNameController.text = record['fullname'];
                        _docnameController.text = record['docname'];
                        _dateController.text = record['date'];
                        _timeController.text = record['time'];
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