abstract class Cup {
  RShape rCurve;
  RShape lCurve;
  RShape body;

  ArrayList<PVector> rCurvePts = new ArrayList<PVector>();
  ArrayList<PVector> lCurvePts = new ArrayList<PVector>();

  RShape hCurveT;
  RShape hCurveB;
  
  RShape tCurve, ttCurve, bCurve;
  
  float w, h;
  
  float handleR;
  float handleWidth;

  public Cup(float w, float h) {
    this.w = w;
    this.h = h;
    
    if (random(1) < 0.5) {
      handleR = random(0.1, 0.3);
    } else {
      handleR = random(0.6, 0.75);
    }

    handleWidth = random(0.1, 0.2);
  }
  
  void drawPolygon(RShape p) {
    RG.setPolygonizer(RG.UNIFORMLENGTH);
    RG.setPolygonizerLength(3);
    RPoint[] points = p.getPoints();
  
    beginShape();
    float px = 0.0;
    float py = 0.0;
    float amp = 25;
    
    boolean over = false;
    
    for (int i = 0; i < points.length; i++) {
      float x = points[i].x + amp * noise(px);
      float y = points[i].y + amp * noise(py);
      px += 0.03;
      py += 0.03;
      
      if (px >= 1.0) {
        px -= 1.0;
      }
      
      if (py >= 1.0) {
        py -= 1.0;
      }
      vertex(x, y);
    }
    
    endShape();
  }

  public void drawCurve(ArrayList<PVector> curve) {
//    drawPolygon(curve);
    beginShape();
    vertex(curve.get(0).x, curve.get(0).y);
    for (int j = 1; j < curve.size()-2; j++) {
      PVector p0 = curve.get(j);
      PVector p1 = curve.get(j+1);
      PVector p2 = curve.get(j+2);
      bezierVertex(p0.x, p0.y, p1.x, p1.y, p2.x, p2.y);
    }
    endShape();
  }

  public void draw() {
    fill(#FFFFFF);
    drawPolygon(body);
    drawPolygon(tCurve);

//    hCurveT.draw();
//    hCurveB.draw();

    fill(#ffffff);
    try {
      RShape handle = new RShape();
      drawHandle(handle, ((frameCount % 100) + 15) / 150.0, true);
      drawHandle(handle, ((frameCount % 100) + 35) / 150.0, false);
//      drawHandle(handle, handleR, true);
//      drawHandle(handle, handleR + handleWidth, false);
      
      RShape handle2 = new RShape(handle);
      
      handle2.addClose();
      handle2.draw();

      closeHandle(handle);

    } catch (Exception e) {
      
    }
    
    // also need to draw a shape that cuts off at the bottom
  }

  public float findR(RPoint p, RShape curve) {
    RPoint bp = curve.getPoint(0);
    float b = 0.0;
    float e = 1.0;

    while (e - b > 1e-5) {
      float m = (b + e) / 2.0;
      RPoint mp = curve.getPoint(m);
      float mpd = mp.dist(bp);
      float pd = p.dist(bp);
      if (mpd < pd) {
        b = m;
      } 
      else {
        e = m;
      }
    }

    return (b + e) / 2.0;
  }
  
  public void closeHandle(RShape handle) {
    float samples = 1000;
    RPoint maxL = null;
    int maxSampleL = 0;
    RPoint maxR = null;
    int maxSampleR = 0;
    
    for (int i = 0; i < samples/2; i++) {
      RPoint p = handle.getPoint(i / samples);
      if (maxL == null || p.y > maxL.y) {
        maxL = p;
        maxSampleL = i;
      }
    }
    
    for (int i = (int) (samples/2); i < samples; i++) {
      RPoint p = handle.getPoint(i / samples);
      if (maxR == null || p.y > maxR.y) {
        maxR = p;
        maxSampleR = i;
      }
    }
    
    RShape[] split = handle.split(maxSampleL / samples);
    RShape left = split[0];
        
    split = handle.split(maxSampleR / samples);
    RShape right = split[1];
    
    // Okay fine we have to treat it like a polygon...
    
    samples = 100;
    
    RShape handleOverlay = new RShape();
    
    handleOverlay.addMoveTo(left.getPoint(0));
    
    for (int i = 1; i < samples; i++) {
      handleOverlay.addLineTo(left.getPoint(i/samples));
    }
    
    handleOverlay.addLineTo(right.getPoint(0));
    
    for (int i = 1; i < samples; i++) {
      handleOverlay.addLineTo(right.getPoint(i/samples));
    }
    
    handleOverlay.addClose();
    
    handleOverlay.draw();
//    drawPolygon(handleOverlay);
  }
  
  public void drawHandle(RShape handle, float r, boolean up) {
    float rOrig = r;
    
    RShape curve = getSlice(r);

    RPoint[] hTi = curve.getIntersections(hCurveT);
    RPoint[] hBi = curve.getIntersections(hCurveB);

//    rect(hTi[0].x-5, hTi[0].y-5, 10, 10);
//    rect(hBi[0].x-5, hBi[0].y-5, 10, 10);

    float rTi = findR(hTi[0], hCurveT);
    float rBi = findR(hBi[0], hCurveB);

    RPoint rTip = hCurveT.getPoint(rTi);

    RPoint rTipTangent = hCurveT.getTangent(rTi);
    rTipTangent.scale(100.0 / rTipTangent.dist(new RPoint(0, 0)));
    rTip.sub(rTipTangent);
    rTip.rotate(-PI/2.0, hTi[0]);
    rTip.rotate(map(rOrig, 0, 1, PI/2, -PI/2), hTi[0]);

//    RShape.createLine(rTip.x, rTip.y, hTi[0].x, hTi[0].y).draw();

    RPoint rBip = hCurveB.getPoint(rBi);

    RPoint rBipTangent = hCurveB.getTangent(rBi);
    rBipTangent.scale(50.0 / rBipTangent.dist(new RPoint(0, 0)));
    rBip.sub(rBipTangent);
    rBip.rotate(-PI/2.0, hBi[0]);

//    RShape.createLine(rBip.x, rBip.y, hBi[0].x, hBi[0].y).draw();

    if (up) {
      handle.addMoveTo(hTi[0].x, hTi[0].y);
      handle.addBezierTo(rTip.x, rTip.y, rBip.x, rBip.y, hBi[0].x, hBi[0].y);
    } else {
      handle.addLineTo(hBi[0].x, hBi[0].y);
      handle.addBezierTo(rBip.x, rBip.y, rTip.x, rTip.y, hTi[0].x, hTi[0].y);
    }
  }
  
  public abstract RShape getSlice(float x);
}

