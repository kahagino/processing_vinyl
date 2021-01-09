class Disk {
  float MAX_RADIUS;
  float MIN_RADIUS;
  float MAX_FURROW_SIZE; // how large the volume will be drawn
  float BASE_ANG_SPEED; // how fast the disk spin. in rad/frame

  float angle;
  float radius;
  float angular_speed;
  float radius_speed;

  PFont custom_font;
  int FONT_SIZE;

  // each vertex will be connected to draw a continuous line
  ArrayList<PVector> vertexs;

  Disk(float MAX_RADIUS_, float BASE_ANG_SPEED_, float MAX_FURROW_SIZE_, int FONT_SIZE_) {
    MAX_RADIUS = MAX_RADIUS_;
    MIN_RADIUS = 0.25 * MAX_RADIUS;
    BASE_ANG_SPEED = BASE_ANG_SPEED_;
    MAX_FURROW_SIZE = MAX_FURROW_SIZE_;
    FONT_SIZE = FONT_SIZE_;

    angle = 0.0;
    radius = MAX_RADIUS;

    custom_font = createFont("Cyberpunk.ttf", FONT_SIZE);

    vertexs = new ArrayList<PVector>();
  }


  void process(float delta, PVector pos) {
    if (radius > MIN_RADIUS) {
      vertexs.add(pos);
      
      float nb_frames = audio.duration() * frameRate;
      float dist = MAX_RADIUS - MIN_RADIUS;
      
      radius_speed = dist / nb_frames;
      radius -= radius_speed;
    }

    angular_speed = delta * BASE_ANG_SPEED;
    angle -= angular_speed;
  }


  void display() {        
    push();
    
    rotate(-angle -angular_speed); // rotate the disk. Add angular_speed to match with the arm position
    
    draw_disc();
    draw_line();

    textFont(custom_font);
    textAlign(CENTER);
    textSize(FONT_SIZE);
    text("Ran", 0, -0.4 * MIN_RADIUS);

    textFont(custom_font);
    textAlign(CENTER);
    textSize(FONT_SIZE);
    text("doM", 0, 0.5 * MIN_RADIUS);

    pop();
  }


  void draw_disc() {
    push();
    
    // draw_disk
    fill(0, 0, 0, 35);
    stroke(0, 0, 0, 50);
    strokeWeight(2);
    ellipse(0, 0, 2*MAX_RADIUS + 16, 2*MAX_RADIUS + 16);

    noStroke();

    // disk center
    fill(255, 255, 255, 50);
    ellipse(0, 0, 2*MIN_RADIUS, 2*MIN_RADIUS);

    // draw center dot
    fill(255);
    ellipse(0, 0, 0.2 * MIN_RADIUS, 0.2 * MIN_RADIUS);

    pop();
  }
  
  void draw_line() {
    push();
    
    noFill();
    stroke(255);
    
    ellipse(0, 0, 2*MAX_RADIUS, 2*MAX_RADIUS);
    ellipse(0, 0, 2*MIN_RADIUS, 2*MIN_RADIUS);
    
    beginShape();
    for (int i = 0; i < vertexs.size(); i++) {
      vertex(vertexs.get(i).x, vertexs.get(i).y);
    }
    endShape();
    pop();
  }
}
