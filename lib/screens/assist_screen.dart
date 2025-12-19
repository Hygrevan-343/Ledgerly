import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../services/mock_data_service.dart';

class AssistScreen extends StatefulWidget {
  const AssistScreen({super.key});

  @override
  AssistScreenState createState() => AssistScreenState();
}

class AssistScreenState extends State<AssistScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _textFieldFocusNode = FocusNode();
  
  // Method to focus keyboard (called from widget actions)
  void focusKeyboard() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_textFieldFocusNode.canRequestFocus) {
          _textFieldFocusNode.requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assist'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'clear':
                  _clearChat();
                  break;
                case 'export':
                  _exportChat();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Text('Clear Chat'),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Text('Export Chat'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Expanded(
                child: provider.chatMessages.isEmpty
                    ? _buildWelcomeSection()
                    : _buildChatSection(provider),
              ),
              _buildInputSection(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      child: Column(
        children: [
          const SizedBox(height: AppConstants.spacingXL),
          _buildSparkleIcons(),
          const SizedBox(height: AppConstants.spacingL),
          const Text(
            'How can I help?',
            style: TextStyle(
              fontSize: AppConstants.fontSizeXXL,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingS),
          const Text(
            'Ask me anything about your receipts.',
            style: TextStyle(
              fontSize: AppConstants.fontSizeL,
              color: AppConstants.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingXL),
          _buildSuggestionButtons(),
          const SizedBox(height: AppConstants.spacingL),
          _buildComingSoonDisclaimer(),
        ],
      ),
    );
  }

  Widget _buildSparkleIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.auto_awesome,
          color: AppConstants.primaryTeal,
          size: 32,
        ),
        const SizedBox(width: AppConstants.spacingS),
        Icon(
          Icons.auto_awesome,
          color: AppConstants.primaryTeal.withOpacity(0.7),
          size: 24,
        ),
        const SizedBox(width: AppConstants.spacingS),
        Icon(
          Icons.auto_awesome,
          color: AppConstants.primaryTeal.withOpacity(0.5),
          size: 20,
        ),
      ],
    );
  }

  Widget _buildSuggestionButtons() {
    final suggestions = MockDataService.getChatSuggestions();

    return Column(
      children: suggestions.map((suggestion) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: AppConstants.spacingS),
          child: OutlinedButton(
            onPressed: () => _sendSuggestion(suggestion),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppConstants.dividerColor),
              padding: const EdgeInsets.all(AppConstants.spacingM),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
            ),
            child: Text(
              suggestion,
              style: const TextStyle(
                color: AppConstants.textPrimary,
                fontSize: AppConstants.fontSizeM,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildComingSoonDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppConstants.primaryTeal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppConstants.primaryTeal.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppConstants.primaryTeal,
            size: 20,
          ),
          const SizedBox(width: AppConstants.spacingS),
          const Expanded(
            child: Text(
              'AI features use mock responses. Real AI integration coming soon!',
              style: TextStyle(
                color: AppConstants.textPrimary,
                fontSize: AppConstants.fontSizeS,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatSection(AppProvider provider) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(AppConstants.spacingM),
            itemCount: provider.chatMessages.length + (provider.isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.chatMessages.length && provider.isTyping) {
                return _buildTypingIndicator();
              }
              
              final message = provider.chatMessages[index];
              return _buildMessageBubble(message);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingM),
      child: Row(
        mainAxisAlignment: message.isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) _buildAvatarIcon(),
          const SizedBox(width: AppConstants.spacingS),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? AppConstants.primaryTeal 
                    : AppConstants.surfaceDark,
                borderRadius: BorderRadius.circular(AppConstants.radiusM).copyWith(
                  bottomLeft: message.isUser 
                      ? const Radius.circular(AppConstants.radiusM)
                      : const Radius.circular(4),
                  bottomRight: message.isUser 
                      ? const Radius.circular(4)
                      : const Radius.circular(AppConstants.radiusM),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser 
                          ? Colors.white 
                          : AppConstants.textPrimary,
                      fontSize: AppConstants.fontSizeM,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXS),
                  Text(
                    AppHelpers.timeAgo(message.timestamp),
                    style: TextStyle(
                      color: message.isUser 
                          ? Colors.white.withOpacity(0.7)
                          : AppConstants.textSecondary,
                      fontSize: AppConstants.fontSizeS,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingS),
          if (message.isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingM),
      child: Row(
        children: [
          _buildAvatarIcon(),
          const SizedBox(width: AppConstants.spacingS),
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            decoration: BoxDecoration(
              color: AppConstants.surfaceDark,
              borderRadius: BorderRadius.circular(AppConstants.radiusM).copyWith(
                bottomLeft: const Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.5 + (0.5 * value),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppConstants.textSecondary.withOpacity(value),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarIcon() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppConstants.primaryTeal.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.auto_awesome,
        color: AppConstants.primaryTeal,
        size: 20,
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppConstants.dividerColor,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        color: AppConstants.textSecondary,
        size: 20,
      ),
    );
  }

  Widget _buildInputSection(AppProvider provider) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: const BoxDecoration(
        color: AppConstants.surfaceDark,
        border: Border(
          top: BorderSide(
            color: AppConstants.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Voice input button
          IconButton(
            onPressed: () {
              // Placeholder for voice input logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Voice input coming soon!'),
                  backgroundColor: AppConstants.primaryTeal,
                ),
              );
            },
            icon: Icon(
              Icons.mic,
              color: AppConstants.textSecondary.withOpacity(0.5),
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppConstants.primaryTeal.withOpacity(0.1),
              padding: const EdgeInsets.all(AppConstants.spacingS),
            ),
          ),
          const SizedBox(width: AppConstants.spacingS),
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _textFieldFocusNode,
              decoration: const InputDecoration(
                hintText: 'Type your question or request...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingM,
                  vertical: AppConstants.spacingS,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(provider),
              enabled: !provider.isTyping,
            ),
          ),
          const SizedBox(width: AppConstants.spacingS),
          IconButton(
            onPressed: provider.isTyping ? null : () => _sendMessage(provider),
            icon: Icon(
              Icons.send,
              color: provider.isTyping 
                  ? AppConstants.textSecondary 
                  : AppConstants.primaryTeal,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(AppProvider provider) {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      provider.sendChatMessage(message);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _sendSuggestion(String suggestion) {
    final provider = context.read<AppProvider>();
    provider.sendChatMessage(suggestion);
    _scrollToBottom();
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

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.surfaceDark,
        title: const Text(
          'Clear Chat',
          style: TextStyle(color: AppConstants.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to clear all chat messages?',
          style: TextStyle(color: AppConstants.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppConstants.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AppProvider>().clearChat();
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppConstants.primaryTeal),
            ),
          ),
        ],
      ),
    );
  }

  void _exportChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export chat feature coming soon!'),
        backgroundColor: AppConstants.primaryTeal,
      ),
    );
  }
} 