import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../providers/quran_provider.dart';
import '../models/verse.dart';

class DetailScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;

  const DetailScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isAudioLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuranProvider>(
        context,
        listen: false,
      ).fetchSurahDetail(widget.surahNumber);
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          _isAudioLoading =
              state.processingState == ProcessingState.loading ||
              state.processingState == ProcessingState.buffering;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPauseSurah() async {
    final provider = Provider.of<QuranProvider>(context, listen: false);
    final detail = provider.currentSurahDetail;
    if (detail == null) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        if (_audioPlayer.audioSource == null) {
          final reciterKey = provider.selectedReciter;
          final url = detail.audioFull[reciterKey];
          if (url != null) {
            await _audioPlayer.setUrl(url);
            await _audioPlayer.play();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Audio not available for this reciter'),
              ),
            );
          }
        } else {
          await _audioPlayer.play();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error playing audio: $e')));
    }
  }

  void _showReciterSettings() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      builder: (context) {
        return Consumer<QuranProvider>(
          builder: (context, provider, _) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Reciter',
                    style: GoogleFonts.outfit(
                      color: theme.textTheme.bodyMedium?.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...provider.reciters.entries.map((entry) {
                    return ListTile(
                      title: Text(
                        entry.value,
                        style: GoogleFonts.inter(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      trailing: provider.selectedReciter == entry.key
                          ? Icon(Icons.check, color: theme.primaryColor)
                          : null,
                      onTap: () {
                        provider.setReciter(entry.key);
                        // Reset player if source changes
                        _audioPlayer.stop();
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.surahName,
          style: GoogleFonts.outfit(color: theme.textTheme.bodyMedium?.color),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_voice, color: theme.iconTheme.color),
            onPressed: _showReciterSettings,
          ),
        ],
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading || provider.currentSurahDetail == null) {
            return Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            );
          }

          final detail = provider.currentSurahDetail!;

          return Column(
            children: [
              // Surah Info Card
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.secondary.withOpacity(0.8),
                      theme.primaryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      detail.namaLatin,
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      detail.arti,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 200,
                      height: 1,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${detail.tempatTurun.toUpperCase()} • ${detail.jumlahAyat} VERSES',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Audio Control for Surah
                    ElevatedButton.icon(
                      onPressed: _playPauseSurah,
                      icon: _isAudioLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.primaryColor,
                              ),
                            )
                          : Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: theme.primaryColor,
                            ),
                      label: Text(
                        _isPlaying ? 'Pause Surah' : 'Play Surah',
                        style: GoogleFonts.outfit(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: detail.ayat.length,
                  itemBuilder: (context, index) {
                    final verse = detail.ayat[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: theme.dividerColor.withOpacity(0.1),
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Verse Actions Row
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${verse.nomorAyat}',
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(
                                    Icons.share,
                                    color: theme.primaryColor,
                                    size: 20,
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.play_circle_outline,
                                    color: theme.primaryColor,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    // Can implement verse playback here
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.bookmark_border,
                                    color: theme.primaryColor,
                                    size: 20,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Arabic
                          Text(
                            verse.teksArab,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.amiri(
                              fontSize: 28,
                              height: 2.2,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Latin
                          Text(
                            verse.teksLatin,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: theme.primaryColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Indonesian
                          Text(
                            verse.teksIndonesia,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: theme.textTheme.bodySmall?.color,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
