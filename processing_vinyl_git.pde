/* processing sketch to draw a vinyl-like visualization from a song on your
computer */

String filename = "audio.wav"; // replace this line by your audio file name

import processing.sound.*;
Amplitude amp;
SoundFile audio;

PImage backgd; // background image 

Disk disk;
Arm arm;


void setup() {
  frameRate(60);
  size(512, 512, P2D);
  smooth(8); // antialiasing
  backgd = loadImage("coolHue-43CBFF-9708CC.png");

  // create a disk with radius, angular speed, max furrow size, font size
  // values are given here for a 60 seconds audio
  disk = new Disk(228, 0.06, 7, 32);
  // create arm that will follow disk/audio position
  arm = new Arm(disk.MAX_RADIUS);

  // load the audio
  audio = new SoundFile(this, filename);
  // object that gives volume information of the playing audio
  amp = new Amplitude(this);
  amp.input(audio);
  audio.play();
}

void draw() {
  // to make disk fps-independent. reference is 60.0 fps
  float delta = 60.0 / frameRate;
  
  translate(width/2, height/2); // center drawing
  rotate(PI/4); // some rotation for better looking arm-placement

  draw_background();

  // calculate the position vector and add volume
  float volume = map(amp.analyze(), 0, 1, 0, disk.MAX_FURROW_SIZE);
  float mag = disk.radius - volume;
  PVector pos = new PVector(mag * cos(disk.angle), mag * sin(disk.angle));

  disk.process(delta, pos);
  disk.display();
  arm.display(pos.mag());
}

void keyPressed() {
  if (key == 'q') {
    exit();
  }
}

void draw_background() {
  push();
  // background gradient
  imageMode(CENTER);
  image(backgd, 0, 0, width * 1.5, height * 1.5);
  pop();
}
