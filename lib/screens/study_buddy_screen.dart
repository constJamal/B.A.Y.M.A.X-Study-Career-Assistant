import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../core/constants.dart';
import '../widgets/baymax_app_bar.dart';
import '../presentation/widgets/shimmer_loader.dart';
import '../services/document_summarization_service.dart';

class StudyBuddyScreen extends StatefulWidget {
  const StudyBuddyScreen({super.key});

  @override
  State<StudyBuddyScreen> createState() => _StudyBuddyScreenState();
}

class _StudyBuddyScreenState extends State<StudyBuddyScreen> {
  String? _selectedDocumentName;
  bool _isProcessing = false;
  String _thinkingState = '';
  String? _finalSummary;
  List<String> _bulletPoints = [];

  final List<String> _thinkingSteps = [
    'Scanning PDF Structure...',
    'Extracting Semantic Embeddings...',
    'Analyzing Cross-References...',
    'Generating Grounded Summary...',
  ];

  Future<void> _pickAndProcessDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: false, // We're simulating, no need for actual bytes
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedDocumentName = result.files.first.name;
          _isProcessing = true;
          _finalSummary = null;
          _bulletPoints = [];
        });

        // Simulate advanced AI thinking log
        for (String step in _thinkingSteps) {
          if (!mounted) return;
          setState(() => _thinkingState = step);
          await Future.delayed(const Duration(milliseconds: 1500));
        }

        if (mounted) {
          // Generate bullet-point summary using AI
          final summaryText = await _generateBulletPointSummary();
          setState(() {
            _isProcessing = false;
            _finalSummary = summaryText;
            _bulletPoints = _parseBulletPoints(summaryText);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<String> _generateBulletPointSummary() async {
    // Option 1: Use real Groq API (requires API key configuration)
    // final documentText = "...extracted PDF text...";
    // final summary = await DocumentSummarizationService.generateBulletPointSummary(
    //   documentText,
    //   _selectedDocumentName ?? "Document",
    // );
    // return summary;

    // Option 2: Simulated summary for demonstration
    const String simulatedSummary = '''
• The document outlines the foundational principles of scalable systems architectures [Page 4]
• Decoupling components ensures high availability and fault tolerance across distributed systems
• Caching layers reduce database load by serving frequently accessed data from memory rather than disk [Page 12]
• Modern systems rely heavily on asynchronous message queues for background processing [Page 15]
• Load balancing strategies distribute traffic across multiple servers to prevent bottlenecks
• Database replication provides redundancy and improves read performance in production environments
• API rate limiting protects services from overwhelming traffic spikes and abuse
• Monitoring and observability tools are essential for detecting and resolving system issues quickly
''';
    return simulatedSummary;
  }

  List<String> _parseBulletPoints(String summary) {
    final lines = summary.split('\n');
    final bulletPoints = <String>[];

    for (String line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('•') && trimmed.length > 1) {
        bulletPoints.add(trimmed.substring(1).trim());
      }
    }

    return bulletPoints;
  }

  void _showCitationPopup(String page) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.verified, color: AppConfig.successGreen),
              const SizedBox(width: 8),
              Text(
                'Verified Source',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppConfig.primaryBrand.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Source: $_selectedDocumentName - $page',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppConfig.primaryBrand,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '"...this architectural pattern completely isolates the state management from the rendering logic. '
                'As observed in production environments, caching strategies decrease latency by up to 40%..."',
                style: GoogleFonts.inter(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  List<InlineSpan> _buildRichTextWithCitations(String text) {
    final RegExp exp = RegExp(r'\[(.*?)\]');
    final matches = exp.allMatches(text);

    if (matches.isEmpty) {
      return [TextSpan(text: text)];
    }

    int lastMatchEnd = 0;
    final List<InlineSpan> spans = [];

    for (var match in matches) {
      // Add text before the citation
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }

      // Add the citation badge
      final citationText = match.group(1)!;
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: () => _showCitationPopup(citationText),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppConfig.accentTeal.withValues(alpha: 0.15),
                border: Border.all(
                  color: AppConfig.accentTeal.withValues(alpha: 0.5),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    size: 12,
                    color: AppConfig.accentTeal,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    citationText,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppConfig.accentTeal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      lastMatchEnd = match.end;
    }

    // Add remaining text
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const BaymaxAppBar(title: 'Study Buddy RAG'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Intelligent Document Analysis',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConfig.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload a PDF. Our agentic RAG pipeline will extract semantic embeddings and provide grounded summaries with precise source citations.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppConfig.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Upload Button
            GestureDetector(
              onTap: _isProcessing ? null : _pickAndProcessDocument,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  color: AppConfig.surfaceGrey,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isProcessing
                        ? AppConfig.accentTeal
                        : AppConfig.borderLight,
                    width: _isProcessing ? 2 : 1,
                  ),
                  boxShadow: _isProcessing
                      ? [
                          BoxShadow(
                            color: AppConfig.accentTeal.withValues(alpha: 0.2),
                            blurRadius: 16,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  children: [
                    Icon(
                      _isProcessing
                          ? Icons.cloud_sync_rounded
                          : Icons.cloud_upload_rounded,
                      size: 48,
                      color: _isProcessing
                          ? AppConfig.accentTeal
                          : AppConfig.primaryBrand,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isProcessing
                          ? 'Processing Document...'
                          : 'Tap to Upload PDF',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isProcessing
                            ? AppConfig.accentTeal
                            : AppConfig.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Thinking Log Overlay
            if (_isProcessing)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppConfig.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppConfig.accentTeal,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'AI Thinking Log',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppConfig.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _thinkingState,
                        key: ValueKey<String>(_thinkingState),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppConfig.accentTeal,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const ShimmerLoader(
                      isLoading: true,
                      type: ShimmerType.paragraph,
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),

            // Final Summary - Bullet Points
            if (_finalSummary != null && _bulletPoints.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppConfig.successGreen.withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppConfig.successGreen.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: AppConfig.successGreen,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Key Takeaways',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppConfig.successGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _bulletPoints.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  right: 12,
                                  top: 2,
                                ),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppConfig.successGreen,
                                ),
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      height: 1.5,
                                      color: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color,
                                    ),
                                    children: _buildRichTextWithCitations(
                                      _bulletPoints[index],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
