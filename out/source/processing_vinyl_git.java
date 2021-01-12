import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import com.hamoid.*; 
import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class processing_vinyl_git extends PApplet {

/* processing sketch to draw a vinyl-like visualization
 from a song on your computer */


String filename = "audio.wav"; // replace this line by your audio file name

boolean RECORD_VIDEO = true; // Put true here and a video will be generated in the
                              // project directory.
                              // Video stops automaticaly at end of song
                              // you can use <q> to stop it at any time

float SKETCH_FPS = 30.0f; // RECORDING ONLY WORKS AT 30.0 fps



VideoExport videoExport;


Amplitude amp;
SoundFile audio;

PImage backgd; // background image 

Disk disk;
Arm arm;


public void setup() {
  frameRate(SKETCH_FPS);
  
   // antialiasing
  backgd = loadImage("coolHue-43CBFF-9708CC.png");
  
  // create a disk with radius, angular speed, max furrow size, font size
  // values are given here for a 60 seconds audio
  disk = new Disk(228, 0.04f, 7, 32);
  // create arm that will follow disk/audio position
  arm = new Arm(disk.MAX_RADIUS);

  if (RECORD_VIDEO) {
    videoExport = new VideoExport(this, "raw_output.mp4");
    videoExport.setFrameRate(30.0f);
    videoExport.startMovie();
  }
  
  // load the audio
  audio = new SoundFile(this, filename);
  amp = new Amplitude(this); // object that gives volume information of the playing audio
  amp.input(audio);
  audio.play();
}

public void draw() {
  translate(width/2, height/2); // center drawing
  
  push();
  // background gradient
  imageMode(CENTER);
  rotate(disk.angle /4);
  image(backgd, 0, 0, width * 1.5f, height * 1.5f);
  pop();
  
  rotate(PI/4); // some rotation for better looking arm-placement

  float delta = 60.0f / frameRate; // to make disk fps-independent. reference is 60.0 fps
  
  // calculate the position vector and add volume
  float volume = map(amp.analyze(), 0, 1, 0, disk.MAX_FURROW_SIZE);
  float mag = disk.radius - volume;
  PVector pos = new PVector(mag * cos(disk.angle), mag * sin(disk.angle));

  disk.process(delta, pos);
  disk.display();
  arm.display(mag);

  if (RECORD_VIDEO) {
    // to have video stop at the right time
    // for better sync with ffmpeg:
    
    if (videoExport.getCurrentTime() < audio.duration()) {
      videoExport.saveFrame();
    } else {
      videoExport.endMovie();
      exit();
    }
  }
}

public void keyPressed() {
  if (key == 'q') {
    videoExport.endMovie();
    exit();
  }
}  
class Arm {
  float disk_size;
  PVector elbow_pos;
  
  Arm(float disk_size_) {
    disk_size = disk_size_;
  }
  
  public void display(float mag) {
    push();
    
    elbow_pos = new PVector(mag -0.02f * disk_size, -0.2f * disk_size);
    
    fill(255);
    stroke(0, 0, 0, 40);
    strokeWeight(0.03f * disk_size);
    
    // base
    ellipse(0, -1.3f * disk_size, 0.15f * disk_size, 0.15f * disk_size);

    stroke(255);

    // main arm
    line(0, -1.3f * disk_size, elbow_pos.x, elbow_pos.y);

    // sub arm
    strokeWeight(0.06f * disk_size);
    line(elbow_pos.x, elbow_pos.y, mag, 0);

    pop();
  }
}
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
    MIN_RADIUS = 0.25f * MAX_RADIUS;
    BASE_ANG_SPEED = BASE_ANG_SPEED_;
    MAX_FURROW_SIZE = MAX_FURROW_SIZE_;
    FONT_SIZE = FONT_SIZE_;

    angle = 0.0f;
    radius = MAX_RADIUS;

    custom_font = createFont("Cyberpunk.ttf", FONT_SIZE);

    vertexs = new ArrayList<PVector>();
  }


  public void process(float delta, PVector pos) {
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


  public void display() {        
    push();
    
    rotate(-angle -angular_speed); // rotate the disk. Add angular_speed to match with the arm position
    
    draw_disc();
    draw_line();

    textFont(custom_font);
    textAlign(CENTER);
    textSize(FONT_SIZE);
    text("Ran", 0, -0.4f * MIN_RADIUS);

    textFont(custom_font);
    textAlign(CENTER);
    textSize(FONT_SIZE);
    text("doM", 0, 0.5f * MIN_RADIUS);

    pop();
  }


  public void draw_disc() {
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
    ellipse(0, 0, 0.2f * MIN_RADIUS, 0.2f * MIN_RADIUS);

    pop();
  }
  
  public void draw_line() {
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
  public void settings() {  size(512, 512, P2D);  smooth(8); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "processing_vinyl_git" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
