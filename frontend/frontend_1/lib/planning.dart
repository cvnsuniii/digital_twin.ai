import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp1());
}
List<List<String>> F=[
  ['23','45','65','54','2','344','56'],
  ['23','45','65','54','2','34e4','56']
];
class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Planning(factories:[['23','45','65','54','2','344','56'],['23','45','65','54','2','34e4','56']]),
    );
  }
}
class Planning extends StatefulWidget {
  const Planning({super.key,required this.factories });
  /*
  should consist of plans of any updates for existing plant to the plant class in python
  should help plan new plants based on production requiremtn based on previous data 
  should help determine timings for new model 
  */
  final List<List<String>> factories;
  @override
  
  State<Planning> createState() => PlanningState();
}
class PlanningState extends State<Planning> {
  List<bool> ishoveredfact=List.filled(F.length+1,false);
  List<bool> ishoveredcomp=List.filled(F.length+1,false);
  List<bool> ishoveredcar=List.filled(F.length+1,false);
  void SignOut(){}
  void RegetData(){}
  @override
  Widget build (BuildContext context){
    return Scaffold(
      bottomNavigationBar:BottomAppBar(child:Text('Last updated on')),
      //planning dept dosent require rapidly updating data and hence only updates when reloaded. also suggest updata data every 2 days 
      appBar:AppBar(title: Text('Planning Department'),actions:[OutlinedButton(onPressed:SignOut,child: Text('Sign Out'))],leading:FloatingActionButton(onPressed: RegetData,child:Icon(Icons.update))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 40,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing:10,
                children: [
                  const Text("Dashboard",style:TextStyle(fontSize: 25,fontWeight:FontWeight.bold)),
                  Text('Highlights',style:TextStyle(fontSize:20,color:Colors.deepPurple,fontWeight:FontWeight.bold)),
                  // show import planning descitions ai generated which needs to be taken 
                  Text('Car Designs',style:TextStyle(fontSize:20,color:Colors.deepPurple,fontWeight:FontWeight.bold)),

                  Row(spacing:20,children:[
                    for (int k=0;k< widget.factories.length ;k++)
                      MouseRegion(
                        onEnter: (_) => setState(() => ishoveredcar[k] = true),
                        onExit: (_) => setState(() => ishoveredcar[k] = false),
                        child: GestureDetector(
                          onTap:(){},//{Navigator.push(context,MaterialPageRoute(builder: (context) =>  const FactDesign(),)) },
                          
                          child:AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            transform: Matrix4.translationValues(
                              0,
                              ishoveredcar[k] ? -5 : 0,
                              0,
                            ),
                            padding: const EdgeInsets.all(20),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: ishoveredcar[k] ? 15 : 5,
                                  color: Colors.black.withValues(alpha:0.15),
                                ),
                              ],
                            ),
                            child:Column(children: [
                              Text('Tesla Model Y',style:TextStyle(fontSize:16)),
                              Text('vehicles produced ${widget.factories[k][0]}'),
                              Text('Average production time ${widget.factories[k][1]}'),
                              Text('companies assosciated ${widget.factories[k][2]}'),
                              Text('Design problems occured ${widget.factories[k][3]}'),
                              Text('vehicles produced yesterday ${widget.factories[k][4]}'),
                              Text('most prone failure type ${widget.factories[k][5]}'),
                              Text('cars failed tests ${widget.factories[k][6]}'),
                              Text('click to plan and view more stats',style:TextStyle(decoration: TextDecoration.underline,))
                            ],)
                          ),
                        
                        ),
                      ),
                      
                    MouseRegion(
                      onEnter: (_) => setState(() => ishoveredcar[widget.factories.length] = true),
                      onExit: (_) => setState(() => ishoveredcar[widget.factories.length] = false),
                      
                      child: GestureDetector(
                        onTap:(){},
                        
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.translationValues(
                            0,
                            ishoveredcar[widget.factories.length] ? -5 : 0,
                            0,
                          ),
                          padding: const EdgeInsets.all(20),
                          
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: ishoveredcar[widget.factories.length] ? 15 : 5,
                                color: Colors.black.withValues(alpha:0.15),
                              ),
                            ],
                          ),
                          child:Icon(Icons.add,size:40),
                        )
                        
                      ),
                    ),
                    
                      
                  ]),


                  Text('Factory Design',style:TextStyle(fontSize:20,color:Colors.deepPurple,fontWeight:FontWeight.bold)),
                  
                  Row(spacing:20,children:[
                    for (int k=0;k< widget.factories.length ;k++)
                      MouseRegion(
                        onEnter: (_) => setState(() => ishoveredfact[k] = true),
                        onExit: (_) => setState(() => ishoveredfact[k] = false),
                        child: GestureDetector(
                          onTap:(){},//{Navigator.push(context,MaterialPageRoute(builder: (context) =>  const FactDesign(),)) },
                          
                          child:AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            transform: Matrix4.translationValues(
                              0,
                              ishoveredfact[k] ? -5 : 0,
                              0,
                            ),
                            padding: const EdgeInsets.all(20),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: ishoveredfact[k] ? 15 : 5,
                                  color: Colors.black.withValues(alpha:0.15),
                                ),
                              ],
                            ),
                            child:Column(children: [
                              Text('vehicles produced ${widget.factories[k][0]}'),
                              Text('designs handled ${widget.factories[k][1]}'),
                              Text('companies assosciated ${widget.factories[k][2]}'),
                              Text('assembly branches inhouse ${widget.factories[k][3]}'),
                              Text('vehicles produced yesterday ${widget.factories[k][4]}'),
                              Text('high delayed supply ${widget.factories[k][5]}'),
                              Text('cars failed tests ${widget.factories[k][6]}'),
                              Text('click to view more stats',style:TextStyle(decoration: TextDecoration.underline,))
                            ],)
                          ),
                        
                        ),
                      ),
                      
                    MouseRegion(
                      onEnter: (_) => setState(() => ishoveredfact[widget.factories.length] = true),
                      onExit: (_) => setState(() => ishoveredfact[widget.factories.length] = false),
                      
                      child: GestureDetector(
                        onTap:(){},
                        
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.translationValues(
                            0,
                            ishoveredfact[widget.factories.length] ? -5 : 0,
                            0,
                          ),
                          padding: const EdgeInsets.all(20),
                          
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: ishoveredfact[widget.factories.length] ? 15 : 5,
                                color: Colors.black.withValues(alpha:0.15),
                              ),
                            ],
                          ),
                          child:Icon(Icons.add,size:40),
                        )
                        
                      ),
                    ),
                    
                      
                  ]),
                  
                  
                  
                  Text('Companies',style:TextStyle(fontSize:20,color:Colors.deepPurple,fontWeight:FontWeight.bold)),

                  Row(spacing:20,children:[
                    for (int k=0;k< widget.factories.length ;k++)
                      MouseRegion(
                        onEnter: (_) => setState(() => ishoveredcomp[k] = true),
                        onExit: (_) => setState(() => ishoveredcomp[k] = false),
                        child: GestureDetector(
                          onTap:(){},//{Navigator.push(context,MaterialPageRoute(builder: (context) =>  const FactDesign(),)) },
                          
                          child:AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            transform: Matrix4.translationValues(
                              0,
                              ishoveredcomp[k] ? -5 : 0,
                              0,
                            ),
                            padding: const EdgeInsets.all(20),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: ishoveredcomp[k] ? 15 : 5,
                                  color: Colors.black.withValues(alpha:0.15),
                                ),
                              ],
                            ),
                            child:Column(children: [
                              Text('${widget.factories[k][0]} types of components produced'),
                              Text('${widget.factories[k][1]} ontime deliveries'),
                              Text('${widget.factories[k][2]} highly delayed deliveries'),
                              Text('${widget.factories[k][3]} pending deliveries'),
                              Text('${widget.factories[k][4]} factories assosciated'),
                              Text('revenue-  ${widget.factories[k][5]}'),
                              
                              Text('click to view more stats and plan',style:TextStyle(decoration: TextDecoration.underline,))
                            ],)
                          ),
                        
                        ),
                      ),
                      
                    MouseRegion(
                      onEnter: (_) => setState(() => ishoveredcomp[widget.factories.length] = true),
                      onExit: (_) => setState(() => ishoveredcomp[widget.factories.length] = false),
                      
                      child: GestureDetector(
                        onTap:(){},
                        
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.translationValues(
                            0,
                            ishoveredcomp[widget.factories.length] ? -5 : 0,
                            0,
                          ),
                          padding: const EdgeInsets.all(20),
                          
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: ishoveredcomp[widget.factories.length] ? 15 : 5,
                                color: Colors.black.withValues(alpha:0.15),
                              ),
                            ],
                          ),
                          child:Icon(Icons.add,size:40),
                        )
                        
                      ),
                    ),
                    
                      
                  ]),

                  Text('Supply chain Plan',style:TextStyle(fontSize:20,color:Colors.deepPurple,fontWeight:FontWeight.bold)),
                  // rest of your UI
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}