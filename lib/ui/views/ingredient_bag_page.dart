import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cubit/ingredient_bag_cubit.dart';
import '../../data/entity/ingredient_model.dart';

class IngredientBagPage extends StatefulWidget {
  const IngredientBagPage({super.key});

  @override
  State<IngredientBagPage> createState() => _IngredientBagPageState();
}

class _IngredientBagPageState extends State<IngredientBagPage> {
  int selectedIndex = 0; // 0: Missing, 1: Acquired
  int? userId;
  Set<String> selectedMissing = {}; // ✅ Seçilenler

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchBag();
  }

  void _loadUserIdAndFetchBag() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    if (userId != null && context.mounted) {
      context.read<IngredientBagCubit>().fetchBag(userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Ingredients Bag", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 28)),
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildToggleButtons(),
          const Divider(thickness: 0.3),
          Expanded(
            child: BlocBuilder<IngredientBagCubit, IngredientBagState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final missing = state.ingredients.where((e) => !e.isAcquired).toList();
                final acquired = state.ingredients.where((e) => e.isAcquired).toList();

                if (selectedIndex == 0) {
                  if (missing.isEmpty) return _buildEmptyMessage("No missing ingredients.");
                  return _buildMissingList(missing);
                } else {
                  if (acquired.isEmpty) return _buildEmptyMessage("No acquired ingredients yet.");
                  return _buildAcquiredList(acquired);
                }
              },
            ),
          ),
          if (selectedIndex == 0) // Always show the button when in "Missing" tab
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton.icon(
                onPressed: selectedMissing.isNotEmpty && userId != null
                    ? () {
                  for (final ing in selectedMissing) {
                    context.read<IngredientBagCubit>().markAsAcquired(userId!, ing);
                  }
                  setState(() {
                    selectedMissing.clear();
                  });
                }
                    : null, // Disable button if no items are selected or userId is null
                icon: const Icon(Icons.check_circle),
                label: const Text("Mark as Acquired"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0F6),
        borderRadius: BorderRadius.circular(32),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildSwitchButton(0, "Missing"),
          _buildSwitchButton(1, "Acquired"),
        ],
      ),
    );
  }

  Widget _buildSwitchButton(int index, String text) {
    final isSelected = index == selectedIndex;
    final selectedColor = index == 0 ? Colors.redAccent : Colors.green;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          selectedIndex = index;
          selectedMissing.clear();
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : Colors.transparent,
            borderRadius: BorderRadius.circular(32),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyMessage(String message) {
    return Center(
      child: Text(message, style: GoogleFonts.poppins(fontSize: 16)),
    );
  }

  Widget _buildMissingList(List<IngredientItem> missing) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: missing.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) newIndex -= 1;
          final item = missing.removeAt(oldIndex);
          missing.insert(newIndex, item);
        });
      },
      itemBuilder: (context, index) {
        final ing = missing[index];
        return Padding(
          key: ValueKey(ing.name),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle),
            ),
            title: Text(ing.name, style: GoogleFonts.poppins()),
            trailing: Checkbox(
              value: selectedMissing.contains(ing.name),
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    selectedMissing.add(ing.name);
                  } else {
                    selectedMissing.remove(ing.name);
                  }
                });
              },
            ),
            tileColor: Colors.red.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        );
      },
    );
  }

  Widget _buildAcquiredList(List<IngredientItem> acquired) {
    return Column(
      children: [
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: acquired.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final item = acquired.removeAt(oldIndex);
                acquired.insert(newIndex, item);
              });
            },
            itemBuilder: (context, index) {
              final ing = acquired[index];
              return Padding(
                key: ValueKey(ing.name),
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: ReorderableDragStartListener(
                    index: index,
                    child: const Icon(Icons.drag_handle),
                  ),
                  title: Text(ing.name, style: GoogleFonts.poppins()),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      if (userId != null) {
                        context.read<IngredientBagCubit>().deleteIngredient(userId!, ing.name);
                      }
                    },
                  ),
                  tileColor: Colors.green.shade50,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              );
            },
          ),
        ),
        ElevatedButton.icon(
          onPressed: acquired.isNotEmpty && userId != null
              ? () async {
            final bool? confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  "Clear All Ingredients?",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                content: Text(
                  "Are you sure you want to delete all acquired ingredients?",
                  style: GoogleFonts.poppins(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      "Confirm",
                      style: GoogleFonts.poppins(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            );
            if (confirm == true && userId != null) {
              for (final ing in acquired) {
                context.read<IngredientBagCubit>().deleteIngredient(userId!, ing.name);
              }
            }
          }
              : null, // Disable button if no items or userId is null
          icon: const Icon(Icons.delete),
          label: const Text("Clear All"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}