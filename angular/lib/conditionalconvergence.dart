import 'dart:html';
import 'dart:math';
import 'package:angular/angular.dart';

typedef double Sequence(int n);

bool include(double sum, target, element){
  if ((target - sum - element).abs() < (target - sum).abs()) {return true;} else return false;
}



Sequence example = (int n){
  if (n % 2 ==1) {return (-1.0)/n;} else return 1.0/n;
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




const int Height = 200;

const int Width= 1000;




@Component(
    selector: 'condconv',
    templateUrl: 'packages/mathlets/conditionalconvergence.html',
    cssUrl: 'packages/mathlets/conditionalconvergence.css',
    publishAs: 'cmp')
class ConditionalConvergence extends Object with ShadowRootAware{
  num accuExp =0.0;
  
//  double err() => double.parse(accuExp);
  
  CanvasRenderingContext2D context ;
  
  var spacing = 5.0;

  var yscale = 15.0;
  
  @NgAttr('init-target')
  set initTarget(String t){
    targettxt = t;
  }
  
  @NgAttr('init-accuracy')
  set initAccuracy(String t){
    accuExp = double.parse(t);
  }
 
  
  String targettxt;

  num target() => double.parse(targettxt);

  void onShadowRoot(ShadowRoot shadowRoot){
//    accuExp = 2.0;
    CanvasElement canvas =
          shadowRoot.querySelector("#canvas");
    initCanvas(canvas);
    context.save();
//    drawLine(1,1, 20, 20, "red");
  }
  
  void initCanvas(CanvasElement canvas) {
       context = canvas.context2D;
    }
  
  String result() =>
    printSeq(approxSeq(targettxt, example, accuExp));


  void drawLine(num x1, y1, num x2, num y2, String colour, [num width = 1]){
    context..beginPath()
           ..lineWidth = width
           ..strokeStyle = colour
           ..moveTo(x1,  - (y1 * yscale) + Height/2)
           ..lineTo(x2, - (y2 * yscale) + Height/2)
           ..closePath()
           ..stroke();
  }

  List<double> approxSeq(String targettxt, Sequence seq, int acc){
//    return [target, acc.toDouble()];
    double error = pow(2.0, -acc.toDouble());
    List<double> accum = [0.0];
    double sum = 0.0;
    double target = double.parse(targettxt);
    
    context.clearRect(0.0, 0.0, Width, Height);
    drawLine(0.0, 0.0, Width, 0.0, "black");
    drawLine(0, target, Width, target, "red", 2.0);

//    return [target, acc.toDouble(), error];

    for (var n=1; (target - sum).abs() > error; n++){
      if (include(sum, target, seq(n))) {
        accum.add(seq(n));
        sum += seq(n);
        drawLine(n * spacing, 0.0, n* spacing, sum, "blue");
      }
      
    }
    accum[0] = sum;
//    return [sum, target, acc.toDouble(), error];
    return accum;
  }
  
  /*
  ConditionalConvergence(){
    result();
  }
*/
}



