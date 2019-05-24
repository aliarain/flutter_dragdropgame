import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';



void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'PressStart',
      ),
      home: ColorGame(),
    );
    
  }
}



class ColorGame extends StatefulWidget {
  createState() => ColorGameState(); 
}
class ColorGameState extends State<ColorGame>{
/// Track Game Score
  final Map<String , bool> score = {}; 
/// Choice For Game
final Map choices ={
 		'🍏': Colors.green,
    '🍋': Colors.yellow,
    '🍓': Colors.red,
    '🍇': Colors.purple,
    '🍐': Colors.brown,
    '🍩': Colors.pink
 
};
  
    int seed = 0;

  //Play Sounds  
 AudioCache _audioCache = AudioCache();
 

   @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        title: Text('Score ${score.length} / 6'),
        backgroundColor: Colors.black26,),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed:  (){
          setState((){
            score.clear();
            seed++;
          });
        },
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: choices.keys.map((emoji){
              return Draggable<String>(
                data: emoji,
                child: Emoji(emoji: score[emoji] == true ? '☑' : emoji , ),
                feedback: Emoji(emoji: emoji),
                childWhenDragging: Emoji(emoji: '🌱'),
              );

            }).toList()),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: choices.keys.map((emoji) => _buildDragTarget(emoji)).toList()
              ..shuffle(Random(seed)),
            ),
        ],
      ),
      
      );
  }
  Widget _buildDragTarget(emoji){
    return DragTarget<String>(
      builder: (BuildContext context, List <String> incoming,List rejected){
        if (score [emoji] == true){
          return Container(
            color: Colors.white,
            child: Text('Correct!'),
            alignment: Alignment.center,
            height: 80,
            width: 200,
          );
        }else{
          return Container(
            color: choices[emoji],
            height: 80,
            width: 200,
          );
        }
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data){
           setState((){
             score[emoji] = true;
           });
           
      },
      onLeave: (data){},
    );
  }


}

class Emoji extends StatelessWidget {
  const Emoji({Key key,this.emoji}) : super(key: key);
 final String emoji;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        padding: EdgeInsets.all(0),
        child: Text(
          emoji,
          style: TextStyle(color: Colors.black, fontSize: 50),

        ),
      ),
    );
  }
}