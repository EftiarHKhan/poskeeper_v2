import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

class LineTitles {
  static FlTitlesData getTitleData() {
    return FlTitlesData(
      show: true,
      topTitles: AxisTitles(
        sideTitles: SideTitles(
            showTitles: false
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
            showTitles: false
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value,meta){
              String text = '';
              switch (value.toInt()){
                case 1:
                  text = 'Jan';
                  break;
                case 2:
                  text = 'Feb';
                  break;
                case 3:
                  text = 'Mar';
                  break;
                case 4:
                  text = 'Apr';
                  break;
                case 5:
                  text = 'May';
                  break;
                case 6:
                  text = 'Jun';
                  break;
                case 7:
                  text = 'Jul';
                  break;
                case 8:
                  text = 'Aug';
                  break;
                case 9:
                  text = 'Sept';
                  break;
                case 10:
                  text = 'Oct';
                  break;
                case 11:
                  text = 'Nov';
                  break;
                case 12:
                  text = 'Dec';
                  break;
              }
              return Text(text,style: TextStyle(fontSize: 11),);
            }
        ),
      ),

    );
  }
}
