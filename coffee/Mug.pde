class Mug extends Cup {

  public Mug(float w, float h) {
    super(w, h);
    
    float x = random(w/4.0, w/2.0); // top right
    this.w = x;

    // "depth" of the 2.5ness
    float d = random(30, 80);
    
    body = new RShape();
    body.addMoveTo(x, -h/2.0);
    body.addLineTo(x, h/2.0);
    body.addBezierTo(x, h/2.0 + d, -x, h/2.0 + d, -x, h/2.0);
    body.addLineTo(-x, -h/2.0);
    body.addBezierTo(-x, -h/2.0 - d, x, -h/2.0 - d, x, -h/2.0);
    
    RPath tCurvePath = new RPath(x, -h/2.0);
    tCurvePath.addBezierTo(x, -h/2.0 + d, -x, -h/2.0 + d, -x, -h/2.0);
    tCurve = new RShape(tCurvePath);

    float hCurveTr = random(0.1, 0.3);
    RPoint hCurveTs = new RPoint(-x, hCurveTr * h - h/2);
    RPoint hCurveTe = new RPoint(x, hCurveTr * h - h/2);
    RPath hCurveTPath = new RPath(hCurveTs.x, hCurveTs.y);
    hCurveTPath.addBezierTo(hCurveTs.x, hCurveTs.y + d, hCurveTe.x, hCurveTe.y + d, hCurveTe.x, hCurveTe.y);
    hCurveT = new RShape(hCurveTPath);

    float hCurveBr = random(0.6, 0.8);
    RPoint hCurveBs = new RPoint(-x, hCurveBr * h - h/2);
    RPoint hCurveBe = new RPoint(x, hCurveBr * h - h/2);
    RPath hCurveBPath = new RPath(hCurveBs.x, hCurveBs.y);
    hCurveBPath.addBezierTo(hCurveBs.x, hCurveBs.y + d, hCurveBe.x, hCurveBe.y + d, hCurveBe.x, hCurveBe.y);
    hCurveB = new RShape(hCurveBPath);
  }
  
  public RShape getSlice(float r) {
    float rOrig = r;
    
    r = (r - 0.5) * 2;
    
    float x = r * w;
    
    RShape s = new RShape();
    s.addMoveTo(x, -h/2);
    s.addLineTo(x, h/2);
    return s;
  }
}

