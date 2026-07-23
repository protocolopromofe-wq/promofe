import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../models/evaluation_model.dart';
import '../evaluation/section2_screen.dart';

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  State<PatientRegistrationScreen> createState() => _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers para os campos
  final _nameController = TextEditingController();
  final _rgController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // Controllers de Endereço
  final _cepController = TextEditingController();
  final _cepMaskFormatter = MaskTextInputFormatter(mask: '#####-###', filter: { "#": RegExp(r'[0-9]') });
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  final _professionController = TextEditingController();
  final _workTimeController = TextEditingController();

  String? _selectedGender;
  String? _selectedMaritalStatus;
  String? _selectedEducation;

  bool _isLoadingCep = false;

  @override
  void dispose() {
    _nameController.dispose();
    _rgController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _cepController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _professionController.dispose();
    _workTimeController.dispose();
    super.dispose();
  }

  void _clearAddressFields() {
    setState(() {
      _streetController.clear();
      _neighborhoodController.clear();
      _cityController.clear();
      _stateController.clear();
      _numberController.clear();
      _complementController.clear();
    });
  }

  Future<void> _fetchCep(String cep) async {
    final cleanCep = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanCep.length != 8) {
      _clearAddressFields();
      return;
    }

    setState(() { _isLoadingCep = true; });
    try {
      final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cleanCep/json/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['erro'] == null) {
          setState(() {
            _streetController.text = data['logradouro'] ?? '';
            _neighborhoodController.text = data['bairro'] ?? '';
            _cityController.text = data['localidade'] ?? '';
            _stateController.text = data['uf'] ?? '';
          });
        } else {
          _clearAddressFields();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CEP não encontrado')));
        }
      }
    } catch (e) {
      _clearAddressFields();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao buscar CEP')));
    } finally {
      setState(() { _isLoadingCep = false; });
    }
  }

  void _savePatient() {
    if (_formKey.currentState!.validate()) {
      // TODO: Salvar paciente de verdade no banco
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paciente cadastrado! Iniciando avaliação...')),
      );

      // Cria a instância da Avaliação vinculada a este paciente falso
      final evaluation = EvaluationModel(
        patientId: 'temp_patient_123',
        date: DateTime.now(),
      );

      // Navega para a Seção 2 passando o modelo
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Section2Screen(evaluation: evaluation),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Paciente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Dados Pessoais',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome Completo', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rgController,
                      decoration: const InputDecoration(labelText: 'RG', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _birthDateController,
                      decoration: const InputDecoration(labelText: 'Data de Nasc.', border: OutlineInputBorder(), hintText: 'DD/MM/AAAA'),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Gênero', border: OutlineInputBorder()),
                isExpanded: true,
                value: _selectedGender,
                items: ['Feminino', 'Masculino', 'Outro'].map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value, overflow: TextOverflow.ellipsis));
                }).toList(),
                onChanged: (newValue) => setState(() => _selectedGender = newValue),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Estado Civil', border: OutlineInputBorder()),
                isExpanded: true,
                value: _selectedMaritalStatus,
                items: ['Solteiro(a)', 'Casado(a)', 'Divorciado(a)', 'Viúvo(a)'].map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value, overflow: TextOverflow.ellipsis));
                }).toList(),
                onChanged: (newValue) => setState(() => _selectedMaritalStatus = newValue),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telefone / WhatsApp', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
              ),
              
              const SizedBox(height: 32),
              const Text(
                'Endereço',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cepController,
                      decoration: InputDecoration(
                        labelText: 'CEP',
                        border: const OutlineInputBorder(),
                        suffixIcon: _isLoadingCep 
                          ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2))
                          : IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () => _fetchCep(_cepController.text),
                            ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [_cepMaskFormatter],
                      onChanged: (value) {
                        if (value.length == 9) {
                          _fetchCep(value);
                          // Esconde o teclado após digitar o CEP completo
                          FocusScope.of(context).unfocus();
                        } else {
                          // Limpa os campos se o CEP for apagado ou estiver incompleto
                          if (_streetController.text.isNotEmpty) {
                            _clearAddressFields();
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(labelText: 'Estado (UF)', border: OutlineInputBorder()),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: 'Cidade', border: OutlineInputBorder()),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _neighborhoodController,
                      decoration: const InputDecoration(labelText: 'Bairro', border: OutlineInputBorder()),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(labelText: 'Rua / Logradouro', border: OutlineInputBorder()),
                readOnly: true,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _numberController,
                      decoration: const InputDecoration(labelText: 'Número', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _complementController,
                      decoration: const InputDecoration(labelText: 'Complemento', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              const Text(
                'Dados Profissionais',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Escolaridade', border: OutlineInputBorder()),
                isExpanded: true,
                value: _selectedEducation,
                items: ['Ensino Fundamental', 'Ensino Médio', 'Ensino Superior', 'Pós-graduação'].map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value, overflow: TextOverflow.ellipsis));
                }).toList(),
                onChanged: (newValue) => setState(() => _selectedEducation = newValue),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _professionController,
                decoration: const InputDecoration(labelText: 'Profissão', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _workTimeController,
                decoration: const InputDecoration(labelText: 'Tempo de Trabalho (Ex: 5 anos)', border: OutlineInputBorder()),
              ),
              
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: _savePatient,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Salvar Paciente', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
