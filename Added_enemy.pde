// class for the satellite and bomber (or other possibble future enemies)
class Added_enemy{
  Particle bomb;
  int bomb_count;
  PVector enemy;
  float drop_location;
  boolean is_alive;
  boolean is_shot;
  int r;
  Added_enemy(float x, float y,int r, float drop){
    enemy=new PVector(x,y);
    bomb_count=(int)random(1,5);
    is_alive=true;
    this.r=r;
    drop_location=drop;
    is_shot=false;
  }
  
  ///checking if the enemy has reached the location its suppposed to drop its payload at
  boolean check_drop(){
    if((int)enemy.x<=(int)drop_location && bomb_count>0 && is_alive==true){
      drop_location=(float)random(enemy.x/2,enemy.x);
      return true;
    }
    else
      return false;  
  }
  
  //dropping the payload if the location has been reached
  boolean drop_bomb(float velx, float vely){
    if(check_drop()){
      bomb=new Particle(enemy.x,enemy.y,velx,vely,1);
      bomb_count--;
      return true;
    }
    return false;
  }
  
  //updating the enemy location to make it move each time its called
  void move(int w, float c){
    if(is_alive==true)
      enemy.x-=(float)(2*(float)(w+c)/8);
    if((enemy.x+r)<0)
      is_alive=false;
  }
  
  //checking if the enemy is colliding with anything (a missile or particle explosion)
  boolean check_collision(float cx, float cy, float cr){
    PVector explosion=new PVector(cx,cy);
    if(explosion.dist(enemy)<=((cr/2)+(r/2))){
      is_alive=false;
      is_shot=true;
    }
    return is_alive;
  }
  
  //drawing the enemy as a circle to keep collision detections simple
  void draw_enemy(){
    if(is_alive){
      fill(84,35,35);
      circle(enemy.x,enemy.y,r);
    }
  }
}
