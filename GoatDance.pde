import papaya.Mat;

// for video export
//import com.hamoid.*;
//VideoExport videoExport;

// variables for the sound processing -----------------------------



PShape goat_shape, temps, sbackup ;
float fheight;
float fwidth;
boolean unlocked         = false;
boolean show_goat        = false;
boolean show_one         = true;
boolean show_all_spheres = false;
boolean video = false;
PVector pos = new PVector(0,0,0);
long seedpara;
int back =1;
float [][][] origoat;
//
// corners geometry ------------------------------
float[] corner_rub = new float[3];
float[] corner_lub = new float[3];
float[] corner_rlb = new float[3];
float[] corner_llb = new float[3];
//
float[] corner_ruf = new float[3];
float[] corner_luf = new float[3];
float[] corner_rlf = new float[3];
float[] corner_llf = new float[3];
//
float depth   = -1000;
float time    = 0;
float delta_t = 0.002;
//

float normtemps;

float dt = 0.5;
float[][][] velocity;

float[] center = {fwidth/2 , fheight/2 };
// -------------------------------------------------------------------------------

// factors that can be controlled by the keyboard -----------
// they are multiplied to the sound numbers and control the physical parameters
//     0: , 1: size , 2: damping, 3: magnusfak, 4: drag 
float[] factors     = {0.05, 0.05 , 0.008743586 }; // Mat.constant(1.0,5);
float stereo_fac    = 0.002;
// scaling of all factors by multiplication of the superfac or (2-supberfac)
float superfac      = 0.9 ; 
boolean log_on      = false;
float clickstart    = 2.5;
//
int N_triangles;

Sound_Processing Sound = new Sound_Processing();

void setup() {
  //size(1000, 1000, P3D);
  fullScreen(P3D,2);//, SPAN);
  // The file "bot.obj" must be in the data folder
  // of the current sketch to load successfully
  goat_shape = loadShape("Standing_Goat.obj");
  //s = loadShape("Happy_Goat.obj");
  goat_shape.rotateX(PI);
  goat_shape.scale(70);
  //
  fheight = float(height);
  fwidth = float(width);
  println(fheight);
  println(fwidth);
  //sbackup = copyShape(s);
  //
  goat_shape.translate(0,fheight/3);
  goat_shape.rotateY(PI/1.4);
  
  N_triangles = goat_shape.getChildCount();
  // not shure how to use push Matrix
  // pushMatrix();
  
  getGoat();
  
  stroke(255);
  
  background(0);
  
} // END SETUP ------------------------------------------------------------------
//
// DRAW -------------------------------------------------------------------------
void draw() {
  lights();
  // background color ---------------------------------------
  // draw a rectangle at the very end of z to realize a 
  // slightly transparant background
  if (unlocked){
    fill(0,10);
    noStroke();
    translate(0,0,-1000);
    rectMode(RADIUS);
    rect(0,0,2*fwidth,2*fheight); // why the width and height is not working correctly??
    translate(0,0,1000);
    // set a spotlight
    //spotLight(v1, v2, v3, x, y, z, nx, ny, nz, angle, concentration) concentration Try 1 -> 10000
    //spotLight( 255, 10, 0,  0, 0, 0, 1, 1, -1, PI/2, 1000);
  }
  // --------------------------------------------------

  //background(0);
  // time value for the rotation Y of the goat 
  time = (time + delta_t) % TWO_PI;
  //drawspace(false);
  translate(fwidth/2, fheight/2,-100);
  Sound.Get_sound_numbers();
  // change the seeding if a hich change in the sound is detected
  //println("f_diff");
  //println(f_diff);
  if(Sound.f_diff > clickstart){
    back *=-1;
    seedpara +=1;
    noiseSeed(seedpara);
    println("click");
    println(Sound.f_diff);
  }
  //println(maxmag, meanmag);
  // --------------------------------------
  // set the camera view position
  //camera(mouseX, mouseY, (height/2) / tan(PI/6), mouseX, mouseY, 0, 0, 1, 0);
  //camera(mouseX, mouseY, (-mouseX+mouseY)*5, fwidth/2, fheight/2, 0, 0, 1, 0);
  //camera(60, 200, 700, fwidth/2, fheight/2, 0, 0, 1, 0);
  //println(mouseX, mouseY, (-mouseX+mouseY)*5);
  if (unlocked){
    //goat_shape.rotateZ(( mouseY/fheight + mouseY/fwidth )*PI);
    //goat_shape.rotateX(mouseY/fheight*PI);
    //goat_shape.rotateY(mouseX/fwidth*PI);
    for(int i=0;i<N_triangles;i++){
      //pos.set(random(fwidth),random(fheight),random(-fwidth,300));
      temps = goat_shape.getChild(i);
      //goat_shape.setVertex(i,pos);
      //println(temps.getVertexCount());
      for(int j =0;j<temps.getVertexCount();j++){
          pos=temps.getVertex(j);
          
          normtemps = 1;
          velocity[i][j][0] = (origoat[i][j][0]-pos.x)*dt;
          velocity[i][j][1] = (origoat[i][j][1]-pos.y)*dt;
          velocity[i][j][2] = (origoat[i][j][2]-pos.z)*dt;
          // global fatness of the goat
          pos.x = (pos.x-center[0])*(1 + 0.02*Sound.f_means[0])  + velocity[i][j][0]*dt*0.1 +center[0] ;
          pos.y = (pos.y-center[1])*(1 + 0.005*Sound.f_means[1]) + velocity[i][j][1]*dt*0.1 +center[1] ;
          pos.z = (pos.z)*          (1 + 0.02*Sound.f_means[0])  + velocity[i][j][2]*dt*0.1;
          
          
          pos.x += Sound.f_maxs[1]*dt*back*(0.5- noise(pos.x)) + velocity[i][j][0]*dt*0.1 + Sound.f_maxs[2]*randomGaussian();
          pos.y += Sound.f_maxs[1]*dt*back*(0.5- noise(pos.y)) + velocity[i][j][1]*dt*0.1 + Sound.f_maxs[2]*randomGaussian();
          pos.z += Sound.f_maxs[1]*dt*back*(0.5- noise(pos.z)) + velocity[i][j][2]*dt*0.1 + Sound.f_maxs[2]*randomGaussian();
          temps.setVertex(j,pos);
          temps.setStroke(0);
          //break;
      }// end inner forloop
    } // end outer forloop
    rotateY(time + Sound.f_means[0]/10);
    rotateZ(Sound.stereo);
    rotateX(Sound.stereo);
    //goat_shape.setStroke(0);
    //fill(50,10);
    //goat_shape.setFill(color(map(mouseX, 0, width, 0, 255)));
    shape(goat_shape, 0, 0);
  } // end if
  else{
    stroke(255);
    // only draw points at the positions of the goat
    if (show_goat){
      shape(goat_shape,0,0);
    }
    draw_balls(2);
    
  }

  
  //println(goat_shape.getVertexCount());
  //println(goat_shape.getChildCount());
  //goat_shape.rotateY(PI/1000);


  /*
  if(video){
    videoExport.saveFrame();
  }
  */
  
}
// END DRAW ----------------------------------------------------------------------------------
