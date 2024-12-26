import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/joke.dart';
import '../models/joke_filters.dart';
import '../services/joke_service.dart';
import '../services/api/base_api_client.dart';
import 'joke_detail_screen.dart';

class JokeListScreen extends StatefulWidget {
  const JokeListScreen({super.key});

  @override
  State<JokeListScreen> createState() => _JokeListScreenState();
}

class _JokeListScreenState extends State<JokeListScreen> {
  final _jokeService = JokeService();
  final _jokesNotifier = ValueNotifier<List<Joke>>([]);
  final _isLoadingNotifier = ValueNotifier<bool>(false);
  final _hasErrorNotifier = ValueNotifier<bool>(false);
  final _errorMessageNotifier = ValueNotifier<String>('');

  // API Client selection
  var _selectedClient = ApiClient.dio;

  // Joke filters
  final _selectedCategories = JokeCategory.defaultSelection;
  var _jokeType = JokeType.both;
  var _amount = 10;
  var _safeMode = true;
  final _blacklistFlags = JokeFlag.defaultBlacklist;

  @override
  void dispose() {
    _jokesNotifier.dispose();
    _isLoadingNotifier.dispose();
    _hasErrorNotifier.dispose();
    _errorMessageNotifier.dispose();
    _jokeService.dispose();
    super.dispose();
  }

  Future<void> _loadJokes() async {
    try {
      _isLoadingNotifier.value = true;
      _hasErrorNotifier.value = false;
      _errorMessageNotifier.value = '';

      final jokes = await _jokeService.getJokes(
        client: _selectedClient,
        amount: _amount,
        categories: _selectedCategories,
        safe: _safeMode,
        blacklistFlags: _blacklistFlags,
        type: _jokeType,
      );
      _jokesNotifier.value = jokes;
    } catch (e) {
      _hasErrorNotifier.value = true;
      _errorMessageNotifier.value = e.toString();
    } finally {
      _isLoadingNotifier.value = false;
    }
  }

  void _cancelRequest() {
    _jokeService.cancelRequest();
    _isLoadingNotifier.value = false;
  }

  Widget _buildLoadButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoadingNotifier,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return FilledButton.icon(
            onPressed: _cancelRequest,
            icon: const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            label: const Text('Cancel'),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return FilledButton.icon(
          onPressed: _loadJokes,
          icon: const Icon(Icons.download),
          label: const Text('Load Jokes'),
        );
      },
    );
  }

  Widget _buildFilters() {
    return ExpansionTile(
      title: Text(
        'Filters',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: JokeCategory.values.map((category) {
                    final isSelected = _selectedCategories.contains(category);
                    return FilterChip(
                      label: Text(category.displayName),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedCategories.add(category);
                          } else if (_selectedCategories.length > 1) {
                            _selectedCategories.remove(category);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  'Joke Type',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedButton<JokeType>(
                  segments: JokeType.values.map((type) {
                    return ButtonSegment<JokeType>(
                      value: type,
                      label: Text(type.displayName),
                    );
                  }).toList(),
                  selected: {_jokeType},
                  onSelectionChanged: (selected) {
                    setState(() {
                      _jokeType = selected.first;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Amount',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _amount.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: _amount.toString(),
                  onChanged: (value) {
                    setState(() {
                      _amount = value.toInt();
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Safe Mode',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: _safeMode,
                      onChanged: (value) {
                        setState(() {
                          _safeMode = value;
                          if (value) {
                            _blacklistFlags.addAll(JokeFlag.values);
                          }
                        });
                      },
                    ),
                  ],
                ),
                if (!_safeMode) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Blacklist Flags',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: JokeFlag.values.map((flag) {
                      final isSelected = _blacklistFlags.contains(flag);
                      return FilterChip(
                        label: Text(flag.displayName),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _blacklistFlags.add(flag);
                            } else {
                              _blacklistFlags.remove(flag);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jokes',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadJokes,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select API Client:',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<ApiClient>(
                          segments: const [
                            ButtonSegment<ApiClient>(
                              value: ApiClient.dio,
                              label: Text('Dio'),
                            ),
                            ButtonSegment<ApiClient>(
                              value: ApiClient.http,
                              label: Text('HTTP'),
                            ),
                          ],
                          selected: {_selectedClient},
                          onSelectionChanged: (Set<ApiClient> selected) {
                            setState(() {
                              _selectedClient = selected.first;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: _buildLoadButton(),
                        ),
                      ],
                    ),
                  ),
                  _buildFilters(),
                ],
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: _hasErrorNotifier,
              builder: (context, hasError, child) {
                if (hasError) {
                  return ValueListenableBuilder<String>(
                    valueListenable: _errorMessageNotifier,
                    builder: (context, errorMessage, child) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              errorMessage,
                              style: GoogleFonts.poppins(
                                color: Theme.of(context).colorScheme.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadJokes,
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                return ValueListenableBuilder<List<Joke>>(
                  valueListenable: _jokesNotifier,
                  builder: (context, jokes, child) {
                    if (jokes.isEmpty) {
                      return Center(
                        child: Text(
                          'No jokes loaded yet.\nTap the button above to load some jokes!',
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _loadJokes,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: jokes.length,
                        itemBuilder: (context, index) {
                          final joke = jokes[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                joke.preview,
                                style: GoogleFonts.poppins(),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  joke.category,
                                  style: GoogleFonts.poppins(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        JokeDetailScreen(joke: joke),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
