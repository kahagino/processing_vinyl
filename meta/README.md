# processing_vinyl
processing sketch to draw a vinyl like visualization from a song on your computer

![Preview of the recorded video](preview.png)

## usage

 - 📁 put your song in the same directory as processing_vinyl.pde
 - 🏷 rename it "audio.wav"
 - 💻 [processing_vinyl.pde] in setup() function, tweak values where disk object is created to match a good looking disk. This is necessary for audios longer or smaller than 60 seconds. disk = new Disk(<radius>, <angular speed>, <maximum furrow size>, <font size>);