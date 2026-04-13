import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/colors.dart';
import '../../widgets/widgets.dart';

class ReviewScreen extends StatelessWidget {
  final AppState state;
  final Map<String, dynamic> t;
  const ReviewScreen({super.key, required this.state, required this.t});

  @override
  Widget build(BuildContext context) {
    final app       = state.selectedApp!;
    final statuses  = t['statuses'] as Map;
    final decisions = t['rv_decisions'] as List;

    return RimalScaffold(
      state: state,
      t: t,
      backView: 'regdash',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                RSectionLabel(t['rv_label']),
                const SizedBox(height: 4),
                Text(app['project'],
                    style: const TextStyle(
                        color: C.textPrim,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                Text('${app['org']} · ${app['id']}',
                    style:
                        const TextStyle(color: C.textDim, fontSize: 12)),
              ]),
              RBadge(
                  label: statuses[app['status']] ?? app['status'],
                  bg: statusBg(app['status']),
                  fg: statusFg(app['status'])),
            ],
          ),
          const SizedBox(height: 16),

          // AI Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF002040),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF0072CF30)),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                            color: C.sand, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(t['rv_ai_label'].toString().toUpperCase(),
                        style: const TextStyle(
                            color: C.sand,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8)),
                  ]),
                  const SizedBox(height: 8),
                  Text(t['rv_ai_text'],
                      style: const TextStyle(
                          color: C.textMut, fontSize: 13, height: 1.6)),
                ]),
          ),
          const SizedBox(height: 12),

          // Risk Score
          RCard(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t['rv_score'].toString().toUpperCase(),
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
          const SizedBox(height: 12),

          // Regulator actions
          RCard(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t['rv_actions'].toString().toUpperCase(),
                      style: const TextStyle(
                          color: C.textDim,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8)),
                  const SizedBox(height: 14),

                  // Risk assignment
                  Text(t['rv_assign_risk'],
                      style: const TextStyle(
                          color: C.textDim, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      {'label': 'Low',    'fg': C.green,  'bg': const Color(0xFF003322)},
                      {'label': 'Medium', 'fg': C.orange, 'bg': const Color(0xFF1A0A00)},
                      {'label': 'High',   'fg': C.red,    'bg': const Color(0xFF1A0000)},
                    ].map((r) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: r['label'] != 'High' ? 6 : 0),
                          child: _RiskBtn(
                            label:    r['label'] as String,
                            fg:       r['fg'] as Color,
                            activeBg: r['bg'] as Color,
                            isActive: state.reviewRisk == r['label'],
                            onTap:    () => state.setReviewRisk(r['label'] as String),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Internal notes
                  Text(t['rv_notes'],
                      style: const TextStyle(
                          color: C.textDim, fontSize: 12)),
                  const SizedBox(height: 6),
                  TextField(
                    maxLines: 3,
                    style: const TextStyle(color: C.textPrim, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: t['rv_notes_ph'],
                      hintStyle: const TextStyle(
                          color: C.textDim, fontSize: 13),
                      filled: true,
                      fillColor: C.bg,
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: C.border)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: C.border)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: C.blue)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Decision radio list
                  Text(t['rv_decision'],
                      style: const TextStyle(
                          color: C.textDim, fontSize: 12)),
                  const SizedBox(height: 8),
                  ...decisions.map((d) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _DecisionItem(
                      label:    d,
                      isActive: state.reviewDecision == d,
                      onTap:    () => state.setDecision(d),
                    ),
                  )),
                  const SizedBox(height: 6),

                  // Quick action buttons
                  Row(children: [
                    Expanded(child: _QuickBtn(label: t['rv_clarify'])),
                    const SizedBox(width: 8),
                    Expanded(child: _QuickBtn(label: t['rv_schedule'])),
                  ]),
                  const SizedBox(height: 12),
                  RBtn(
                    label: t['rv_submit'],
                    onTap: state.submitReview,
                    disabled: state.reviewDecision.isEmpty,
                    fullWidth: true,
                  ),
                ]),
          ),
        ]),
      ),
    );
  }
}

// ── Review Done ────────────────────────────────────────────────────────────
class ReviewDoneScreen extends StatelessWidget {
  final AppState state;
  final Map<String, dynamic> t;
  const ReviewDoneScreen({super.key, required this.state, required this.t});

  @override
  Widget build(BuildContext context) => RimalScaffold(
        state: state,
        t: t,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                      color: const Color(0xFF003322),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF004433))),
                  child: const Icon(Icons.check_rounded,
                      color: C.green, size: 32),
                ),
                const SizedBox(height: 20),
                Text(t['rv_done'],
                    style: const TextStyle(
                        color: C.textPrim,
                        fontSize: 22,
                        fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(t['rv_done_decision'],
                    style: const TextStyle(
                        color: C.textMut, fontSize: 14)),
                const SizedBox(height: 4),
                Text(state.reviewDecision,
                    style: const TextStyle(
                        color: C.textPrim,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                RBtn(
                    label: t['rv_done_btn'],
                    onTap: () => state.go('regdash'),
                    ghost: true),
              ],
            ),
          ),
        ),
      );
}

// ── Risk level selector button ─────────────────────────────────────────────

class _RiskBtn extends StatefulWidget {
  final String label;
  final Color fg;
  final Color activeBg;
  final bool isActive;
  final VoidCallback onTap;

  const _RiskBtn({
    required this.label,
    required this.fg,
    required this.activeBg,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_RiskBtn> createState() => _RiskBtnState();
}

class _RiskBtnState extends State<_RiskBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:  SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: widget.isActive
                ? widget.activeBg
                : (_hovered ? widget.activeBg.withValues(alpha: 0.4) : Colors.transparent),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: (widget.isActive || _hovered)
                  ? widget.fg.withValues(alpha: 0.5)
                  : C.border,
            ),
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:      widget.fg,
              fontSize:   12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Decision radio item ────────────────────────────────────────────────────

class _DecisionItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DecisionItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_DecisionItem> createState() => _DecisionItemState();
}

class _DecisionItemState extends State<_DecisionItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active     = widget.isActive;
    final isApproved = widget.label.contains('Approved');
    final isRejected = widget.label.contains('Rejected');
    final isMoreInfo = widget.label.contains('More');

    final Color borderColor = active
        ? isApproved ? C.green
            : isRejected ? C.red
            : isMoreInfo ? C.orange
            : C.blue
        : (_hovered ? C.borderHi : C.border);

    final Color bgColor = active
        ? isApproved ? const Color(0xFF003322)
            : isRejected ? const Color(0xFF1A0000)
            : isMoreInfo ? const Color(0xFF1A0A00)
            : const Color(0xFF002040)
        : (_hovered ? C.card : C.bg);

    return MouseRegion(
      cursor:  SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color:        bgColor,
            borderRadius: BorderRadius.circular(12),
            border:       Border.all(color: borderColor),
          ),
          child: Row(children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width:  16,
              height: 16,
              decoration: BoxDecoration(
                shape:  BoxShape.circle,
                border: Border.all(color: borderColor, width: 2),
                color:  active ? borderColor : Colors.transparent,
              ),
              child: active
                  ? const Icon(Icons.circle, color: Colors.white, size: 8)
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              widget.label,
              style: TextStyle(
                color: active
                    ? borderColor
                    : (_hovered ? C.textPrim : C.textMut),
                fontSize:   13,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ── Quick action button ────────────────────────────────────────────────────

class _QuickBtn extends StatefulWidget {
  final String label;

  const _QuickBtn({required this.label});

  @override
  State<_QuickBtn> createState() => _QuickBtnState();
}

class _QuickBtnState extends State<_QuickBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:  SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color:        _hovered ? C.card : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border:       Border.all(color: _hovered ? C.borderHi : C.border),
        ),
        child: Text(
          widget.label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color:    _hovered ? C.textMut : C.textDim,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
