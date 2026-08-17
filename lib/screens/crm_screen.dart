import 'package:flutter/material.dart';

class CrmScreen extends StatelessWidget {
  const CrmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = [
      {'name': 'Arif Hossain', 'email': 'arif@horizonmedia.com', 'stage': 'Qualified', 'value': '\$1,200'},
      {'name': 'Mizanur Rahman', 'email': 'mizan@amanamart.com', 'stage': 'Negotiation', 'value': '\$4,500'},
      {'name': 'Jannatul Ferdous', 'email': 'jannat@pixelcraft.io', 'stage': 'Proposal', 'value': '\$800'},
      {'name': 'Tariqul Islam', 'email': 'tariq@digitalbd.com', 'stage': 'Contacted', 'value': '\$0'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF030712),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        title: const Text('CRM Contacts & Leads', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: contacts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final c = contacts[index];
          final String stage = c['stage'] ?? '';
          Color badgeColor = Colors.grey;
          if (stage == 'Qualified') badgeColor = Colors.blue;
          if (stage == 'Negotiation') badgeColor = Colors.purple;
          if (stage == 'Proposal') badgeColor = Colors.amber;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              border: Border.all(color: const Color(0xFF1F2937)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c['name'] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      c['email'] ?? '',
                      style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.1),
                        border: Border.all(color: badgeColor.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        stage,
                        style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      c['value'] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
