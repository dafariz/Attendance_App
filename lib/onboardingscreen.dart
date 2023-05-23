import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'homescreen.dart';

class OnboardingScreen extends StatelessWidget {
  final List<Widget> slides = [
        
    const SlideWidget(
      title: 'Welcome to Attendance App', textAlign: TextAlign.center,
      description: 'Lets Explore Our Features!!',
      imagePath: 'assets/image/Welcome.png',
    ),
    const SlideWidget(
      title: 'View Attendance Record List...', textAlign: TextAlign.center,
      description: 'Here, you are able to view the attendance record list.',
      imagePath: 'assets/image/View_Att.png',
    ),
    const SlideWidget(
      title: 'Adding New Attendance Record...', textAlign: TextAlign.center,
      description: 'Next, you are able to add a new attendance record into the list using add button at bottom right.',
      imagePath: 'assets/image/Add_Att.png',
    ),
    const SlideWidget(
      title: 'Search Attendance Record...', textAlign: TextAlign.center,
      description: 'hard to find a specific record due to the large number of records? this feature can make it easier for you.',
      imagePath: 'assets/image/Search_Att.png',
    ),
    const SlideWidget(
      title: 'View Particular Record...', textAlign: TextAlign.center,
      description: 'You are able to view particular record by just click on the attendance record!!',
      imagePath: 'assets/image/Particular_Rec.png',
    ),
    const SlideWidget(
      title: 'We are finished...', textAlign: TextAlign.center,
      description: 'Get started to our main page...',
      imagePath: 'assets/image/finishedd.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return slides[index];
        },
        itemCount: slides.length,
        pagination: const SwiperPagination(),
        control: const SwiperControl(),
        onIndexChanged: (int index) {
          if (index == slides.length - 1) {
            // User has reached the last slide, otw to attendance record page
              _showLastSlide(context); // Show the last slide with button
          } else {
            // Return void for other slides
            return;
          }
        },
      ),
    );
  }
}

 void _showLastSlide(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thank you!', textAlign: TextAlign.center,),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Slide content...
              const Text(
                'Please Click the button to access the main page.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the main page when the button is clicked
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: const Text('Get Started'),
              ),
            ],
          ),
        );
      },
    );
  }


class SlideWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const SlideWidget({super.key, 
    required this.title, required TextAlign textAlign,
    required this.description,
    required this.imagePath, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath),
          const SizedBox(height: 40.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}



