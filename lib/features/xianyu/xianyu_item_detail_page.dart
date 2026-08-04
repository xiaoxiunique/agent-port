import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/xianyu_item.dart';

/// 闲鱼商品详情页 — 跳转闲鱼 APP 查看.
class XianyuItemDetailPage extends StatelessWidget {
  const XianyuItemDetailPage({super.key, required this.item});

  final XianyuItem item;

  Future<void> _openInApp(BuildContext context) async {
    // 闲鱼实际注册的 scheme: fleamarket://item?id=xxx
    // 备选: http://2.taobao.com/item.htm?id=xxx
    final appUri = Uri.parse('fleamarket://item?id=${item.itemId}');
    final fallbackUri =
        Uri.parse('http://2.taobao.com/item.htm?id=${item.itemId}');

    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(fallbackUri)) {
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('未安装闲鱼 APP')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('商品详情'),
        actions: [
          TextButton.icon(
            onPressed: () => _openInApp(context),
            icon: const Icon(Icons.open_in_new),
            label: const Text('在闲鱼中查看'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品图片
            if (item.picUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.picUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 48,
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // 价格
            Text(
              '¥${item.price}',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // 标题
            Text(
              item.title,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),

            // 元信息
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                if (item.area != null)
                  Chip(
                    avatar: const Icon(Icons.location_on_outlined, size: 16),
                    label: Text(item.area!),
                    visualDensity: VisualDensity.compact,
                  ),
                if (item.wantCnt != null && item.wantCnt != '0')
                  Chip(
                    avatar: const Icon(Icons.favorite_outline, size: 16),
                    label: Text('${item.wantCnt}人想要'),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // 打开按钮
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _openInApp(context),
                icon: const Icon(Icons.open_in_new),
                label: const Text('在闲鱼中查看详情'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
