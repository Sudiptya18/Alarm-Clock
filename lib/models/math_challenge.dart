import 'dart:math';

class MathChallenge {
  final int firstNumber;
  final int secondNumber;
  final String operator;
  final int correctAnswer;
  final String question;

  MathChallenge({
    required this.firstNumber,
    required this.secondNumber,
    required this.operator,
    required this.correctAnswer,
    required this.question,
  });

  factory MathChallenge.generate() {
    final random = Random();
    final operators = ['+', '-', '*', '/'];
    final operator = operators[random.nextInt(operators.length)];
    
    int firstNumber, secondNumber, correctAnswer;
    String question;

    switch (operator) {
      case '+':
        firstNumber = random.nextInt(50) + 1;
        secondNumber = random.nextInt(50) + 1;
        correctAnswer = firstNumber + secondNumber;
        question = '$firstNumber + $secondNumber = ?';
        break;
      case '-':
        firstNumber = random.nextInt(50) + 25;
        secondNumber = random.nextInt(25) + 1;
        correctAnswer = firstNumber - secondNumber;
        question = '$firstNumber - $secondNumber = ?';
        break;
      case '*':
        firstNumber = random.nextInt(12) + 1;
        secondNumber = random.nextInt(12) + 1;
        correctAnswer = firstNumber * secondNumber;
        question = '$firstNumber × $secondNumber = ?';
        break;
      case '/':
        correctAnswer = random.nextInt(12) + 1;
        secondNumber = random.nextInt(12) + 1;
        firstNumber = correctAnswer * secondNumber;
        question = '$firstNumber ÷ $secondNumber = ?';
        break;
      default:
        firstNumber = 1;
        secondNumber = 1;
        correctAnswer = 2;
        question = '1 + 1 = ?';
    }

    return MathChallenge(
      firstNumber: firstNumber,
      secondNumber: secondNumber,
      operator: operator,
      correctAnswer: correctAnswer,
      question: question,
    );
  }

  bool checkAnswer(int userAnswer) {
    return userAnswer == correctAnswer;
  }
}

class MathChallengeSession {
  final List<MathChallenge> challenges;
  final int requiredCorrectAnswers;
  int currentChallengeIndex;
  int correctAnswersCount;
  int wrongAnswersCount;

  MathChallengeSession({
    required this.challenges,
    this.requiredCorrectAnswers = 3,
  }) : currentChallengeIndex = 0,
       correctAnswersCount = 0,
       wrongAnswersCount = 0;

  factory MathChallengeSession.create() {
    final challenges = List.generate(10, (_) => MathChallenge.generate());
    return MathChallengeSession(challenges: challenges);
  }

  MathChallenge get currentChallenge => challenges[currentChallengeIndex];

  bool get isCompleted => correctAnswersCount >= requiredCorrectAnswers;
  
  bool get hasFailed => wrongAnswersCount > 0;

  void reset() {
    currentChallengeIndex = 0;
    correctAnswersCount = 0;
    wrongAnswersCount = 0;
  }

  bool submitAnswer(int answer) {
    if (currentChallenge.checkAnswer(answer)) {
      correctAnswersCount++;
      if (correctAnswersCount >= requiredCorrectAnswers) {
        return true; // Session completed successfully
      }
    } else {
      wrongAnswersCount++;
      // Reset the session if wrong answer
      reset();
      return false;
    }
    
    // Move to next challenge
    currentChallengeIndex = (currentChallengeIndex + 1) % challenges.length;
    return false;
  }

  String get progressText {
    return '$correctAnswersCount / $requiredCorrectAnswers';
  }

  double get progress {
    return correctAnswersCount / requiredCorrectAnswers;
  }
}
