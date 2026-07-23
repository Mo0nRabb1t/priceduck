import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/tables/price_records.dart';
import '../../providers/records_provider.dart';
import '../../repositories/record_repository.dart';
import '../../utils/unit_price.dart';
import '../../theme/app_theme.dart';

/// 记录列表（R1.2：独立圆角白卡，卡片间间隔10px）
class RecordList extends ConsumerWidget {
  const RecordList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(recordsProvider);

    return recordsAsync.when(
      data: (records) {
        if (records.isEmpty) {
          return const Center(
            child: Text('暂无记录',
                style: TextStyle(color: AppTheme.textSecondary)),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 12),
              child: Row(children: [
                const Text('最近记录',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const Spacer(),
                Text('共 ${records.length} 条',
                    style: const TextStyle(
                        fontSize: 13, color: AppTheme.textSecondary)),
              ]),
            ),
            ...records.map((r) {
              final record = RecordRepository.toPriceRecord(r);
              final up = computeUnitPrice(
                  record.price, record.quantity, record.unit);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius:
                        BorderRadius.circular(AppTheme.cardRadius),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(record.product,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary)),
                              const SizedBox(height: 4),
                              Text(
                                '${record.store ?? '未填超市'}  ·  ${_formatTime(record.createdAt)}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Text(up.display,
                            style: AppTheme.priceTextStyle),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) =>
          Center(child: Text('加载失败: $err')),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final target = DateTime(dt.year, dt.month, dt.day);
    final diff = now.difference(target).inDays;
    if (diff == 0) return '今天';
    if (diff == 1) return '昨天';
    if (diff == 2) return '前天';
    if (diff < 7) return '$diff天前';
    return '${dt.month}月${dt.day}日';
  }
}
