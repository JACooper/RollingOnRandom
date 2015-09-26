/*
  Jesse Cooper
  IGME 202.01
  "Rolling on Random" Homework
 */

import java.util.*;

//  --  Global Variables  --

vehicle cart;
character cartPusher;   // The name is actually Kjeldson, but for legibility I left it as simply "cartPusher" in the code 
int WINDOW_WIDTH = 1200, WINDOW_HEIGHT = 700;

// Variables for determining character & vehicle animation
int foreLegRotation, backLegRotation;
boolean forward;        // For determining if the character's legs are moving forward or backward
float charY;
float vehicleY;
float wheelRotation;
float headRotation;

// Variables for perlin noise landscape
float yOffset;
float backgroundOffset;

// Variables necessary for vector math - used in determining angle of rotation between character/vehicle and ground
PVector myVec;
float rotAngle;
boolean negateY;

// Holder variables, used to simplify calculations in draw()
float perlin;
float HEIGHT_HOLDER;
float CHARY_HOLDER;
float VEHICLEY_HOLDER;
float SNOW_HEIGHT_HOLDER;
PVector xAxis;

Random generator;  // Used for snow & stars

// Variables for snowfall
int numSnow;
PVector[] snowPos;
PVector[] snowPos2;
PVector[] snowPos3;
PVector[] snowPos4;
PVector[] snowPos5;

// Variables for star display
int numStars;
PVector[] starPos;
boolean assignedStars;  // Stars display differently each night - this tells the program when to recalculate them 

// Determine the color of the ground - i.e. enables snow to collect
float redColor;
float greenColor;
float blueColor;

float darkness;         // Transparency of a black overlay
boolean day;            // Determines if it should be getting lighter or darker out

float bloodMoon;        // Keeps the blood moon moving

PFont myFont;           // Custom font for the end of the world

//  --  End of Global Variables  --


void setup()
{
  /*
  * Invalid in Processing 3
  * WINDOW_WIDTH = 1200;
  * WINDOW_HEIGHT = 700;
  * size(WINDOW_WIDTH, WINDOW_HEIGHT, P2D);
  */
  
  size(1200, 700, P2D);
  
  cart = new vehicle(0, 105);
  cartPusher = new character(160, 80);
  foreLegRotation = 0;
  backLegRotation = 0;
  forward = true;
  yOffset = 0;
  backgroundOffset = 0;
  rotAngle = 0;
  wheelRotation = 0;
  headRotation = 0;
  
  
  HEIGHT_HOLDER = height / 2;  // Use of holder variable reduces # of divisions per frame by 7,204 @ width = 1200
  CHARY_HOLDER = HEIGHT_HOLDER - (cartPusher.CHARACTER_BODY_HEIGHT + 26);
  VEHICLEY_HOLDER = HEIGHT_HOLDER - 47.5;
  SNOW_HEIGHT_HOLDER = height * 2 / 3;
  xAxis = new PVector(1, 0);   // Reduces number of calls to new PVector() from 1 per frame to 1
  
  myVec = new PVector();
  generator = new Random();
  numSnow = (int)generator.nextGaussian() + 100;
  snowPos = new PVector[numSnow];
  snowPos2 = new PVector[numSnow];
  snowPos3 = new PVector[numSnow];
  snowPos4 = new PVector[numSnow];
  snowPos5 = new PVector[numSnow];
  for (int k = 0; k < numSnow; k++)
  {
    snowPos[k] = new PVector((float)(generator.nextGaussian() * 500 + 600), 0);      // Cluster snow mostly around the middle, but have a large standard dev. so 
    snowPos2[k] = new PVector((float)(generator.nextGaussian() * 500 + 600), -125);  // Stagger each "row" of snow to give it the appearance of uniform snowfall
    snowPos3[k] = new PVector((float)(generator.nextGaussian() * 500 + 600), -250);
    snowPos4[k] = new PVector((float)(generator.nextGaussian() * 500 + 600), -375);
    snowPos5[k] = new PVector((float)(generator.nextGaussian() * 500 + 600), -500);
  }
  
  numStars = (int)generator.nextGaussian() * 10 + 50;  // Creates a random amount of stars
  starPos = new PVector[numStars];
  for (int i = 0; i < numStars; i++)
    starPos[i] = new PVector(0,0);
  
  assignedStars = false;
  
  redColor = 0;
  greenColor = 0; 
  blueColor = 0;
  
  darkness = 0;
  day = true;
 
  bloodMoon = 0;  // Initially no adjust in the blood moon's position
  
  myFont = createFont("Algerian", 30);
}

void draw()
{
  background(255);
  
  // Draw mountains
  for (int j = 0; j < width; j++)
  {
    perlin = noise((backgroundOffset) + (0.015 * j)) * (HEIGHT_HOLDER);
    stroke(0);                       // Outline
    line(j, perlin, j + 1, noise((backgroundOffset) + (0.015 * (j + 1))) * (HEIGHT_HOLDER));
    stroke(color(115, 115, 115));    // Mountains
    line(j, perlin + 50, j, height);
    stroke(color(170, 180, 240));    // Sky
    line(j, 0, j, perlin);
    stroke(color(240, 240, 240));    // Upper Peaks
    line(j, perlin, j, perlin + 20);
    stroke(color(180, 180, 210));    // Lower Peaks
    line(j, perlin + 20, j, perlin + 50);
  }
  backgroundOffset += 0.0007;
  
  // Draw landscapes
  for (int i = 0; i < width; i++)
  {
    perlin = HEIGHT_HOLDER + noise((yOffset) + (0.001 * i)) * (HEIGHT_HOLDER);
    stroke(0);                       // Outline
    line(i, perlin, i + 1, HEIGHT_HOLDER + noise((yOffset) + (0.001 * (i + 1))) * (HEIGHT_HOLDER));
    stroke(color(redColor, 127 + greenColor, blueColor));    // Upper ground
    line(i, perlin, i + 1, perlin + 20);
    stroke(color(redColor - 25, 102 + greenColor, blueColor - 25));    // Middle ground
    line(i, perlin + 20, i, perlin + 60);
    stroke(color(redColor - 50, 77 + greenColor, blueColor - 50));    // Lower ground
    line(i, perlin + 60, i, height);
  }
  
  // After a certain number of frames, start accumulating snow
  if (frameCount >= 360 && redColor < 230)
  {
    redColor += 0.04;
    greenColor += 0.04;
    blueColor += 0.04;
  }
  
  // Adjust character & vehicle y coordinates to match the landscape curve
  charY = CHARY_HOLDER + noise((yOffset) + (0.001 * cartPusher.xCoord)) * (HEIGHT_HOLDER);
  vehicleY = VEHICLEY_HOLDER + noise((yOffset) + (0.001 * (cart.xCoord + 65))) * (HEIGHT_HOLDER);
  
  yOffset += 0.001;
  
  // Get a vector from the vehicle wheel to the character's legs
  myVec.x = (cartPusher.xCoord) - (cart.xCoord + 65);
  myVec.y = (charY - vehicleY);
  
  // If it's a downward slope, negate the angle (since the x-axis is at 0)
  negateY = false;
  if (myVec.y < 0)
    negateY = true;
    
  //myVec.normalize();
  rotAngle = PVector.angleBetween(myVec, xAxis);
  
  if (negateY == true)
    rotAngle *= -1;
    
  // Values to hold snow "sway" (so it doesn't just fall straight down)
  float rndNumOne;
  float rndNumTwo;
  
  // White snow
  stroke(color(255, 255, 255, 255));
  for (int k = 0; k < numSnow; k++)
  {
    // Draw the snow
    point(snowPos[k].x, snowPos[k].y);
    point(snowPos2[k].x, snowPos2[k].y);
    point(snowPos3[k].x, snowPos3[k].y);
    point(snowPos4[k].x, snowPos4[k].y);
    point(snowPos5[k].x, snowPos5[k].y);
    
    rndNumTwo = (float)generator.nextGaussian();
    
    // Make the snow fall at varying rates
    if (rndNumTwo > 0)
    {
      snowPos[k].y += 0.3;
      snowPos2[k].y += 0.4;
      snowPos3[k].y += 0.5;
      snowPos4[k].y += 0.4;
      snowPos5[k].y += 0.3;
    }
    else
    {
      snowPos[k].y += 2.3;
      snowPos2[k].y += 2.2;
      snowPos3[k].y += 2.1;
      snowPos4[k].y += 2.2;
      snowPos5[k].y += 2.3;
    }
    
    rndNumOne = (float)generator.nextGaussian();
    
    if (rndNumOne > 0)
      rndNumOne = -1;
    else
      rndNumOne = 1;
    
    // If snow is at either edge of the screen, make sure it doesn't go off, otherwise sway it
    if (snowPos[k].x >= width)
    {
      snowPos[k].x -= 1;
      snowPos2[k].x -= 1;
      snowPos3[k].x -= 1;
      snowPos4[k].x -= 1;
      snowPos5[k].x -= 1;
    }
    else if (snowPos[k].x <= 0)
    {
      snowPos[k].x += 1;
      snowPos2[k].x += 1;
      snowPos3[k].x += 1;
      snowPos4[k].x += 1;
      snowPos5[k].x += 1;
    }
    else
    {
      snowPos[k].x += rndNumOne;
      snowPos2[k].x += rndNumOne;
      snowPos3[k].x += rndNumOne;
      snowPos4[k].x += rndNumOne;
      snowPos5[k].x += rndNumOne;
    }
    
    // If the snow has reached its maximum height value, reset it
    if (snowPos[k].y >= SNOW_HEIGHT_HOLDER)
      snowPos[k].y = 0;
      
    if (snowPos2[k].y >= SNOW_HEIGHT_HOLDER)
      snowPos2[k].y = 0;
      
    if (snowPos3[k].y >= SNOW_HEIGHT_HOLDER)
      snowPos3[k].y = 0;
      
    if (snowPos4[k].y >= SNOW_HEIGHT_HOLDER)
      snowPos4[k].y = 0;
      
    if (snowPos5[k].y >= SNOW_HEIGHT_HOLDER)
      snowPos5[k].y = 0;
  }
  
  if (wheelRotation == 360)  // If the wheel has rotated completely around, revert it (not really necessary, but nice)
    wheelRotation = 0;
  wheelRotation++;
  
  // Character leg rotation
  if (forward == true)
  {
    if (foreLegRotation == 25)
      forward = false;
    foreLegRotation++;
    backLegRotation--;
  }
  else if (forward == false)
  {
    if (foreLegRotation == -25)
      forward = true;
    foreLegRotation--; 
    backLegRotation++;
  }
  
  // Force character/vehicle y coordinates to match the landscape curve
  cartPusher.yCoord = charY;
  cart.yCoord = vehicleY;
  // If the stars have come out, have Kjeldson look up
  if (darkness > 190)
  {
    if (headRotation < 25)
      headRotation += 0.5;
    cartPusher.walkCharacterLegsRotatedAlt(headRotation, rotAngle, foreLegRotation, backLegRotation);
  }
  else
  {
    if (headRotation > 0)
      headRotation -= 0.5;
    cartPusher.walkCharacterLegsRotatedAlt(headRotation, rotAngle, foreLegRotation, backLegRotation);
  }
  
  cart.displayVehicleRotated(wheelRotation, rotAngle);
  
  // Draw "night"
  fill(color(0, 0, 0, darkness));
  rect(-1, -1, WINDOW_WIDTH, WINDOW_HEIGHT);
  
  // If it's day, make things darker
  if (day == true)
    darkness += 0.05;
  else if (day == false && darkness >= 180)  // If it's the middle of the night, make things a little lighter
    darkness -= 0.02;
  else  // If it's dawn, make things gradually lighter
    darkness -= 0.04;
  
  // If you haven't assigned the stars tonight
  if (darkness >= 180 && assignedStars == false)
  {
    for (int j = 0; j < numStars; j++)
    {
      starPos[j].x = (float)generator.nextGaussian() * 600 + 600;
      starPos[j].y = map(noise((float)generator.nextGaussian()), 0, 1, 0, noise((backgroundOffset) + (0.015 * starPos[j].x)) * (HEIGHT_HOLDER));
    }
    assignedStars = true; 
  }
  else if (darkness >= 180)  // If it's night and the stars have been assigned, draw the stars
  {
    fill(color(255, 255, 255, darkness - 165));
    stroke(color(255, 255, 255, darkness - 165));
    for (int j = 0; j < numStars - 3; j++)
    {
      ellipse(starPos[j].x, starPos[j].y, 3, 3);
      if (dist(starPos[j].x, starPos[j].y, starPos[j + 1].x, starPos[j + 1].y) < 40)  // Maybe draw some simple lines of doom and/or constellations
        line(starPos[j].x, starPos[j].y, starPos[j + 1].x, starPos[j + 1].y);
      if (dist(starPos[j].x, starPos[j].y, starPos[j + 2].x, starPos[j + 2].y) < 40)
        line(starPos[j].x, starPos[j].y, starPos[j + 2].x, starPos[j + 2].y);
      if (dist(starPos[j].x, starPos[j].y, starPos[j + 3].x, starPos[j + 3].y) < 40)
        line(starPos[j].x, starPos[j].y, starPos[j + 3].x, starPos[j + 3].y);
      starPos[j].x -= 0.04;
    }
  }
  
  float DARK_HOLDER = darkness - 40;  // To reduce calculations later
  if (darkness <= 40)  // If it's bright, draw a grayish-white blood moon
  { 
    stroke(color(200, 200, 200));
    fill(color(200, 200, 200));
  }
  else if (darkness < 160)  // As it gets darker, the blood moon gets more and more red
  {
    stroke(color(200, 200 - DARK_HOLDER, 200 - DARK_HOLDER));
    fill(color(200, 200 - DARK_HOLDER, 200 - DARK_HOLDER));
  }
  else if (darkness >= 160)
  {
    stroke(color(200, 80, 80));
    fill(color(200, 80, 80));
  }
  ellipse((width - 60) + bloodMoon, 30, 40, 40);
  bloodMoon -= 0.05;  // Shift the blood moon so that the end time will eventually come (i.e. it doesn't clip with passing by mountains
  
  //  Unassign stars. Commenting these lines out *should* force the stars to stay the same, rather than changing each night
  if (darkness < 180)
    assignedStars = false;
  
  // "Make darker/brighter" switch
  if (darkness >= 220)
    day = false;
  else if (darkness <= 2)
    day = true;
  
  // If the end times have come
  if (width + bloodMoon < 20)
  {
    fill(color(0, 0, 0, 250 + ((float)generator.nextGaussian())));
    rect(-1, -1, WINDOW_WIDTH, WINDOW_HEIGHT);
    fill(color(240, 110, 110, 250 + ((float)generator.nextGaussian())));
    textFont(myFont);
    text("Eternal night sunders the land", width / 2 - 260, height / 2 - 20, 520, 40);
  }
}