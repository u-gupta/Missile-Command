class Silo extends City{
  Particle missile;
  int missile_counter;
  Silo(float x1, float y1, float x2, float y2){
    super(x1, y1, x2, y2);
    missile_counter=10;
  }
  void shoot_missile(float x, float y, float velx, float vely, float m, float dx, float dy){
    if(missile_counter>0){
      missile=new Particle(x,y,velx,vely,m,dx,dy);
      missile_counter--;
    }
    else
      return;
  }
}
