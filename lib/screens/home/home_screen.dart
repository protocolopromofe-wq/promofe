import 'package:flutter/material.dart';
import '../../models/patient_model.dart';
import '../../services/firebase_auth_service.dart';
import '../patient/patient_registration_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Lista mockada para fins de UI por enquanto
  List<PatientModel> _allPatients = [
    PatientModel(id: '1', name: 'João Silva', rg: '12.345.678-9', phone: '(11) 99999-9999'),
    PatientModel(id: '2', name: 'Maria Souza', rg: '98.765.432-1', phone: '(11) 88888-8888'),
  ];
  
  List<PatientModel> _filteredPatients = [];

  @override
  void initState() {
    super.initState();
    _filteredPatients = _allPatients;
    _searchController.addListener(_filterPatients);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPatients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPatients = _allPatients.where((patient) {
        return patient.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _logout() {
    // TODO: Usar _authService.signOut() quando o Firebase for inicializado
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra de busca
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar paciente por nome',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Lista de pacientes
            Expanded(
              child: _filteredPatients.isEmpty
                  ? const Center(child: Text('Nenhum paciente encontrado.'))
                  : ListView.builder(
                      itemCount: _filteredPatients.length,
                      itemBuilder: (context, index) {
                        final patient = _filteredPatients[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(patient.name[0].toUpperCase()),
                            ),
                            title: Text(patient.name),
                            subtitle: Text(patient.phone ?? 'Sem telefone'),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              // TODO: Navegar para histórico/detalhes do paciente
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PatientRegistrationScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo Paciente'),
      ),
    );
  }
}
