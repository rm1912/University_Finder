import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  static String country = "";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isTextFieldEnabled = false;
  TextEditingController countryController = TextEditingController();

  TextStyle _inputTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
  );

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    countryController.dispose();
    super.dispose();
  }

  void _navigateToResultPage() {
    if (countryController.text.isNotEmpty) {
      HomePage.country = countryController.text; // Set the country name
      Navigator.pushNamed(context, 'result_page');
    } else {
      _showEmptyCountryNameDialog();
    }
  }

  void _showEmptyCountryNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            "Error",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "Please enter Country Name",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black, Color(0xFF536982)], // Define the gradient colors you want
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 70, 30, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/bg1.png',
                    height: 80,
                    width: 80,
                  ),
                ],
              ),
              SizedBox(height: 20),
              const Text(
                "Find the best",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "University for you",
                style: TextStyle(
                  letterSpacing: 2,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isTextFieldEnabled = !_isTextFieldEnabled;
                  });
                  if (_isTextFieldEnabled) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                },
                child: AnimatedContainer(
                  padding: const EdgeInsets.only(left: 40),
                  height: 45,
                  width: double.infinity,
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(.1),
                  ),
                  child: Row(
                    children: [
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(_isTextFieldEnabled ? 0.0 : -1.0, 0.0),
                          end: Offset(0.0, 0.0),
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.white.withOpacity(.3),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: AnimatedOpacity(
                          opacity: _isTextFieldEnabled ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: TextFormField(
                            controller: countryController,
                            enabled: _isTextFieldEnabled,
                            style: _isTextFieldEnabled ? _inputTextStyle : TextStyle(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Find here...",
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(.3),
                                fontSize: 18,
                              ),
                            ),
                            onFieldSubmitted: (_) => _navigateToResultPage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Transform.scale(
                    scale: 1.4,
                    child: Image.asset(
                      'assets/bg.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
