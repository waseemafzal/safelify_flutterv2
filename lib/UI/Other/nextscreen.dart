import 'package:flutter/material.dart';

class Screen2 extends StatelessWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape:RoundedRectangleBorder(
        borderRadius:BorderRadius.circular(14.0,),
      ),
     title: Padding(
       padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.28),
       child: Container(
         decoration: BoxDecoration(
           color: Colors.red,
           borderRadius: BorderRadius.circular(100)
         ),
         child: Icon(Icons.close,color: Colors.white,),
       ),
     ),
        actions: [
          Center(
            child: Row(children: [
              SizedBox(width: 20,),
              Container(
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: LinearGradient(
                    colors: [Colors.white,Colors.red]
                  )
                ),
                child: Center(child: Text('Flag',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
              ),
              SizedBox(width: 20,),
              Container(
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(

                        colors: [Colors.white,Colors.blue]
                    )
                ),
                child: Center(child: Text('Confirm',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
              ),


            ],),
          )
        ],
    );
  }
}