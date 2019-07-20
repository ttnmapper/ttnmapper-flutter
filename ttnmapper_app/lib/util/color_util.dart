import 'dart:ui';

class ColorUtil {

  static final Map<int, Color> color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };

  static String parseColorForRssi(int rssi) {
    const blueThreshold = -120;
    const cyanThreshold = -115;
    const greenThreshold = -110;
    const yellowThreshold = -105;
    const orangeThreshold = -100;

    if (rssi < blueThreshold) {
      return '#0B24FB';
    } else if (rssi < cyanThreshold) {
      return '#2DFFFE';
    } else if (rssi < greenThreshold) {
      return '#17A13D';
    } else if (rssi < yellowThreshold) {
      return '#FEDD32';
    } else if (rssi < orangeThreshold) {
      return '#FC6721';
    } else {
      return '#ED1D25';
    }
  }
}