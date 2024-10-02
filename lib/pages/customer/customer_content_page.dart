import 'package:flutter/material.dart';
import 'customer_repair_page.dart';

class CustomerContentPage extends StatefulWidget {
  const CustomerContentPage({super.key});

  @override
  State<CustomerContentPage> createState() => _CustomerContentPageState();
}

class FadeSlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeSlidePageRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Start position (right side)
      const end = Offset.zero; // End position (center)
      const curve = Curves.elasticInOut;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}

class _CustomerContentPageState extends State<CustomerContentPage> {
  final PageController _controller = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    Widget buildCard(String title, String description, Widget nextPage) =>
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                if (_controller.hasClients &&
                    _controller.position.hasContentDimensions) {
                  final page = _controller.page ?? 0;
                  final cardIndex = page.round(); // Current page index
                  final isCurrentPage = cardIndex == _controller.page?.round();
                  final scale = isCurrentPage
                      ? 1 - (_controller.page! - cardIndex).abs() * 0.2
                      : 0.8;
                  final opacity = isCurrentPage
                      ? 1 - (_controller.page! - cardIndex).abs()
                      : 0.8;

                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        width: 800,
                        padding: const EdgeInsets.all(16),
                        margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue[900]!, Colors.blueAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 300,
                              ),
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 52,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "nunito",
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                description,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                  fontFamily: "Mont",
                                ),
                              ),
                              const SizedBox(
                                height: 64,
                              ),
                              SizedBox(
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        //ZoomPageRoute(builder: (context) => nextPage),
                                        FadeSlidePageRoute(page: nextPage));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "OPEN SERVICE",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: "nunito",
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    width: 800,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[900]!, Colors.blueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 300,
                          ),
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 52,
                              fontWeight: FontWeight.bold,
                              fontFamily: "nunito",
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontFamily: "Mont",
                            ),
                          ),
                          const SizedBox(
                            height: 64,
                          ),
                          SizedBox(
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    //ZoomPageRoute(builder: (context) => nextPage),
                                    FadeSlidePageRoute(page: nextPage));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "OPEN SERVICE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: "nunito",
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ); // Return an empty container until dimensions are established
                }
              },
            );
          },
        );

    return Scaffold(
      body: PageView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        children: [
          buildCard(
            "REPAIR",
            'Book your luggage to get repaired by our experts',
            const CustomerRepairPage(),
          ),
          buildCard(
            "PICKUP",
            'Schedule a pickup for your luggage after booking',
            const CustomerRepairPage(),
          ),
          buildCard(
            "DELIVERY",
            'Get your repaired luggage delivered back to you',
            const CustomerRepairPage(),
          ),
        ],
      ),
    );
  }
}
