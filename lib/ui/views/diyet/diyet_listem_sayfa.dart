import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


/*class DiyetListemSayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Diet List")),
      body: BlocBuilder<DiyetListemSayfaCubit, DietState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: state.days,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  title: Text("Day ${index + 1}"),
                  subtitle: Text("- ${state.dailyCalories} kcal"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              );
            },
          );
        },
      ),
    );
  }
}*/
