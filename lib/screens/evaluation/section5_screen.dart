import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../models/evaluation_model.dart';
import 'section6_screen.dart';

class Section5Screen extends StatefulWidget {
  final EvaluationModel evaluation;

  const Section5Screen({super.key, required this.evaluation});

  @override
  State<Section5Screen> createState() => _Section5ScreenState();
}

class _Section5ScreenState extends State<Section5Screen> {
  final ImagePicker _picker = ImagePicker();
  
  // Lista com os nomes das posições exigidas
  final List<String> _photoLabels = [
    'Frente (Repouso)',
    'Perfil Direito',
    'Perfil Esquerdo',
    'Sorriso Aberto',
    'Sorriso Fechado',
    'Raiva',
    'Espanto',
    'Bico Forte',
  ];

  // Armazena as imagens selecionadas na sessão atual (XFile funciona na Web e Mobile)
  final Map<int, XFile> _selectedImages = {};

  Future<void> _pickImage(int index, ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source, imageQuality: 70);
      if (image != null) {
        setState(() {
          _selectedImages[index] = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao selecionar imagem')));
    }
  }

  void _showPickerOptions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  _pickImage(index, ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Câmera'),
                onTap: () {
                  _pickImage(index, ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildPhotoSlot(int index) {
    final imageFile = _selectedImages[index];
    
    return GestureDetector(
      onTap: () => _showPickerOptions(index),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagem
            if (imageFile != null)
              kIsWeb 
                ? Image.network(imageFile.path, fit: BoxFit.cover)
                : Image.file(File(imageFile.path), fit: BoxFit.cover)
            else
              Container(
                color: Colors.grey[200],
                child: const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
              ),
            
            // Título inferior escurecido
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: Text(
                  _photoLabels[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Fotográfico'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Toque no espaço para anexar as fotos correspondentes do paciente.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8, // Mais alto que largo
                ),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return _buildPhotoSlot(index);
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    foregroundColor: Colors.grey[700],
                  ),
                  child: const Text('Voltar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Section6Screen(evaluation: widget.evaluation),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    minimumSize: const Size(150, 50),
                  ),
                  child: const Text('Avançar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
