import 'package:flutter/material.dart';


class Analysis extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Statistics'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatisticContainer(
                label: 'Số sản phẩm',
                value: '100',
                color: Colors.blue,
              ),
              StatisticContainer(
                label: 'Số lượng đơn hàng',
                value: '75',
                color: Colors.green,
              ),
              StatisticContainer(
                label: 'Tổng tiền',
                value: '1500',
                color: Colors.orange,
              ),
            ],
          ),
        ),
      );
  }
}

class StatisticContainer extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  StatisticContainer({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
