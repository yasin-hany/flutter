import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class.dart';
class ChecklistItem {
  final String text;
  bool isChecked;
  ChecklistItem(this.text, {this.isChecked = false});
}
class DetailScreen extends StatefulWidget {
  final Recipe recipe;
  const DetailScreen({super.key, required this.recipe}); 
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}
class _DetailScreenState extends State<DetailScreen> {
  late List<ChecklistItem> _ingredientList;
  late List<ChecklistItem> _instructionList;
  @override
  void initState() {
    super.initState();
    _ingredientList = _buildIngredientList();
    _instructionList = _buildInstructionList();
  }
  List<ChecklistItem> _buildIngredientList() {
    final List<ChecklistItem> list = [];
    for (int i = 0; i < widget.recipe.ingredients.length; i++) {
      final text =
          '${widget.recipe.measurements[i]} ${widget.recipe.ingredients[i]}';
      list.add(ChecklistItem(text));
    }
    return list;
  }
  List<ChecklistItem> _buildInstructionList() {
    final steps = widget.recipe.instructions
        .split('.')
        .where((s) => s.trim().isNotEmpty)
        .toList();
    return steps.map((step) => ChecklistItem(step.trim())).toList();
  }
  void _toggleCheck(ChecklistItem item) {
    setState(() {
      item.isChecked = !item.isChecked; 
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView( 
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.recipe.name, 
                style: const TextStyle(
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
              background: Image.network(
                widget.recipe.thumbnail,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey.shade300, child: const Center(child: Icon(Icons.image, size: 50))),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'category: ${widget.recipe.category}, ${widget.recipe.area}', 
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle('ingredients'), 
                      _buildChecklist(_ingredientList), 
                      const SizedBox(height: 30),
                      _buildSectionTitle('instructions'), 
                      _buildChecklist(_instructionList, isNumbered: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSectionTitle(String title) {
    return Text(
      title, //
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.teal,
      ),
    );
  }
  Widget _buildChecklist(List<ChecklistItem> items, {bool isNumbered = false}) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true, 
      physics: const NeverScrollableScrollPhysics(), 
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () => _toggleCheck(item), 
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    isNumbered ? '${index + 1}. ${item.text}' : ' ${item.text}', 
                    style: TextStyle(
                      fontSize: 16,
                      decoration: item.isChecked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: item.isChecked ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                Icon(
                  item.isChecked ? Icons.check_box : Icons.check_box_outline_blank, 
                  color: item.isChecked ? Colors.teal : Colors.grey,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}