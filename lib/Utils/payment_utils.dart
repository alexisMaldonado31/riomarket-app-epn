import 'package:flutter/material.dart';
class PaymentUtils{

  Map<String,IconData> list ={
    'ps_wirepayment':Icons.account_balance,
    'ps_cashondelivery':Icons.account_balance_wallet,
    'kushkipagos':Icons.credit_card,
    'paypal':Icons.payment
  };

  IconData cargarIconos(String name){
    if(list.containsKey(name)){
      return list[name];
    }
    return Icons.payment;
  }

}