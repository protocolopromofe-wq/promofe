import 'package:flutter/material.dart';
import '../../models/evaluation_model.dart';

class Section7Screen extends StatefulWidget {
  final EvaluationModel evaluation;

  const Section7Screen({super.key, required this.evaluation});

  @override
  State<Section7Screen> createState() => _Section7ScreenState();
}

class _Section7ScreenState extends State<Section7Screen> {
  void _updateData(String key, dynamic value) {
    setState(() {
      widget.evaluation.section7Data[key] = value;
    });
  }

  Widget _buildSlider(String title, String key, int maxVal) {
    int currentVal = widget.evaluation.section7Data[key] as int? ?? 1;
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
          min: 1, // Mínimo 1 para expectativa
          max: maxVal.toDouble(),
          divisions: maxVal - 1,
          label: currentVal.toString(),
          onChanged: (val) {
            _updateData(key, val.toInt());
          },
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1 (Baixa)', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text('5 (Alta)', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
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
            groupValue: widget.evaluation.section7Data[key] as String?,
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

  void _finishCompleteEvaluation() {
    // TODO: Ir para a tela de Dashboard Final e Salvar no Firebase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Avaliação COMPLETADA com sucesso! (Fim do fluxo visual)')),
    );
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expectativas e Adesão'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Esta é a última etapa. Entenda a perspectiva do paciente.',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),

            const Text('Expectativa de Mudança', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 16),
            _buildSlider('Qual o seu grau de expectativa com o tratamento?', 'expectativa_grau', 5),
            
            const SizedBox(height: 32),

            _buildRadioGroup(
              'Em quanto tempo você espera ver os primeiros resultados visíveis?', 
              'expectativa_tempo', 
              [
                'Imediatamente (Nas primeiras sessões)',
                'Curto prazo (1 a 2 meses)',
                'Médio/Longo prazo (3 meses ou mais)',
              ]
            ),

            const SizedBox(height: 16),

            _buildRadioGroup(
              'Qual a sua disponibilidade e adesão para realizar a rotina diária de exercícios em casa?', 
              'adesao_exercicios', 
              [
                'Alta (Consigo dedicar tempo diário facilmente)',
                'Média (Tentarei fazer, mas minha rotina é corrida)',
                'Baixa (Acho difícil conseguir realizar tarefas em casa)',
              ]
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
              const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Etapa Final', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
                  Text(
                    'Expectativas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.teal),
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
                    onPressed: _finishCompleteEvaluation,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text('Concluir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
