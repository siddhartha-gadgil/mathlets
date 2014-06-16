import 'dart:html';
import 'dart:math';

typedef double Sequence(int n);

bool include(double sum, target, element){
  if ((target - sum - element).abs() < (target - sum).abs()) {return true;} else return false;
}

List<double> approxSeq(double target, Sequence seq, double error){
  List<double> accum = [0.0];
  double sum = 0.0;
  
  context.clearRect(0, 0, Width, Height);
  drawLine(0, 0, Width, 0, "black");
  drawLine(0, target, Width, target, "red", 2);

  for (var n=1; (target - sum).abs() > error; n++){
    if (include(sum, target, seq(n))) {
      accum.add(seq(n));
      sum += seq(n);
      drawLine(n * spacing, 0, n* spacing, sum, "blue");
    }
    
  }
  accum[0] = sum;
  return accum;
}

Sequence example = (int n){
  if (n % 2 ==1) {return (-1)/n;} else return 1/n;
};

String oneovern(double x){
  var d= (1/x).round();
  if (d<0) return "(-1/"+(-d).toString()+")"; else return "(1/"+d.toString()+")"; 
}

String printSeq(List<double> seq){
  var sum = seq[0];
  seq.removeAt(0);
  if (seq.length ==0) {return sum.toString()+ " = ";}
//  List<String> elems = (seq.map((double d) => (d >0) ? d.toString() : "("+d.toString()+")")).toList();
  List<String> elems = (seq.map(oneovern)).toList();
  return sum.toString() + " = " + elems.reduce((a, b) => a + " + " + b);
}

double target(){
  InputElement targ = querySelector("#target");
  var result;
  try {result = double.parse(targ.value);
      }
  on FormatException {
    result =0.0 ;
  }
  return result;
}

double accuExp = 0.0;

void accuInp(){
  var accuInp = new RangeInputElement();
  accuInp..min = "0.0"
         ..max ="3.0"
         ..value="0.0"
         ..step="0.1";
  
  accuInp.onChange.listen((Event e){
    accuExp = - double.parse(accuInp.value);
    querySelector("#exp").text = accuExp.toString();
    result();
  });
  querySelector("#accu").children.add(accuInp);
}

void result(){
  querySelector("#result").text = printSeq(approxSeq(target(), example, pow(10.0, accuExp)));  
}

final CanvasRenderingContext2D context =
(querySelector("#canvas") as CanvasElement).context2D;

var spacing = 5;

var yScale = 15;

const int Height = 200;

const int Width= 1000;

void drawLine(num x1, y1, num x2, num y2, String colour, [num width = 1]){
  context..beginPath()
         ..lineWidth = width
         ..strokeStyle = colour
         ..moveTo(x1,  - (y1 * yScale) + Height/2)
         ..lineTo(x2, - (y2 * yScale) + Height/2)
         ..closePath()
         ..stroke();
}

void main() {
  accuInp();
  drawLine(0, 0, Width, 0, "black");
  querySelector("#work").onClick.listen((Event e) => result());
  querySelector("#yscale").onChange.listen((Event e){
    yScale = int.parse((querySelector("#yscale") as InputElement).value);
    result();
  });
  querySelector("#spacing").onChange.listen((Event e){
    spacing = int.parse((querySelector("#spacing") as InputElement).value);
    result();
  });
  querySelector("#target").onChange.listen((Event e) => result());
}


