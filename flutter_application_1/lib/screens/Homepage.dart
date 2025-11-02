import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class.dart';
import 'package:flutter_application_1/screens/DetailScreen.dart';
import 'package:flutter_application_1/screens/recipepage.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  Recipe? _currentRecipe;
  bool _isLoading = false;
  String? _error;
  final RecipeService _recipeService = RecipeService();
  Future<void> _fetchRandomRecipe() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final recipe = await _recipeService.fetchRandomRecipe();
      setState(() {
        _currentRecipe = recipe; 
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('random recipe genrator'), 
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'do you feeling hungry?', 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              _buildGeneratorButton(),
              const SizedBox(height: 50),
              _buildRecipeDisplay(),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomButton(icon: Icons.favorite, label: 'favorites'), 
                  _buildBottomButton(icon: Icons.book, label: 'cookbook'), 
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildGeneratorButton() {
    return Center(
      child: InkWell(
        onTap: _isLoading ? null : _fetchRandomRecipe,
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isLoading ? Colors.teal.shade200 : Colors.teal,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white) 
                : const Text(
                    'surprise Me!', 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
  Widget _buildRecipeDisplay() {
    if (_error != null) {
      return Text(
        'erorr: $_error',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.red, fontSize: 16),
      );
    } else if (_currentRecipe != null) {
      return RecipeCard(
        recipe: _currentRecipe!,
        onView: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(recipe: _currentRecipe!),
            ),
          );
        },
      );
    } else {
      return const RecipeCard(
        recipe: null,
        onView: null,
      );
    }
  }
  Widget _buildBottomButton({required IconData icon, required String label}) {
    return Column(
      children: [
        Icon(icon, color: Colors.teal),
        Text(label, style: const TextStyle(color: Colors.teal)),
      ],
    );
  }
}
class RecipeCard extends StatelessWidget {
  final Recipe? recipe;
  final VoidCallback? onView;
  const RecipeCard({super.key, required this.recipe, required this.onView});
  @override
  Widget build(BuildContext context) {
    final bool hasRecipe = recipe != null;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'recipee review', 
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                  ),
                  child: hasRecipe
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            recipe!.thumbnail,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                          ),
                        )
                      : const Center(child: Icon(Icons.image, color: Colors.grey)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title:', 
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: hasRecipe ? Colors.black : Colors.grey),
                      ),
                      Text(
                        hasRecipe ? recipe!.name : 'short description', 
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: hasRecipe ? FontWeight.bold : FontWeight.normal),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: onView, //
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Text('view recipe'),
                          label: const Icon(Icons.arrow_right_alt), 
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}