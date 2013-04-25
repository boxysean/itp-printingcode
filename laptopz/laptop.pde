class Laptop {
  float x, y, angle, w, h, r, keyboardPaddingPercent, keyboardSizePercent, keyboardThickness, 
  keyboardRows, keyboardColumns, trackpadPaddingPercent, screenPaddingPercent;

  boolean rotate;

  Body body;

  public Laptop(float x, float y, float angle, float w, float h, float r, 
  float keyboardPaddingPercent, float keyboardSizePercent, float keyboardThickness, 
  float keyboardRows, float keyboardColumns, float trackpadPaddingPercent, 
  float screenPaddingPercent, boolean rotate) {
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.w = w;
    this.h = h;
    this.r = r;
    this.keyboardPaddingPercent = keyboardPaddingPercent;
    this.keyboardSizePercent = keyboardSizePercent;
    this.keyboardThickness = keyboardThickness;
    this.trackpadPaddingPercent = trackpadPaddingPercent;
    this.screenPaddingPercent = screenPaddingPercent;
    this.rotate = rotate;
    
    makeBody(x, y);
  }

  public Laptop(float x, float y, float angle, float w, float h, float r, 
  float keyboardPaddingPercent, float keyboardSizePercent, float keyboardThickness, 
  float keyboardRows, float keyboardColumns, float trackpadPaddingPercent, 
  float screenPaddingPercent) {
    this(x, y, angle, w, h, r, keyboardPaddingPercent, keyboardSizePercent, keyboardThickness, 
    keyboardRows, keyboardColumns, trackpadPaddingPercent, screenPaddingPercent, false);
  }

  void draw() {
    pushMatrix();
    
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    
    translate(pos.x, pos.y);
    rotate(a+r);
     
    if (rotate) {
      angle = frameCount / 100.0;
    }

    float modAngle = angle % (2*PI);

    float xx = h * cos(angle);
    float yy = h * sin(angle);

    float minX = -w/2.0;
    float maxX = xx+w/2.0;
    float minY = -h;
    float maxY = yy;

    // keyboard base
    //  float keyboardThickness = 10;

    if (0 < modAngle && modAngle <= PI) {
      drawPolygon(-w/2.0, 0, 
      -w/2.0, keyboardThickness, 
      xx-w/2.0, yy + keyboardThickness, 
      xx-w/2.0, yy);

      drawPolygon(xx+w/2.0, yy, 
      xx+w/2.0, yy + keyboardThickness, 
      w/2.0, keyboardThickness, 
      w/2.0, 0);

      drawPolygon(xx-w/2.0,   yy, 
      xx-w/2.0, yy + keyboardThickness, 
      xx+w/2.0, yy + keyboardThickness, 
      xx+w/2.0, yy);
    } 
    else {
      drawPolygon(xx-w/2.0, yy, 
      xx-w/2.0, yy + keyboardThickness, 
      xx+w/2.0, yy + keyboardThickness, 
      xx+w/2.0, yy);

      drawPolygon(-w/2.0, 0, 
      -w/2.0, keyboardThickness, 
      xx-w/2.0, yy + keyboardThickness, 
      xx-w/2.0, yy);

      drawPolygon(xx+w/2.0, yy, 
      xx+w/2.0, yy + keyboardThickness, 
      w/2.0, keyboardThickness, 
      w/2.0, 0);
    }

    drawPolygon(-w/2.0, 0, 
    xx-w/2.0, yy, 
    xx+w/2.0, yy, 
    w/2.0, 0);

    // keyboard crosshatch
    //  float keyboardPaddingPercent = 0.05;
    //  float keyboardSizePercent = 0.5;
    //  float keyboardRows = 4;
    //  float keyboardColumns = 10;

    float keytlx = -w/2.0 + (h * keyboardPaddingPercent) * cos(angle) + (w * keyboardPaddingPercent);
    float keytrx = w/2.0 + (h * keyboardPaddingPercent) * cos(angle) - (w * keyboardPaddingPercent);
    float keyblx = -w/2.0 + (h * keyboardSizePercent) * cos(angle) + (w * keyboardPaddingPercent);
    float keybrx = w/2.0 + (h * keyboardSizePercent) * cos(angle) - (w * keyboardPaddingPercent);

    float keyty = h * keyboardPaddingPercent * sin(angle);
    float keyby = h * keyboardSizePercent * sin(angle);  

    drawPolygon(keytlx, keyty, 
    keytrx, keyty, 
    keybrx, keyby, 
    keyblx, keyby);

    for (int i = 1; i < keyboardRows; i++) {
      float keyrowy = (keyby - keyty) * ((float) i / keyboardRows) + keyty;
      float keyrowlx = (keyblx - keytlx) * ((float) i / keyboardRows) + keytlx;
      float keyrowrx = (keybrx - keytrx) * ((float) i / keyboardRows) + keytrx;
      //    line(keyrowlx, keyrowy, keyrowrx, keyrowy);
      closePolygon(false);
      drawPolygon(keyrowlx, keyrowy, keyrowrx, keyrowy);
      closePolygon(true);
    }

    for (int i = 1; i < keyboardColumns; i++) {
      float keycoltx = (keytrx - keytlx) * ((float) i / keyboardColumns) + keytlx;
      float keycolbx = (keybrx - keyblx) * ((float) i / keyboardColumns) + keyblx;
      //    line(keycoltx, keyty, keycolbx, keyby);
      closePolygon(false);
      drawPolygon(keycoltx, keyty, keycolbx, keyby);
      closePolygon(true);
    }

    // trackpad
    //  float trackpadPaddingPercent = 0.05;
    float trackpadSizePercent = 1.0 - keyboardSizePercent;
    float trackpadSizeRatio = 1.0;

    float trackpadh = h * (trackpadSizePercent - 2 * trackpadPaddingPercent);
    float trackpadw = trackpadh * trackpadSizeRatio;
    float trackpadby = h * (1.0 - trackpadPaddingPercent) * sin(angle);
    float trackpadty = h * (1.0 - trackpadSizePercent + trackpadPaddingPercent * 2) * sin(angle);

    float trackpadtlx = h * (1.0 - trackpadSizePercent + trackpadPaddingPercent * 2) * cos(angle) - trackpadw/2.0;
    float trackpadtrx = h * (1.0 - trackpadSizePercent + trackpadPaddingPercent * 2) * cos(angle) + trackpadw/2.0;
    float trackpadblx = h * (1.0 - trackpadPaddingPercent) * cos(angle) - trackpadw/2.0;
    float trackpadbrx = h * (1.0 - trackpadPaddingPercent) * cos(angle) + trackpadw/2.0;

    drawPolygon(trackpadtlx, trackpadty, 
    trackpadtrx, trackpadty, 
    trackpadbrx, trackpadby, 
    trackpadblx, trackpadby);

    //  line(0, 0, cos(angle) * h, sin(angle) * h);
    //  line(cos(angle) * h / 2.0 - w/4.0, sin(angle) * h / 2.0, cos(angle) * h - w/4.0, sin(angle) * h);

    // screen
    fill(#FFFFFF);
    //  float screenPaddingPercent = 0.05;

    if (0 < modAngle && modAngle <= PI) {
      drawPolygon(-w/2.0, -h, w/2.0, -h, w/2.0, 0, -w/2.0, 0);
      //    rect(-w/2.0, -h, w, h);
      drawPolygon(-w/2.0 * (1-screenPaddingPercent), -h * (1-screenPaddingPercent), 
      w/2.0 * (1-screenPaddingPercent), -h * (1-screenPaddingPercent), 
      w/2.0 * (1-screenPaddingPercent), -h * screenPaddingPercent, 
      -w/2.0 * (1-screenPaddingPercent), -h * screenPaddingPercent);
      //    rect(-w/2.0 * (1-screenPaddingPercent), -h * (1-screenPaddingPercent), w * (1-screenPaddingPercent), h * (1-2*screenPaddingPercent));
    } 
    else {
      rect(-w/2.0, -h, w, h + keyboardThickness);
    }

    popMatrix();
  }
  
  // Here's our function that adds the particle to the Box2D world
  void makeBody(float x, float y) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.createBody(bd);
    
    // Make the body's shape a polygon
    PolygonShape psBottom = new PolygonShape();
    PolygonShape psTop = new PolygonShape();

    float modAngle = angle % (2*PI);

    float xx = h * cos(angle);
    float yy = h * sin(angle);

    Vec2[] verticesBottom = { new Vec2(-w/2.0, 0), new Vec2(w/2.0, 0), new Vec2(xx-w/2.0, yy), new Vec2(xx+w/2.0, yy) };
    Vec2[] verticesTop = { new Vec2(-w/2.0, 0), new Vec2(-w/2.0, -h), new Vec2(w/2.0, -h), new Vec2(w/2.0, 0) };
    
    psTop.set(verticesTop, verticesTop.length);
    psBottom.set(verticesBottom, verticesBottom.length);

    FixtureDef fd = new FixtureDef();
    fd.shape = psTop;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = 0.3;

//    body.createFixture(psTop, 1.0);
    body.createFixture(psBottom, 1.0);
    
    body.setAngularVelocity(random(-2, 2));
  }  
}

