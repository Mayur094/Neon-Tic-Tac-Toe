import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<String> board = List.filled(9, ''); // Tracks cell states
  String turn = 'O';
  String result = '';

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      turn = 'O';
      result = '';
    });
  }

  void playMove(int index) {
    if (board[index] != '' || result.isNotEmpty) return; // Ignore if cell filled or game over

    setState(() {
      board[index] = turn;
      if (checkWinner(turn)) {
        result = '$turn Wins!';
      } else if (!board.contains('')) {
        result = 'It\'s a Tie!';
      } else {
        turn = turn == 'O' ? 'X' : 'O';
      }
    });
  }

  bool checkWinner(String player) {
    List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var pattern in winPatterns) {
      if (board[pattern[0]] == player &&
          board[pattern[1]] == player &&
          board[pattern[2]] == player) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF011627),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'TIC TAC TOE',
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: <Color>[Colors.cyan, Colors.purple, Colors.pink],
                    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF17429AFF), Color(0xFF0B295CFF)]),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(width: 2, color: Color(0xFF4F74A8FF)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('CURRENT TURN',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          color: Colors.white24,
                        )),
                    Text(turn,
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          foreground: Paint()
                            ..shader = LinearGradient(
                              colors: [Colors.purple, Colors.pink],
                            ).createShader(Rect.fromLTWH(160, 0, 50, 50)),
                        )),
                    SizedBox(height: 10),
                    Text(result,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        )),
                    SizedBox(height: 10),
                    Container(
                      height: 320,
                      width: 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF0b0f29),
                        border: Border.all(width: 2, color: Color(0xff090e40)),
                        boxShadow: [
                          BoxShadow(color: Color(0xff090e40), blurRadius: 5.0, spreadRadius: 2.0)
                        ],
                      ),
                      padding: EdgeInsets.all(12),
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.cyan, Colors.purple, Colors.pink],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 9,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => playMove(index),
                              child: Container(
                                color: Color(0xFF0b0f29),
                                child: Center(
                                  child: Text(
                                    board[index],
                                    style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.w600,
                                      foreground: Paint()
                                        ..shader = LinearGradient(
                                          colors: [Colors.purple, Colors.pink],
                                        ).createShader(Rect.fromLTWH(0.0, 0.0, 100, 100)),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.cyan, Colors.purple, Colors.pink],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      margin: EdgeInsets.all(20),
                      child: OutlinedButton(
                        onPressed: resetGame,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Color(0xFF0b0f29),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                              colors: [Colors.cyan, Colors.purple, Colors.pink],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight)
                              .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh, size: 40, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'RESET',
                                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
