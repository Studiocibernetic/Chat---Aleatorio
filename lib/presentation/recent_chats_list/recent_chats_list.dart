import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/chat_item_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/search_bar_widget.dart';

class RecentChatsList extends StatefulWidget {
  const RecentChatsList({Key? key}) : super(key: key);

  @override
  State<RecentChatsList> createState() => _RecentChatsListState();
}

class _RecentChatsListState extends State<RecentChatsList>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  String _searchQuery = '';
  bool _isLoading = false;
  bool _showArchived = false;
  int _currentNavIndex = 0;

  // Mock data for recent chats
  final List<Map<String, dynamic>> _allChats = [
    {
      "id": 1,
      "nickname": "Maria Silva",
      "avatar":
          "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
      "lastMessage":
          "Oi! Como você está hoje? Espero que esteja tudo bem por aí 😊",
      "timestamp": "14:32",
      "unreadCount": 3,
      "isOnline": true,
      "isPinned": true,
      "isMuted": false,
      "isArchived": false,
    },
    {
      "id": 2,
      "nickname": "João Santos",
      "avatar":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "lastMessage":
          "Obrigado pela conversa interessante! Foi muito bom falar sobre viagens",
      "timestamp": "12:15",
      "unreadCount": 0,
      "isOnline": false,
      "isPinned": false,
      "isMuted": false,
      "isArchived": false,
    },
    {
      "id": 3,
      "nickname": "Ana Costa",
      "avatar":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "lastMessage": "Que legal! Também gosto muito de música brasileira 🎵",
      "timestamp": "Ontem",
      "unreadCount": 1,
      "isOnline": true,
      "isPinned": false,
      "isMuted": true,
      "isArchived": false,
    },
    {
      "id": 4,
      "nickname": "Carlos Lima",
      "avatar":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "lastMessage": "Até mais! Foi ótimo conversar contigo",
      "timestamp": "Seg",
      "unreadCount": 0,
      "isOnline": false,
      "isPinned": false,
      "isMuted": false,
      "isArchived": true,
    },
    {
      "id": 5,
      "nickname": "Lucia Ferreira",
      "avatar":
          "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=400",
      "lastMessage":
          "Adorei suas dicas de livros! Vou procurar na biblioteca 📚",
      "timestamp": "Dom",
      "unreadCount": 0,
      "isOnline": true,
      "isPinned": false,
      "isMuted": false,
      "isArchived": false,
    },
  ];

  List<Map<String, dynamic>> get _filteredChats {
    List<Map<String, dynamic>> chats = _allChats.where((chat) {
      final bool matchesArchiveFilter = _showArchived
          ? (chat['isArchived'] == true)
          : (chat['isArchived'] != true);

      if (!matchesArchiveFilter) return false;

      if (_searchQuery.isEmpty) return true;

      final nickname = (chat['nickname'] as String).toLowerCase();
      final lastMessage = (chat['lastMessage'] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();

      return nickname.contains(query) || lastMessage.contains(query);
    }).toList();

    // Sort: pinned first, then by timestamp
    chats.sort((a, b) {
      if (a['isPinned'] == true && b['isPinned'] != true) return -1;
      if (b['isPinned'] == true && a['isPinned'] != true) return 1;
      return 0; // Keep original order for same pin status
    });

    return chats;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Handle scroll events if needed
  }

  Future<void> _refreshChats() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network request
    await Future.delayed(const Duration(milliseconds: 1500));

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    setState(() {
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
    });
  }

  void _navigateToChat(Map<String, dynamic> chatData) {
    Navigator.pushNamed(context, '/main-chat-interface');
  }

  void _startNewChat() {
    Navigator.pushNamed(context, '/random-user-discovery');
  }

  void _pinChat(int chatId) {
    setState(() {
      final chatIndex = _allChats.indexWhere((chat) => chat['id'] == chatId);
      if (chatIndex != -1) {
        _allChats[chatIndex]['isPinned'] =
            !(_allChats[chatIndex]['isPinned'] ?? false);
      }
    });
    HapticFeedback.selectionClick();
  }

  void _muteChat(int chatId) {
    setState(() {
      final chatIndex = _allChats.indexWhere((chat) => chat['id'] == chatId);
      if (chatIndex != -1) {
        _allChats[chatIndex]['isMuted'] =
            !(_allChats[chatIndex]['isMuted'] ?? false);
      }
    });
    HapticFeedback.selectionClick();
  }

  void _archiveChat(int chatId) {
    setState(() {
      final chatIndex = _allChats.indexWhere((chat) => chat['id'] == chatId);
      if (chatIndex != -1) {
        _allChats[chatIndex]['isArchived'] = true;
      }
    });
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Conversa arquivada'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              final chatIndex =
                  _allChats.indexWhere((chat) => chat['id'] == chatId);
              if (chatIndex != -1) {
                _allChats[chatIndex]['isArchived'] = false;
              }
            });
          },
        ),
      ),
    );
  }

  void _deleteChat(int chatId) {
    setState(() {
      _allChats.removeWhere((chat) => chat['id'] == chatId);
    });
    HapticFeedback.heavyImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Conversa excluída'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _blockUser(int chatId) {
    Navigator.pushNamed(context, '/user-blocking-and-reporting');
  }

  void _exportChat(int chatId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exportando conversa...'),
      ),
    );
  }

  void _clearHistory(int chatId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limpar Histórico'),
          content: const Text(
              'Tem certeza que deseja limpar o histórico desta conversa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Histórico limpo'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Limpar'),
            ),
          ],
        );
      },
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 0:
        // Already on chats
        break;
      case 1:
        Navigator.pushNamed(context, '/random-user-discovery');
        break;
      case 2:
        // Navigate to settings (not implemented in this screen)
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredChats = _filteredChats;
    final hasArchivedChats =
        _allChats.any((chat) => chat['isArchived'] == true);

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          _showArchived ? 'Conversas Arquivadas' : 'Random Chat',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        leading: _showArchived
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _showArchived = false;
                  });
                },
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 6.w,
                ),
              )
            : null,
        actions: [
          if (!_showArchived)
            IconButton(
              onPressed: () {
                // Show menu or additional options
              },
              icon: CustomIconWidget(
                iconName: 'more_vert',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          if (!_showArchived)
            SearchBarWidget(
              onSearchChanged: _onSearchChanged,
              onClearSearch: _clearSearch,
            ),
          Expanded(
            child: filteredChats.isEmpty
                ? _showArchived
                    ? _buildArchivedEmptyState()
                    : EmptyStateWidget(onStartChat: _startNewChat)
                : RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _refreshChats,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredChats.length +
                          (hasArchivedChats && !_showArchived ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == filteredChats.length &&
                            hasArchivedChats &&
                            !_showArchived) {
                          return _buildArchivedSection();
                        }

                        final chat = filteredChats[index];
                        return ChatItemWidget(
                          chatData: chat,
                          onTap: () => _navigateToChat(chat),
                          onPin: () => _pinChat(chat['id']),
                          onMute: () => _muteChat(chat['id']),
                          onArchive: () => _archiveChat(chat['id']),
                          onDelete: () => _deleteChat(chat['id']),
                          onBlock: () => _blockUser(chat['id']),
                          onExport: () => _exportChat(chat['id']),
                          onClearHistory: () => _clearHistory(chat['id']),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: !_showArchived
          ? FloatingActionButton(
              onPressed: _startNewChat,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              child: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 7.w,
              ),
            )
          : null,
      bottomNavigationBar: !_showArchived
          ? BottomNavigationWidget(
              currentIndex: _currentNavIndex,
              onTap: _onBottomNavTap,
            )
          : null,
    );
  }

  Widget _buildArchivedSection() {
    final archivedCount =
        _allChats.where((chat) => chat['isArchived'] == true).length;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: 'archive',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 6.w,
        ),
        title: Text(
          'Conversas Arquivadas',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              archivedCount.toString(),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ],
        ),
        onTap: () {
          setState(() {
            _showArchived = true;
          });
        },
      ),
    );
  }

  Widget _buildArchivedEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'archive',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 15.w,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Nenhuma conversa arquivada',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'As conversas arquivadas aparecerão aqui',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
