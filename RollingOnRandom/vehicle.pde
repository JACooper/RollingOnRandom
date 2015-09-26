/*
  Jesse Cooper
  IGME 202.01
  "Rolling on Random" Homework
 */

class vehicle
{
  //  --  Instance Variables  --
  
  private float xCoord, yCoord;
  private PShape vehicleBody;
  private PShape vehicleBackWheel;
  private PShape vehicleChassis;
  private PShape vehicleHandle;
  PImage cart;
  PImage wheel;
  
  //  --  End of Instance Variables  --
  
  
  
  //  --  Constructors  --
  
  public vehicle(int x, int y)
  {
    xCoord = x;
    yCoord = y;
    
    cart = loadImage("Cart.png");
    vehicleChassis = createShape();
    vehicleChassis.beginShape();
      vehicleChassis.textureMode(NORMAL);
      vehicleChassis.texture(cart);
      vehicleChassis.vertex(0, 0, 0, 0);
      vehicleChassis.vertex(135, 0, 1, 0);
      vehicleChassis.vertex(130, 30, 1, 1);
      vehicleChassis.vertex(10, 30, 0, 1);
    vehicleChassis.endShape(CLOSE);
    vehicleChassis.setStroke(color(255, 255, 255, 0));
    
    
    vehicleHandle = createShape();
    vehicleHandle.beginShape();
      vehicleHandle.fill(color(197, 156, 109));
      vehicleHandle.vertex(130, 18);
      vehicleHandle.vertex(190, 15);
      vehicleHandle.vertex(190, 10);
      vehicleHandle.vertex(131, 12);
    vehicleHandle.endShape();
    vehicleHandle.setStroke(color(255, 255, 255, 0));
    
    
    wheel = loadImage("Wheel.png");
    //vehicleBackWheel = createShape(ELLIPSE, 66.5, 29, 35, 35, CENTER);    // Invalid in Processing 3
    ellipseMode(CENTER);
    vehicleBackWheel = createShape(ELLIPSE, 66.5, 29, 35, 35);
    vehicleBackWheel.setFill(color(0, 0, 0));
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
    
    public PShape getVehicleBody()
    { return vehicleBody; }
    
    public PShape getBackVehicleWheel()
    { return vehicleBackWheel; }
    
    //  --  End of Accessor/Mutator Methods  --
  
    //  --  Display Methods  --
    
    public void displayVehicleRotated(float whlRot, float rotAngle)
    {
      pushMatrix();
        translate(xCoord + 65, yCoord + 32.5);
        rotate(rotAngle);
        translate(-65, -32.5);
        shape(vehicleBackWheel);
        shape(vehicleHandle);
        shape(vehicleChassis);
        pushMatrix();
          translate(65,29.6);
          rotate(radians(whlRot));
          imageMode(CENTER);
          image(wheel, 0, 0);
        popMatrix();
      popMatrix(); 
    }
    
    //  --  End of Display Methods  --
  
  //  --  End of Methods  --
  
  
}// End of vehicle