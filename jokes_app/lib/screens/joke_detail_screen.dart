import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/joke.dart';

class JokeDetailScreen extends StatelessWidget {
  final Joke joke;

  const JokeDetailScreen({
    super.key,
    required this.joke,
  });

  Widget _buildMetadataItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlags(BuildContext context) {
    final activeFlags = joke.activeFlags;
    if (activeFlags.isEmpty) {
      return _buildMetadataItem(
        context,
        'Flags',
        'No flags',
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Flags: ',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: activeFlags.map((flag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    flag.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          joke.category,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (joke.type == 'twopart') ...[
                      Text(
                        joke.setup,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        joke.delivery,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ] else
                      Text(
                        joke.joke,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Joke Details',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Divider(),
                    _buildMetadataItem(context, 'ID', '#${joke.id}'),
                    _buildMetadataItem(
                      context,
                      'Category',
                      joke.category.toUpperCase(),
                    ),
                    _buildMetadataItem(
                      context,
                      'Type',
                      joke.type == 'single' ? 'Single Part' : 'Two Part',
                    ),
                    _buildMetadataItem(
                      context,
                      'Language',
                      joke.lang.toUpperCase(),
                    ),
                    _buildMetadataItem(
                      context,
                      'Safe',
                      joke.safe ? 'Yes' : 'No',
                    ),
                    _buildFlags(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
