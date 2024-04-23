import 'package:app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Search extends StatelessWidget {
  const Search({super.key, required this.prefixIcon});
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: isDarkMode ? Colors.grey[700] :Colors.grey[300],
      ),
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.search),
            const SizedBox(width: 15,),
            Text(
              "Search account for chatting",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
    // return Container(
    //   decoration: BoxDecoration(
    //     color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
    //     borderRadius: BorderRadius.circular(50),
    //   ),
    //   child: E(
    //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
    //     child: Text(
    //       'Search',
    //       style: TextStyle(
    //         fontFamily: 'Roboto',
    //       ),
    //     ),
    //   ),
      
    // );
  }
}
