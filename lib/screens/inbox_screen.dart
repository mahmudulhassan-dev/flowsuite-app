import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  List<dynamic> _threads = [];
  bool _isLoading = true;
  String? _selectedThreadId;
  String? _selectedCustomerName;
  final _messageController = TextEditingController();
  final List<Map<String, dynamic>> _mockMessages = [
    {'sender': 'customer', 'text': 'I would like to inquire about the pricing details of the growth plan.'},
    {'sender': 'agent', 'text': 'Hello! The Growth Plan is \$29/month and includes WhatsApp official API setup.'},
    {'sender': 'customer', 'text': 'Awesome, does it support local payment methods like bKash?'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchThreads();
  }

  Future<void> _fetchThreads() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final result = await apiService.getInboxThreads();
    if (mounted) {
      setState(() {
        _threads = result;
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _selectedThreadId == null) return;

    setState(() {
      _mockMessages.add({'sender': 'agent', 'text': text});
      _messageController.clear();
    });

    final apiService = Provider.of<ApiService>(context, listen: false);
    await apiService.sendInboxMessage(_selectedThreadId!, text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030712),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        title: Text(
          _selectedThreadId == null ? 'Omnichannel Inbox' : _selectedCustomerName ?? 'Chat',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: _selectedThreadId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => setState(() => _selectedThreadId = null),
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF9333EA)))
          : _selectedThreadId == null
              ? _buildThreadsList()
              : _buildChatWindow(),
    );
  }

  Widget _buildThreadsList() {
    if (_threads.isEmpty) {
      return const Center(child: Text('No active threads found.', style: TextStyle(color: Colors.white70)));
    }
    return RefreshIndicator(
      onRefresh: _fetchThreads,
      color: const Color(0xFF9333EA),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _threads.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final thread = _threads[index];
          final String channel = thread['channel'] ?? 'livechat';
          final IconData channelIcon = channel == 'whatsapp'
              ? Icons.phone_android
              : channel == 'messenger'
                  ? Icons.messenger_outline
                  : Icons.chat_bubble_outline;

          final Color channelColor = channel == 'whatsapp'
              ? Colors.green
              : channel == 'messenger'
                  ? Colors.blue
                  : Colors.purple;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedThreadId = thread['id'];
                _selectedCustomerName = thread['customerName'];
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                border: Border.all(color: const Color(0xFF1F2937)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: channelColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(channelIcon, color: channelColor, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          thread['customerName'] ?? 'Customer',
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          thread['lastMessage'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFF4B5563)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatWindow() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _mockMessages.length,
            itemBuilder: (context, index) {
              final msg = _mockMessages[index];
              final isMe = msg['sender'] == 'agent';
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xFF9333EA) : const Color(0xFF1F2937),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: isMe ? const Radius.circular(14) : Radius.zero,
                      bottomRight: isMe ? Radius.zero : const Radius.circular(14),
                    ),
                  ),
                  child: Text(
                    msg['text'] ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Color(0xFF111827),
            border: Border(top: BorderSide(color: Color(0xFF1F2937))),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                    filled: true,
                    fillColor: const Color(0xFF030712),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFF9333EA)),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
