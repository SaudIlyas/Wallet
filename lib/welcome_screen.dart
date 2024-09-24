import 'package:flutter/material.dart';
import 'package:wallet/components/neu_box.dart';
import 'package:wallet/first_setup.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const  EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5,),
                    Container(
                      width: MediaQuery.sizeOf(context).height*0.1,
                      height: MediaQuery.sizeOf(context).height*0.08,
                      decoration: const BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/Images/wallet-removebg-preview.png"), fit: BoxFit.cover)
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text("Wallet", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),softWrap: true, textAlign: TextAlign.center,),
                    const SizedBox(height: 10,),
                    const Text("Your comprehensive expense tracker and money manager", style: TextStyle(fontSize: 15, fontFamily: "Montserrat"),),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height*0.15,),
              const Text("ENTER WITH OFFLINE ACCOUNT", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black54),),
              const Text("Your data will be saved only locally on your phone. You risk losing your data if you uninstall the app or change your device. To prevent data loss, we recommend exporting backup from settings regularly.", style: TextStyle(color: Colors.black54),),
              SizedBox(height: MediaQuery.sizeOf(context).height*0.05,),
              // SizedBox(
              //   width: MediaQuery.sizeOf(context).width,
              //   height: MediaQuery.sizeOf(context).width*0.15,
              //   child: ElevatedButton(
              //     style: const ButtonStyle(
              //       backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(15, 75, 167, 1)),
              //     ),
              //     onPressed: (){
              //       Navigator.push(context, MaterialPageRoute(builder: (context)=>FirstSetup()));
              //     },
              //     child: const Text("Register - It’s free", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),),
              //   ),
              // )
              GestureDetector(onTap:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=> FirstSetup()));} ,child: const NeuBox(child: Row(children: [CircleAvatar(child: Icon(Icons.account_circle_outlined),),SizedBox(width: 10,), Text("Offline account", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)],)))
            ],
          ),
        )
    );
  }
}
