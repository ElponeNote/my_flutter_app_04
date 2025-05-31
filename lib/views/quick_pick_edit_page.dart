import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/music.dart';
import '../viewmodels/player_viewmodel.dart';
import 'player_page.dart';
import '../resources/sample_data.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuickPickEditPage extends StatefulWidget {
  const QuickPickEditPage({super.key});

  @override
  State<QuickPickEditPage> createState() => _QuickPickEditPageState();
}

class _QuickPickEditPageState extends State<QuickPickEditPage> {
  String nickname = 'SkoolChef';
  String _pendingNickname = 'SkoolChef';
  final TextEditingController _nickController = TextEditingController();
  List<Map<String, dynamic>> quickPicks = [
    {
      'title': 'No One Else Like You',
      'youtubeUrl': 'https://www.youtube.com/watch?v=9r8pJ3Xv1Hc',
      'albumArtUrl': 'https://img.youtube.com/vi/9r8pJ3Xv1Hc/hqdefault.jpg',
      'checked': false,
    },
    {
      'title': 'Sugar',
      'youtubeUrl': 'https://www.youtube.com/watch?v=09R8_2nJtjg',
      'albumArtUrl': 'https://img.youtube.com/vi/09R8_2nJtjg/hqdefault.jpg',
      'checked': false,
    },
    {
      'title': 'Shape of You',
      'youtubeUrl': 'https://www.youtube.com/watch?v=JGwWNGJdvx8',
      'albumArtUrl': 'https://img.youtube.com/vi/JGwWNGJdvx8/hqdefault.jpg',
      'checked': false,
    },
    {
      'title': 'Blinding Lights',
      'youtubeUrl': 'https://www.youtube.com/watch?v=4NRXx6U8ABQ',
      'albumArtUrl': 'https://img.youtube.com/vi/4NRXx6U8ABQ/hqdefault.jpg',
      'checked': false,
    },
  ];
  File? _pendingProfileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _nickController.dispose();
    super.dispose();
  }

  void _addQuickPick() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        final urlController = TextEditingController();
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return CupertinoAlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('추천 곡 추가'),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(CupertinoIcons.xmark, size: 22, color: CupertinoColors.systemGrey),
                  ),
                ],
              ),
              content: Column(
                children: [
                  CupertinoTextField(
                    controller: urlController,
                    placeholder: '유튜브 링크 입력',
                    autofocus: true,
                  ),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text('추가'),
                  onPressed: () {
                    final url = urlController.text.trim();
                    String? videoId;
                    if (url.isNotEmpty) videoId = _extractYoutubeId(url);
                    if (videoId == null || url.isEmpty) {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('입력 오류'),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: const Icon(CupertinoIcons.xmark, size: 22, color: CupertinoColors.systemGrey),
                              ),
                            ],
                          ),
                          content: const Text('유효한 유튜브 링크를 입력하세요.'),
                        ),
                      );
                      return;
                    }
                    setState(() {
                      quickPicks.add({
                        'title': '',
                        'youtubeUrl': url,
                        'albumArtUrl': 'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
                        'checked': false,
                      });
                    });
                    // 팝업 닫지 않음
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('영구 저장'),
                  isDefaultAction: true,
                  onPressed: () {
                    final url = urlController.text.trim();
                    String? videoId;
                    if (url.isNotEmpty) videoId = _extractYoutubeId(url);
                    if (videoId == null || url.isEmpty) {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('입력 오류'),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: const Icon(CupertinoIcons.xmark, size: 22, color: CupertinoColors.systemGrey),
                              ),
                            ],
                          ),
                          content: const Text('유효한 유튜브 링크를 입력하세요.'),
                        ),
                      );
                      return;
                    }
                    // sampleMusics에만 추가
                    sampleMusics.add(Music(
                      title: '',
                      artist: '',
                      albumArtUrl: 'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
                      youtubeUrl: url,
                    ));
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  String? _extractYoutubeId(String url) {
    final regExp = RegExp(r'(?:v=|\/)([0-9A-Za-z_-]{11}).*');
    final match = regExp.firstMatch(url);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }
    return null;
  }

  void _deleteSelected() {
    setState(() {
      quickPicks.removeWhere((item) => item['checked'] == true);
    });
  }

  void _playSelected() {
    // 체크된 곡 중 quickPicks에서 가장 위(첫 번째) 곡을 재생
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final idx = quickPicks.indexWhere((item) => item['checked'] == true);
      if (idx != -1) {
        final item = quickPicks[idx];
        final music = Music(
          title: item['title'] ?? '',
          artist: '',
          albumArtUrl: item['albumArtUrl'] ?? '',
          youtubeUrl: item['youtubeUrl'] ?? '',
        );
        final playerVM = Provider.of<PlayerViewModel>(context, listen: false);
        playerVM.play(music);
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (context) => const PlayerPage()),
        );
      }
    });
  }

  Future<void> _pickProfileImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pendingProfileImage = File(pickedFile.path);
      });
    }
  }

  void _onNicknameChanged(String val) {
    setState(() {
      _pendingNickname = val;
    });
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    if (_pendingProfileImage != null) {
      await prefs.setString('profile_image_path', _pendingProfileImage!.path);
    }
    await prefs.setString('profile_nickname', _pendingNickname);
    nickname = _pendingNickname;
    if (mounted) {
      setState(() {});
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_image_path');
    final nick = prefs.getString('profile_nickname');
    setState(() {
      if (path != null && path.isNotEmpty) {
        _pendingProfileImage = File(path);
      }
      if (nick != null && nick.isNotEmpty) {
        nickname = nick;
        _pendingNickname = nick;
        _nickController.text = nick;
      } else {
        _nickController.text = nickname;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('프로필/추천 선곡 편집'),
        backgroundColor: CupertinoColors.black,
      ),
      backgroundColor: CupertinoColors.black,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // 프로필 편집
            Center(
              child: Column(
                children: [
                  // 1행 2열: 프로필 이미지 + 닉네임 입력
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _pickProfileImage,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: CupertinoColors.activeOrange,
                            shape: BoxShape.circle,
                            image: _pendingProfileImage != null
                                ? DecorationImage(
                                    image: FileImage(_pendingProfileImage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _pendingProfileImage == null
                              ? const Icon(CupertinoIcons.person_solid, color: CupertinoColors.white, size: 38)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CupertinoTextField(
                          controller: _nickController,
                          placeholder: '닉네임 입력',
                          style: const TextStyle(color: CupertinoColors.white, fontSize: 18),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: CupertinoColors.darkBackgroundGray,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onChanged: _onNicknameChanged,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('프로필 사진 업로드 또는 닉네임 수정 후 저장하세요', style: TextStyle(color: CupertinoColors.systemGrey2, fontSize: 13)),
                  const SizedBox(height: 16),
                  CupertinoButton(
                    color: CupertinoColors.activeBlue,
                    borderRadius: BorderRadius.circular(12),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                    onPressed: _saveProfile,
                    child: const Text('저장', style: TextStyle(fontSize: 16, color: CupertinoColors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // 추천 선곡 리스트 헤더 + 추가 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('추천 선곡 리스트', style: TextStyle(color: CupertinoColors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                Container(
                  constraints: BoxConstraints(minHeight: 36),
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    borderRadius: BorderRadius.circular(18),
                    color: CupertinoColors.activeBlue,
                    onPressed: _addQuickPick,
                    child: const Icon(CupertinoIcons.add, color: CupertinoColors.white, size: 22),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...quickPicks.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: CupertinoColors.darkBackgroundGray,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(minHeight: 0),
                      child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        onPressed: () {
                          setState(() {
                            item['checked'] = !(item['checked'] ?? false);
                          });
                        },
                        child: Icon(
                          item['checked'] == true ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.circle,
                          color: item['checked'] == true ? CupertinoColors.activeBlue : CupertinoColors.systemGrey2,
                          size: 26,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        item['albumArtUrl'],
                        width: 38,
                        height: 38,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 38,
                          height: 38,
                          color: CupertinoColors.systemGrey4,
                          child: const Icon(CupertinoIcons.music_note, color: CupertinoColors.systemGrey2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['title'], style: const TextStyle(color: CupertinoColors.white, fontSize: 15)),
                            Text(item['youtubeUrl'], style: const TextStyle(color: CupertinoColors.systemGrey2, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      onPressed: () {
                        setState(() {
                          quickPicks.removeAt(idx);
                        });
                      },
                      child: const Icon(CupertinoIcons.delete, color: CupertinoColors.systemRed, size: 22),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 32),
            // 하단 버튼 1행 3열
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CupertinoButton(
                    color: CupertinoColors.systemGrey2,
                    borderRadius: BorderRadius.circular(12),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    onPressed: _deleteSelected,
                    child: const Text('선택 삭제', style: TextStyle(fontSize: 15, color: CupertinoColors.black, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: CupertinoButton(
                    color: CupertinoColors.activeBlue,
                    borderRadius: BorderRadius.circular(12),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    onPressed: _playSelected,
                    child: const Text('선택 플레이', style: TextStyle(fontSize: 15, color: CupertinoColors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 