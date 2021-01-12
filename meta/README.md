# processing_vinyl
processing sketch to draw a vinyl like visualization from a song on your computer

![Preview of the recorded video](preview/preview.png)

## usage

 - 🎵 supported formats are WAV, AIF/AIFF, MP3. MP3 is not recommended and may be very slow
 - 📁 put your audio file in the "resources" directory
 - 🏷 open the sketch and change `audio_file_path` with the name of the audio you just added in the "resources" dir
 - 💻 [processing_vinyl.pde] in `setup()` function, tweak values where disk object is created to match a good looking disk. This is necessary for audios longer or smaller than 60 seconds. `disk = new Disk(radius, angular speed, maximum furrow size, font size);`
 - ⏯ run the sketch