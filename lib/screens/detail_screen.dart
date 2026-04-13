import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/colors.dart';
import '../widgets/widgets.dart';

class DetailScreen extends StatelessWidget {
  final AppState state;
  final Map<String, dynamic> t;
  const DetailScreen({super.key, required this.state, required this.t});

  @override
  Widget build(BuildContext context) {
    final app        = state.selectedApp!;
    final statuses   = t['statuses'] as Map;
    final flagLabels = t['flag_labels'] as List;
    final flags      = app['flags'] as List;

    return RimalScaffold(
      state: state,
      t: t,
      backView: 'dash',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header card
          RCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(app['id'],
                      style: const TextStyle(
                          color: C.textDim,
                          fontSize: 11,
                          fontFamily: 'monospace')),
                  RBadge(
                      label: statuses[app['status']] ?? app['status'],
                      bg: statusBg(app['status']),
                      fg: statusFg(app['status'])),
                ],
              ),
              const SizedBox(height: 6),
              Text(app['project'],
                  style: const TextStyle(
                      color: C.textPrim,
                      fontSize: 18,
                      fontWeight: FontWeight.w900)),
              Text(app['org'],
                  style:
                      const TextStyle(color: C.textMut, fontSize: 13)),
            ]),
          ),
          const SizedBox(height: 12),

          // Project info
          RCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t['detail_info'].toString().toUpperCase(),
                  style: const TextStyle(
                      color: C.textDim,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8)),
              const SizedBox(height: 10),
              ...[
                ['Sector', app['sector']],
                ['AI Type', app['aiType']],
                ['Stage', app['stage'] ?? 'Pilot'],
                ['Region', app['region'] ?? 'Jordan'],
              ].map((row) => Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(row[0],
                              style: const TextStyle(
                                  color: C.textMut, fontSize: 13)),
                          Text(row[1],
                              style: const TextStyle(
                                  color: C.textPrim,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const RDivider(),
                  ])),
            ]),
          ),
          const SizedBox(height: 12),

          // AI Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF002040),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF0072CF30)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: C.sand, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(t['detail_ai_label'].toString().toUpperCase(),
                    style: const TextStyle(
                        color: C.sand,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
              ]),
              const SizedBox(height: 8),
              Text(t['detail_ai_text'],
                  style: const TextStyle(
                      color: C.textMut, fontSize: 13, height: 1.6)),
            ]),
          ),
          const SizedBox(height: 12),

          // Risk Score
          RCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t['detail_score'].toString().toUpperCase(),
                  style: const TextStyle(
                      color: C.textDim,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8)),
              const SizedBox(height: 12),
              Center(
                child: RRiskRing(score: app['score']),
              ),
              const SizedBox(height: 12),
              Center(
                child: RBadge(
                    label: app['risk'],
                    bg: riskBg(app['risk']),
                    fg: riskFg(app['risk'])),
              ),
            ]),
          ),

          // Compliance flags
          if (flags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A0800),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF3A1800)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t['detail_flags'].toString().toUpperCase(),
                    style: const TextStyle(
                        color: C.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
                const SizedBox(height: 8),
                ...flags.map((fi) {
                  final icons = [
                    Icons.lock_outline_rounded,
                    Icons.supervised_user_circle_outlined,
                    Icons.warning_amber_rounded,
                    Icons.balance_rounded,
                  ];
                  final icon = fi < icons.length ? icons[fi] : Icons.flag_rounded;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(children: [
                      Icon(icon,
                          color: C.orange, size: 14),
                      const SizedBox(width: 8),
                      Text(flagLabels[fi],
                          style: const TextStyle(
                              color: C.orange, fontSize: 13)),
                    ]),
                  );
                }),
              ]),
            ),
          ],

          // ── Score Breakdown (Phase 4) ──────────────────────────────────
          const SizedBox(height: 12),
          RCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t['detail_breakdown'].toString().toUpperCase(),
                  style: const TextStyle(
                      color: C.textDim,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8)),
              const SizedBox(height: 10),
              _breakdownRow('Sector', _sectorLabel(app['sector']),
                  _sectorPts(app['sector'])),
              const RDivider(),
              const SizedBox(height: 8),
              _breakdownRow('Data', 'Personal / biometric data',
                  _dataPts(app['score'], app['sector'])),
              const RDivider(),
              const SizedBox(height: 8),
              _breakdownRow('Autonomy', _autonomyLabel(app['risk']),
                  _autonomyPts(app['risk'])),
            ]),
          ),

          // Documents
          const SizedBox(height: 12),
          RCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t['detail_docs'].toString().toUpperCase(),
                  style: const TextStyle(
                      color: C.textDim,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8)),
              const SizedBox(height: 8),
              ...[
                'Project Brief.pdf',
                'Model Documentation.pdf',
                'Data Sheet.pdf',
              ].map((doc) => Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(doc,
                              style: const TextStyle(
                                  color: C.textPrim, fontSize: 13)),
                          const Text('PDF',
                              style: TextStyle(
                                  color: C.textDim, fontSize: 11)),
                        ],
                      ),
                    ),
                    const RDivider(),
                  ])),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ── Breakdown helpers for mock apps ───────────────────────────────────────
Widget _breakdownRow(String category, String label, int pts) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(category.toUpperCase(),
            style: const TextStyle(
                color: C.blue,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1)),
        const SizedBox(height: 4),
        Row(children: [
          Expanded(
              child: Text(label,
                  style:
                      const TextStyle(color: C.textMut, fontSize: 12))),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
                color: C.bg,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: C.border)),
            child: Text('+$pts',
                style: const TextStyle(
                    color: C.textPrim,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace')),
          ),
        ]),
      ]),
    );

String _sectorLabel(String s) => '$s sector';

int _sectorPts(String s) {
  switch (s) {
    case 'Healthcare':     return 30;
    case 'Finance':        return 25;
    case 'Public Services':return 20;
    case 'Education':      return 10;
    default:               return 10;
  }
}

int _dataPts(int score, String sector) =>
    score - _sectorPts(sector) - _autonomyPts('High');

String _autonomyLabel(String risk) => risk == 'High'
    ? 'Fully automated decisions'
    : risk == 'Medium'
        ? 'Decision support with oversight'
        : 'Human approval required';

int _autonomyPts(String risk) =>
    risk == 'High' ? 25 : risk == 'Medium' ? 10 : 5;
