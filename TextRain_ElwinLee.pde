/*========================================================*/
/*
Project-1 Part B. Processing
TextRain by Elwin Lee
Carnegie Mellon University
 
51-882 Interactive Art & Computational Design
Class by Golan Levin, Spring 2013
Carnegie Mellon University, School of Art

/*Description
Text Rain based on the now-classic of interactive art by Camille Utterback and Romy Achituv (1999).
Letters (OOP) will fall down from a random position and stops when it "collides" with an object. 
The letters will also trace around an object's edge through an algorithm that pushes the letter 
upwards by checking the brightness of the vertical pixels above it.
?*
/*========================================================*/

import processing.video.*;

PFont f;

Capture video;
Letter[] letters;


int w = 640;
int h = 480;

String message = "For Part B of this assignment, you are asked to implement “Text Rain” in Processing. Reimplementing a project like this can be highly instructive, and test the limits of your attention to detail.";


color thresholdColor;


void setup() {
  size(w, h);  //window size
  
  f = createFont("Arial", 16, true);
  textFont(f);
  
  letters = new Letter[message.length()];
  for( int i = 0; i < message.length(); i++ ) {
    letters[i] = new Letter( random(0,width), 0, message.charAt(i) );
  }

  //Checks which cameras are available
  //  String[] cameras = Capture.list();
  //  if (cameras.length == 0) {
  //    println("There are no cameras available for capture.");
  //    exit();
  //  } else {
  //    println("Available cameras:");
  //    for (int i = 0; i < cameras.length; i++) {
  //      println(cameras[i]);
  //    }
  //  }  
  
  video = new Capture(this, w, h, 30); //initiates capture
  video.start();  //starts capturing video

  smooth();
}

void draw() {
  if ( video.available() ) {
    video.read();  //reads video input
  }

  image(video, 0, 0);  //displays video image

  for( int i = 0; i < message.length(); i++ ) {
    letters[i].update();
    letters[i].display();
  }
}


class Letter {

  char letter;
  float x, y;
  int velocity;
  int brightnessThreshold = 150; 
  
  long start;
  long delay;
  float life = 255;
  boolean dying = false;
  
  Letter( float _x, float _y, char _letter ) {  //creates Letter instance
    x = _x;
    y = _y;
    letter = _letter;
    velocity = round(random(1,3));
    life = round(random(100,256));
    
    start = millis();
    delay = round(random(500,10000));  //delay when letter falls at the beginning
  }
  
  void display() {  //displays Letter
    fill(100, life);
    text(letter, x, y);
  }
  
  void update() {  //update letter variables

    if( y >= height ) {  //reset if letter at the bottom
      x = random(0,width);  //give random x position
      y = 0;
      
    } else {
      if( brightness(video.pixels[round(x+y*width)]) < brightnessThreshold ) {  //if letter position is dark, stop letter

        //algorithm to push letter up to follow the "edge"
        if( y > 0 && y != 0) {  //only push up if y pos is not at 0
          float _y = y;  //temp y
          
          for( int i = int(y); i > 0; i-- ) {  //look at every single pixel above letter
            if( brightness(video.pixels[round(x+i*width)]) > brightnessThreshold ) {  //if it is bright
              _y = i;  //make that new y position
              break;  //stop looking for next pixel
            }
          }
          y = _y;  //update y position
        }       
      } else {  //move letter down
        if ( (millis() - start) > delay) {  //delay
          y += 1;
        }
      } 
    }
  }
  
}

