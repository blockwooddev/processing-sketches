import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
BeatDetect kickDetect;
BeatDetect snareDetect;
BeatDetect hatDetect;
BeatListener bl;
BeatListener sl, hl;

class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;
  
  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
  
  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }
  
  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

PImage img;  // Declare a variable of type PImage
color swap = color(153,255, 255);

int i = 0;

void replaceColor(PImage img, color replace) {
  img.loadPixels();
  
  //select a random pixel
  int randX = int(random(img.width));
  int randY = int(random(img.height));
  
  int randLoc = randX + randY*img.width;

  swap = img.pixels[randLoc];
  
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int loc = x + y*img.width;

      if(img.pixels[loc] == swap) {
          img.pixels[loc] = replace;
      }
    }
    
  }
  img.updatePixels();


}

void setup() {
  size(800,600);
  // Make a new instance of a PImage by loading an image file
  img = loadImage("art.jpg");
  //img = loadImage("sodacan.png");

  minim = new Minim(this);
  
  song = minim.loadFile("test.mp3", 1024);
  song.play();

  kickDetect = new BeatDetect(song.bufferSize(), song.sampleRate());
  snareDetect = new BeatDetect(song.bufferSize(), song.sampleRate());
  hatDetect = new BeatDetect(song.bufferSize(), song.sampleRate());

  kickDetect.setSensitivity(1200);  
  snareDetect.setSensitivity(300);
  hatDetect.setSensitivity(4800);

  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(kickDetect, song);  
  sl = new BeatListener(snareDetect, song);
  hl = new BeatListener(hatDetect, song);

}

void draw() {
  background(0);

  int lowBand = 15;
  int highBand = 20;
  int kickLowB = 0;
  int kickHighB = 1;
  // at least this many bands must have an onset 
  // for isRange to return true
  int kickNumberOfOnsetsThreshold = 1;
  int numberOfOnsetsThreshold = 2;
  
  if ( kickDetect.isRange(kickLowB, kickHighB, kickNumberOfOnsetsThreshold) || 
       snareDetect.isRange(lowBand, highBand, numberOfOnsetsThreshold) ||
       hatDetect.isHat()) {
    color replace = color(random(255), random(255), random(255));
    replaceColor(img, replace);
  }

  image(img,0,0);
}