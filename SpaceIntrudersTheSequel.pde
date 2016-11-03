/**
*@author Juan S. Vasquez
*@date June 6th, 2013
* Space Intruders The Sequel
* In this game, you must dodge kamikaze aliens by moving your spaceship using the left and right keys. 
* The asteroids will not damage you, as your ship is made of asteroid-proof metal. 
* ALL-TIME HIGH SCORE: 17 points
*/

//imports minim application
import ddf.minim.*;
Minim minim;

//declares sounds to be loaded
AudioPlayer explosion;
AudioPlayer shipMovement;

//score
int score=0;

//title screen
boolean play= false;

//spaceship location variables
int sX=200;
int sY=375;

//alien location variables
int aX= round(random(30,370));
int aY= 0;

//collision variables
int shipAlienCollision=30;
boolean collided=false;

//asteroid variables
int asY1= 0;
int asY2= 400/5;
int asY3= 400/5*2;
int asY4= 400/5*3;
int asY5= 400/5*4;
int asX1= round(random(0,400));
int asX2= round(random(0,400));
int asX3= round(random(0,400));
int asX4= round(random(0,400));
int asX5= round(random(0,400));
 
void setup(){
  /**
  * Setup function - creates a window of size 400 x 400
  *starts the minim sound engine
  */
  size(400,400);
  minim= new Minim(this);
  explosion= minim.loadFile("explosion.mp3");
  shipMovement= minim.loadFile("shipMovement.mp3");
}

void draw(){
  /**
  * Draw function -
  * Draws alien, spaceship, and asteroids
  * Draws a title screen w/ options
  * Increases frame rate to 60, and counts player's score in real time
  * Key mapping
  * X-boundaries to prevent the ship from going off-screen
  * Moves alien down, and increases speed as frame count gets higher
  * Moves asteroids down, and increases speed as frame count gets higher
  * Resets alien position when it reaches the bottom
  * Resets asteroid positions when they reach the bottom
  * Detects collision between alien and ship
  * Displays game over screen if collision occurs
  */
  background(0, 0, 50);
    // title screen
  //PROJECT REQUIREMENT (CONDITIONAL)
  if (play == false) { 
    fill(0, 250, 50);
    textSize(13);
    text("Click to start", 170, 375);   
    textSize(35);
    text("THE SPACE INTRUDERS", 10,100);
    text("IN:", 180,150);
    textSize(70);
    text("THE SEQUEL", 0,270);
    //start game when mouse is clicked
    if (mousePressed) {
            play = true;
    }          
  }
  else{
    drawAlien(aX,aY,40,20);
  
    drawAsteroids(asX1,asY1,60,60);
    drawAsteroids(asX2,asY2,20,20);
    drawAsteroids(asX3,asY3,30,30);
    drawAsteroids(asX4,asY4,40,40);
    drawAsteroids(asX5,asY5,50,50);
    
    drawShip(sX,sY,24,40);
    
    //Set frame rate
    frameRate(60);
    
    //Scoring
    score= round(frameCount/60);
    fill(0, 255, 0);
    textSize(16);
    text("Score:"+score,10,30);
    
    //Key controls function call
    keyControls();
    
    //ship boundaries
    if(sX<25){
      //stops the ship
      sX=25;
    }
    if(sX>375){
      //stops the ship
      sX=375;
    }  
    //Alien movement downwards
    //alien gets faster as frameCount increases
    aY+=3+frameCount/60; 
      
    //alien position reset 
    if(aY>425){
      aX= round(random(30,370));
      aY= 0;
    }
    
    //asteroids position reset
    asteroidsReset();  
    
    //collision detection  
    float dist= sqrt((sX-aX)*(sX-aX)+(sY-aY)*(sY-aY));
    if(dist<shipAlienCollision){
     collided=true;
    } 
      
    //GAME OVER screen
    if(collided){
      background(255,0,0);
      fill(0);
      textSize(18);
      text("Ship Destroyed. Game Over!",75,200);
      text("Your Final Score Is "+score,110,244);
      frameRate(0);
      explosion.play();
      }
    
    //asteroid movement down increases over time  
    asY1+=3+frameCount/60;
    asY2+=3+frameCount/60;
    asY3+=3+frameCount/60;
    asY4+=3+frameCount/60;
    asY5+=3+frameCount/60;
  
  }
}

void stop(){
  /**
  * Sound function - closes the sound engine  
  */
  minim.stop();
  super.stop();
}

void drawShip(int shipX, int shipY, int shipWidth, int shipLength){
    /**
    *function definition: drawShip
    * Function draws a ship of shipWidth width and shipLength length.
    * Ship is centered at coordinates shipX and shipY
    * The ship has a nose, two wings, and a window
    * @param shipX - x coordinate of the ship
    * @param shipY - y coordinate of the ship
    * @param shipWidth - width of the ship
    * @param shipLength - length of the ship
    */
    noStroke();
    //orange
    fill(255, 165, 0);
    //body
    rect(shipX-13,shipY-20,shipWidth, shipLength);
    //gray color 
    fill(128);
    //nose guns
    rect(shipX-6,shipY-38,shipWidth-30, shipLength-23);
    rect(shipX+11,shipY-38,shipWidth-30, shipLength-23);
    //red color
    fill(255, 0, 0);
    //nose
    triangle(shipX-1,shipY-42,shipX-13,shipY-20,shipX+11,shipY-20);
    //gray color
    fill(128);
    //left wing guns
    rect(shipX-20,shipY-10,shipWidth-20, shipLength-20);
    rect(shipX-25,shipY-5,shipWidth-20, shipLength-20);
    //right wing guns
    rect(shipX+15,shipY-10,shipWidth-20, shipLength-20);
    rect(shipX+20,shipY-5,shipWidth-20, shipLength-20);
    //red color
    fill(255,0,0);
    //left flap
    triangle(shipX-13,shipY,shipX-31,shipY+20,shipX-13,shipY+20);
    //right flap
    triangle(shipX+11,shipY,shipX+11,shipY+20,shipX+32,shipY+20);
    //blue color
    fill(30, 0, 255);
    //window
    ellipse(shipX-1,shipY-10,shipWidth-9,shipLength-25);
    //back flames
    fill(255,255,0);
    rect(shipX-7, shipY+20, shipWidth-12, shipLength-20);
}

void drawAlien(int alienX, int alienY, int alienWidth, int alienLength){
    /**
    *function definition: drawAlien
    * Function draws an alien of alienWidth width and alienLength length.
    * Alien is located at coordinates alienX and alienY
    * The alien has eyes, and antennae with antennae tips
    * @param alienX - x coordinate of the alien
    * @param alienY - y coordinate of the alien
    * @param alienWidth - width of the alien
    * @param alienLength - length of the alien
    */
    strokeWeight(1);
    //red stroke
    stroke(240, 0, 0);
    //alien legs
    rect(alienX+5, alienY+20,7,7);
    rect(alienX+15,alienY+20,10,15);
    rect(alienX+28, alienY+20,7,7);
    //green color
    fill(0, 250, 50);
    //alien body
    rect(alienX,alienY,alienWidth,alienLength);
    //red color
    fill(255,0,0);
    //alien eyes
    rect(alienX+5,alienY+2,alienWidth-30,alienLength-10);
    rect(alienX+25,alienY+2,alienWidth-30,alienLength-10);
    //alien hat
    triangle(alienX+14,alienY,alienX+27,alienY,alienX+20,alienY-10);
    //alien antennae
    line(alienX+38,alienY-20,alienX+27,alienY);
    line(alienX+4,alienY-20,alienX+14,alienY);
    //alien antennae tips
    ellipse(alienX+38,alienY-20,alienWidth-35,alienLength-15);
    ellipse(alienX+4,alienY-20,alienWidth-35,alienLength-15);
}

void drawAsteroids(float asteroidX, float asteroidY, int asteroidWidth, int asteroidLength){
    /**
    *function definition: drawAsteroids
    * Function draws an asteroid of asteroidWidth width and asteroidLength length.
    * Asteroid is located at coordinates asteroidX and asteroidY
    * @param asteroidX - x coordinate of the asteroid
    * @param asteroidY - y coordinate of the asteroid
    * @param asteroidWidth - width of the asteroid
    * @param asteroidLength - length of the asteroid
    */
    strokeWeight(1);
    noStroke();
    //gray color
    fill(120, 118, 115);
    //asteroid
    rect(asteroidX,asteroidY,asteroidWidth,asteroidLength);
    
}
//PROJECT REQUIREMENT (FUNCTION #1)
void keyControls(){
    /**
    *function definition: keyControls
    * Function creates if statements binding the left and right arrow keys to ship movement and sound effects.
    */
    if(keyPressed && keyCode==RIGHT){
      //moves the ship right
      sX+=7;
      //plays sound
      shipMovement.play();
      //restarts sound
      shipMovement.rewind();
    } 
    if(keyPressed && keyCode==LEFT){
      //moves the ship left
      sX-=7;
      //plays sound
      shipMovement.play();
      //restarts sound
      shipMovement.rewind();
    }
}

//PROJECT REQUIREMENT (FUNCTION #2)
void asteroidsReset(){
    /**
    *function definition: asteroidsReset
    * Function resets asteroids back to the top of the screen when they are under the bottom part of the screen.
    */  
    if(asY1>425){
          asX1= round(random(0,400));
          asY1= 0;
      }
    if(asY2>425){
          asX2= round(random(0,400));
          asY2= 0;
      }
    if(asY3>425){
          asX3= round(random(0,400));
          asY3= 0;
      }
    if(asY4>425){
          asX4= round(random(0,400));
          asY4= 0;
      }
    if(asY5>425){
          asX5= round(random(0,400));
          asY5= 0;
      }
}
