import 'package:flutter/cupertino.dart';

class QuickPickEditPage extends StatefulWidget {
  const QuickPickEditPage({super.key});

  @override
  State<QuickPickEditPage> createState() => _QuickPickEditPageState();
}

class _QuickPickEditPageState extends State<QuickPickEditPage> {
  String nickname = 'SkoolChef';
  final TextEditingController _nickController = TextEditingController();
  List<String> quickPicks = [
    'No One Else Like You',
    'Sugar',
    'Shape of You',
    'Blinding Lights',
  ];

  @override
  void initState() {
    super.initState();
    _nickController.text = nickname;
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
        final controller = TextEditingController();
        return CupertinoAlertDialog(
          title: const Text('추천 곡 추가'),
          content: CupertinoTextField(
            controller: controller,
            placeholder: '곡 제목 입력',
            autofocus: true,
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('취소'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              child: const Text('추가'),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    quickPicks.add(controller.text.trim());
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: CupertinoColors.activeOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(CupertinoIcons.person_solid, color: CupertinoColors.white, size: 38),
                  ),
                  const SizedBox(height: 12),
                  CupertinoTextField(
                    controller: _nickController,
                    placeholder: '닉네임 입력',
                    style: const TextStyle(color: CupertinoColors.white, fontSize: 18),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: CupertinoColors.darkBackgroundGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onChanged: (val) {
                      setState(() {
                        nickname = val;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Text('닉네임을 수정하세요', style: TextStyle(color: CupertinoColors.systemGrey2, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // 추천 선곡 리스트
            Text('추천 선곡 리스트', style: TextStyle(color: CupertinoColors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...quickPicks.asMap().entries.map((entry) {
              final idx = entry.key;
              final song = entry.value;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: CupertinoColors.darkBackgroundGray,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Text(song, style: const TextStyle(color: CupertinoColors.white, fontSize: 15)),
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
            const SizedBox(height: 10),
            CupertinoButton(
              color: CupertinoColors.activeBlue,
              borderRadius: BorderRadius.circular(10),
              onPressed: _addQuickPick,
              child: const Text('추천 곡 추가', style: TextStyle(color: CupertinoColors.white)),
            ),
            const SizedBox(height: 32),
            CupertinoButton.filled(
              onPressed: () {
                // 실제 저장 로직은 추후 연동
                showCupertinoDialog(
                  context: context,
                  builder: (context) => const CupertinoAlertDialog(
                    title: Text('저장 완료'),
                    content: Text('프로필과 추천 선곡이 저장되었습니다.'),
                  ),
                );
                if (mounted) {
                Future.delayed(const Duration(seconds: 1), () {
                  if (!mounted) return;
                  Navigator.pop(context);
                });
                }
              },
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
} 