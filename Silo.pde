//class silo that uses the basic instances and methods of the city class but adds arguments and a method for missiles 

class Silo extends City{
  ///creates the missiles and keeps track of the missiles left
  Particle missile;
  int missile_counter;
  Silo(float x1, float y1, float x2, float y2){
    super(x1, y1, x2, y2);
    missile_counter=10;
  }
  
  //creating a new object for missile each time this function is called
  void shoot_missile(float x, float y, float velx, float vely, float m, float dx, float dy){
    if(missile_counter>0){
      missile=new Particle(x,y,velx,vely,m,dx,dy);
      missile_counter--;
    }
    else
      return;
  }
}
