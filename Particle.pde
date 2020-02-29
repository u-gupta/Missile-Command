class Particle{
  
  public PVector velocity, position, acceleration;
  public static final float drag=0.99995f;
  boolean dead;
  float destx,desty;
  float invMass;
  Particle(float x, float y, float vel1, float vel2, float m){
    velocity = new PVector(vel1, vel2);
    position = new PVector(x, y);
    acceleration= new PVector();
    invMass=m;
    dead=false;
  }
  Particle(float x, float y, float vel1, float vel2, float m, float dx, float dy){
    velocity = new PVector(vel1, vel2);
    position = new PVector(x, y);
    acceleration= new PVector();
    invMass=m;
    destx=dx;
    desty=dy;
  }
  void integrate(PVector force) {
    if (invMass <= 0f) return ;
    
    position.add(velocity) ;
    
    acceleration.add(force) ;
    acceleration.mult(invMass) ;
    if(velocity.mag()<2)
    velocity.add(acceleration) ;
    velocity.mult(drag);
    if ((position.x < 0) || (position.x > width)) velocity.x = -velocity.x*0.9 ;
    if (position.y > height-5) {velocity.y = 0 ; velocity.x = 0;}
  }
  boolean particle_dead(){
    if (position.y > height-5) 
       dead= true;
    return dead;
    }
  boolean particle_dead(float cx, float cy, int r){
    PVector circle=new PVector(cx,cy);
    if(circle.dist(position)<=r/2)
      dead=true;
    return dead;
  }
  boolean missile_hit(float mouse_x, float mouse_y){
      if(position.x==mouse_x&&position.y==mouse_y)
        return true;
      return false;
  }
  boolean detonate(){
    if((int)position.y<=(int)desty)
      return true;
    return false;
  }
}
