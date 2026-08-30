import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
void main() {
  runApp(const MyApp2());
}
List<List<String>> F=[
  ['23','45','65','54','2','344','56'],
  ['23','45','65','54','2','34e4','56']
];
class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const FactPlanning(factories:[['23','45','65','54','2','344','56'],['23','45','65','54','2','34e4','56']]),
    );
  }
}
class FactPlanning extends StatefulWidget {
  const FactPlanning({super.key,required this.factories });
  /*
  should consist of plans of any updates for existing plant to the plant class in python
  should help plan new plants based on production requiremtn based on previous data 
  should help determine timings for new model 
  */
  final List<List<String>> factories;
  @override
  
  State<FactPlanning> createState() => FactPlanningState();
}
class FactPlanningState extends State<FactPlanning> {
  String factoryname='';
  bool editing=false;
  TextEditingController e1=TextEditingController(text:'Factory ');
  void signout(){}
  void reload(){}

  

  @override
  Widget build (BuildContext context){
    final Graph graph = Graph();

    final Node factory = Node.Id("Factory");
    final Node chassis = Node.Id("Chassis");
    final Node engine = Node.Id("Engine");
    final Node wiring = Node.Id("Wiring");
    final Node inspection = Node.Id("Inspection");
    List<bool> isHovered=[];
    graph.addEdge(factory, chassis);
    graph.addEdge(factory, engine);
    graph.addEdge(engine, wiring);
    graph.addEdge(wiring, inspection);

    final BuchheimWalkerConfiguration config =
        BuchheimWalkerConfiguration();

    config
      ..siblingSeparation = 50
      ..levelSeparation = 80
      ..subtreeSeparation = 50
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT;
    return Scaffold(
      appBar: AppBar(
        leading:FloatingActionButton(onPressed: reload,child:Icon(Icons.update)),
        titleSpacing:100,
        title:SizedBox(width:400,child:TextField(maxLength:20,controller:e1,readOnly:!editing,onChanged:(value) {},onSubmitted:(String value) {e1.text=value;setState((){editing=false;});},)),
        actions:[
          if (!editing) IconButton(icon: Icon(Icons.edit),onPressed:(){setState((){editing=true;});}),
          if (editing) IconButton(icon:Icon(Icons.check),onPressed:(){setState((){editing=false;});}),
          OutlinedButton(onPressed:signout,child: Text('sign out'))
        ]
      ),
      body:SingleChildScrollView(
        scrollDirection:Axis.vertical,
        child:Padding(
          padding:EdgeInsetsGeometry.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 40,
            ),
            child:  Container(
              padding:EdgeInsets.all(20),
              width:double.infinity,
              decoration:BoxDecoration(color:Color.fromARGB(255, 245, 231, 240),borderRadius:BorderRadius.circular(5)),
              child:Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                Text('Highlights'),
                //should represent along with data of success of  some part of system
                Text('${e1.text} layout'),
                // below should be an editable map of factory
                GraphView(
                  graph: graph,
                  algorithm: BuchheimWalkerAlgorithm(
                    config,
                    TreeEdgeRenderer(config),
                  ),
                  builder: (Node node) {

                    final String name = node.key!.value as String;
                    return MouseRegion(
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
                          child: Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                    
                  },
                )
              ],)
            ,)
          ),
          
        ) ,
      )
    ,);
  }
}