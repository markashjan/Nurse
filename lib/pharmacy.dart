import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Pharmacy extends StatefulWidget {
  @override
  _PharmacyPageState createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<Pharmacy> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _medicineController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  List<dynamic> pharmacy = []; // Placeholder for Pharmacy
  dynamic selectedpharmacy;

  @override
  void initState() {
    super.initState();
    fetchPharmacy(); // Fetch records when the page initializes
  }

  Future<void> fetchPharmacy() async {
    try {
      final Uri uri = Uri.parse('http://127.0.0.1/Mysql/pharmacy.php'); // Replace with your appointment script URL
      final response = await http.get(uri);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isNotEmpty) {
          final decodedBody = json.decode(responseBody);
          if (decodedBody != null && decodedBody is List<dynamic>) {
            setState(() {
              pharmacy = decodedBody;
            });
            print('Pharmacy fetched successfully');
          } else {
            throw Exception('Invalid JSON data');
          }
        } else {
          throw Exception('Response body is empty');
        }
      } else {
        throw Exception('Failed to load pharmacy: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pharmacy: $e');
      // Display user-friendly error message (e.g., snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching pharmacy')),
      );
    }
  }
  Future<void> fetchPharmacyById(String id) async {
    try {
      final Uri uri = Uri.parse('http://127.0.0.1/Mysql/pharmacy.php?id=$id');
      final response = await http.get(uri);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isNotEmpty) {
          final decodedBody = json.decode(responseBody);
          if (decodedBody != null && decodedBody is List<dynamic>) {
            setState(() {
              selectedpharmacy = decodedBody[0];
            });
            print('Health record fetched successfully');
          } else {
            throw Exception('Invalid JSON data');
          }
        } else {
          throw Exception('Response body is empty');
        }
      } else {
        throw Exception('Failed to load pharmacy: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching health record: $e');
    }
  }
  Future<void> addHealthRecord(String fullName,String id, String medicinename, String quantity, String details) async {
    try {
      final Uri uri = Uri.parse('http://127.0.0.1/Mysql/addpharmacy.php');
      final response = await http.post(uri, body: {
        'id': id,
        'fullname': fullName,
        'medicinename' : medicinename,
        'quantity' : quantity,
        'details': details,

      });

      if (response.statusCode == 200) {
        fetchPharmacy();
        setState(() {});// Refresh records after adding
      } else {
        throw Exception('Failed to add health record: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding health record: $e');
    }
  }

  Future<void> updateHealthRecord(String fullName,String id, String medicinename, String quantity, String details) async {
    try {
      final Uri uri = Uri.parse('http://127.0.0.1/Mysql/updatepharmacy.php');
      final response = await http.post(uri, body: {
        'id': id,
        'fullname': fullName,
        'medicinename' : medicinename,
        'quantity' : quantity,
        'details': details,
      });

      if (response.statusCode == 200) {
        fetchPharmacy();
        setState(() {});// Refresh records after updating
      } else {
        throw Exception('Failed to update health record: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating health record: $e');
    }



  }

  Future<void> deleteHealthRecord(String id) async {
    try {
      final Uri uri = Uri.parse('http://127.0.0.1/Mysql/deletepharmacy.php');
      final response = await http.post(uri, body: {
        'id': id,
      });

      if (response.statusCode == 200) {
        fetchPharmacy();
        setState(() {});// Refresh records after deleting
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
          title: const Text('Add Pharmacy'),
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
                controller: _medicineController,
                decoration: const InputDecoration(
                  labelText: 'Medicine',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quality',
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
                    _medicineController.text.isEmpty || _quantityController.text.isEmpty||
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
                  _medicineController.text,
                  _quantityController.text,
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
                    _medicineController.text = '';
                    _quantityController.text = '';
                    _detailsController.text = '';
                    selectedpharmacy = null;
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
    if (selectedpharmacy == null) {
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
                initialValue: selectedpharmacy['fullname'],
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  selectedpharmacy['fullname'] = value;
                },
              ),const SizedBox(height: 10.0),
              TextFormField(
                initialValue: selectedpharmacy['id'],
                decoration: const InputDecoration(
                  labelText: 'ID',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  selectedpharmacy['id'] = value;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                initialValue: selectedpharmacy['medicinename'],
                decoration: const InputDecoration(
                  labelText: 'Blood Type',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  selectedpharmacy['medicinename'] = value;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                initialValue: selectedpharmacy['quantity'],
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  selectedpharmacy['quantity'] = value;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                initialValue: selectedpharmacy['details'],
                decoration: const InputDecoration(
                  labelText: 'Details',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  selectedpharmacy['details'] = value;
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
                    selectedpharmacy['fullname'],
                    selectedpharmacy['id'],
                    selectedpharmacy['medicinename'],
                    selectedpharmacy['quantity'],
                    selectedpharmacy['details']
                ).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pharmacy updated successfully!'))
                  );
                  setState(() {
                    fetchPharmacy();
                    selectedpharmacy = null;
                    _fullNameController.text='';
                    _idController.text='';
                    _medicineController.text='';
                    _quantityController.text='';
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
    if (selectedpharmacy == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please search for a record to delete.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Pharmacy'),
          content: const Text('Are you sure you want to delete this pharmacy record?'),
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
                  selectedpharmacy['id'],
                ).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pharmacy record deleted successfully!'))
                  );
                  setState(() {
                    fetchPharmacy();
                    selectedpharmacy = null;
                    _fullNameController.text='';
                    _idController.text='';
                    _medicineController.text='';
                    _quantityController.text='';
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
      final Uri uri = Uri.parse('http://127.0.0.1/Mysql/pharmacy.php?id=$id');
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
        throw Exception('Failed to load pharmacy: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pharmacy: $e');
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
                          subtitle: Text(record['medicinename']),
                          trailing: Text(record['quantity']),
                          onTap: () {
                            setState(() {
                              selectedpharmacy = record;
                              _fullNameController.text = record['fullname'];
                              _idController.text = record['id'];
                              _medicineController.text = record['medicinename'];
                              _quantityController.text = record['quantity'];
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
        _fullNameController.text='';
        _idController.text='';
        _medicineController.text='';
        _quantityController.text='';
        _detailsController.text='';
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text('Pharmacy',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),),
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
            child: Row(
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
          ...pharmacy.map<Widget>(
                (record) => Card(
              elevation: 4,
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(record['fullname']),
                subtitle: Text(record['medicinename']),
                trailing: Text(record['quantity']),
                onTap: () {
                  setState(() {
                    selectedpharmacy = record;
                    _fullNameController.text = record['fullname'];
                    _idController.text = record['id'];
                    _medicineController.text = record['medicinename'];
                    _quantityController.text = record['quantity'];
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