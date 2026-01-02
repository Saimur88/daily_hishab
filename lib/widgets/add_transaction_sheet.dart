import 'package:daily_hishab/models/transaction.dart';
import 'package:flutter/material.dart';
class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

List<String> expenseCategories = ['Shopping', 'Entertainment', 'Other'];
List<String> incomeCategories = ['Salary', 'Bonus', 'Business','Other'];


class _AddTransactionSheetState extends State<AddTransactionSheet> {

  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = expenseCategories[0];
  String _header = "Add Expense";


  TransactionType _type = TransactionType.expense;

  @override
  Widget build(BuildContext context) {
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
                        setState(() {
                          _type = TransactionType.expense;
                          _selectedCategory = expenseCategories[0];
                          _header = "Add Expense";
                          _amountController.clear();
                        });
                      },
                      child: Text("Add Expense")
                  ),
                Text("|",style: TextStyle(
                  fontSize: 30,
                ),),
                TextButton(
                    onPressed: (){
                      setState(() {
                        _type = TransactionType.income;
                        _selectedCategory = incomeCategories[0];
                        _header = "Add Income";
                        _amountController.clear();
                      });
                    },
                    child: Text("Add Income")
                )
              ],
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              color: Colors.black,
            ),
            Center(
              child: Text( _header ,style: TextStyle(
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
                controller: _amountController,
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
                Text(_type == TransactionType.expense ? "Expense Category" : "Income Category",style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15
                ),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: DropdownButtonFormField(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )
                ),
                items: _type == TransactionType.expense ? expenseCategories.map((e) => DropdownMenuItem(value: e,child: Text(e),)).toList() : incomeCategories.map((e) => DropdownMenuItem(value: e,child: Text(e),)).toList() ,
                borderRadius: BorderRadius.circular(20),
                onChanged: (newValue){
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },),
            ),
            SizedBox(height: 20,),
            Center(child: ElevatedButton(
                onPressed: (){

                  final transaction = Transaction(
                      amount: double.parse(_amountController.text),
                      category: _selectedCategory,
                      type: _type);
                  Navigator.pop(context, transaction);
                }, child: Text(_type == TransactionType.expense ? "Add Expense" : "Add Income")))

          ],
        ),
      ),
    );
  }
}
