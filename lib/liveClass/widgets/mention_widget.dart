import 'package:b_barna_app/liveClass/models/live_user.dart';
import 'package:flutter/material.dart';

class MentionInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final List<LiveUser> users; // pass your LiveUser list here

  const MentionInputWidget({
    super.key,
    required this.controller,
    required this.onSend,
    required this.users,
  });

  @override
  State<MentionInputWidget> createState() => _MentionInputWidgetState();
}

class _MentionInputWidgetState extends State<MentionInputWidget> {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();

  OverlayEntry? _overlayEntry;
  List<LiveUser> _suggestions = [];
  int _mentionStartIndex = -1;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  // ── Core mention detection ───────────────────
  void _onTextChanged() {
    final text = widget.controller.text;
    final cursor = widget.controller.selection.baseOffset;

    if (cursor < 0) return;

    final sub = text.substring(0, cursor);
    final atIndex = sub.lastIndexOf('@');

    // No '@' found → hide
    if (atIndex == -1) {
      _hideSuggestions();
      return;
    }

    final query = sub.substring(atIndex + 1);

    // Space after '@' means user is done typing the mention
    if (query.contains(' ')) {
      _hideSuggestions();
      return;
    }

    _mentionStartIndex = atIndex;

    final filtered = widget.users.where((u) {
      return u.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (filtered.isEmpty) {
      _hideSuggestions();
      return;
    }

    _suggestions = filtered;
    _showOverlay();
  }

  // ── Select a user from the list ──────────────
  void _selectUser(LiveUser user) {
    final text = widget.controller.text;
    final cursor = widget.controller.selection.baseOffset;

    final before = text.substring(0, _mentionStartIndex);
    final after = cursor < text.length ? text.substring(cursor) : '';

    // Insert @name with a trailing space
    final newText = '$before@${user.name} $after';

    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: before.length + user.name.length + 2, // '@' + name + ' '
      ),
    );

    _hideSuggestions();
    _focusNode.requestFocus();
  }

  // ── Overlay helpers ──────────────────────────
  void _hideSuggestions() {
    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        width: 240,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          // Appears just above the text field
          targetAnchor: Alignment.topLeft,
          followerAnchor: Alignment.bottomLeft,
          offset: const Offset(8, -4),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(10),
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: _MentionSuggestionList(
              suggestions: _suggestions,
              onSelect: _selectUser,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  // ── Build ────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        cursorColor: const Color(0xFF09636E),
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Type a message…',
          hintStyle: TextStyle(
            color: Colors.black.withValues(alpha: 0.6),
            fontSize: 13,
          ),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        ),
        onSubmitted: (_) {
          // If suggestion list is open, do NOT send — user is mid-mention
          if (_overlayEntry != null) return;
          widget.onSend();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Suggestion dropdown list
// ─────────────────────────────────────────────
class _MentionSuggestionList extends StatelessWidget {
  final List<LiveUser> suggestions;
  final ValueChanged<LiveUser> onSelect;

  const _MentionSuggestionList({
    required this.suggestions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final items = suggestions.take(6).toList();
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: items.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: Colors.grey.shade100),
      itemBuilder: (_, i) {
        final user = items[i];
        return InkWell(
          onTap: () => onSelect(user),
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Avatar circle with first letter
                CircleAvatar(
                  radius: 15,
                  backgroundColor: const Color(0xFF09636E),
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Name + online indicator
                Expanded(
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Online dot
                if (user.isOnline)
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF09636E),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}