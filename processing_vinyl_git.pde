/* processing sketch to draw a vinyl-like visualization
 from a song on your computer */


String filename = "audio.wav"; // replace this line by your audio file name

boolean RECORD_VIDEO = true;  // Put true here and a video will be generated in the
                              // project directory.
                              // Video stops automaticaly at end of song
                              // you can use <q> to stop it at any time

float SKETCH_FPS = 30.0; // RECORDING ONLY WORKS AT 30.0 fps


import com.hamoid.*;
VideoExport videoExport;

import processing.sound.*;
Amplitude amp;
SoundFile audio;

PImage backgd; // background image 

Disk disk;
Arm arm;


void setup() {
  frameRate(SKETCH_FPS);
  size(512, 512, P2D);
  smooth(8); // antialiasing
  backgd = loadImage("coolHue-43CBFF-9708CC.png");
  
  // create a disk with radius, angular speed, max furrow size, font size
  // values are given here for a 60 seconds audio
  disk = new Disk(228, 0.04, 7, 32);
  // create arm that will follow disk/audio position
  arm = new Arm(disk.MAX_RADIUS);

  if (RECORD_VIDEO) {
    videoExport = new VideoExport(this, "raw_output.mp4");
    videoExport.setFrameRate(30.0);
    videoExport.startMovie();
  }
  
  // load the audio
  audio = new SoundFile(this, filename);
  amp = new Amplitude(this); // object that gives volume information of the playing audio
  amp.input(audio);
  audio.play();
}

void draw() {
  translate(width/2, height/2); // center drawing
  
  push();
  // background gradient
  imageMode(CENTER);
  rotate(disk.angle /4);
  image(backgd, 0, 0, width * 1.5, height * 1.5);
  pop();
  
  rotate(PI/4); // some rotation for better looking arm-placement

  float delta = 60.0 / frameRate; // to make disk fps-independent. reference is 60.0 fps
  
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

void keyPressed() {
  if (key == 'q') {
    videoExport.endMovie();
    exit();
  }
}  
