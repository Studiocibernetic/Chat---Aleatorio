import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/chat_header_widget.dart';
import './widgets/chat_menu_widget.dart';
import './widgets/message_bubble_widget.dart';
import './widgets/message_input_widget.dart';
import './widgets/typing_indicator_widget.dart';

class MainChatInterface extends StatefulWidget {
  const MainChatInterface({Key? key}) : super(key: key);

  @override
  State<MainChatInterface> createState() => _MainChatInterfaceState();
}

class _MainChatInterfaceState extends State<MainChatInterface> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _partnerTyping = false;
  String _currentPartner = 'Usuário Anônimo';
  bool _isPartnerOnline = true;

  // Mock messages data
  final List<Map<String, dynamic>> _messages = [
    {
      "id": 1,
      "message": "Olá! Como você está?",
      "isSent": false,
      "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
      "deliveryStatus": "read",
    },
    {
      "id": 2,
      "message": "Oi! Estou bem, obrigado por perguntar. E você?",
      "isSent": true,
      "timestamp": DateTime.now().subtract(const Duration(minutes: 14)),
      "deliveryStatus": "read",
    },
    {
      "id": 3,
      "message": "Também estou bem! De onde você é?",
      "isSent": false,
      "timestamp": DateTime.now().subtract(const Duration(minutes: 12)),
      "deliveryStatus": "read",
    },
    {
      "id": 4,
      "message": "Sou do Brasil, São Paulo. E você?",
      "isSent": true,
      "timestamp": DateTime.now().subtract(const Duration(minutes: 10)),
      "deliveryStatus": "delivered",
    },
    {
      "id": 5,
      "message": "Que legal! Eu sou do Rio de Janeiro. Você gosta de música?",
      "isSent": false,
      "timestamp": DateTime.now().subtract(const Duration(minutes: 8)),
      "deliveryStatus": "read",
    },
    {
      "id": 6,
      "message": "Adoro! Principalmente rock e MPB. Qual seu estilo favorito?",
      "isSent": true,
      "timestamp": DateTime.now().subtract(const Duration(minutes: 5)),
      "deliveryStatus": "sent",
    },
  ];

  @override
  void initState() {
    super.initState();
    _simulatePartnerTyping();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _simulatePartnerTyping() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _partnerTyping = true;
        });
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _partnerTyping = false;
            });
          }
        });
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = {
      "id": _messages.length + 1,
      "message": _messageController.text.trim(),
      "isSent": true,
      "timestamp": DateTime.now(),
      "deliveryStatus": "sent",
    };

    setState(() {
      _messages.add(newMessage);
      _isTyping = false;
    });

    _messageController.clear();
    _scrollToBottom();

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Simulate partner response
    _simulatePartnerResponse();
  }

  void _simulatePartnerResponse() {
    final responses = [
      "Interessante! Conte-me mais sobre isso.",
      "Concordo totalmente com você!",
      "Que legal! Nunca pensei nisso dessa forma.",
      "Haha, você é engraçado!",
      "Verdade, também penso assim.",
      "Nossa, que experiência incrível!",
    ];

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _partnerTyping = true;
        });

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            final response =
                responses[DateTime.now().millisecond % responses.length];
            final newMessage = {
              "id": _messages.length + 1,
              "message": response,
              "isSent": false,
              "timestamp": DateTime.now(),
              "deliveryStatus": "read",
            };

            setState(() {
              _messages.add(newMessage);
              _partnerTyping = false;
            });
            _scrollToBottom();
          }
        });
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onTextChanged(String text) {
    final isTyping = text.trim().isNotEmpty;
    if (isTyping != _isTyping) {
      setState(() {
        _isTyping = isTyping;
      });
    }
  }

  void _showNextPartnerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Próximo Parceiro',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Deseja se conectar com um novo usuário? A conversa atual será encerrada.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _connectToNextPartner();
              },
              child: Text('Conectar'),
            ),
          ],
        );
      },
    );
  }

  void _connectToNextPartner() {
    final partners = [
      'MúsicoAnônimo',
      'ViajanteRJ',
      'TechLover',
      'ArtistaBR',
      'BookwormSP',
      'NatureLover',
    ];

    setState(() {
      _currentPartner = partners[DateTime.now().millisecond % partners.length];
      _messages.clear();
      _isPartnerOnline = true;
    });

    // Show connection message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conectado com $_currentPartner'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showChatMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ChatMenuWidget(
          onBlockUser: () {
            Navigator.pop(context);
            _showBlockUserDialog();
          },
          onReportUser: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/user-blocking-and-reporting');
          },
          onSaveChat: () {
            Navigator.pop(context);
            _saveChatLocally();
          },
          onEndSession: () {
            Navigator.pop(context);
            _showEndSessionDialog();
          },
        );
      },
    );
  }

  void _showBlockUserDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Bloquear Usuário',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
          content: Text(
            'Tem certeza que deseja bloquear $_currentPartner? Você não receberá mais mensagens deste usuário.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _blockUser();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: Text('Bloquear'),
            ),
          ],
        );
      },
    );
  }

  void _showEndSessionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Encerrar Sessão',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Deseja encerrar a conversa atual? As mensagens serão perdidas se não forem salvas.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/random-user-discovery');
              },
              child: Text('Encerrar'),
            ),
          ],
        );
      },
    );
  }

  void _blockUser() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_currentPartner foi bloqueado'),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
    Navigator.pushNamed(context, '/random-user-discovery');
  }

  void _saveChatLocally() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conversa salva localmente'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _onMessageLongPress(Map<String, dynamic> message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'copy',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                title: Text('Copiar'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: message['message']));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Mensagem copiada'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              if (!message['isSent']) ...[
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'reply',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 6.w,
                  ),
                  title: Text('Responder'),
                  onTap: () {
                    Navigator.pop(context);
                    _messageController.text = '@${message['message']} ';
                    _messageController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _messageController.text.length),
                    );
                  },
                ),
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'report',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 6.w,
                  ),
                  title: Text(
                    'Denunciar',
                    style:
                        TextStyle(color: AppTheme.lightTheme.colorScheme.error),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                        context, '/user-blocking-and-reporting');
                  },
                ),
              ],
              SizedBox(height: 4.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          ChatHeaderWidget(
            partnerNickname: _currentPartner,
            isOnline: _isPartnerOnline,
            onNextPartner: _showNextPartnerDialog,
            onMenuPressed: _showChatMenu,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Histórico atualizado'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                itemCount: _messages.length + (_partnerTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _partnerTyping) {
                    return TypingIndicatorWidget(isVisible: _partnerTyping);
                  }

                  final message = _messages[index];
                  return MessageBubbleWidget(
                    message: message['message'],
                    isSent: message['isSent'],
                    timestamp: message['timestamp'],
                    deliveryStatus: message['deliveryStatus'],
                    onLongPress: () => _onMessageLongPress(message),
                  );
                },
              ),
            ),
          ),
          MessageInputWidget(
            controller: _messageController,
            onSend: _sendMessage,
            onEmojiPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Seletor de emoji em breve!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            onAttachmentPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Anexos em breve!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            onTextChanged: _onTextChanged,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNextPartnerDialog,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        child: CustomIconWidget(
          iconName: 'skip_next',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 6.w,
        ),
      ),
    );
  }
}
