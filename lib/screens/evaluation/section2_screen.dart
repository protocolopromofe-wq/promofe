import 'package:flutter/material.dart';
import '../../models/evaluation_model.dart';
import 'section3_screen.dart';

class Section2Screen extends StatefulWidget {
  final EvaluationModel evaluation;

  const Section2Screen({super.key, required this.evaluation});

  @override
  State<Section2Screen> createState() => _Section2ScreenState();
}

class _Section2ScreenState extends State<Section2Screen> {
  final TextEditingController _queixaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _queixaController.text = widget.evaluation.section2Data['queixa_principal'] ?? '';
  }

  @override
  void dispose() {
    _queixaController.dispose();
    super.dispose();
  }

  void _updateData(String key, dynamic value) {
    setState(() {
      widget.evaluation.section2Data[key] = value;
    });
  }

  Widget _buildCheckbox(String title, String key) {
    bool isChecked = widget.evaluation.section2Data[key] == true;
    return CheckboxListTile(
      title: Text(title),
      value: isChecked,
      onChanged: (val) {
        _updateData(key, val);
      },
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildRadioGroup(String title, String key, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ...options.map((option) {
          return RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: widget.evaluation.section2Data[key] as String?,
            onChanged: (val) {
              if (val != null) _updateData(key, val);
            },
            dense: true,
            contentPadding: EdgeInsets.zero,
          );
        }),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anamnese e Hábitos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Registro da Queixa Principal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _queixaController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Descreva a queixa principal do paciente...',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => _updateData('queixa_principal', val),
            ),
            const SizedBox(height: 24),

            const Text('História Clínica', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 8),
            _buildCheckbox('Pratica Atividade Física', 'hist_atividade_fisica'),
            _buildCheckbox('Alimentação Balanceada', 'hist_alimentacao'),
            _buildCheckbox('Realizou Procedimentos Estéticos Prévios', 'hist_procedimentos_esteticos'),
            _buildCheckbox('Cirurgias Faciais/Orais Prévias', 'hist_cirurgias'),
            _buildCheckbox('Problemas de Saúde Relevantes', 'hist_saude'),
            _buildCheckbox('Histórico de DTM (Disfunção Temporomandibular)', 'hist_dtm'),
            _buildCheckbox('Uso de Medicamentos Contínuos', 'hist_medicamentos'),

            const SizedBox(height: 24),
            const Text('Hábitos Orais e Estilo de Vida', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 8),
            _buildCheckbox('Onicofagia (Roer unhas)', 'habito_onicofagia'),
            _buildCheckbox('Bruxismo Cêntrico (Apertamento)', 'habito_bruxismo_c'),
            _buildCheckbox('Bruxismo Excêntrico (Ranger)', 'habito_bruxismo_e'),
            _buildCheckbox('Tabagismo', 'habito_tabagismo'),
            _buildCheckbox('Exposição Solar/Radiação Frequente sem Proteção', 'habito_exposicao_solar'),
            _buildRadioGroup('Ingestão de Água Diária', 'habito_agua', ['Pouca (menos de 1L)', 'Adequada (1L a 2L)', 'Muita (Mais de 2L)']),

            const SizedBox(height: 24),
            const Text('Hábitos Posturais', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 8),
            _buildCheckbox('"Tech Neck" (Uso excessivo de celular)', 'postura_tech_neck'),
            _buildCheckbox('Projeção Anterior de Cabeça', 'postura_projecao_cabeca'),
            _buildCheckbox('Dorme de Lado/Bruços frequentemente', 'postura_dormir'),
            _buildCheckbox('Apoia o rosto nas mãos frequentemente', 'postura_apoiar_rosto'),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Etapa 1', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
                  Text(
                    'Anamnese',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.teal),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Section3Screen(evaluation: widget.evaluation),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Avançar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
