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
AudioInput in;
WindowFunction newWindow = FFT.NONE;




PShape s, temps, sbackup ;
float fheight;
float fwidth;
boolean locked;
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
float depth = -1000;
//



void setup() {
  //size(1000, 1000, P3D);
  fullScreen(P3D);//, SPAN);
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
  
  getGoat();
  // draw space ---------------------------------------------------
   // back corners
  corner_rub[0] = width; corner_rub[1] =0; corner_rub[2] = depth;
  corner_lub[0] = 0; corner_lub[1] =0; corner_lub[2] = depth;
  corner_rlb[0] = width; corner_rlb[1] =height; corner_rlb[2] = depth;
  corner_llb[0] = 0; corner_llb[1] = height; corner_llb[2] = depth;
  // front corners
  corner_ruf[0] = width; corner_ruf[1] =0; corner_ruf[2] = 0;
  corner_luf[0] = 0; corner_luf[1] =0; corner_luf[2] = 0;
  corner_rlf[0] = width; corner_rlf[1] =height; corner_rlf[2] = 0;
  corner_llf[0] = 0; corner_llf[1] = height; corner_llf[2] = 0;
  // ---------------------------------------------------------------
  // for the Sound processing ------
  
  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);                                               
  // construct a LiveInput by giving it an InputStream from minim.                                                  
  in = minim.getLineIn(); //new LiveInput( inputStream );
  fft = new FFT( buffer, in.sampleRate() );
  println(in.sampleRate()); 
  
  // -------------------------------
  
  for(int i=0;i<buffer;i++){
    fftmag[i] = 0;
  }
  
  println(cutoff);
  stroke(255);
  
} // END SETUP --------------------------------------


float[] fftmag = new float[buffer]; 
float maxmag , maxlowmag, maxhighmag, tempmag, normtemps, maxdiff, meandiff,highfak =5;
float[] meanhighmag = {0.1 , 0.1};
float[] meanlowmag = {0.1 , 0.1};
float clickstart = 15;
float dt = 0.5;
float[][][] velocity;
int cutoff = buffer/3;
float[] center = {fwidth/2 , fheight/2 };

// DRAW -------------------------------------------------------------------------
void draw() {
  lights();
  background(0);
  drawspace(false);
  // Soud processing ----------------------
  newWindow = FFT.HANN;
  fft.window( newWindow );
  //fourier-Transformation
  fft.forward( in.mix );
  maxmag = 0;
  meanlowmag[1] = 0;
  meanhighmag[1] = 0;
  maxdiff = 0;
  meandiff = 0;
  maxhighmag = 0;
  maxlowmag = 0;
  // loop through the low frequencies -------------
  for(int n=1;n<cutoff;n++){
    tempmag = log(fft.getBand(n)+1);
    meanlowmag[1] += tempmag;
    maxlowmag = max(maxlowmag,tempmag);
    // the change in magnitude
    maxdiff = max(abs(tempmag-fftmag[n]),maxdiff);
    meandiff += pow(tempmag-fftmag[n],2);
    fftmag[n] = tempmag;
    //line(n,tempmag*200,-10,n,0,-10);
  }
  
  meanlowmag[1] /= cutoff;
  
  // loop through the high frequencies -------------
  for(int n=cutoff;n<buffer;n++){
    tempmag = log(fft.getBand(n)+1);
    meanhighmag[1] += tempmag;
    maxhighmag = max(maxhighmag,tempmag);
    // the change in magnitude
    maxdiff = max(abs(tempmag-fftmag[n]),maxdiff);
    meandiff += pow(tempmag-fftmag[n],2);
    fftmag[n] = tempmag;
    //line(n,tempmag*200,-10,n,0,-10);
  }  
  //line(cutoff,height,-10,cutoff,0,-10);
  meanhighmag[1] /= (buffer-cutoff) ;
  meandiff = sqrt(meandiff/(buffer-1));
  maxdiff /= meanlowmag[0];
  meanlowmag[0] = (meanlowmag[0]+meanlowmag[1])/2;
  meanhighmag[1] = pow(meanhighmag[1]*highfak,2);
  //println("meandiff: " , meandiff);
  //println("maxdiff: " , maxdiff);
  //meanhighmag = maxhighmag/10;
  //meanlowmag = maxlowmag;
  //meanhighmag =0;
  maxmag = max(maxlowmag,maxhighmag); 
  if(maxdiff>clickstart){
    back *=-1;
    seedpara +=1;
    noiseSeed(seedpara);
    println("click");
    println(maxdiff);
  }
  //println(maxmag, meanmag);
  // --------------------------------------
  // set the camera view position
  //camera(mouseX, mouseY, (height/2) / tan(PI/6), mouseX, mouseY, 0, 0, 1, 0);
  //camera(mouseX, mouseY, (-mouseX+mouseY)*5, fwidth/2, fheight/2, 0, 0, 1, 0);
  //camera(60, 200, 700, fwidth/2, fheight/2, 0, 0, 1, 0);
  //println(mouseX, mouseY, (-mouseX+mouseY)*5);
  if (locked){
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
          pos.x = (pos.x-center[0])*(1+0.005*maxlowmag) + velocity[i][j][0]*dt*0.1 +center[0] ;
          //pos.y = (pos.y-center[1])*(1+0.01*maxlowmag) + velocity[i][j][1]*dt*0.1 +center[1] ;
          pos.z = (pos.z)*(1+0.005*maxlowmag) + velocity[i][j][2]*dt*0.1;
          
          pos.x += meanlowmag[1]*dt*back*(0.5- noise(pos.x)) + velocity[i][j][0]*dt*0.1 + meanhighmag[1]*randomGaussian();
          pos.y += meanlowmag[1]*dt*back*(0.5- noise(pos.y)) + velocity[i][j][1]*dt*0.1 + meanhighmag[1]*randomGaussian();
          pos.z += meanlowmag[1]*dt*back*(0.5- noise(pos.z)) + velocity[i][j][2]*dt*0.1 + meanhighmag[1]*randomGaussian();
          temps.setVertex(j,pos);
          temps.setStroke(0);
          //break;
      }// end inner forloop
    } // end outer forloop
  } // end if
  s.setStroke(0);
  fill(50);
  
  //println(s.getVertexCount());
  //println(s.getChildCount());
  //s.rotateY(PI/1000);
  translate(fwidth/2, fheight/2,-100);
  shape(s, 0, 0);
  if(video){
    videoExport.saveFrame();
  }
  
}
// END DRAW ----------------------------------------------------------------------------------
void keyPressed() {
  if (key == 'q') {
    videoExport.endMovie();
    exit();
  }
  else if(key == 's'){
    video = !video;
    videoExport = new VideoExport(this);
    videoExport.startMovie();
  }
  else if (key == 'r') {
    seedpara +=1;
    noiseSeed(seedpara);
    renewGoat();
  }
  else if (key == 'b') {
    // backward motion
    back *= -1;
    if (back==1){
      println("forwards");
    }
    else
    println("backwards");
  }
  else if (key == 'n') {
    seedpara +=1;
    noiseSeed(seedpara);
    println("new seeding");
    println(seedpara);
  }
  else if (key == 'k') {
    clickstart +=0.5;
    println("clickstart");
    println(clickstart);
  }
  else if (key == 'j') {
    clickstart -=0.5;
    println("clickstart");
    println(clickstart);
  }
  else if (key == 'h') {
    highfak +=0.2;
    println("highfak");
    println(highfak);
  }
  else if (key == 'g') {
    highfak -=0.2;
    println("highfak");
    println(highfak);
  }
}

void mousePressed() {
  locked = true;
  if (mouseButton == RIGHT){
    locked = false;
  }
    
    //println(mouseY/fheight);
}
void mouseReleased() {
  //locked = false;
}
