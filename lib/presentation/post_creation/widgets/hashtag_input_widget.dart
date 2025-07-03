import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HashtagInputWidget extends StatefulWidget {
  final List<String> selectedHashtags;
  final Function(List<String>) onHashtagsChanged;

  const HashtagInputWidget({
    super.key,
    required this.selectedHashtags,
    required this.onHashtagsChanged,
  });

  @override
  State<HashtagInputWidget> createState() => _HashtagInputWidgetState();
}

class _HashtagInputWidgetState extends State<HashtagInputWidget> {
  final TextEditingController _hashtagController = TextEditingController();
  final FocusNode _hashtagFocusNode = FocusNode();

  final List<String> _trendingHashtags = [
    '#motorcycle',
    '#roadtrip',
    '#bikelife',
    '#carshow',
    '#modification',
    '#racing',
    '#vintage',
    '#sportbike',
    '#cruiser',
    '#adventure',
    '#touring',
    '#custom',
    '#garage',
    '#mechanic',
    '#restoration',
  ];

  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _hashtagController.addListener(_onHashtagChanged);
    _hashtagFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _hashtagController.dispose();
    _hashtagFocusNode.dispose();
    super.dispose();
  }

  void _onHashtagChanged() {
    final text = _hashtagController.text.toLowerCase();
    if (text.isNotEmpty) {
      setState(() {
        _filteredSuggestions = _trendingHashtags
            .where((hashtag) =>
                hashtag.toLowerCase().contains(text) &&
                !widget.selectedHashtags.contains(hashtag))
            .take(5)
            .toList();
        _showSuggestions = _filteredSuggestions.isNotEmpty;
      });
    } else {
      setState(() {
        _showSuggestions = false;
        _filteredSuggestions.clear();
      });
    }
  }

  void _onFocusChanged() {
    if (!_hashtagFocusNode.hasFocus) {
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  void _addHashtag(String hashtag) {
    if (!widget.selectedHashtags.contains(hashtag) &&
        widget.selectedHashtags.length < 10) {
      final updatedHashtags = List<String>.from(widget.selectedHashtags);
      updatedHashtags.add(hashtag);
      widget.onHashtagsChanged(updatedHashtags);
      _hashtagController.clear();
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  void _removeHashtag(String hashtag) {
    final updatedHashtags = List<String>.from(widget.selectedHashtags);
    updatedHashtags.remove(hashtag);
    widget.onHashtagsChanged(updatedHashtags);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.accentBlue.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'tag',
                color: AppTheme.accentBlue,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Hashtags (${widget.selectedHashtags.length}/10)',
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
              ),
              if (widget.selectedHashtags.isNotEmpty)
                GestureDetector(
                  onTap: () => widget.onHashtagsChanged([]),
                  child: CustomIconWidget(
                    iconName: 'clear_all',
                    color: AppTheme.textSecondary,
                    size: 5.w,
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          if (widget.selectedHashtags.isNotEmpty) ...[
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: widget.selectedHashtags.map((hashtag) {
                return _buildHashtagChip(hashtag);
              }).toList(),
            ),
            SizedBox(height: 2.h),
          ],
          TextField(
            controller: _hashtagController,
            focusNode: _hashtagFocusNode,
            decoration: InputDecoration(
              hintText: 'Add hashtag...',
              prefixText: '#',
              prefixStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.accentBlue,
              ),
              suffixIcon: _hashtagController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        final hashtag = '#${_hashtagController.text.trim()}';
                        if (hashtag.length > 1) {
                          _addHashtag(hashtag);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'add',
                          color: AppTheme.accentBlue,
                          size: 5.w,
                        ),
                      ),
                    )
                  : null,
            ),
            onSubmitted: (value) {
              final hashtag = '#${value.trim()}';
              if (hashtag.length > 1) {
                _addHashtag(hashtag);
              }
            },
          ),
          if (_showSuggestions) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.secondaryDark,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.accentBlue.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggestions',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _filteredSuggestions.map((hashtag) {
                      return GestureDetector(
                        onTap: () => _addHashtag(hashtag),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: AppTheme.accentBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.accentBlue.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            hashtag,
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.accentBlue,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
          if (widget.selectedHashtags.isEmpty) ...[
            SizedBox(height: 2.h),
            Text(
              'Popular hashtags',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: _trendingHashtags.take(6).map((hashtag) {
                return GestureDetector(
                  onTap: () => _addHashtag(hashtag),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.textSecondary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      hashtag,
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHashtagChip(String hashtag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.accentBlue.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentBlue.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hashtag,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.accentBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 1.w),
          GestureDetector(
            onTap: () => _removeHashtag(hashtag),
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.accentBlue,
              size: 4.w,
            ),
          ),
        ],
      ),
    );
  }
}
