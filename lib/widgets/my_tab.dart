import 'package:flutter/material.dart';

class MyTab extends StatefulWidget {
  const MyTab({
    super.key,
    required this.pages,
    required this.titles,
  });

  final List<Widget> pages;
  final List<String> titles;

  @override
  State<MyTab> createState() => _MyTabState();
}

class _MyTabState extends State<MyTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        Container(
          height: 58,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Color(0xff090034),
            borderRadius: BorderRadius.circular(58),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            tabs: List.generate(
              widget.titles.length,
              (index) {
                return _Tab(
                  title: widget.titles[index],
                  isSelected: _selectedIndex == index,
                );
              },
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.pages,
          ),
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.title,
    required this.isSelected,
  });

  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: 170,
      decoration: BoxDecoration(
        color: isSelected ? Color(0xff6F18FA) : Colors.transparent,
        borderRadius: BorderRadius.circular(42),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: isSelected ? 'w700' : 'w500',
          ),
        ),
      ),
    );
  }
}
