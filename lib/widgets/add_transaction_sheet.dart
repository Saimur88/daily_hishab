 import 'package:daily_hishab/models/transaction.dart';
  import 'package:daily_hishab/providers/add_transaction_provider.dart';
  import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
  import 'package:provider/provider.dart';

  class AddTransactionSheet extends StatefulWidget {
    final Transaction? existingTransaction; //gets the existing transaction when called to edit the transaction
     const AddTransactionSheet({super.key, this.existingTransaction});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {

    final _formKey = GlobalKey<FormState>();
    final _formFieldKey = GlobalKey<FormFieldState<String>>();
    bool _submitted = false;

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
                          provider.addExpenseSheet();
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _submitted =false;
                          });
                          _formFieldKey.currentState?.reset();
                        },
                        child: Text('Add Expense')
                    ),
                    Text("|",style: TextStyle(
                      fontSize: 30,
                    ),),
                    TextButton(
                        onPressed: () {
                          provider.addIncomeSheet();
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _submitted =false;
                          });
                          _formFieldKey.currentState?.reset();
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
                    key: _formFieldKey,
                    validator: (value){
                      final raw = value?.trim() ?? '';
                      if(raw.isEmpty) return 'Please enter an amount';
                      final amount = double.tryParse(raw);
                      if (amount == null || amount <= 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
                    ],
                    autovalidateMode: _submitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,

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
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                    items: provider.categories
                        .map((e) => DropdownMenuItem<String>(value: e,child: Text(e)))
                        .toList(),
                    borderRadius: BorderRadius.circular(20),
                    onChanged: (newValue){
                      if (newValue == null) return;
                        provider.changeSelected(newValue);
                    },),
                ),
                SizedBox(height: 16,),
                Center(child: ElevatedButton(
                    onPressed: (){
                      setState(() {
                        _submitted =true;
                      });
                      final ok = _formKey.currentState?.validate() ?? false;
                      if (!ok) return;
                      final amount = double.tryParse(controller.text.trim());
                      if (amount == null) {
                        final messenger = ScaffoldMessenger.of(context);
                        messenger.hideCurrentSnackBar();
                        messenger.showSnackBar(const SnackBar(content: Text('Invalid amount'))
                        );
                        return;

                      }
                      final transaction = Transaction(
                          id: widget.existingTransaction?.id ?? '',
                          amount: amount,
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
