import 'package:aplikasi_perhitungan_berat_badan_ideal/helpers/database_helper.dart';
import 'package:aplikasi_perhitungan_berat_badan_ideal/models/user.dart';
import 'package:aplikasi_perhitungan_berat_badan_ideal/models/weight_record.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddWeightPage extends StatefulWidget {
  final User user;

  const AddWeightPage({Key? key, required this.user}) : super(key: key);

  @override
  _AddWeightPageState createState() => _AddWeightPageState();
}

class _AddWeightPageState extends State<AddWeightPage> {
  final _formKey = GlobalKey<FormState>();
  final weightController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  double calculateIdealWeight() {
    // Rumus BMI yang ideal: height (m) ^ 2 * 22.5
    final heightInMeters = widget.user.height / 100;
    return double.parse(
        (heightInMeters * heightInMeters * 22.5).toStringAsFixed(1));
  }

  Future<void> _saveWeight() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final record = WeightRecord(
        userId: widget.user.id!,
        weight: double.parse(weightController.text),
        recordedAt: selectedDate.toIso8601String(),
      );

      await DatabaseHelper.instance.createWeightRecord(record);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berat badan berhasil disimpan')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final idealWeight = calculateIdealWeight();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Berat Badan',
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); //untuk kembali
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Info Berat Badan Ideal',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tinggi Badan: ${widget.user.height} cm',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Berat Badan Ideal: $idealWeight kg',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Berat badan ideal dihitung menggunakan rumus BMI yang disarankan oleh WHO dengan nilai BMI = 22.5 untuk keseimbangan optimal.',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 44),
                const Center(
                  child: Text(
                    'Masukkan Berat Badan Anda',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: weightController,
                  decoration: const InputDecoration(
                    labelText: 'Berat Badan (kg)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Berat badan tidak boleh kosong';
                    }
                    try {
                      final weight = double.parse(value);
                      if (weight <= 0 || weight > 500) {
                        return 'Berat badan tidak valid';
                      }
                    } catch (e) {
                      return 'Input harus berupa angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Pencatatan',
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('dd MMMM yyyy').format(selectedDate),
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 181,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: isLoading ? null : _saveWeight,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Simpan',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
