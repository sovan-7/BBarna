import 'dart:async';

import 'package:b_barna_app/liveClass/models/live_class_model.dart';
import 'package:b_barna_app/liveClass/providers/live_class_viewmodel.dart';
import 'package:b_barna_app/liveClass/screens/live_class_screen.dart';
import 'package:b_barna_app/textSize/text_view_bold.dart';
import 'package:flutter/material.dart';

class ClassCard extends StatefulWidget {
  final LiveClassModel item;
  final LiveClassViewModel vm;
  String classStatus;

  ClassCard({
    required this.item,
    required this.vm,
    required this.classStatus,
    super.key,
  });

  @override
  State<ClassCard> createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
  bool _dotVisible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.classStatus == "live") {
      _timer = Timer.periodic(const Duration(milliseconds: 700), (_) {
        if (mounted) setState(() => _dotVisible = !_dotVisible);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Stack(
              children: [
                // Image
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: widget.item.youtubeVideoLink.isNotEmpty
                      ? Image.network(
                          getYouTubeThumbnail(
                            widget.item.youtubeVideoLink,
                            quality: 'hqdefault',
                          ),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(),
                          loadingBuilder: (_, child, progress) =>
                              progress == null ? child : _placeholder(),
                        )
                      : _placeholder(),
                ),

                // LIVE badge
                if (widget.classStatus == "live")
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE24B4A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedOpacity(
                            opacity: _dotVisible ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(right: 5),
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                            ),
                          ),
                          const Text('LIVE',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.8)),
                        ],
                      ),
                    ),
                  ),

                // Subject label on gradient
                Positioned(
                  bottom: 10,
                  left: 12,
                  child: Text(
                    widget.item.subject,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Info ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextViewBold(
                  textContent: "${widget.item.title} (${widget.item.subject})",
                  textColor: Colors.black.withValues(alpha: 0.9),
                  textSizeNumber: 15,
                ),
                const SizedBox(height: 2),
                TextViewBold(
                  textContent: widget.item.subject,
                  textColor: Colors.black.withValues(alpha: 0.6),
                  textSizeNumber: 13,
                ),
                const SizedBox(height: 10),

                // Teacher + time row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Icon(Icons.person_outline_rounded,
                          size: 18, color: Colors.black.withValues(alpha: 0.6)),
                      const SizedBox(width: 4),
                      TextViewBold(
                        textContent: widget.item.teacherName,
                        textColor: Colors.black.withValues(alpha: 0.6),
                        textSizeNumber: 13,
                      ),
                    ]),
                    Row(children: [
                      Icon(Icons.access_time_rounded,
                          size: 14, color: Colors.black.withValues(alpha: 0.9)),
                      const SizedBox(width: 4),
                      TextViewBold(
                        textContent: widget.vm.formatTimeSlot(widget.item),
                        textColor: Colors.black.withValues(alpha: 0.7),
                        textSizeNumber: 13,
                      ),
                    ]),
                  ],
                ),

                const SizedBox(height: 12),

                // Button
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClassroomScreen(item: widget.item,)));
                  },
                  child: Container(
                      width: double.infinity,
                      height: 35,
                      decoration: BoxDecoration(
                          color: widget.classStatus == "upcoming"
                              ? Colors.transparent
                              : Color(0xFF09636E),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: widget.classStatus == "upcoming"
                                  ? Colors.black.withValues(alpha: 0.3)
                                  : Colors.transparent,
                              width: 1.3)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.classStatus != "upcoming")
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Icon(
                                Icons.play_circle_outline_rounded,
                                size: 17,
                                color: Colors.white,
                              ),
                            ),
                          TextViewBold(
                            textContent: widget.vm.getButtonStatus(
                                widget.item, widget.classStatus),
                            textSizeNumber: 15,
                            textColor: widget.classStatus == "upcoming"
                                ? Colors.black
                                : Colors.white,
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        color: const Color(0xFFEEEEEE),
        child: const Center(
          child: Icon(Icons.play_lesson_rounded,
              size: 48, color: Color(0xFFCCCCCC)),
        ),
      );
  String getYouTubeThumbnail(String url, {String quality = 'maxresdefault'}) {
    final patterns = [
      RegExp(r'youtube\.com/watch\?.*v=([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtu\.be/([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com/shorts/([a-zA-Z0-9_-]{11})'),
      RegExp(r'^([a-zA-Z0-9_-]{11})$'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(url.trim());
      if (match != null) {
        final id = match.group(1)!;
        return 'https://img.youtube.com/vi/$id/$quality.jpg';
      }
    }

    return ""; // invalid URL
  }
}
