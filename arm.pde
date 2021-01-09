class Arm {
  float disk_size;
  PVector elbow_pos;
  
  Arm(float disk_size_) {
    disk_size = disk_size_;
  }
  
  void display(float mag) {
    push();
    
    elbow_pos = new PVector(mag -0.02 * disk_size, -0.2 * disk_size);
    
    fill(255);
    stroke(0, 0, 0, 40);
    strokeWeight(0.03 * disk_size);
    
    // base
    ellipse(0, -1.3 * disk_size, 0.15 * disk_size, 0.15 * disk_size);

    stroke(255);

    // main arm
    line(0, -1.3 * disk_size, elbow_pos.x, elbow_pos.y);

    // sub arm
    strokeWeight(0.06 * disk_size);
    line(elbow_pos.x, elbow_pos.y, mag, 0);

    pop();
  }
}
