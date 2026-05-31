import 'package:b_barna_app/liveClass/screens/class_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:b_barna_app/liveClass/providers/live_class_viewmodel.dart';

class ClassTabsScreen extends StatefulWidget {
  const ClassTabsScreen({super.key});

  @override
  State<ClassTabsScreen> createState() => _ClassTabsScreenState();
}

class _ClassTabsScreenState extends State<ClassTabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveClassViewModel>().fetchClasses();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LiveClassViewModel>(builder: (context, viewModel, child) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFF09636E),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 25,
              color: Colors.white,
            ),
          ),
          elevation: 0,
          title: Text(
            'Class List',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: const Color(0xFFE8E8E8),
            labelStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            unselectedLabelStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            tabs: [
              Tab(text: 'Upcoming (${viewModel.upcomingClasses.length})'),
              Tab(text: 'Live (${viewModel.liveClasses.length})'),
              Tab(text: 'Past (${viewModel.pastClasses.length})'),
            ],
          ),
        ),
        body:  viewModel.error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.wifi_off_rounded,
                            size: 40, color: Color(0xFFCCCCCC)),
                        const SizedBox(height: 12),
                        Text(viewModel.error!,
                            style: const TextStyle(color: Color(0xFF888888))),
                        const SizedBox(height: 12),
                        TextButton(
                            onPressed: viewModel.fetchClasses,
                            child: const Text('Retry')),
                      ],
                    ),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      ClassListView(
                        classes: viewModel.upcomingClasses,
                        vm: viewModel,
                        classStatus: "upcoming",
                      ),
                      ClassListView(
                        classes: viewModel.liveClasses,
                        vm: viewModel,
                        classStatus: "live",
                      ),
                      ClassListView(
                        classes: viewModel.pastClasses,
                        vm: viewModel,
                        classStatus: "past",
                      ),
                    ],
                  ),
      );
    });
  }
}
