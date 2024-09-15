import 'package:flutter/material.dart';
import 'package:wallet/components/neu_box.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, this.title, this.subtitle, this.category, required this.account, required this.amount, required this.expense});

  final String? title;
  final String? subtitle;
  final String? category;
  final String account;
  final String amount;
  final bool expense;


  @override
  Widget build(BuildContext context) {
    return NeuBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(227, 182, 188, 1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.category_rounded),
                      const SizedBox(width: 5,),
                      SizedBox(height: 30,child: Center(child: Text(category.toString(), style: const TextStyle(fontWeight: FontWeight.w500),))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20,),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(245, 220, 144, 1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        const Icon(Icons.monetization_on_outlined,),
                        const SizedBox(width: 5,),
                        Text(account, style: const TextStyle(fontWeight: FontWeight.w500),),
                      ],
                    ),
                  )
                ),
              ),
            ],
          ),
          const SizedBox(height: 5,),
          Text(title.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          const SizedBox(height: 5,),
          Text(subtitle.toString(), style: const TextStyle(fontSize: 12),),
          const SizedBox(height: 5,),
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                child: Icon(expense == true ? Icons.upload_rounded: Icons.download_rounded),
              ),
              const SizedBox(width: 10,),
              Text(amount,style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
            ],
          )
        ],
      ),
    );
  }
}
