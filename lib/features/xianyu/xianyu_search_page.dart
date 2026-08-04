import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../data/models/xianyu_item.dart';
import '../../services/xianyu_service.dart';
import 'xianyu_item_detail_page.dart';

/// 闲鱼搜索 Tab 页面.
class XianyuSearchPage extends ConsumerStatefulWidget {
  const XianyuSearchPage({super.key});

  @override
  ConsumerState<XianyuSearchPage> createState() => _XianyuSearchPageState();
}

class _XianyuSearchPageState extends ConsumerState<XianyuSearchPage> {
  late List<String> _keywords;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _keywords = List.from(defaultXianyuKeywords);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      if (_keywords.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _search(_keywords.first);
        });
      }
    }
  }

  void _search(String keyword) {
    if (keyword.trim().isEmpty) return;
    ref.read(xianyuSearchProvider.notifier).search(keyword.trim());
  }

  // ─── 关键词管理 ────────────────────────────────────────

  void _showManageSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _KeywordManageSheet(
        keywords: _keywords,
        onChanged: (list) => setState(() => _keywords = list),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(xianyuSearchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('闲鱼'),
        actions: [
          if (state.keyword != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _search(state.keyword!),
            ),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: '管理关键词',
            onPressed: _showManageSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // 关键词 chips
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _keywords.length + 1,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                if (i == _keywords.length) {
                  return _KeywordChip(
                    label: '+',
                    active: false,
                    onTap: _showManageSheet,
                    compact: true,
                  );
                }
                final kw = _keywords[i];
                final active = state.keyword == kw;
                return _KeywordChip(
                  label: kw,
                  active: active,
                  onTap: () => _search(kw),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

  Widget _buildBody(XianyuSearchState state) {
    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text('搜索失败', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              state.error!,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () {
                if (state.keyword != null) _search(state.keyword!);
              },
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }
    if (state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.storefront_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 12),
            Text(
              state.keyword != null ? '没有找到相关商品' : '选择关键词搜索闲鱼商品',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }
    return _ItemList(items: state.items);
  }
}

// ─── 关键词管理 Bottom Sheet ────────────────────────────────

class _KeywordManageSheet extends StatefulWidget {
  const _KeywordManageSheet({required this.keywords, required this.onChanged});

  final List<String> keywords;
  final ValueChanged<List<String>> onChanged;

  @override
  State<_KeywordManageSheet> createState() => _KeywordManageSheetState();
}

class _KeywordManageSheetState extends State<_KeywordManageSheet> {
  late List<String> _list;

  @override
  void initState() {
    super.initState();
    _list = List.from(widget.keywords);
  }

  void _notify() => widget.onChanged(_list);

  void _add() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('添加关键词'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: '输入关键词'),
          onSubmitted: (_) => _doAdd(ctx, ctrl),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => _doAdd(ctx, ctrl),
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  void _doAdd(BuildContext ctx, TextEditingController ctrl) {
    final v = ctrl.text.trim();
    if (v.isNotEmpty && !_list.contains(v)) {
      setState(() => _list.add(v));
      _notify();
    }
    Navigator.of(ctx).pop();
  }

  void _edit(int index) {
    final ctrl = TextEditingController(text: _list[index]);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('编辑关键词'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: '输入关键词'),
          onSubmitted: (_) => _doEdit(ctx, ctrl, index),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _list.removeAt(index));
              _notify();
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
          FilledButton(
            onPressed: () => _doEdit(ctx, ctrl, index),
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _doEdit(BuildContext ctx, TextEditingController ctrl, int index) {
    final v = ctrl.text.trim();
    if (v.isNotEmpty) {
      setState(() => _list[index] = v);
      _notify();
    }
    Navigator.of(ctx).pop();
  }

  void _delete(int index) {
    setState(() => _list.removeAt(index));
    _notify();
  }

  void _moveUp(int index) {
    if (index == 0) return;
    setState(() {
      final tmp = _list[index];
      _list[index] = _list[index - 1];
      _list[index - 1] = tmp;
    });
    _notify();
  }

  void _moveDown(int index) {
    if (index >= _list.length - 1) return;
    setState(() {
      final tmp = _list[index];
      _list[index] = _list[index + 1];
      _list[index + 1] = tmp;
    });
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollCtrl) {
        return Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '管理关键词',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    onPressed: _add,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('添加'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            // List
            Expanded(
              child: _list.isEmpty
                  ? Center(
                      child: Text(
                        '暂无关键词，点击上方"添加"创建',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollCtrl,
                      itemCount: _list.length,
                      itemBuilder: (context, i) {
                        final kw = _list[i];
                        return ListTile(
                          leading: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          title: Text(kw),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                tooltip: '编辑',
                                onPressed: () => _edit(i),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_upward,
                                    size: 20,
                                    color: i == 0
                                        ? theme.colorScheme.outlineVariant
                                        : null),
                                tooltip: '上移',
                                onPressed: i == 0 ? null : () => _moveUp(i),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_downward,
                                    size: 20,
                                    color: i == _list.length - 1
                                        ? theme.colorScheme.outlineVariant
                                        : null),
                                tooltip: '下移',
                                onPressed: i == _list.length - 1
                                    ? null
                                    : () => _moveDown(i),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    size: 20, color: Colors.red),
                                tooltip: '删除',
                                onPressed: () => _delete(i),
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
    );
  }
}

// ─── 胶囊 Chip ────────────────────────────────────────────

class _KeywordChip extends StatelessWidget {
  const _KeywordChip({
    required this.label,
    required this.active,
    required this.onTap,
    this.compact = false,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    return Material(
      color: active
          ? theme.colorScheme.primary.withValues(alpha: 0.12)
          : Colors.transparent,
      shape: StadiumBorder(
        side: BorderSide(
          color: active
              ? theme.colorScheme.primary.withValues(alpha: 0.5)
              : AgentPortTheme.separator(b),
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 12),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: active ? theme.colorScheme.primary : null,
                fontWeight: active ? FontWeight.w600 : null,
                fontSize: compact ? 14 : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── 商品列表 ────────────────────────────────────────────

class _ItemList extends StatelessWidget {
  const _ItemList({required this.items});
  final List<XianyuItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: items.length,
      itemBuilder: (context, index) => _ItemCard(item: items[index]),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.item});
  final XianyuItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => XianyuItemDetailPage(item: item),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: item.picUrl != null
                    ? Image.network(
                        item.picUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image_outlined,
                          color: theme.colorScheme.outlineVariant,
                        ),
                      )
                    : Icon(
                        Icons.storefront_outlined,
                        color: theme.colorScheme.outlineVariant,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '¥${item.price}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (item.area != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            item.area!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.outlineVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
