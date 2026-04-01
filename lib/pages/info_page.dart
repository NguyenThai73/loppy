import 'package:flutter/material.dart';
import '../models/beaver_info.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final BeaverInfo _beaver = BeaverInfo(
    name: 'Loppy',
    age: 2,
    hobbies: 'Gam go, Xay dam, Boi loi, An ngo',
  );

  bool _isEditing = false;

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _hobbiesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _beaver.name);
    _ageController = TextEditingController(text: _beaver.age.toString());
    _hobbiesController = TextEditingController(text: _beaver.hobbies);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _hobbiesController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_isEditing) {
      setState(() {
        _beaver.name = _nameController.text;
        _beaver.age = int.tryParse(_ageController.text) ?? _beaver.age;
        _beaver.hobbies = _hobbiesController.text;
        _isEditing = false;
      });
    } else {
      setState(() {
        _isEditing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.brown.shade100,
                  child: const Text(
                    '🦫',
                    style: TextStyle(fontSize: 64),
                  ),
                ),
                if (_isEditing)
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt,
                          size: 18, color: Colors.white),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Chuc nang chon anh (demo)')),
                        );
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            if (!_isEditing) ...[
              Text(
                _beaver.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Chip(
                avatar: const Icon(Icons.cake, size: 18),
                label: Text('${_beaver.age} tuoi'),
              ),
              const SizedBox(height: 24),
              _buildInfoCard(
                context,
                icon: Icons.pets,
                title: 'Ten',
                value: _beaver.name,
              ),
              _buildInfoCard(
                context,
                icon: Icons.cake,
                title: 'Tuoi',
                value: '${_beaver.age} tuoi',
              ),
              _buildInfoCard(
                context,
                icon: Icons.favorite,
                title: 'So thich',
                value: _beaver.hobbies,
              ),
            ] else ...[
              _buildEditField('Ten', _nameController, Icons.pets),
              const SizedBox(height: 12),
              _buildEditField('Tuoi', _ageController, Icons.cake,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildEditField('So thich', _hobbiesController, Icons.favorite,
                  maxLines: 3),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleEdit,
        child: Icon(_isEditing ? Icons.check : Icons.edit),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.brown.shade50,
          child: Icon(icon, color: Colors.brown),
        ),
        title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildEditField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
