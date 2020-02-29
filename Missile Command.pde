int wave;
Particle p[];
PVector g;
float scrHeight;
int counter, rcounter;
City cities[];
float distance;
float altitude;
float velx;
int numb;
int c;
boolean city_dead[];
boolean particle_dead[];
int score;
int particle_count;
Silo s[];
boolean silo_dead[];
Particle missiles[];
int active_missile_counter;
int detonation_counter[];
int detonation_counter_temp[];
int detonation_updater[];
int explosion_counter[];
int explosion_counter_temp[];
int explosion_updater[];
int dead_missiles;
boolean start;
boolean reset;
int extra_particles;
int splitting_particles;
int[] child_particles;
boolean[] is_splitable;
boolean is_killable[];
int immortality_timer[];
boolean explosion_flag[];
Added_enemy bomber;
Added_enemy satellite;
int enemy_counter;
boolean bomber_is_alive;
boolean satellite_is_alive;
int smart_bomb;
boolean smart_bomb_activated;
float smart_bomber_originalvelx,smart_bomber_originalvely;
float smart_timer;
boolean frame;
void setup(){
  // frameRate(30);
  size(800,600);
  noCursor();
  reset=false;
  start();
  enemy_counter=0;
  bomber_is_alive=false;
  satellite_is_alive=false;
  smart_timer=1;
}
void draw(){
  frame=true;
  //System.out.println("new frame");
  if(start==true){
    if(c==3){
    background(130,205,255);
    c=0;}
    c++;
    textAlign(LEFT);
    fill(0);
    text("Score: "+score,10,10);
    fill(0);
    text("Wave: "+wave,(width/2)-20,10);
    for(int i=0;i<particle_dead.length;i++)
      if(particle_dead[i]==false)
        particle_count++;
    text("Particles left: "+ particle_count,width-100,10);
    crosshair();
    for(int i=0;i<p.length;i++){
      remove_particles();
      explosion_flag[i]=false;
      PVector position = p[i].position;
      if(particle_dead[i]==false){
        p[i].integrate(g);
        fill(2) ;
        rect(position.x, position.y, 2, 2);
      }
      add_cities(position.x,position.y);
      draw_silos(position.x,position.y);
    }
    if(wave>1 && enemy_counter==0){
      add_bomber();
      add_satellite();
      enemy_counter++;
    }
    if(wave>1){
      handle_bomber();
      handle_satellite();
    }
    check_wave();
    particle_count=0;
    shoot_missile();
  }
  if(start==false){
    background(130,205,255);
    crosshair();
    textSize(43);
    textAlign(CENTER);
    fill(38,81,125);
    text("Particle Command",width/2,(height/2)-10);
    textSize(12);
    text("Press Spacebar to Continue!",width/2,(height/2)+10);
    
    if(keyPressed==true && key== ' ')
      start=true;
  }
}
void add_bomber(){
  bomber=new Added_enemy((float)random(width+50,width+250+(200*wave)),(float)height/2,40, (float)random(width/2,width));
  bomber.draw_enemy();
  bomber_is_alive=bomber.is_alive;
}
void add_satellite(){
  satellite=new Added_enemy((float)random(width+100,width+250+(200*wave)),(float)height/4,30, (float)random(width/2,width));
  satellite.draw_enemy();
  satellite_is_alive=satellite.is_alive;
}

void handle_bomber(){
  bomber.move(wave,0);
  bomber.draw_enemy();
  float velx;
  float vely;
  int target=(int)random(0,5);
  switch(target){
    case 0:velx=(2*distance+distance/192f);break;
    case 1:velx=(3.1*distance+distance/192f);break;
    case 2:velx=(4.2*distance+distance/192f);break;
    case 3:velx=(6.3*distance+distance/192f);break;
    case 4:velx=(7.4*distance+distance/192f);break;
    case 5:velx=(8.5*distance+distance/192f);break;  
    default: velx=0;
  }
  velx=(velx+((distance/4f)-(distance/96f)-bomber.enemy.x))/(280+(abs(bomber.enemy.y)/30));
  vely=2+(float)wave/32;
  if(bomber.drop_bomb(velx,vely)){
    int original_length=p.length;
    Particle temp[]=p;
    boolean tparticle_dead[]=particle_dead, tis_splitable[]=is_splitable, tis_killable[]=is_killable,texplosion_flag[]=explosion_flag;
    int texplosion_counter[]=explosion_counter, texplosion_counter_temp[]=explosion_counter_temp, texplosion_updater[]=explosion_updater, timmortality_timer[]=immortality_timer;
    p=new Particle[original_length+1];
    particle_dead=new boolean[p.length];
    explosion_counter=new int[p.length];
    explosion_counter_temp=new int[p.length];
    explosion_updater=new int[p.length];
    is_splitable=new boolean[p.length];
    immortality_timer=new int[p.length];
    is_killable=new boolean[p.length];
    explosion_flag=new boolean[p.length];
    for(int i=0;i<original_length;i++){
      is_killable[i]=tis_killable[i];
      immortality_timer[i]=timmortality_timer[i];
      particle_dead[i]=tparticle_dead[i];
      explosion_counter[i]=texplosion_counter[i];
      explosion_counter_temp[i]=texplosion_counter_temp[i];
      explosion_updater[i]=texplosion_updater[i];
      explosion_flag[i]=texplosion_flag[i];
      p[i]=temp[i];
      is_splitable[i]=tis_splitable[i];
    }
    explosion_counter[p.length-1]=1;
    explosion_counter_temp[p.length-1]=1;
    explosion_updater[p.length-1]=1;
    particle_dead[p.length-1]=false;
    is_splitable[p.length-1]=false;
    immortality_timer[p.length-1]=0;
    p[p.length-1]=bomber.bomb;
    is_killable[p.length-1]=true;
  }
}
void handle_satellite(){
  satellite.move(wave,0.5);
  satellite.draw_enemy();
  float velx;
  float vely;
  int target=(int)random(0,5);
  switch(target){
    case 0:velx=(2*distance+distance/192f);break;
    case 1:velx=(3.1*distance+distance/192f);break;
    case 2:velx=(4.2*distance+distance/192f);break;
    case 3:velx=(6.3*distance+distance/192f);break;
    case 4:velx=(7.4*distance+distance/192f);break;
    case 5:velx=(8.5*distance+distance/192f);break;  
    default: velx=0;
  }
  velx=(velx+((distance/4f)-(distance/96f)-satellite.enemy.x))/(280+(abs(satellite.enemy.y)/30));
  vely=2+(float)wave/32;
  if(satellite.drop_bomb(velx,vely)){
    int original_length=p.length;
    Particle temp[]=p;
    boolean tparticle_dead[]=particle_dead, tis_splitable[]=is_splitable, tis_killable[]=is_killable,texplosion_flag[]=explosion_flag;
    int texplosion_counter[]=explosion_counter, texplosion_counter_temp[]=explosion_counter_temp, texplosion_updater[]=explosion_updater, timmortality_timer[]=immortality_timer;
    p=new Particle[original_length+1];
    particle_dead=new boolean[p.length];
    explosion_counter=new int[p.length];
    explosion_counter_temp=new int[p.length];
    explosion_updater=new int[p.length];
    is_splitable=new boolean[p.length];
    immortality_timer=new int[p.length];
    is_killable=new boolean[p.length];
    explosion_flag=new boolean[p.length];
    for(int i=0;i<original_length;i++){
      is_killable[i]=tis_killable[i];
      immortality_timer[i]=timmortality_timer[i];
      particle_dead[i]=tparticle_dead[i];
      explosion_counter[i]=texplosion_counter[i];
      explosion_counter_temp[i]=texplosion_counter_temp[i];
      explosion_updater[i]=texplosion_updater[i];
      explosion_flag[i]=texplosion_flag[i];
      p[i]=temp[i];
      is_splitable[i]=tis_splitable[i];
    }
    explosion_counter[p.length-1]=1;
    explosion_counter_temp[p.length-1]=1;
    explosion_updater[p.length-1]=1;
    particle_dead[p.length-1]=false;
    is_splitable[p.length-1]=false;
    immortality_timer[p.length-1]=0;
    p[p.length-1]=satellite.bomb;
    is_killable[p.length-1]=true;
  }  
}
void crosshair(){
  stroke(0);
  line(mouseX-6,mouseY-6,mouseX-2,mouseY-2);
  line(mouseX+6,mouseY+6,mouseX+2,mouseY+2);
  line(mouseX+6,mouseY-6,mouseX+2,mouseY-2);
  line(mouseX-6,mouseY+6,mouseX-2,mouseY+2);
  noStroke();
  fill(255,0,0);
  circle(mouseX,mouseY,1);
}
void check_wave(){
    if(check_wave_condition()==1){
      for(int i=0;i<city_dead.length;i++)
        if(city_dead[i]==false)
          score+=(100*((wave+1)/2));
        score+=((30-active_missile_counter)*5*((wave+1)/2));
      //System.out.println("Score: "+score);
      if(score>=10000){
        for(int i=0;i<city_dead.length;i++)
          if(city_dead[i] && score >=10000){
            city_dead[i]=false;
            score-=10000;
          }
      }
      enemy_counter=0;
      add_particles();
      if(wave>5){
        smart_bomb_activated=false;
        smart_bomb=(int)random(0,p.length);
      }
      add_silos();
      active_missile_counter=0;
      for(int i=0;i<detonation_counter.length;i++)
        detonation_counter[i]=detonation_counter_temp[i]=detonation_updater[i]=1;
      for(int i=0;i<missiles.length;i++)
        missiles[i]=null;
    }
    if(check_wave_condition()==2){
      fill(30,64,99);
      textAlign(CENTER);
      textSize(23);
      text("You Lose!",width/2,(height/2)-45);
      text("Wave:"+wave,width/2,height/2-20);
      text("Score:"+score,width/2,height/2+5);
      textSize(12);
      text("Press Spacebar to Try Again.",width/2, (height/2)+30);
      if(keyPressed==true && key==' '){
          reset=true;
          start();
      }
    }
}
void start(){
  start=reset;
  score=0;
  c=0;
  distance=width/11f;
  altitude=height;
  wave=0;
  extra_particles=0;
  add_particles();
  cities=new City[6];
  city_dead= new boolean[cities.length];
  for(int i=0;i<city_dead.length;i++){
    city_dead[i]=false;
  }
  s=new Silo[3];
  silo_dead=new boolean[3];
  missiles=new Particle[31];
  active_missile_counter=0;
  scrHeight=(float)height/18000000f;
  g=new PVector(0 ,9.8*scrHeight);
  detonation_counter= new int[30];
  detonation_updater= new int[30];
  detonation_counter_temp= new int[30];
  for(int i=0;i<30;i++){
   detonation_counter[i]=1;
   detonation_counter_temp[i]=1;
   detonation_updater[i]=1;}
  add_silos();
  dead_missiles=0;
}
void shoot_missile(){
  int i=0;
  while(missiles[i]!=null){
    if(active_missile_counter!=31){
      PVector position=missiles[i].position;
      missiles[i].integrate(g);
      if(wave>5){
        if(particle_dead[smart_bomb]==false){
          //System.out.println("smart bomb="+smart_bomb);
          float tvelx=p[smart_bomb].velocity.x, tvely=p[smart_bomb].velocity.y;
          System.out.println("before updating : velx="+tvelx+"vely="+tvely);
          if(missiles[i].desty - missiles[i].position.y <= 50 && abs(missiles[i].destx - missiles[i].position.x) <= 50 && (missiles[i].detonate()!=true || (missiles[i].detonate()==true && detonation_counter[i]>0)) || smart_bomb_activated==true){
            //System.out.println("before updating : y dist="+(missiles[i].position.y - p[smart_bomb].position.y)+"x dist="+ (tvelx>0) +" "+ (missiles[i].position.x - p[smart_bomb].position.x)+"or "+ (tvelx<0) +" " + (p[smart_bomb].position.x - missiles[i].position.x ));
            //System.out.println("before updating : y= "+p[smart_bomb].position.y+"x dist="+ (tvelx>0) +" "+ p[smart_bomb].position.x+"or "+ (tvelx<0) +" " + missiles[i].position.x );
            if(missiles[i].position.y - p[smart_bomb].position.y <= 50 
            && smart_bomb_activated==false 
            && ((tvelx>0 && missiles[i].position.x - p[smart_bomb].position.x <= 50)||(tvelx<0 && p[smart_bomb].position.x - missiles[i].position.x  <= 50))){
              smart_bomber_originalvelx=tvelx;
              smart_bomber_originalvely=tvely;
              p[smart_bomb].velocity=new PVector(tvelx*2,tvely*2);
              p[smart_bomb].invMass=1;
              smart_bomb_activated=true;
              smart_timer=160;
              //System.out.println("after updating 1 : velx="+p[smart_bomb].velocity.x+"vely="+p[smart_bomb].velocity.y);
            }
            else if(missiles[i].position.y - p[smart_bomb].position.y <= 150 
            && missiles[i].position.y - p[smart_bomb].position.y >= 50 
            && smart_bomb_activated==false 
            && ((tvelx>0 && missiles[i].position.x - p[smart_bomb].position.x <= 50)
            ||(tvelx<0    && p[smart_bomb].position.x - missiles[i].position.x  <= 50))){
              smart_bomber_originalvelx=tvelx;
              smart_bomber_originalvely=tvely;
              p[smart_bomb].velocity=new PVector(tvelx/8 ,tvely/8  );
              p[smart_bomb].invMass=0.25 ;
              smart_bomb_activated=true;
              smart_timer=160;
              //System.out.println("after updating 2 : velx="+p[smart_bomb].velocity.x+"vely="+p[smart_bomb].velocity.y);
            }
            else if(smart_timer <= 1 && smart_bomb_activated==true && missiles[i].position.y - p[smart_bomb].position.y < 0 
            || ((tvelx > 0 && missiles[i].position.x - p[smart_bomb].position.x < -50)
            ||(tvelx < 0 && p[smart_bomb].position.x - missiles[i].position.x  < - 50))  ){
              if(smart_timer<=1){
                p[smart_bomb].velocity=new PVector(smart_bomber_originalvelx , smart_bomber_originalvely);
                p[smart_bomb].invMass=1;
                //System.out.println("after updating 3 : velx="+p[smart_bomb].velocity.x+"vely="+p[smart_bomb].velocity.y + " timer"+smart_timer);
                smart_bomb_activated=false;
                }
            }
            else{
              p[smart_bomb].velocity=new PVector(tvelx,tvely);
              if(frame==true){
                smart_timer--;
                frame=false;  
              }
              //System.out.println("after updating 4 : velx="+p[smart_bomb].velocity.x+"vely="+p[smart_bomb].velocity.y + " timer"+smart_timer);
            }
          
            //System.out.println("after updating : y dist="+(missiles[i].position.y - p[smart_bomb].position.y)+"x dist="+ (tvelx>0) +" "+ (missiles[i].position.x - p[smart_bomb].position.x)+"or "+ (tvelx<0) +" " + (p[smart_bomb].position.x - missiles[i].position.x ));
          }              
        }
      }
      if(missiles[i].detonate()){
        noStroke();
        fill(255,243,166);
        circle(missiles[i].destx,missiles[i].desty,detonation_counter[i]);
        if(detonation_counter_temp[i]<40 && detonation_counter[i]>0)
          detonation_counter[i]+=detonation_updater[i];
        detonation_counter_temp[i]+=detonation_updater[i];
        if(abs(detonation_counter_temp[i])==80)
          detonation_updater[i]*=(-1);
        if(wave>1){
          boolean tempa = bomber_is_alive, tempb = satellite_is_alive;
          bomber_is_alive=bomber.check_collision(missiles[i].destx,missiles[i].desty,detonation_counter[i]);
          satellite_is_alive=satellite.check_collision(missiles[i].destx,missiles[i].desty,detonation_counter[i]);
          if(bomber_is_alive==false && tempa==true)
            score+= (100*((wave+1)/2));
          if(satellite_is_alive==false && tempb==true)
            score+= (100*((wave+1)/2));
        }
        for(int j=0;j<p.length;j++){
          //System.out.println("starting shoot loop "+j);
          boolean ptemp=particle_dead[j];
          if(is_killable[j])
            particle_dead[j]=p[j].particle_dead(missiles[i].destx,missiles[i].desty,detonation_counter[i]);
          else if(immortality_timer[j]==0){is_killable[j]=true;}
          else if(immortality_timer[j]>0) {immortality_timer[j]--;}
          if(particle_dead[j]==true && ptemp!=true) 
            score+= (25*((wave+1)/2));
          if(((particle_dead[j]==true && ptemp!=true) || explosion_counter[j]!=1)&& explosion_flag[j]==false){
            explosion_flag[j]=true;
            //System.out.println("Calling explode from shoot missile for "+j+" counter:"+ explosion_counter[j]);
            explode_particle(j);
            //System.out.println("out of explode");
            if(is_splitable[j]){
              is_splitable[j]=false;
              //System.out.println("Splitting! from missile "+detonation_counter[i]);
              split(p[j],0);
            }
          }
          
        }
      }
      else{
        fill(255,10,100);
        rect(position.x,position.y,3,2);
      }
      i++;
    }
    else
    return;
  }
}
void explode_particle(int index){
  //System.out.println("on explosion:"+p[index].position.x+" "+p[index].position.y+" "+explosion_counter[index]+"state"+particle_dead[index]);
  noStroke();
  fill(255,243,166);
  circle(p[index].position.x,p[index].position.y,explosion_counter[index]);
  if(explosion_counter_temp[index]<40 && explosion_counter[index]>0)
    explosion_counter[index]+=explosion_updater[index];
    explosion_counter_temp[index]+=explosion_updater[index];
  if(abs(explosion_counter_temp[index])==80)
    explosion_updater[index]*=(-1);
  if(wave>1){
    boolean tempa = bomber_is_alive, tempb = satellite_is_alive;
    bomber_is_alive=bomber.check_collision(p[index].position.x,p[index].position.y,explosion_counter[index]);
    satellite_is_alive=satellite.check_collision(p[index].position.x,p[index].position.y,explosion_counter[index]);
    if(bomber_is_alive==false && tempa==true)
      score+= (100*((wave+1)/2));
    if(satellite_is_alive==false && tempb==true)
      score+= (100*((wave+1)/2));
  }
  for(int i=0;i<p.length;i++){
    boolean ptemp=particle_dead[i];
    if(is_killable[i])
      particle_dead[i]=p[i].particle_dead(p[index].position.x,p[index].position.y,explosion_counter[index]);
    else if(immortality_timer[i]==0){is_killable[i]=true;}
    else if(immortality_timer[i]>0) {immortality_timer[i]--;}
    if((particle_dead[i]==true && ptemp!=true)){
      score+= (25*((wave+1)/2));
      //System.out.println("calling itself");
      explode_particle(i);
      if(is_splitable[i]){
        is_splitable[i]=false;
        //System.out.println("Splitting! from explode "+explosion_counter[index]);
        split(p[i],1);
      }
    }
  }
}
void split(Particle parent,int check){
  System.out.println("Splitting at:");
  int no_of_children=(int)random(2,5);
  int original_length=p.length;
  Particle temp[]=p;
  boolean tparticle_dead[]=particle_dead, tis_splitable[]=is_splitable, tis_killable[]=is_killable,texplosion_flag[]=explosion_flag;
  int texplosion_counter[]=explosion_counter, texplosion_counter_temp[]=explosion_counter_temp, texplosion_updater[]=explosion_updater, timmortality_timer[]=immortality_timer;
  p=new Particle[original_length+no_of_children];
  particle_dead=new boolean[p.length];
  explosion_counter=new int[p.length];
  explosion_counter_temp=new int[p.length];
  explosion_updater=new int[p.length];
  is_splitable=new boolean[p.length];
  immortality_timer=new int[p.length];
  is_killable=new boolean[p.length];
  explosion_flag=new boolean[p.length];
  for(int i=0;i<original_length;i++){
    is_killable[i]=tis_killable[i];
    immortality_timer[i]=timmortality_timer[i];
    particle_dead[i]=tparticle_dead[i];
    explosion_counter[i]=texplosion_counter[i];
    explosion_counter_temp[i]=texplosion_counter_temp[i];
    explosion_updater[i]=texplosion_updater[i];
    explosion_flag[i]=texplosion_flag[i];
    p[i]=temp[i];
    is_splitable[i]=tis_splitable[i];
  }
  for(int i=original_length;i<p.length;i++){
    explosion_counter[i]=1;
    explosion_counter_temp[i]=1;
    explosion_updater[i]=1;
    particle_dead[i]=false;
    is_splitable[i]=false;
    int target=(int)random(0,6);
    switch(target){
    case 0:velx=(2*distance+distance/192f);break;
    case 1:velx=(3.1*distance+distance/192f);break;
    case 2:velx=(4.2*distance+distance/192f);break;
    case 3:velx=(6.3*distance+distance/192f);break;
    case 4:velx=(7.4*distance+distance/192f);break;
    case 5:velx=(8.5*distance+distance/192f);break;
    }
    fill(0);
    velx=(velx+((distance/4f)-(distance/96f)-parent.position.x))/(280+(abs(parent.position.y)/30));
    p[i]=new Particle(parent.position.x,parent.position.y,velx,2+(float)wave/32,1);
    if(check==0)
      immortality_timer[i]=160;
    else
      immortality_timer[i]=320;
    is_killable[i]=false;
    //System.out.println("escaping split "+parent.position.x+" "+parent.position.y+30);
  }
}
void remove_particles(){
  for(int i=0;i<p.length;i++)
    particle_dead[i]=p[i].particle_dead();
}
void add_particles(){
  p= new Particle[10+(wave++*5)];
  is_killable=new boolean[p.length];
  immortality_timer=new int[p.length];
  is_splitable=new boolean[p.length];
  explosion_flag=new boolean[p.length];
  for(int i=0;i<p.length;i++)
    is_splitable[i]=false;
  if(wave>=2){
    splitting_particles=wave*2;
    for(int i=0;i<splitting_particles;i++){
      int split_random=(int)random(0,p.length);
      if(is_splitable[split_random]==true)
        i--;
      else
        is_splitable[split_random]=true;
    }
  }
  particle_dead=new boolean[p.length];
  explosion_counter=new int[p.length];
  explosion_counter_temp=new int[p.length];
  explosion_updater=new int[p.length];
  for(int i=0;i<p.length;i++){
    is_killable[i]=true;
    immortality_timer[i]=0;
    explosion_counter[i]=1;
    explosion_counter_temp[i]=1;
    explosion_updater[i]=1;
    explosion_flag[i]=false;
    particle_dead[i]=false;
    int location= (int)random(0,width);
    int start_height=(int)random(-(p.length*100),0);
    int target=6*location/800;
    switch(target){
    case 0:velx=(2*distance+distance/192f);break;
    case 1:velx=(3.1*distance+distance/192f);break;
    case 2:velx=(4.2*distance+distance/192f);break;
    case 3:velx=(6.3*distance+distance/192f);break;
    case 4:velx=(7.4*distance+distance/192f);break;
    case 5:velx=(8.5*distance+distance/192f);break;
    }
    fill(0);
    velx=(velx+((distance/4f)-(distance/96f)-location))/(280+(abs(start_height)/30));
    //System.out.println("Target:"+ target+ " Velx:"+ velx+" Location:"+location+" Start_Height:"+start_height);
    p[i]=new Particle(location,start_height,velx,2+(float)wave/32,1);
  }
}
void add_cities(float particleX,float particleY){
  float dimensions[]= new float[4];
  for(int i=0;i<cities.length;i++){
    switch(i){
      case 0:{
        fill(0);
        dimensions[0]=2*distance+(distance/192f);
        dimensions[1]=altitude-5;
        dimensions[2]=(distance/2f)-(distance/96f);
        dimensions[3]= altitude/80f;
      }break;
      case 1:{
        fill(0);
        dimensions[0]=(3.1*distance)+(distance/192f);
        dimensions[1]=altitude-5;
        dimensions[2]=(distance/2f)-(distance/96f);
        dimensions[3]=altitude/80f;
      }break;
      case 2:{
        fill(0);
        dimensions[0]=(4.2*distance)+(distance/192f);
        dimensions[1]=altitude-5;
        dimensions[2]=(distance/2f)-(distance/96f);
        dimensions[3]=altitude/80f;
      }break;
      case 3:{
        fill(0);
        dimensions[0]=(6.3*distance)+(distance/192f);
        dimensions[1]=altitude-5;
        dimensions[2]=(distance/2f)-(distance/96f);
        dimensions[3]=altitude/80f;
      }break;
      case 4:{
        fill(0);
        dimensions[0]=(7.4*distance)+(distance/192f);
        dimensions[1]=altitude-13;
        dimensions[2]=(distance/2f)-(distance/96f);
        dimensions[3]=altitude/40f;
      }break;
      case 5:{
        fill(0);
        dimensions[0]=(8.5*distance)+(distance/192f);
        dimensions[1]=altitude-5;
        dimensions[2]=(distance/2f)-(distance/96f);
        dimensions[3]=altitude/80f;
      }break;
    }
    cities[i]=new City(dimensions[0],dimensions[1],(dimensions[0]+dimensions[2]),(dimensions[1]+dimensions[3]));
    if(cities[i].isAlive(particleX,particleY)&&city_dead[i]==false){
      noStroke();
      fill(133,133,133);
    }
    else{
      noStroke();
      fill(123,0,0);
      city_dead[i]=true;
    }
    rect(dimensions[0],dimensions[1],dimensions[2],dimensions[3]);
  }
}
int check_wave_condition(){
  for(int j=0;j<city_dead.length;j++)
    if(city_dead[j]==false){
      for(int i=0;i<particle_dead.length;i++)
        if(particle_dead[i]==false || bomber_is_alive==true || satellite_is_alive==true)
          return 0;
      return 1;}
  return 2;
  
}
void add_silos(){
  dead_missiles=0;
  float dimensions[]= new float[4];
  for(int i=0;i<s.length;i++){
    silo_dead[i]=false;
    switch(i){
      case 0: {
        dimensions[0]=0.5*distance+(distance/192f);
        dimensions[1]=altitude-25;
        dimensions[2]=(distance)-(distance/96f);
        dimensions[3]= altitude/20f;
      }break;
      case 1: {
        dimensions[0]=5*distance+(distance/192f);
        dimensions[1]=altitude-25;
        dimensions[2]=(distance)-(distance/96f);
        dimensions[3]= altitude/20f;
      }break;
      case 2: {
        dimensions[0]=9.4*distance+(distance/192f);
        dimensions[1]=altitude-25;
        dimensions[2]=(distance)-(distance/96f);
        dimensions[3]= altitude/20f;
      }break;
    }
    s[i]=new Silo(dimensions[0],dimensions[1],dimensions[0]+dimensions[2],dimensions[1]+dimensions[3]);
  }
}
void draw_silos(float px,float py){
  for(int i=0;i<s.length;i++){
    if(s[i].isAlive(px,py) && silo_dead[i]==false){
      noStroke();
      fill(58,74,44);
      rect(s[i].x1,s[i].y1,s[i].x2-s[i].x1,s[i].y2-s[i].y1);
    }
    else{
      noStroke();
      fill(94,44,29);
      rect(s[i].x1,s[i].y1,s[i].x2-s[i].x1,s[i].y2-s[i].y1);
      silo_dead[i]=true;
      if(s[i].missile_counter!=0)
        dead_missiles=s[i].missile_counter;
      s[i].missile_counter=0;
    }
    textAlign(CENTER);
    fill(255);
    text(s[i].missile_counter,((s[i].x1+s[i].x2)/2),(s[i].y1+s[i].y2)/2);
  }
}

void mousePressed(){
  if(active_missile_counter+dead_missiles<30 && check_wave_condition()!=2 && start==true && s[0].missile_counter+s[1].missile_counter+s[2].missile_counter >0 ){
    //System.out.println("on mouse click:"+active_missile_counter+dead_missiles);
    float mtargetx=mouseX;
    float mtargety=(600-mouseY);
    int origin=3*(int)(mtargetx-2)/800;
    shoot(origin, mtargetx, mtargety);
  }
}
void keyPressed(){
  if((keyCode == UP ||keyCode == RIGHT ||keyCode == LEFT) && start==true ){
    if(active_missile_counter+dead_missiles<30 && check_wave_condition()!=2){
      //System.out.println("on key press"+active_missile_counter+dead_missiles);
      float mtargetx=mouseX;
      float mtargety=(600-mouseY);
      int origin;
      if(keyCode == UP) origin = 1;
      else if(keyCode == RIGHT) origin = 2;
      else origin = 0;
      shoot(origin, mtargetx, mtargety);
    }
  }
}
void shoot(int origin, float mtargetx, float mtargety){
      if(s[origin].missile_counter==0){
        switch(origin){
        case 0:{if(s[1].missile_counter!=0) origin=1; else if(s[2].missile_counter!=0) origin=2; }break;
        case 1:{ origin= (int)mtargetx/400; if(origin==1) origin=2; if(s[0].missile_counter==0) origin=2; else if(s[2].missile_counter==0) origin=0;}break;
        case 2:{if(s[1].missile_counter!=0) origin=1; else if(s[0].missile_counter!=0) origin=0; }break;
        }
      }
      //System.out.println("on shooting"+mtargetx+" "+origin);
      //System.out.println("on shooting 2"+mtargetx+" "+origin+" "+(s[origin].x1+s[origin].x2)/2+" "+s[origin].y1);
      if(origin==1)
        s[origin].shoot_missile((s[origin].x1+s[origin].x2)/2,s[origin].y1,(mtargetx-((s[origin].x1+s[origin].x2)/2))/23,-mtargety/23,1,mouseX,mouseY);
      else
        s[origin].shoot_missile((s[origin].x1+s[origin].x2)/2,s[origin].y1,(mtargetx-((s[origin].x1+s[origin].x2)/2))/28,-mtargety/29,1,mouseX,mouseY);
      missiles[active_missile_counter++]=s[origin].missile;

}
