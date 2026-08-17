import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final result = await apiService.getDashboardStats();
    if (mounted) {
      setState(() {
        _stats = result['stats'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030712), // bg-slate-950
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827), // bg-slate-900
        title: const Text('FlowSuite Control Center', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF9333EA)))
          : RefreshIndicator(
              onRefresh: _fetchStats,
              color: const Color(0xFF9333EA),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0x331E3A8A), Color(0x1F312E81), Color(0xFF111827)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: Colors.blue.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enterprise Omnichannel Suite',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Your social publishing, AI agents, unified inbox, and local billing infrastructure are fully operational.',
                            style: TextStyle(color: Color(0xFFD1D5DB), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Quick Stats Grid
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildStatCard(
                          'Scheduled Posts',
                          _stats?['scheduled_posts']?.toString() ?? '128',
                          '+14% this month',
                          Icons.calendar_month,
                          Colors.blue,
                        ),
                        _buildStatCard(
                          'Active Chats',
                          _stats?['active_conversations']?.toString() ?? '342',
                          '+22% this week',
                          Icons.message_outlined,
                          Colors.indigo,
                        ),
                        _buildStatCard(
                          'CRM Leads',
                          _stats?['crm_leads']?.toString() ?? '1,890',
                          '+8.5% growth',
                          Icons.people_outline,
                          Colors.green,
                        ),
                        _buildStatCard(
                          'AI Credits',
                          _stats?['ai_credits']?.toString() ?? '4,850',
                          'Wallet active',
                          Icons.auto_awesome,
                          Colors.amber,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Navigation Actions
                    const Text('Workspace Quick Launch', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),

                    _buildNavigationCard(
                      'Omnichannel Inbox',
                      'Reply to WhatsApp, Messenger & Live Web Chat',
                      Icons.chat_bubble_outline,
                      Colors.indigo,
                      () => Navigator.pushNamed(context, '/inbox'),
                    ),
                    const SizedBox(height: 12),

                    _buildNavigationCard(
                      'CRM Contacts & Leads',
                      'View leads table and deals kanban stages',
                      Icons.people_outline,
                      Colors.green,
                      () => Navigator.pushNamed(context, '/crm'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(String label, String value, String sub, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827), // bg-slate-900
        border: Border.all(color: const Color(0xFF1F2937)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11, fontWeight: FontWeight.bold)),
              Icon(icon, color: color, size: 18),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 2),
              Text(sub, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
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
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF4B5563)),
          ],
        ),
      ),
    );
  }
}
