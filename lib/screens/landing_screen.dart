import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/colors.dart';
import '../widgets/widgets.dart';

class LandingScreen extends StatelessWidget {
  final AppState state;
  final Map<String, dynamic> t;
  const LandingScreen({super.key, required this.state, required this.t});

  @override
  Widget build(BuildContext context) {
    final steps   = t['landing_steps'] as List;
    final sectors = t['landing_sectors'] as List;
    final sv      = t['landing_sv'] as List;
    final sl      = t['landing_sl'] as List;

    return RimalScaffold(
      state: state,
      t: t,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Hero ──
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [const Color(0xFF003D6B), C.bg],
                ),
                border: const Border(bottom: BorderSide(color: C.border)),
              ),
              child: Column(children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF002040),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: C.border),
                  ),
                  child: Text(t['landing_badge'],
                      style: const TextStyle(
                          color: C.orange,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center),
                ),
                const SizedBox(height: 16),
                Text(t['landing_h1'],
                    style: const TextStyle(
                        color: C.textPrim,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        height: 1.2),
                    textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text(t['landing_sub'],
                    style: const TextStyle(
                        color: C.textMut, fontSize: 15, height: 1.6),
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RBtn(
                        label: t['landing_cta1'],
                        onTap: () => state.go('login')),
                    const SizedBox(width: 12),
                    RBtn(
                        label: t['landing_cta2'],
                        onTap: () => state.go('login'),
                        ghost: true),
                  ],
                ),
              ]),
            ),

            // ── Stats ──
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: C.border))),
              child: Row(
                children: List.generate(
                  4,
                  (i) => Expanded(
                    child: Container(
                      decoration: i < 3
                          ? const BoxDecoration(
                              border: Border(
                                  right: BorderSide(color: C.border)))
                          : null,
                      child: Column(children: [
                        Text(sv[i],
                            style: const TextStyle(
                                color: C.textPrim,
                                fontSize: 26,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 2),
                        Text(sl[i],
                            style:
                                const TextStyle(color: C.textDim, fontSize: 10),
                            textAlign: TextAlign.center),
                      ]),
                    ),
                  ),
                ),
              ),
            ),

            // ── How it works ──
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t['landing_how'].toString().toUpperCase(),
                      style: const TextStyle(
                          color: C.textDim,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1)),
                  const SizedBox(height: 16),
                  ...steps.map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: RCard(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s[0],
                                    style: const TextStyle(
                                        color: C.orange,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'monospace')),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(s[1],
                                            style: const TextStyle(
                                                color: C.textPrim,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 3),
                                        Text(s[2],
                                            style: const TextStyle(
                                                color: C.textDim,
                                                fontSize: 12,
                                                height: 1.5)),
                                      ]),
                                ),
                              ]),
                        ),
                      )),
                ],
              ),
            ),

            // ── Sectors ──
            Container(
              color: C.card,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t['landing_sectors_label'].toString().toUpperCase(),
                      style: const TextStyle(
                          color: C.textDim,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: sectors
                        .map((s) => _SectorChip(label: s))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sector chip with hover animation ──────────────────────────────────────

class _SectorChip extends StatefulWidget {
  final String label;
  const _SectorChip({required this.label});

  @override
  State<_SectorChip> createState() => _SectorChipState();
}

class _SectorChipState extends State<_SectorChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:  SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color:        _hovered ? C.card : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border:       Border.all(color: _hovered ? C.borderHi : C.border),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color:    _hovered ? C.textPrim : C.textMut,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
