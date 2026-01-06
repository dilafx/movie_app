import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/services/api_service.dart';
import 'package:movie_app/pages/movie_details_page.dart';
import 'package:movie_app/pages/profile_page.dart';
import 'package:movie_app/pages/search_page.dart'; // Ensure this is imported

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeContent(size), // Index 0: Home
          const SearchPage(), // Index 1: Search
          const ProfilePage(), // Index 2: Profile
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomeContent(Size size) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: Colors.black)),
          Positioned(child: Image.asset('assets/bg1.png')),
          Positioned(
            top: 300,
            right: -150,
            child: Image.asset('assets/bg2.png'),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.1),
                  const Text(
                    'What would You like to watch?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _onItemTapped(1),
                            child: AbsorbPointer(
                              // Prevents keyboard from opening
                              child: TextField(
                                readOnly: true, // Make it read-only
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white38,
                                  hintText: 'Search...',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // GestureDetector(
                        //   onTap: () => _onItemTapped(1), // Switch to Search Tab
                        //   child: Container(
                        //     padding: const EdgeInsets.all(16),
                        //     decoration: BoxDecoration(
                        //       color: Colors.white38,
                        //       borderRadius: BorderRadius.circular(25),
                        //     ),
                        //     child: const Icon(
                        //       Icons.search,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Popular Movies',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMovieList(
                    size,
                    ApiService.fetchMovies(type: 'popular'),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Top Rated Movies',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMovieList(
                    size,
                    ApiService.fetchMovies(type: 'top_rated'),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Upcoming Movies',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMovieList(
                    size,
                    ApiService.fetchMovies(type: 'upcoming'),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieList(Size size, Future<List<MovieModel>> movieFuture) {
    return SizedBox(
      height: size.height * 0.35,
      width: size.width,
      child: FutureBuilder<List<MovieModel>>(
        future: movieFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No Movies Available',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final movie = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailsPage(movie: movie),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w200${movie.posterPath ?? ""}',
                            height: 200,
                            width: 130,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 200,
                                  width: 130,
                                  color: Colors.grey,
                                  child: const Icon(Icons.broken_image),
                                ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 130,
                          child: Text(
                            movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
