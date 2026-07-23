import 'package:flutter/material.dart';
import '../../models/evaluation_model.dart';
import 'section7_screen.dart';

class Section6Screen extends StatefulWidget {
  final EvaluationModel evaluation;

  const Section6Screen({super.key, required this.evaluation});

  @override
  State<Section6Screen> createState() => _Section6ScreenState();
}

class _Section6ScreenState extends State<Section6Screen> {
  void _updateScore(String key, String label, int score) {
    setState(() {
      widget.evaluation.section6Data[key] = label;
      widget.evaluation.section6Data['\${key}_score'] = score;
      widget.evaluation.calculateSection6Score();
    });
  }

  Widget _buildRadioGroup(String title, String key, Map<String, int> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ...options.entries.map((entry) {
          return RadioListTile<String>(
            title: Text(entry.key),
            value: entry.key,
            groupValue: widget.evaluation.section6Data[key] as String?,
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

  void _nextScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Section7Screen(evaluation: widget.evaluation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autopercepção do Paciente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Responda baseado na sua percepção atual.',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),

            _buildRadioGroup(
              'Em uma escala de 0 a 10, como você avalia a aparência atual do seu rosto?', 
              'appearance', 
              {
                'Satisfeito (0)': 0,
                'Indiferente (0)': 0,
                'Insatisfeito (1)': 1,
              }
            ),

            _buildRadioGroup(
              'O aspecto atual do seu rosto impacta negativamente na sua confiança no dia a dia?', 
              'confidence_impact', 
              {
                'Sim, muito (2)': 2,
                'Parcialmente (1)': 1,
                'Não impacta (0)': 0,
              }
            ),

            _buildRadioGroup(
              'Você sente que seu rosto aparenta ser mais velho, mais jovem ou compatível com a sua idade cronológica?', 
              'age_perception', 
              {
                'Mais velho (1)': 1,
                'Mais novo (0)': 0,
                'Compatível com a idade (0)': 0,
              }
            ),

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
                    '${widget.evaluation.section6Score} / 4',
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
                    onPressed: _nextScreen,
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
