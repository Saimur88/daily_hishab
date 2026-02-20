import 'package:daily_hishab/models/transaction.dart';
import 'package:daily_hishab/providers/add_transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTransactionSheet extends StatelessWidget {
  final Transaction? existingTransaction;
   const AddTransactionSheet({super.key, this.existingTransaction});

  @override
  Widget build(BuildContext context) {

    final provider = context.read<AddTransactionProvider>();
    final header = context.select((AddTransactionProvider p) => p.header);
    final selectedCategory = context.select((AddTransactionProvider p) => p.selectedCategory);
    final type = context.select((AddTransactionProvider p) => p.type);
    final categoryLabel = context.select((AddTransactionProvider p) => p.categoryLabel);
    final controller = context.read<AddTransactionProvider>().controller;


    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: (){
                      context.read<AddTransactionProvider>().addExpenseSheet();
                    },
                    child: Text('Add Expense')
                ),
                Text("|",style: TextStyle(
                  fontSize: 30,
                ),),
                TextButton(
                    onPressed: () {
                      context.read<AddTransactionProvider>().addIncomeSheet();
                    },
                    child: Text('Add Income')
                )
              ],
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              color: Colors.black,
            ),
            Center(
              child: Text( header ,style: TextStyle(
                fontSize: 20,
              ),),
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(width: 30,height: 30,),
                Text("Amount",style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15
                ),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  floatingLabelStyle: TextStyle(
                    fontSize: 25,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(width: 30,height: 30,),
                Text(categoryLabel,style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15
                ),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: DropdownButtonFormField(
                initialValue: selectedCategory,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),
                items: provider.categories.map((e) => DropdownMenuItem(value: e,child: Text(e),)).toList(),
                borderRadius: BorderRadius.circular(20),
                onChanged: (newValue){
                    provider.changeSelected(newValue!);
                },),
            ),
            SizedBox(height: 20,),
            Center(child: ElevatedButton(
                onPressed: () async {
                  final transaction = Transaction(
                      id: existingTransaction?.id ?? DateTime.now().toIso8601String(),
                      amount: double.parse(controller.text),
                      category: selectedCategory,
                      type: type,
                    timestamp: DateTime.now(),
                  )
                  ;
                  Navigator.pop(context, transaction);
                  }, child: Text(header))),

          ],
        ),
      ),
    );

  }
}
