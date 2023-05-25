// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rental_info/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RentalInformation {
  int floorNumber;
  int flatNumber;
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  String renterName;
  int renterMobileNumber;
  int renterNIDNumber;
  double rentAmount;

  RentalInformation({
    required this.floorNumber,
    required this.flatNumber,
    required this.year,
    required this.month,
    required this.renterName,
    required this.renterMobileNumber,
    required this.renterNIDNumber,
    required this.rentAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'floorNumber': floorNumber,
      'flatNumber': flatNumber,
      'year': year,
      'month': month,
      'renterName': renterName,
      'renterMobileNumber': renterMobileNumber,
      'renterNIDNumber': renterNIDNumber,
      'rentAmount': rentAmount
    };
  }

  factory RentalInformation.fromJson(Map<String, dynamic> json) {
    return RentalInformation(
        floorNumber: json['floorNumber'],
        flatNumber: json['flatNumber'],
        year: json['year'],
        month: json['month'],
        renterName: json['renterName'],
        renterMobileNumber: json['renterMobileNumber'],
        renterNIDNumber: json['renterNIDNumber'],
        rentAmount: json['rentAmount']);
  }

  @override
  String toString() {
    return 'RentalInformation(floorNumber: $floorNumber, flatNumber: $flatNumber, year: $year, month: $month, renterName: $renterName, renterMobileNumber: $renterMobileNumber, renterNIDNumber: $renterNIDNumber, rentAmount: $rentAmount)';
  }

  @override
  bool operator ==(covariant RentalInformation other) {
    if (identical(this, other)) return true;

    return other.floorNumber == floorNumber &&
        other.flatNumber == flatNumber &&
        other.year == year &&
        other.month == month &&
        other.renterName == renterName &&
        other.renterMobileNumber == renterMobileNumber &&
        other.renterNIDNumber == renterNIDNumber &&
        other.rentAmount == rentAmount;
  }

  @override
  int get hashCode {
    return floorNumber.hashCode ^
        flatNumber.hashCode ^
        year.hashCode ^
        month.hashCode ^
        renterName.hashCode ^
        renterMobileNumber.hashCode ^
        renterNIDNumber.hashCode ^
        rentAmount.hashCode;
  }

  RentalInformation copyWith({
    int? floorNumber,
    int? flatNumber,
    int? year,
    int? month,
    String? renterName,
    int? renterMobileNumber,
    int? renterNIDNumber,
    double? rentAmount,
  }) {
    return RentalInformation(
      floorNumber: floorNumber ?? this.floorNumber,
      flatNumber: flatNumber ?? this.flatNumber,
      year: year ?? this.year,
      month: month ?? this.month,
      renterName: renterName ?? this.renterName,
      renterMobileNumber: renterMobileNumber ?? this.renterMobileNumber,
      renterNIDNumber: renterNIDNumber ?? this.renterNIDNumber,
      rentAmount: rentAmount ?? this.rentAmount,
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Renter Information - For Ashek Mahmud',
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<RentalInformation> rentalList = [];

  @override
  void initState() {
    super.initState();
    _loadRentalListFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renter Information - For Ashek Mahmud'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: rentalList.length,
          itemBuilder: (context, index) {
            final rentalInfo = rentalList[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.pinkAccent, Colors.orangeAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    'Floor: ${rentalInfo.floorNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Flat: ${rentalInfo.flatNumber}\n'
                    'Year: ${rentalInfo.year}\n'
                    'Month: ${rentalInfo.month}\n'
                    'Renter Name: ${rentalInfo.renterName}\n'
                    "Renter's Mobile Number: ${rentalInfo.renterMobileNumber}\n"
                    "Renter's NID Number: ${rentalInfo.renterNIDNumber}\n"
                    'Rent Amount: ${rentalInfo.rentAmount}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            rentalList.removeAt(index);
                            _saveRentalListToStorage();
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editRentalInfo(rentalInfo, index);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRentalInfoDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddRentalInfoDialog() {
    int floorNumber = 0;
    int flatNumber = 0;
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    String renterName = '';
    int renterMobileNumber = 0;
    int renterNIDNumber = 0;
    double rentAmount = 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Renter Information'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Floor Number'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    floorNumber = int.tryParse(value) ?? 0;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Flat Number'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    flatNumber = int.tryParse(value) ?? 0;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Renter Name'),
                  onChanged: (value) {
                    renterName = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: "Renter's Mobile Number"),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    renterMobileNumber = int.tryParse(value) ?? 0;
                  },
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: "Renter's NID Number"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    renterNIDNumber = int.tryParse(value) ?? 0;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Rent Amount'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    rentAmount = double.tryParse(value) ?? 0.0;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Check if any required field is empty
                if (floorNumber == 0 ||
                    flatNumber == 0 ||
                    year == 0 ||
                    month == 0 ||
                    renterName.isEmpty ||
                    renterMobileNumber == 0 ||
                    renterNIDNumber == 0 ||
                    rentAmount == 0.0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Incomplete Information'),
                        content: const Text(
                            'Please fill in all the required fields.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Check if renter already exists with the same mobile number, floor number, and flat number
                  bool renterExists = rentalList.any((rentalInfo) =>
                      rentalInfo.renterMobileNumber == renterMobileNumber &&
                      rentalInfo.floorNumber == floorNumber &&
                      rentalInfo.flatNumber == flatNumber);

                  if (renterExists) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Renter Already Added'),
                          content: const Text(
                              'A renter with the same floor number and flat number already exists.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Create the RentalInformation object and add it to the list
                    RentalInformation newRentalInfo = RentalInformation(
                      floorNumber: floorNumber,
                      flatNumber: flatNumber,
                      year: year,
                      month: month,
                      renterName: renterName,
                      renterMobileNumber: renterMobileNumber,
                      renterNIDNumber: renterNIDNumber,
                      rentAmount: rentAmount,
                    );

                    // Check if renter already exists with the same mobile number, floor number, and flat number
                    bool alreadyAdded = rentalList.any((rentalInfo) =>
                        rentalInfo.floorNumber == newRentalInfo.floorNumber &&
                        rentalInfo.flatNumber == newRentalInfo.flatNumber);

                    if (alreadyAdded) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Renter Already Added'),
                            content: const Text(
                                'A renter with the same floor number and flat number already exists.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      setState(() {
                        rentalList.add(newRentalInfo);
                        _saveRentalListToStorage();
                      });
                      Navigator.pop(context);
                    }
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editRentalInfo(RentalInformation rentalInfo, int index) {
    int floorNumber = rentalInfo.floorNumber;
    int flatNumber = rentalInfo.flatNumber;
    int year = rentalInfo.year;
    int month = rentalInfo.month;
    String renterName = rentalInfo.renterName;
    int renterMobileNumber = rentalInfo.renterMobileNumber;
    int renterNIDNumber = rentalInfo.renterNIDNumber;
    double rentAmount = rentalInfo.rentAmount;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Rental Information'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Renter Name'),
                  onChanged: (value) {
                    renterName = value;
                  },
                  controller:
                      TextEditingController(text: rentalInfo.renterName),
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: "Renter's Mobile Number"),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    renterMobileNumber =
                        int.tryParse(value) ?? rentalInfo.renterMobileNumber;
                  },
                  controller: TextEditingController(
                      text: rentalInfo.renterMobileNumber.toString()),
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: "Renter's NID Number"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    renterNIDNumber =
                        int.tryParse(value) ?? rentalInfo.renterNIDNumber;
                  },
                  controller: TextEditingController(
                      text: rentalInfo.renterNIDNumber.toString()),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Rent Amount'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    rentAmount =
                        double.tryParse(value) ?? rentalInfo.rentAmount;
                  },
                  controller: TextEditingController(
                      text: rentalInfo.rentAmount.toString()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update the rentalInfo object with the edited values

                if (year == 0 ||
                    month == 0 ||
                    renterName.isEmpty ||
                    renterMobileNumber == 0 ||
                    renterNIDNumber == 0 ||
                    rentAmount == 0.0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Incomplete Information'),
                        content: const Text(
                            'Please fill in all the required fields.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  RentalInformation updatedRentalInfo = RentalInformation(
                    floorNumber: floorNumber,
                    flatNumber: flatNumber,
                    year: year,
                    month: month,
                    renterName: renterName,
                    renterMobileNumber: renterMobileNumber,
                    renterNIDNumber: renterNIDNumber,
                    rentAmount: rentAmount,
                  );

                  setState(() {
                    rentalList[index] = updatedRentalInfo;
                    _saveRentalListToStorage();
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveRentalListToStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> rentalListJson = rentalList
        .map((rentalInfo) => jsonEncode(rentalInfo.toJson()))
        .toList();
    await prefs.setStringList('rentalList', rentalListJson);
  }

  Future<void> _loadRentalListFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> rentalListJson = prefs.getStringList('rentalList') ?? [];
    setState(() {
      rentalList.clear();
      rentalList.addAll(rentalListJson
          .map((json) {
            try {
              return RentalInformation.fromJson(jsonDecode(json));
            } catch (e) {
              return null;
            }
          })
          .where((rentalInfo) => rentalInfo != null)
          .whereType<RentalInformation>());
    });
  }
}
