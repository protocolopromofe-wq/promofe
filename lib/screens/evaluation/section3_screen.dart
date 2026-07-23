import 'package:flutter/material.dart';
import '../../models/evaluation_model.dart';
import 'section4_screen.dart';

class Section3Screen extends StatefulWidget {
  final EvaluationModel evaluation;

  const Section3Screen({super.key, required this.evaluation});

  @override
  State<Section3Screen> createState() => _Section3ScreenState();
}

class _Section3ScreenState extends State<Section3Screen> {
  void _updateScore(String key, String label, int score) {
    setState(() {
      widget.evaluation.section3Data[key] = label;
      widget.evaluation.section3Data['\${key}_score'] = score;
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    int total = 0;
    widget.evaluation.section3Data.forEach((k, v) {
      if (k.endsWith('_score') && v is int) total += v;
    });
    widget.evaluation.section3Score = total;
  }

  Widget _buildRadioGroup(String title, String key, Map<String, int> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ...options.entries.map((entry) {
          return RadioListTile<String>(
            title: Text(entry.key),
            value: entry.key,
            groupValue: widget.evaluation.section3Data[key] as String?,
            onChanged: (val) {
              if (val != null) _updateScore(key, val, entry.value);
            },
            dense: true,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Antroposcopia e Funções'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRadioGroup('Simetria Facial', 'simetria', {'Adequada (0)': 0, 'Alterada (1)': 1}),
            _buildRadioGroup('Proporção dos Terços', 'proporcao_tercos', {'Adequada (0)': 0, 'Alterada (1)': 1}),
            _buildRadioGroup('Lábios (Repouso)', 'labios', {'Ocluídos (0)': 0, 'Entreabertos/Abertos (1)': 1}),
            _buildRadioGroup('Volume Labial', 'volume_labial', {'Normal (0)': 0, 'Alterado (1)': 1}),
            _buildRadioGroup('Comissuras', 'comissuras', {'Niveladas (0)': 0, 'Desniveladas (1)': 1}),
            _buildRadioGroup('Mento', 'mento', {'Adequado (0)': 0, 'Contraído/Alterado (1)': 1}),
            
            const Text('Mandíbula (Medidas)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _buildRadioGroup('Abertura Máxima', 'mandibula_abertura', {'Adequada (0)': 0, 'Reduzida/Desvio (1)': 1}),
            _buildRadioGroup('Lateralidade Direita', 'mandibula_lat_d', {'Adequada (0)': 0, 'Alterada (1)': 1}),
            _buildRadioGroup('Lateralidade Esquerda', 'mandibula_lat_e', {'Adequada (0)': 0, 'Alterada (1)': 1}),
            
            const SizedBox(height: 16),
            const Text('Avaliação de Tônus', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 8),
            
            _buildRadioGroup('Lábio Superior', 'tonus_labio_sup', {'Normal (0)': 0, 'Hipo/Hipertensão (1)': 1}),
            _buildRadioGroup('Lábio Inferior', 'tonus_labio_inf', {'Normal (0)': 0, 'Hipo/Hipertensão (1)': 1}),
            _buildRadioGroup('Mento', 'tonus_mento', {'Normal (0)': 0, 'Hipertensão (1)': 1}),
            _buildRadioGroup('Sulco Mentolabial', 'tonus_sulco', {'Normal (0)': 0, 'Acentuado (1)': 1}),
            _buildRadioGroup('Bochecha Direita', 'tonus_bochecha_d', {'Normal (0)': 0, 'Flácida/Tensa (1)': 1}),
            _buildRadioGroup('Bochecha Esquerda', 'tonus_bochecha_e', {'Normal (0)': 0, 'Flácida/Tensa (1)': 1}),

            const SizedBox(height: 16),
            const Text('Funções Estomatognáticas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 8),
            
            _buildRadioGroup('Respiração', 'funcao_respiracao', {'Nasal (0)': 0, 'Oronasal (1)': 1, 'Oral (2)': 2, 'Com esforço (3)': 3}),
            _buildRadioGroup('Mastigação', 'funcao_mastigacao', {'Bilateral Alternada (0)': 0, 'Unilateral Preferencial (1)': 1, 'Unilateral Crônica (2)': 2, 'Inadequada (3)': 3}),
            _buildRadioGroup('Deglutição', 'funcao_degluticao', {'Adequada (0)': 0, 'Atípica leve (1)': 1, 'Atípica moderada (2)': 2, 'Adaptada/Severa (3)': 3}),

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
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Escore Atual', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
                  Text(
                    '${widget.evaluation.section3Score} / 24',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
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
                          builder: (context) => Section4Screen(evaluation: widget.evaluation),
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
            ],
          ),
        ),
      ),
    );
  }
}
