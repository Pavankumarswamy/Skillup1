import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

class AppendContentModulePage1 extends StatefulWidget {
  final String courseId;
  final int moduleIndex;
  final String moduleName;

  const AppendContentModulePage1({
    super.key,
    required this.courseId,
    required this.moduleIndex,
    required this.moduleName,
  });

  @override
  _AppendContentModulePageState createState() =>
      _AppendContentModulePageState();
}

class _AppendContentModulePageState extends State<AppendContentModulePage1> {
  TextEditingController contentController = TextEditingController();
  String selectedType = 'html';
  String currentContent = '';
  bool isPopupVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchModuleContent();
  }

  void _fetchModuleContent() async {
    DatabaseReference contentRef = FirebaseDatabase.instance
        .ref()
        .child('courses')
        .child(widget.courseId)
        .child('modules')
        .child('module_${widget.moduleIndex}')
        .child('content');

    contentRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        try {
          setState(() {
            currentContent = event.snapshot.value as String;
          });
        } catch (e) {
          print("Error parsing content: $e");
          setState(() {
            currentContent = '[]'; // Reset to empty list if parsing fails
          });
        }
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch module content: $error')));
    });
  }

  // Append new content in the database while preserving the old content
  void _appendContent() async {
    if (contentController.text.isNotEmpty) {
      String newContent;

      if (selectedType == "html" || selectedType == "code") {
        // Properly escape newlines and double quotes for both HTML & Code content
        String sanitizedContent = contentController.text
            .replaceAll('"', '\\"') // Escape double quotes
            .replaceAll('\n', '\\n'); // Escape newlines
        newContent = '{"$selectedType": "$sanitizedContent"}';
      } else {
        newContent = '{"$selectedType": "${contentController.text}"}';
      }

      List<dynamic> contentList = [];

      // Decode existing content safely
      if (currentContent.isNotEmpty) {
        try {
          contentList = jsonDecode(currentContent);
        } catch (e) {
          print("Error decoding existing content: $e");
          contentList = [];
        }
      }

      // Append new content
      contentList.add(jsonDecode(newContent));

      // Convert back to JSON
      String updatedContent = jsonEncode(contentList);

      // Firebase database references
      DatabaseReference contentRef = FirebaseDatabase.instance
          .ref()
          .child('courses')
          .child(widget.courseId)
          .child('modules')
          .child('module_${widget.moduleIndex}')
          .child('content');

      contentRef.set(updatedContent).then((_) {
        setState(() {
          currentContent = updatedContent;
        });
        contentController.clear();

        // Update mentor reference
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          DatabaseReference mentorContentRef = FirebaseDatabase.instance
              .ref()
              .child('mentorcourse')
              .child(user.uid)
              .child(widget.courseId)
              .child('modules')
              .child('module_${widget.moduleIndex}')
              .child('content');

          mentorContentRef.set(updatedContent).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text('Content added successfully to both references')));
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Failed to update mentor reference: $error')));
          });
        }

        setState(() {
          isPopupVisible = false;
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save content: $error')));
      });
    }
  }

  void _showContentTypeSelection() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Select Content Type',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800, // Dark blue for the title
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildContentTypeButton(
                  'HTML', Colors.blue.shade100, Colors.blue.shade800),
              SizedBox(height: 10), // Spacing between buttons
              _buildContentTypeButton(
                  'Image URL', Colors.blue.shade100, Colors.blue.shade800),
              SizedBox(height: 10),
              _buildContentTypeButton(
                  'YouTube Video', Colors.blue.shade100, Colors.blue.shade800),
              SizedBox(height: 10),
              _buildContentTypeButton(
                  'Code', Colors.blue.shade100, Colors.blue.shade800),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15), // Rounded corners for the dialog
          ),
          backgroundColor:
              Colors.blue.shade50, // Light sky-blue background for the dialog
        );
      },
    );
  }

// Helper method to create styled ElevatedButton
  Widget _buildContentTypeButton(
      String text, Color backgroundColor, Color textColor) {
    return SizedBox(
      width: 180, // Set a fixed width for all buttons
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          _startAddingContent(text.toLowerCase().replaceAll(' ', ''));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 15), // Adjusted padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Colors.blue.shade300,
              width: 2.5,
            ),
          ),
          elevation: 3,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _startAddingContent(String type) {
    setState(() {
      selectedType = type;
      isPopupVisible = true;
    });
  }

  void _cancelAddingContent() {
    setState(() {
      isPopupVisible = false;
      contentController.clear();
    });
  }

  Widget _buildCodeBlock(String codeContent) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          codeContent.replaceAll('\\n', '\n'),
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            color: Colors.greenAccent,
          ),
        ),
      ),
    );
  }

  Widget _buildContentBlock(String blockType, String content) {
    try {
      List<dynamic> parsedContentList =
          content.startsWith('[') ? jsonDecode(content) : [jsonDecode(content)];

      if (blockType == 'HTML') {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: parsedContentList.expand((item) {
            return [
              if (item is Map && item.containsKey('html'))
                Html(data: item['html'])
              else
                Text('No HTML content available'),
              SizedBox(height: 20),
            ];
          }).toList(),
        );
      } else if (blockType == 'imageurl') {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: parsedContentList.expand((item) {
            return [
              if (item is Map && item.containsKey('imageurl'))
                _buildImage(item['imageurl'])
              else
                Text('No image content available'),
              SizedBox(height: 20),
            ];
          }).toList(),
        );
      } else if (blockType == 'youtubevideo') {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: parsedContentList.expand((item) {
            return [
              if (item is Map && item.containsKey('youtubevideo'))
                _buildYouTubePlayer(item['youtubevideo'])
              else
                Text('No video content available'),
              SizedBox(height: 20),
            ];
          }).toList(),
        );
      } else if (blockType == 'code') {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: parsedContentList.expand((item) {
            return [
              if (item is Map && item.containsKey('code'))
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: HighlightView(
                          item['code'], // Code content
                          language:
                              'html', // Change this based on the language (dart, html, js, etc.)
                          theme:
                              monokaiSublimeTheme, // Syntax highlighting theme
                          padding: EdgeInsets.all(10),
                          textStyle: TextStyle(
                            fontFamily: 'Courier New',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        icon: Icon(Icons.copy, color: Colors.white70, size: 18),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: item['code']))
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Code copied to clipboard!')),
                            );
                          });
                        },
                      ),
                    ),
                  ],
                )
              else
                Text('No code content available'),
              SizedBox(height: 20),
            ];
          }).toList(),
        );
      } else {
        return Text('Unknown content type');
      }
    } catch (e) {
      return Text('Error rendering content: $e');
    }
  }

  Widget _buildYouTubePlayer(String videoUrl) {
    String videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';
    if (videoId.isEmpty) {
      return Text('Invalid video URL');
    }

    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 3), // Blue border
        borderRadius: BorderRadius.circular(25),
        // Rounded corners
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(22), // Slightly smaller for smooth edges
        child: YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
        ),
      ),
    );
  }

  Widget _renderContent(String content) {
    try {
      // Ensure content is a valid JSON array or a single object
      List<dynamic> contentList;

      // Try to decode the content as a list or object
      if (content.startsWith('[')) {
        contentList = jsonDecode(content);
      } else {
        contentList = [jsonDecode(content)];
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: contentList.map((item) {
          if (item is Map) {
            if (item.containsKey('html')) {
              return _buildContentBlock('HTML', jsonEncode([item]));
            } else if (item.containsKey('imageurl')) {
              return _buildContentBlock('imageurl', jsonEncode([item]));
            } else if (item.containsKey('youtubevideo')) {
              return _buildContentBlock('youtubevideo', jsonEncode([item]));
            } else if (item.containsKey('code')) {
              return _buildContentBlock('code', jsonEncode([item]));
            } else {
              return Text('Unknown content type');
            }
          } else {
            return Text('Invalid content format');
          }
        }).toList(),
      );
    } catch (e) {
      return Text('Error rendering content: $e');
    }
  }

  String _extractVideoUrl(String videoJson) {
    try {
      final startIndex = videoJson.indexOf("https://");
      final endIndex = videoJson.indexOf("}", startIndex);
      return videoJson.substring(startIndex, endIndex).trim();
    } catch (e) {
      print("Error extracting video URL: $e");
      return '';
    }
  }

  Widget _buildImage(String imageUrl) {
    try {
      // Ensure that the content passed is a valid image URL
      String actualImageUrl = imageUrl;

      return Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(25), // Rounded corners for the container
          border: Border.all(
            color: Colors.blue, // Border color
            width: 3, // Border width
          ),
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(25), // Rounded corners for the image
          child: Image.network(
            actualImageUrl,
            fit: BoxFit
                .cover, // Ensures the image covers the area without distortion
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child; // Return the image when fully loaded
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ); // Show a progress indicator while loading
            },
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              return Center(
                child: Icon(Icons.error,
                    color: Colors
                        .red), // Show an error icon if the image fails to load
              );
            },
          ),
        ),
      );
    } catch (e) {
      return Center(
        child: Text(
            'Error loading image: $e'), // Catch any error and display an error message
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moduleName),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(
                25), // Rounded corners at the bottom of the AppBar
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25), // Match the rounded corners
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(
                    168, 32, 32, 32), // Darker shadow for 3D effect
                offset: Offset(0, 5), // Shadow position (below the AppBar)
                blurRadius: 2, // Soften the shadow
                spreadRadius: 1.5, // Extend the shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade400, // Lighter blue at the top
                Colors.blue.shade800, // Darker blue at the bottom
              ],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context)
            .requestFocus(FocusNode()), // Dismiss keyboard when tapping outside
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView to make it scrollable
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  elevation:
                      8, // Increased elevation for a more pronounced 3D effect
                  shadowColor: const Color.fromARGB(
                      255, 0, 0, 0), // Blue shade for the shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Rounded corners
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            widget.moduleName
                                .toUpperCase(), // Converts text to uppercase
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Divider(),
                        SizedBox(height: 10),
                        Text(
                          'Current Content: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        currentContent.isNotEmpty
                            ? _renderContent(currentContent)
                            : Text(
                                'No content added yet.',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                isPopupVisible
                    ? Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Smooth rounded corners
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Text
                              Text(
                                'Add $selectedType Content',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              SizedBox(height: 10),

                              // Input Field
                              TextField(
                                controller: contentController,
                                decoration: InputDecoration(
                                  labelText: selectedType == 'html'
                                      ? 'Enter HTML'
                                      : selectedType == 'image'
                                          ? 'Enter Image URL'
                                          : selectedType == 'video'
                                              ? 'Enter YouTube URL'
                                              : '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                maxLines: selectedType == 'html' ? 5 : 2,
                              ),
                              SizedBox(height: 20),

                              // Buttons Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .start, // Left-aligned buttons
                                children: [
                                  // Cancel Button
                                  TextButton(
                                    onPressed: _cancelAddingContent,
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.redAccent,
                                    ),
                                    child: Text('Cancel'),
                                  ),

                                  SizedBox(width: 10),

                                  // Save Button
                                  ElevatedButton(
                                    onPressed: _appendContent,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text('Save'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showContentTypeSelection,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
