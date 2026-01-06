import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/services/api_service.dart';
import 'package:movie_app/pages/movie_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<MovieModel> _searchResults = [];
  bool _isLoading = false;
  Timer? _debounce;

  // This function handles the search logic with a delay
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Wait for 500ms after the user stops typing to call the API
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _performSearch(query);
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() => _isLoading = true);
    try {
      final movies = await ApiService.searchMovies(query);
      setState(() {
        _searchResults = movies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error cleanly
      debugPrint("Error searching: $e");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.deepPurpleAccent,
          decoration: InputDecoration(
            hintText: 'Search movies...',
            hintStyle: TextStyle(color: Colors.grey.shade600),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                : const Icon(Icons.search, color: Colors.grey),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
            )
          : _searchResults.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.movie_creation_outlined,
                    size: 80,
                    color: Colors.grey.shade800,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _searchController.text.isEmpty
                        ? "Start typing to search"
                        : "No results found",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final movie = _searchResults[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailsPage(movie: movie),
                      ),
                    );
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                      width: 50,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 50,
                        height: 75,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  title: Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    movie.releaseDate.toString().split('-')[0], // Shows just the year
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                );
              },
            ),
    );
  }
}
