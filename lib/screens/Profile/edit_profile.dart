import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // Save profile changes logic here
            },
            child: const Text(
              'Simpan',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.orange,
              height: 150,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("images/profile3.png"),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          // Logic to edit profile picture
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField('Nama', 'Anang Prahari Fernando'),
            _buildTextField('Bio', 'Penggemar Teknologi'),
            _buildTextField('Jenis Kelamin', 'Laki-Laki'),
            _buildTextField('Tanggal Lahir', '08/08/1994'),
            _buildTextField('No. Handphone', '081234567894'),
            _buildTextField('Email', 'anang.prahari@example.com'),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
