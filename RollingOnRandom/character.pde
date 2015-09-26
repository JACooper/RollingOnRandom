/*
  Jesse Cooper
  IGME 202.01
  "Rolling on Random" Homework
 */

class character
{
  //  --  Instance Variables  --
  
  private float xCoord, yCoord;
  private PShape characterBody;
  private PShape characterForeLeg;
  private PShape characterBackLeg;
  private PShape characterForeArm;
  private PShape characterBackArm;
  PImage characterFace;
  int CHARACTER_TOTAL_HEIGHT;
  int CHARACTER_BODY_HEIGHT;
  
  //  --  End of Instance Variables  --
  
  
  
  //  --  Constructors  --
  
  public character(int x, int y)
  {
    xCoord = x;
    yCoord = y;
    
    stroke(90);
    characterBody = createShape(LINE, 0, 0, 0, 25);
    
    characterFace = loadImage("Head.png"); 
    
    stroke(170);
    characterForeLeg = createShape(LINE, 0, 0, 0, 26);
    characterBackLeg = createShape(LINE, 0, 0, 0, 26);
    
    characterForeArm = createShape(LINE, 0, 16, 20, 20);
    characterBackArm = createShape(LINE, 0, 16, 17, 18);
    
    CHARACTER_TOTAL_HEIGHT = 33;
    CHARACTER_BODY_HEIGHT = 25;
  }
  
  //  --  End of Constructors  --
  
  
  
  //  --  Methods  --
  
    //  --  Accessor/Mutator Methods  --  UNUSED
    
    public float getX()
    { return xCoord; }
    
    public void setX(float n)
    {
      if (n >= 0)
        xCoord = n; 
    }
    
    public float getY()
    { return yCoord; }
    
    public void setY(float n)
    {
      if (n >= 0)
        yCoord = n; 
    }
    
    public PShape getCharacterBody()
    { return characterBody; }
    
    //public PShape getCharacterHead()
    //{ return characterHead; }
    
    public PShape getCharacterForeLeg()
    { return characterForeLeg; }
    
    public PShape getCharacterBackLeg()
    { return characterBackLeg; }
    
    //  --  End of Accessor/Mutator Methods  --
  
    //  --  Display Methods  --
    
    public void walkCharacterLegsRotatedAlt(float headRotation, float bodyRotationAngle, int foreRotationAngle, int backRotationAngle)
    {
      pushMatrix();
        translate(xCoord, yCoord);
        rotate(bodyRotationAngle);
        shape(characterBody);
        translate(0, CHARACTER_BODY_HEIGHT - CHARACTER_TOTAL_HEIGHT);
        rotate(radians(-headRotation));
        imageMode(CENTER);
        image(characterFace, 0, 0);
        rotate(radians(headRotation));
        shape(characterForeArm);
        shape(characterBackArm);
        translate(0, CHARACTER_TOTAL_HEIGHT);
        pushMatrix();
          rotate(radians(backRotationAngle));
          shape(characterBackLeg);
        popMatrix();
        pushMatrix();
          rotate(radians(foreRotationAngle));
          shape(characterForeLeg);
        popMatrix();
      popMatrix(); 
    }
    
    //  --  End of Display Methods  --
  
  //  --  End of Methods  --
  
  
}// End of vehicle