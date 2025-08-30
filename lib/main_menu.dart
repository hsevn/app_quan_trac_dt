import 'package:flutter/material.dart';
import 'modules/bb_qtmtld/bb_qtmtld_module.dart';
import 'modules/huong_dan_thiet_bi/huong_dan_module.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_AppIcon>[
      _AppIcon(
        icon: Icons.assignment,
        label: 'BB QTMT Lao động',
        onTap: (ctx) => Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => const BBQTMTLDModule()),
        ),
      ),
      _AppIcon(
        icon: Icons.water_drop,
        label: 'Lấy mẫu nước (sắp tới)',
        onTap: (ctx) => ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Chức năng đang phát triển...')),
        ),
      ),
      _AppIcon(
        icon: Icons.info_outline,
        label: 'Hướng Dẫn Thiết Bị',
        onTap: (ctx) => Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => const HuongDanModule()),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ứng dụng Quan Trắc'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive: phone ~4 cột, tablet/desktop nhiều hơn
          final double width = constraints.maxWidth;
          int crossAxisCount;
          if (width < 560) {
            crossAxisCount = 4;
          } else if (width < 900) {
            crossAxisCount = 6;
          } else if (width < 1200) {
            crossAxisCount = 8;
          } else {
            crossAxisCount = 10;
          }

          // Kích cỡ icon & nhãn theo platform width
          final double iconSize = width < 560 ? 28 : 32;
          final double fontSize = width < 560 ? 11 : 12;

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              // mainAxisExtent giúp item có chiều cao nhỏ gọn như launcher
              mainAxisExtent: iconSize + 28 + 18, // icon + text + padding
            ),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final it = items[i];
              return _LauncherIcon(
                icon: it.icon,
                label: it.label,
                iconSize: iconSize,
                fontSize: fontSize,
                onTap: () => it.onTap(context),
              );
            },
          );
        },
      ),
    );
  }
}

class _LauncherIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final double iconSize;
  final double fontSize;
  final VoidCallback onTap;

  const _LauncherIcon({
    required this.icon,
    required this.label,
    required this.iconSize,
    required this.fontSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = Theme.of(context).colorScheme.primary;

    return InkResponse(
      radius: iconSize + 10,
      highlightShape: BoxShape.circle,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Vòng tròn mờ nhẹ kiểu Material You
          Container(
            width: iconSize + 20,
            height: iconSize + 20,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: iconSize, color: iconColor),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 22,
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppIcon {
  final IconData icon;
  final String label;
  final void Function(BuildContext) onTap;
  const _AppIcon({required this.icon, required this.label, required this.onTap});
}
