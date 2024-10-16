import papaya.Mat;
import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.spi.*; // for AudioStream

// for video export
import com.hamoid.*;
VideoExport videoExport;

// variables for the sound processing -----------------------------

int buffer = 1024;
//soundflowers check out
Minim minim;
//AudioPlayer player;
FFT fft ;
AudioOutput out;
AudioInput line_in;
WindowFunction newWindow = FFT.NONE;

int reduce_spheres = 200;


PShape s, temps, sbackup ;
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
int cutoff = buffer/3;
float[] center = {fwidth/2 , fheight/2 };
// -------------------------------------------------------------------------------
// Numbers for sound processing
int[] limits        = new int[4]; // must be f_means.length + 1
float[] f_means     = {0. , 0. , 0.} ;
float[] f_means_old = new float[3];
int[] max_freq      = new int[3];
float[] f_maxs      = new float[3];
// the difference of the before and actuell sound value (dynamic change) 
float f_diff        = 0 ;
// the difference between left and right sound input
float stereo        = 0;
// factors that can be controlled by the keyboard -----------
// they are multiplied to the sound numbers and control the physical parameters
//     0: , 1: size , 2: damping, 3: magnusfak, 4: drag 
float[] factors     = {0.05, 0.05 , 0.008743586 }; // Mat.constant(1.0,5);
float stereo_fac    = 0.002;
// scaling of all factors by multiplication of the superfac or (2-supberfac)
float superfac      = 0.9 ; 
boolean log_on      = false;
float clickstart    = 2.5;

void setup() {
  //size(1000, 1000, P3D);
  fullScreen(P3D,SPAN);//, SPAN);
  // The file "bot.obj" must be in the data folder
  // of the current sketch to load successfully
  s = loadShape("Standing_Goat.obj");
  //s = loadShape("Happy_Goat.obj");
  s.rotateX(PI);
  s.scale(70);
  //
  fheight = float(height);
  fwidth = float(width);
  //sbackup = copyShape(s);
  //
  s.translate(0,fheight/3);
  s.rotateY(PI/1.4);
  // not shure how to use push Matrix
  // pushMatrix();
  
  getGoat();
  // for the Sound processing ------
  
  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);                                               
  // construct a LiveInput by giving it an InputStream from minim.                                                  
  line_in = minim.getLineIn(); //new LiveInput( inputStream );
  fft = new FFT( buffer, line_in.sampleRate() );
  println(line_in.sampleRate()); 
  
  //the limits of the frequency separation
  limits[0] =  1 ;          // start frequency
  limits[1] =  buffer/200 ; //low frequencies
  limits[2] =  buffer/6 ;   //mid frequencies
  limits[3] =  buffer/2 ;   //high frequencies (end frequency)
  
  // -------------------------------
  
  println(cutoff);
  stroke(255);
  
  
  
} // END SETUP ------------------------------------------------------------------
//
// DRAW -------------------------------------------------------------------------
void draw() {
  lights();
  background(0);
  // time value for the rotation Y of the goat 
  time = (time + delta_t) % TWO_PI;
  //drawspace(false);
  translate(fwidth/2, fheight/2,-100);
  Get_sound_numbers();
  // change the seeding if a hich change in the sound is detected
  //println("f_diff");
  //println(f_diff);
  if(f_diff > clickstart){
    back *=-1;
    seedpara +=1;
    noiseSeed(seedpara);
    println("click");
    println(f_diff);
  }
  //println(maxmag, meanmag);
  // --------------------------------------
  // set the camera view position
  //camera(mouseX, mouseY, (height/2) / tan(PI/6), mouseX, mouseY, 0, 0, 1, 0);
  //camera(mouseX, mouseY, (-mouseX+mouseY)*5, fwidth/2, fheight/2, 0, 0, 1, 0);
  //camera(60, 200, 700, fwidth/2, fheight/2, 0, 0, 1, 0);
  //println(mouseX, mouseY, (-mouseX+mouseY)*5);
  if (unlocked){
    //s.rotateZ(( mouseY/fheight + mouseY/fwidth )*PI);
    //s.rotateX(mouseY/fheight*PI);
    //s.rotateY(mouseX/fwidth*PI);
    for(int i=0;i<s.getChildCount();i++){
      //pos.set(random(fwidth),random(fheight),random(-fwidth,300));
      temps = s.getChild(i);
      //s.setVertex(i,pos);
      //println(temps.getVertexCount());
      for(int j =0;j<temps.getVertexCount();j++){
          pos=temps.getVertex(j);
          
          normtemps = 1;
          velocity[i][j][0] = (origoat[i][j][0]-pos.x)*dt;
          velocity[i][j][1] = (origoat[i][j][1]-pos.y)*dt;
          velocity[i][j][2] = (origoat[i][j][2]-pos.z)*dt;
          // global fatness of the goat
          pos.x = (pos.x-center[0])*(1 + 0.02*f_means[0]) + velocity[i][j][0]*dt*0.1 +center[0] ;
          pos.y = (pos.y-center[1])*(1 + 0.005*f_means[1]) + velocity[i][j][1]*dt*0.1 +center[1] ;
          pos.z = (pos.z)*          (1 + 0.02*f_means[0]) + velocity[i][j][2]*dt*0.1;
          
          
          pos.x += f_maxs[1]*dt*back*(0.5- noise(pos.x)) + velocity[i][j][0]*dt*0.1 + f_maxs[2]*randomGaussian();
          pos.y += f_maxs[1]*dt*back*(0.5- noise(pos.y)) + velocity[i][j][1]*dt*0.1 + f_maxs[2]*randomGaussian();
          pos.z += f_maxs[1]*dt*back*(0.5- noise(pos.z)) + velocity[i][j][2]*dt*0.1 + f_maxs[2]*randomGaussian();
          temps.setVertex(j,pos);
          temps.setStroke(0);
          //break;
      }// end inner forloop
    } // end outer forloop
    rotateY(time + f_means[0]/10);
    rotateZ(stereo);
    rotateX(stereo);
    //s.setStroke(0);
    //fill(50,10);
    //s.setFill(color(map(mouseX, 0, width, 0, 255)));
    shape(s, 0, 0);
  } // end if
  else{
    if (time>PI){
      reduce_spheres = max(0,reduce_spheres -5);
    }
    // only draw points at the positions of the goat
    if (show_goat){
      shape(s,0,0);
    }
    draw_balls(reduce_spheres);
    
  }

  
  //println(s.getVertexCount());
  //println(s.getChildCount());
  //s.rotateY(PI/1000);



  if(video){
    videoExport.saveFrame();
  }
  
}
// END DRAW ----------------------------------------------------------------------------------
