import geomerative.*;
import processing.pdf.PGraphicsPDF;

RShape incomplete_word, graph_word;

int sections = 75;
float thresh = 0.3;

void setup() {
  size(2400, 1600);
  
  RG.init(this);
  
  fill(0);
  noStroke();
  
  incomplete_word = RG.getText("indifference", "Times New Roman.ttf", 200, CENTER);
  graph_word = RG.getText("interference", "Times New Roman.ttf", 200, CENTER);

  noLoop();  
}

void draw() {
  beginRecord(PDF, "indifference" + System.currentTimeMillis() + ".pdf"); 

  background(255);

  translate(width/2, height/2);
  drawWord(incomplete_word);
  
  translate(100, 160);
//  drawWord(graph_word);
}
  
void drawWord(RShape word) {
  for (int i = 0; i < word.children.length; i++) {
    RShape letter = word.children[i];
    noStroke();
    fill(0, 0, 0, 16);
//    letter.draw();
    
    RPoint bounds[] = letter.getBoundsPoints();
    
    stroke(0, 0, 15, 32);
    noFill();
//    rect(bounds[0].x, bounds[0].y, bounds[2].x - bounds[0].x, bounds[2].y - bounds[0].y);
    
    RPoint center = letter.getCenter();
    
    RShape circle = RShape.createCircle(center.x, center.y, center.dist(bounds[0])*2);
//    circle.draw();
    
    ArrayList<RPoint> cps = new ArrayList<RPoint>();
    
    for (int j = 0; j < sections; j++) {
      RPoint cp = circle.getPoint(j / (float) sections);
      cps.add(cp);
    }
    
    for (int j = 0; j < cps.size(); j++) {
      RPoint A = cps.get(j);
      for (int k = j+1; k < cps.size(); k++) {
        RPoint B = cps.get(k);
        RShape line = RShape.createLine(A.x, A.y, B.x, B.y);
       
        RPoint ints[] = line.getIntersections(letter);
        
        if (ints != null) {
          float insideLength = 0;
          
          // test first
          
          RPoint btwnInts = new RPoint((A.x + ints[0].x) / 2.0, (A.y + ints[0].y) / 2.0);
          
          if (letter.contains(btwnInts)) {
            insideLength += A.dist(ints[0]);
          }
          
          // test all
          
          for (int l = 0; l < ints.length-1; l++) {
            btwnInts = new RPoint((ints[l].x + ints[l+1].x) / 2.0, (ints[l].y + ints[l+1].y) / 2.0);
            
            if (letter.contains(btwnInts)) {
              insideLength += ints[l].dist(ints[l+1]);
            }
          }
          
          // test last
          
          btwnInts = new RPoint((B.x + ints[ints.length-1].x) / 2.0, (B.y + ints[ints.length-1].y) / 2.0);
          
          if (letter.contains(btwnInts)) {
            insideLength += B.dist(ints[ints.length-1]);
          }
          
          // Sufficient presence test...
          
          if (insideLength / A.dist(B) > thresh) {
            // don't draw the line, but a bigger line...
            
            float lengthMultiplier = 20;
            
            RPoint AA = new RPoint((A.x - B.x) * lengthMultiplier + B.x, (A.y - B.y) * lengthMultiplier + B.y); 
            RPoint BB = new RPoint((B.x - A.x) * lengthMultiplier + A.x, (B.y - A.y) * lengthMultiplier + A.y); 
            RShape Aline = RShape.createLine(AA.x, AA.y, A.x, A.y);
            RShape Bline = RShape.createLine(BB.x, BB.y, B.x, B.y);
            
            line.draw();
            Aline.draw();
            Bline.draw();
          }
        }
      }
    }
  }
  
  endRecord();
}
