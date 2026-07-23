import 'package:flutter/material.dart';
import '../../models/evaluation_model.dart';
import 'section5_screen.dart';

class Section4Screen extends StatefulWidget {
  final EvaluationModel evaluation;

  const Section4Screen({super.key, required this.evaluation});

  @override
  State<Section4Screen> createState() => _Section4ScreenState();
}

class _Section4ScreenState extends State<Section4Screen> {
  void _updateScore(String key, String label, int score) {
    setState(() {
      widget.evaluation.section4Data[key] = label;
      widget.evaluation.section4Data['${key}_score'] = score;
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    int total = 0;
    widget.evaluation.section4Data.forEach((k, v) {
      if (k.endsWith('_score') && v is int) total += v;
    });
    
    // Checkboxes (Flacidez)
    if (widget.evaluation.section4Data['flacidez_palpebra_sup'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_palpebra_inf'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_bochechas'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_mandibula'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_papada'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_pescoco'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_orelha'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_labio_sup'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_labio_inf'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_comissuras'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_sulco_naso'] == true) total += 1;

    widget.evaluation.section4Score = total;
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
            groupValue: widget.evaluation.section4Data[key] as String?,
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

  Widget _buildSlider(String title, String key, int maxVal) {
    int currentVal = widget.evaluation.section4Data[key] as int? ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            Text(currentVal.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal)),
          ],
        ),
        Slider(
          value: currentVal.toDouble(),
          min: 0,
          max: maxVal.toDouble(),
          divisions: maxVal,
          label: currentVal.toString(),
          onChanged: (val) {
            _updateScore(key, val.toInt());
          },
        ),
      ],
    );
  }

  Widget _buildCheckbox(String title, String key) {
    bool isChecked = (widget.evaluation.section4Data[key] as int? ?? 0) == 1;
    return CheckboxListTile(
      title: Text(title),
      value: isChecked,
      onChanged: (val) {
        _updateScore(key, val == true ? 1 : 0);
      },
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estética Facial'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Aspectos Gerais', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 8),
            _buildRadioGroup('Formato Facial', 'formato_facial', {'Adequado (0)': 0, 'Alterado (1)': 1}),
            _buildRadioGroup('Tipo de Pele', 'tipo_pele', {'Boa qualidade (0)': 0, 'Ressecada/Oleosa (1)': 1, 'Muito alterada (2)': 2}),
            _buildRadioGroup('Cicatrizes', 'cicatrizes', {'Ausentes (0)': 0, 'Discretas (1)': 1, 'Evidentes (2)': 2}),
            
            const SizedBox(height: 24),
            const Text('Rugas e Sulcos (Classificação Lemperle 0 a 5)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 16),
            _buildSlider('Linhas Frontais (Testa)', 'rugas_frontais', 5),
            _buildSlider('Glabela', 'rugas_glabela', 5),
            _buildSlider('Periorbitais (Pés de galinha)', 'rugas_periorbitais', 5),
            _buildSlider('Sulco Nasogeniano (Bigode Chinês)', 'rugas_nasogeniano', 5),
            _buildSlider('Linhas Periorais (Código de barras)', 'rugas_periorais', 5),
            _buildSlider('Sulco Labiomentual (Marionete)', 'rugas_marionete', 5),
            _buildSlider('Bochechas', 'rugas_bochechas', 5),
            _buildSlider('Platisma (Pescoço)', 'rugas_platisma', 5),
            _buildSlider('Lóbulos da Orelha', 'rugas_orelha', 5),
            _buildSlider('Região Mentual (Queixo)', 'rugas_mento', 5),
            _buildSlider('Colo', 'rugas_colo', 5),

            const SizedBox(height: 24),
            const Text('Mapeamento de Flacidez (1 pt cada)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 8),
            _buildCheckbox('Pálpebra Superior', 'flacidez_palpebra_sup'),
            _buildCheckbox('Pálpebra Inferior', 'flacidez_palpebra_inf'),
            _buildCheckbox('Bochechas (Terço Médio)', 'flacidez_bochechas'),
            _buildCheckbox('Contorno Mandibular', 'flacidez_mandibula'),
            _buildCheckbox('Submentoniana (Papada)', 'flacidez_papada'),
            _buildCheckbox('Pescoço (Platisma)', 'flacidez_pescoco'),
            _buildCheckbox('Lóbulos da Orelha', 'flacidez_orelha'),
            _buildCheckbox('Lábio Superior', 'flacidez_labio_sup'),
            _buildCheckbox('Lábio Inferior', 'flacidez_labio_inf'),
            _buildCheckbox('Comissuras Labiais', 'flacidez_comissuras'),
            _buildCheckbox('Sulco Nasogeniano', 'flacidez_sulco_naso'),

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
                    '${widget.evaluation.section4Score} / 71',
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
                          builder: (context) => Section5Screen(evaluation: widget.evaluation),
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
