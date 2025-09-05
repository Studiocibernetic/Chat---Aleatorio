import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatItemWidget extends StatelessWidget {
  final Map<String, dynamic> chatData;
  final VoidCallback onTap;
  final VoidCallback onPin;
  final VoidCallback onMute;
  final VoidCallback onArchive;
  final VoidCallback onDelete;
  final VoidCallback onBlock;
  final VoidCallback onExport;
  final VoidCallback onClearHistory;

  const ChatItemWidget({
    Key? key,
    required this.chatData,
    required this.onTap,
    required this.onPin,
    required this.onMute,
    required this.onArchive,
    required this.onDelete,
    required this.onBlock,
    required this.onExport,
    required this.onClearHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isOnline = chatData['isOnline'] ?? false;
    final int unreadCount = chatData['unreadCount'] ?? 0;
    final bool isPinned = chatData['isPinned'] ?? false;
    final bool isMuted = chatData['isMuted'] ?? false;
    final String lastMessage = chatData['lastMessage'] ?? '';
    final String timestamp = chatData['timestamp'] ?? '';
    final String nickname = chatData['nickname'] ?? 'Usuário Anônimo';
    final String avatar = chatData['avatar'] ?? '';

    return Slidable(
      key: ValueKey(chatData['id']),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onPin(),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            foregroundColor: Colors.white,
            icon: isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            label: isPinned ? 'Desafixar' : 'Fixar',
          ),
          SlidableAction(
            onPressed: (_) => onMute(),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            foregroundColor: Colors.white,
            icon: isMuted ? Icons.volume_up : Icons.volume_off,
            label: isMuted ? 'Ativar' : 'Silenciar',
          ),
          SlidableAction(
            onPressed: (_) => onArchive(),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Arquivar',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _showDeleteConfirmation(context),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Excluir',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 6.w,
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  child: avatar.isNotEmpty
                      ? CustomImageWidget(
                          imageUrl: avatar,
                          width: 12.w,
                          height: 12.w,
                          fit: BoxFit.cover,
                        )
                      : CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 6.w,
                        ),
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    nickname,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight:
                          unreadCount > 0 ? FontWeight.w600 : FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isPinned)
                  Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: CustomIconWidget(
                      iconName: 'push_pin',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 4.w,
                    ),
                  ),
                if (isMuted)
                  Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: CustomIconWidget(
                      iconName: 'volume_off',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 4.w,
                    ),
                  ),
              ],
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 0.5.h),
              child: Text(
                lastMessage,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: unreadCount > 0
                      ? AppTheme.lightTheme.colorScheme.onSurface
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight:
                      unreadCount > 0 ? FontWeight.w500 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timestamp,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: unreadCount > 0
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        unreadCount > 0 ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                if (unreadCount > 0)
                  Padding(
                    padding: EdgeInsets.only(top: 0.5.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 5.w,
                        minHeight: 2.5.h,
                      ),
                      child: Text(
                        unreadCount > 99 ? '99+' : unreadCount.toString(),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Conversa'),
          content: const Text(
              'Tem certeza que deseja excluir esta conversa? Esta ação não pode ser desfeita.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              _buildContextMenuItem(
                context,
                icon: 'block',
                title: 'Bloquear Usuário',
                onTap: () {
                  Navigator.pop(context);
                  onBlock();
                },
                isDestructive: true,
              ),
              _buildContextMenuItem(
                context,
                icon: 'file_download',
                title: 'Exportar Conversa',
                onTap: () {
                  Navigator.pop(context);
                  onExport();
                },
              ),
              _buildContextMenuItem(
                context,
                icon: 'clear_all',
                title: 'Limpar Histórico',
                onTap: () {
                  Navigator.pop(context);
                  onClearHistory();
                },
                isDestructive: true,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: isDestructive
            ? Colors.red
            : AppTheme.lightTheme.colorScheme.onSurface,
        size: 6.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: isDestructive
              ? Colors.red
              : AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
    );
  }
}
