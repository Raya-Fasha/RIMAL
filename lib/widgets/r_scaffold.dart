import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/colors.dart';
import '../state/app_state.dart';
import 'r_btn.dart';

class RimalScaffold extends StatelessWidget {
  final AppState state;
  final Map<String, dynamic> t;
  final Widget body;
  final String? backView;

  const RimalScaffold({
    super.key,
    required this.state,
    required this.t,
    required this.body,
    this.backView,
  });

  @override
  Widget build(BuildContext context) {
    final isApplicant = state.role == 'applicant';
    final isRegulator = state.role == 'regulator';

    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        backgroundColor: C.bg,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: C.border),
        ),
        leading: backView != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: C.textMut, size: 18),
                onPressed: () => state.go(backView!),
              )
            : null,
        title: GestureDetector(
          onTap: () => state.go(
            state.role == 'applicant'
                ? 'dash'
                : state.role == 'regulator'
                    ? 'regdash'
                    : 'landing',
          ),
          child: const Text(
            'Rimal',
            style: TextStyle(
                color: C.textPrim,
                fontWeight: FontWeight.w900,
                fontSize: 18),
          ),
        ),
        centerTitle: backView == null,
        actions: [
          TextButton(
            onPressed: state.toggleLang,
            child: Text(
              state.lang == 'en' ? 'عربي' : 'EN',
              style: const TextStyle(
                  color: C.textMut,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
          if (state.role != null)
            TextButton(
              onPressed: state.logout,
              child: Text(t['nav_logout'],
                  style:
                      const TextStyle(color: C.textDim, fontSize: 12)),
            )
          else if (state.view != 'login')
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: RBtn(
                label: t['nav_signin'],
                onTap: () => state.go('login'),
              ),
            ),
        ],
      ),
      body: SafeArea(child: body),
      bottomNavigationBar: (isApplicant || isRegulator)
          ? Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: C.border)),
              ),
              child: BottomNavigationBar(
                backgroundColor: C.bg,
                elevation: 0,
                selectedItemColor: C.blue,
                unselectedItemColor: C.textDim,
                type: BottomNavigationBarType.fixed,
                currentIndex: isApplicant
                    ? (state.view == 'dash' ? 0 : 1)
                    : (state.view == 'regdash' ? 0 : 1),
                onTap: (index) {
                  if (isApplicant) {
                    if (index == 0) {
                      state.go('dash');
                    } else {
                      state.resetForm();
                      state.go('apply');
                    }
                  } else if (isRegulator) {
                    if (index == 0) {
                      state.go('regdash');
                    } else {
                      // Could be filters or other action
                      state.go('regdash');
                    }
                  }
                },
                items: isApplicant
                    ? [
                        const BottomNavigationBarItem(
                          icon: Icon(Icons.list_alt_rounded),
                          label: 'My Apps',
                        ),
                        const BottomNavigationBarItem(
                          icon: Icon(Icons.add_circle_outline_rounded),
                          label: 'New App',
                        ),
                      ]
                    : [
                        const BottomNavigationBarItem(
                          icon: Icon(Icons.list_alt_rounded),
                          label: 'Queue',
                        ),
                        const BottomNavigationBarItem(
                          icon: Icon(Icons.filter_list_rounded),
                          label: 'Filters',
                        ),
                      ],
              ),
            )
          : null,
    );
  }
}
