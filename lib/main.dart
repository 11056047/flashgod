
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '心理測驗',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuizPage(),
    );
  }
}
class Question {
  final String questionText; // 問題文字
  final List<String> options; // 選項
  final int correctOptionIndex; // 正確選項索引（可選）

  Question({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });
}

// 問題資料
List<Question> questions = [
  Question(
    questionText: '你喜歡團隊合作嗎？',
    options: ['非常喜歡', '還好', '不喜歡', '討厭'],
    correctOptionIndex: 0,
  ),
  Question(
    questionText: '當你面對壓力時，你會選擇？',
    options: ['解決問題', '尋求幫助', '逃避', '其他'],
    correctOptionIndex: 1,
  ),
];
class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0; // 目前的問題索引
  List<int> selectedAnswers = []; // 使用者選擇的答案

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('心理測驗'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 問題文字
            Text(
              '問題 ${currentQuestionIndex + 1}: ${question.questionText}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
 
            // 選項列表
            ...question.options.asMap().entries.map((entry) {
              int idx = entry.key;
              String option = entry.value;

              return ListTile(
                title: Text(option),
                leading: Radio<int>(
                  value: idx,
                  groupValue: selectedAnswers.length > currentQuestionIndex
                      ? selectedAnswers[currentQuestionIndex]
                      : -1,
                  onChanged: (value) {
                    setState(() {
                      if (selectedAnswers.length > currentQuestionIndex) {
                        selectedAnswers[currentQuestionIndex] = value!;
                      } else {
                        selectedAnswers.add(value!);
                      }
                    });
                  },
                ),
              );
            }),
            SizedBox(height: 20),

            // 上一題 / 下一題按鈕
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentQuestionIndex > 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentQuestionIndex--;
                      });
                    },
                    child: Text('上一題'),
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (currentQuestionIndex < questions.length - 1) {
                      setState(() {
                        currentQuestionIndex++;
                      });
                    } else {
                      // 結束測驗並跳轉到結果頁面
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPage(selectedAnswers),
                        ),
                      );
                    }
                  },
                  child: Text(currentQuestionIndex == questions.length - 1
                      ? '完成'
                      : '下一題'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class ResultPage extends StatelessWidget {
  final List<int> selectedAnswers;

  ResultPage(this.selectedAnswers);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('測驗結果'),
      ),
      body: Center(
        child: Text(
          '你的答案是：${selectedAnswers.join(', ')}',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
