PImage img;  // Declare a variable of type PImage
color swap = color(153,255, 255);
color replace = color(random(255), random(255), random(255));
int i = 0;

void replaceColor(PImage img) {
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
  size(320,480);
  // Make a new instance of a PImage by loading an image file
  img = loadImage("sodacan.png");
  
  replaceColor(img);
}

void draw() {
  background(0);

  if(i % 50 == 0) {
    replace = color(random(255), random(255), random(255));
    replaceColor(img);
    i = 0;
  }
  i++;
  image(img,0,0);
}