 import 'package:daily_hishab/models/transaction.dart';
  import 'package:daily_hishab/providers/add_transaction_provider.dart';
  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';

  class AddTransactionSheet extends StatefulWidget {
    final Transaction? existingTransaction; //gets the existing transaction when called to edit the transaction
     const AddTransactionSheet({super.key, this.existingTransaction});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {

    final _formKey = GlobalKey<FormState>();

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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                          FocusScope.of(context).unfocus();
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
                  child: TextFormField(
                    validator: (value){
                      final raw = value?.trim() ?? '';
                      if(raw.isEmpty) return 'Please enter an amount';
                      final amount = double.tryParse(raw);
                      if (amount == null || amount <= 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: controller,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                SizedBox(height: 16,),
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
                SizedBox(height: 16,),
                Center(child: ElevatedButton(
                    onPressed: (){
                      final ok = _formKey.currentState?.validate() ?? false;
                      if (!ok) return;
                      final transaction = Transaction(
                          id: widget.existingTransaction?.id ?? '',
                          amount: double.parse(controller.text.trim()),
                          category: selectedCategory,
                          type: type,
                        timestamp: DateTime.now(),
                      );
                      Navigator.pop(context, transaction);

                      }, child: Text(header))),

              ],
            ),
          ),
        ),
      );

    }
}
