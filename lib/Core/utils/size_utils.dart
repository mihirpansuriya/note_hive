import 'package:flutter/cupertino.dart';

double w(BuildContext context, double px) {
  return px * MediaQuery.sizeOf(context).width / 360;
}

double f(BuildContext context, double px) {
  return (MediaQuery.sizeOf(context).width / 360) > 1.5
      ? px * 1.5
      : px * (MediaQuery.sizeOf(context).width / 360);
}

double h(BuildContext context, double px) {
  return px * MediaQuery.sizeOf(context).height / 759;
}
