import 'package:flutter/material.dart';

class ViewList extends StatelessWidget {
  final List<ViewItem> views; // List of views to display

  const ViewList({Key? key, required this.views}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2, // Adjust for number of squares per row
      children: views.map((viewItem) => _buildViewItem(context, viewItem)).toList(),
    );
  }

  Widget _buildViewItem(BuildContext context, ViewItem viewItem) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => viewItem.view)),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            viewItem.name,
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}

class ViewItem {
  final String name;
  final Widget view;

  const ViewItem({required this.name, required this.view});
}