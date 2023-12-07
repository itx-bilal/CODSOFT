class IntroductionScreenContent {
  String image;
  String title;
  String description;

  IntroductionScreenContent({required this.image,required this.title,required this.description});

}
List<IntroductionScreenContent> contents = [
  IntroductionScreenContent(
      image: 'assets/images/pic1.png',
      title: "Welcome to spendX",
      description: "Take control of your finances with our intuitive Expense Tracker app. Monitor your spending, set budgets, and achieve financial goals effortlessly."
  ),
  IntroductionScreenContent(
      image: 'assets/images/pic2.png',
      title: "Effortless Expense Logging",
      description: "Log your daily expenses and income with ease. Our app provides a clear overview of where your money goes, helping you make informed financial decisions."
  ),
  IntroductionScreenContent(
      image: 'assets/images/pic3.png',
      title: "Master Your Finances",
      description: "Create personalized budgets for different spending categories. Receive timely notifications and insights to stay within your budget and save for the things that matter most."
  ),
  IntroductionScreenContent(
      image: 'assets/images/pic4.png',
      title: "Visualize Your Financial Progress",
      description: "Dynamic charts and graphs make it simple to understand your financial trends. Track your progress, identify patterns, and work towards a more secure and prosperous financial future."
  ),
];