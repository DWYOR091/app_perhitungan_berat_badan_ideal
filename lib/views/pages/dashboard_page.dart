import 'package:aplikasi_perhitungan_berat_badan_ideal/helpers/database_helper.dart';
import 'package:aplikasi_perhitungan_berat_badan_ideal/models/user.dart';
import 'package:aplikasi_perhitungan_berat_badan_ideal/models/weight_record.dart';
import 'package:aplikasi_perhitungan_berat_badan_ideal/views/pages/add_weight_page.dart';
import 'package:aplikasi_perhitungan_berat_badan_ideal/views/pages/edit_profil_page.dart';
import 'package:aplikasi_perhitungan_berat_badan_ideal/views/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  final User user;

  const DashboardPage({Key? key, required this.user}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late User currentUser;
  List<WeightRecord> weightRecords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    _loadWeightRecords();
  }

  Future<void> _loadWeightRecords() async {
    setState(() {
      isLoading = true;
    });

    try {
      final records =
          await DatabaseHelper.instance.getWeightRecords(currentUser.id!);
      setState(() {
        weightRecords = records;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  double calculateIdealWeight() {
    // Rumus BMI yang ideal: height (m) ^ 2 * 22.5
    final heightInMeters = currentUser.height / 100;
    return double.parse(
        (heightInMeters * heightInMeters * 22.5).toStringAsFixed(1));
  }

  String getWeightStatus(double weight) {
    final idealWeight = calculateIdealWeight();
    final difference = weight - idealWeight;
    final percentage = (difference / idealWeight * 100).abs();

    if (percentage < 5) {
      return 'Ideal';
    } else if (difference < 0) {
      return 'Kurang ${percentage.toStringAsFixed(1)}%';
    } else {
      return 'Lebih ${percentage.toStringAsFixed(1)}%';
    }
  }

  @override
  Widget build(BuildContext context) {
    final idealWeight = calculateIdealWeight();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () async {
              final updatedUser = await Navigator.of(context).push<User>(
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(user: currentUser),
                ),
              );
              if (updatedUser != null) {
                setState(() {
                  currentUser = updatedUser;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Row(
                      children: [
                        Icon(Icons.warning),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Logout!"),
                      ],
                    ),
                    content: const Text("Apakah anda yakin ingin logout?"),
                    actions: [
                      TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                                    (states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.orange; // Saat ditekan
                              }
                              if (states.contains(WidgetState.hovered)) {
                                return Colors.blue.shade700; // Saat hover
                              }
                              return Colors.blue[300]!; // Normal
                            }),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Tidak",
                            style: TextStyle(color: Colors.white),
                          )),
                      TextButton(
                          style: ButtonStyle(backgroundColor:
                              WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.hovered)) {
                              return Colors.green.shade700;
                            }
                            return Colors.green[300]!;
                          })),
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return const LoginPage();
                              },
                            ));
                          },
                          child: const Text(
                            "Ya",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadWeightRecords,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 2,
                        color: Colors.orange[100],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  'Halo, ${currentUser.name}',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tinggi: ${currentUser.height} cm',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Berat Ideal: $idealWeight kg',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Riwayat Pencatatan Berat Badan',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      weightRecords.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Text(
                                  'Belum ada pencatatan berat badan. Tambahkan catatan baru.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: weightRecords.length,
                              itemBuilder: (context, index) {
                                final record = weightRecords[index];
                                final recordDate =
                                    DateFormat('dd MMM yyyy').format(
                                  DateTime.parse(record.recordedAt),
                                );
                                final status = getWeightStatus(record.weight);
                                Color statusColor;

                                if (status == 'Ideal') {
                                  statusColor = Colors.green;
                                } else if (status.contains('Kurang')) {
                                  statusColor = Colors.orange;
                                } else {
                                  statusColor = Colors.red;
                                }

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    title: Text('${record.weight} kg'),
                                    subtitle: Text('Tanggal: $recordDate'),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(color: statusColor),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddWeightPage(user: currentUser),
            ),
          );
          _loadWeightRecords();
        },
        child: const Icon(
          Icons.add,
          color: Colors.blue,
        ),
      ),
    );
  }
}
