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
  void _updateRadioScore(String key, String label, int score) {
    setState(() {
      widget.evaluation.section4Data[key] = label;
      widget.evaluation.section4Data['${key}_score'] = score;
      _calculateTotal();
    });
  }

  void _updateSliderScore(String key, int score) {
    setState(() {
      widget.evaluation.section4Data[key] = score;
      widget.evaluation.section4Data['${key}_score'] = score;
      _calculateTotal();
    });
  }

  void _updateCheckboxScore(String key, bool value) {
    setState(() {
      widget.evaluation.section4Data[key] = value;
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    int total = 0;
    widget.evaluation.section4Data.forEach((k, v) {
      if (k.endsWith('_score') && v is int) total += v;
    });
    
    // Checkboxes (Flacidez)
    if (widget.evaluation.section4Data['flacidez_complexo_frontal'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_palpebra_sup_d'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_palpebra_sup_e'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_palpebra_inf_d'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_palpebra_inf_e'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_bochecha_d'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_bochecha_e'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_canto_boca_d'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_canto_boca_e'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_platisma'] == true) total += 1;
    if (widget.evaluation.section4Data['flacidez_nariz'] == true) total += 1;

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
              if (val != null) _updateRadioScore(key, val, entry.value);
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
            _updateSliderScore(key, val.toInt());
          },
        ),
      ],
    );
  }

  Widget _buildCheckbox(String title, String key) {
    bool isChecked = widget.evaluation.section4Data[key] == true;
    return CheckboxListTile(
      title: Text(title),
      value: isChecked,
      onChanged: (val) {
        _updateCheckboxScore(key, val == true);
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
            _buildRadioGroup('Formato Facial', 'formato_facial', {'Reto (0)': 0, 'Côncavo (0)': 0, 'Convexo (0)': 0}),
            _buildRadioGroup('Cicatrizes', 'cicatrizes', {'Atróficas (0)': 0, 'Hipertróficas (0)': 0, 'Queloides (0)': 0, 'Normotróficas (0)': 0, 'Ausentes (0)': 0}),
            
            const SizedBox(height: 24),
            const Text('Rugas e Sulcos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const Text('Legenda do protocolo: [Insira a legenda das rugas aqui]', style: TextStyle(color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            _buildSlider('Linhas horizontais da testa', 'rugas_frontais', 5),
            _buildSlider('Linhas de expressão glabelares', 'rugas_glabela', 5),
            _buildSlider('Linhas periorbitais', 'rugas_periorbitais', 5),
            _buildSlider('Linhas pré-auriculares', 'rugas_orelha', 5),
            _buildSlider('Linhas das bochechas', 'rugas_bochechas', 5),
            _buildSlider('Sulcos nasolabiais', 'rugas_nasogeniano', 5),
            _buildSlider('Linhas radiais do lábio superior', 'rugas_periorais', 5),
            _buildSlider('Linhas do canto da boca', 'rugas_canto_boca', 5),
            _buildSlider('Sulcos labiomandibulares', 'rugas_labiomandibular', 5),
            _buildSlider('Sulco labiomentual', 'rugas_marionete', 5),
            _buildSlider('Linhas horizontais do pescoço', 'rugas_pescoco', 5),

            const SizedBox(height: 24),
            const Text('Mapeamento de Flacidez (1 pt cada)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 8),
            _buildCheckbox('Queda do complexo frontal, as sobrancelhas caem abaixo do rebordo orbitário (1)', 'flacidez_complexo_frontal'),
            _buildCheckbox('Queda do complexo da pálpebra superior direita, causando projeção sobre os cílios formando um capuz orbital lateral (1)', 'flacidez_palpebra_sup_d'),
            _buildCheckbox('Queda do complexo da pálpebra superior esquerda, causando projeção sobre os cílios formando um capuz orbital lateral (1)', 'flacidez_palpebra_sup_e'),
            _buildCheckbox('Queda do complexo da pálpebra inferior direita, formando as olheiras e sulco nasojugal (1)', 'flacidez_palpebra_inf_d'),
            _buildCheckbox('Queda do complexo da pálpebra inferior esquerda, formando as olheiras e sulco nasojugal (1)', 'flacidez_palpebra_inf_e'),
            _buildCheckbox('Queda da bochecha direita, formando o sulco nasogeniano (1)', 'flacidez_bochecha_d'),
            _buildCheckbox('Queda da bochecha esquerda, formando o sulco nasogeniano (1)', 'flacidez_bochecha_e'),
            _buildCheckbox('Queda do canto de boca direito, refletindo em um "sorriso de marionete" ou "boca triste" (1)', 'flacidez_canto_boca_d'),
            _buildCheckbox('Queda do canto de boca esquerdo, refletindo em um "sorriso de marionete" ou "boca triste" (1)', 'flacidez_canto_boca_e'),
            _buildCheckbox('Queda do músculo platisma, quebrando a linha da mandíbula (1)', 'flacidez_platisma'),
            _buildCheckbox('Queda da ponta do nariz (1)', 'flacidez_nariz'),

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
                    '${widget.evaluation.section4Score} / 66',
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
