import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.spi.*; // for AudioStream


class Sound_Processing { 
    //---------------------------
    // variable definitions
    float mean_left  = 0;
    float mean_right = 0;
    int buffer = 1024;
    //soundflowers check out
    Minim minim;
    //AudioPlayer player;
    FFT fft ;
    AudioOutput out;
    AudioInput line_in;
    WindowFunction newWindow = FFT.NONE;
    int cutoff = buffer/3;
    //
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

    // initialization -----------------------------------------
    Sound_Processing () {  
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
     
    } 
   

    //----------------------------
    void Get_sound_numbers(){
      //----------------------------
       mean_left  = 0;
       mean_right = 0;
       newWindow = FFT.HANN;
       fft.window( newWindow );
       fft.forward( line_in.mix ); //fourier-Transformation
       // initialization of the sound numbers ---------------------------
       for (int i = 0; i<f_means.length; i++){
         f_means_old[i] = f_means[i];
         f_means[i]     = 0;
         f_maxs[i]      = 0;
         max_freq[i]    = 1;
       }
       //----------------------------------------------------------------
       // loop through all frequency bandwidth
       for (int n =0; n<limits.length-1; n++){
         Get_means(n,limits[n],limits[n+1]);
       }
       f_diff = pow(Mat.sum(f_means_old) - Mat.sum(f_means),2);
       stereo = stereo_fac*(mean_right - mean_left);
       //println(f_means);
       //println(f_maxs);
    }
    
    void Get_means(int index,int l0, int l1){
        for(int i=l0; i<l1 ;i++){
          float tempmag = fft.getBand(i);
          mean_left  += abs(line_in.left.get(i)) ;
          mean_right += abs(line_in.right.get(i));
          if (log_on){
             tempmag = log(tempmag+1);
          }
          f_means[index] += tempmag ;
          //if (log(fft.getBand(max_freq[index]+1) ) <  tempmag ){
          if (f_maxs[index]  <  tempmag ){  
            max_freq[index] = i;
            f_maxs[index]   = fft.getBand(i) ; 
            if(log_on){
              f_maxs[index]   = log(f_maxs[index]+1) ; 
            }
          }
       }
       //f_maxs[index] =   factors[index]*log(fft.getBand(max_freq[index])+1) ; 
       f_maxs[index]  *= factors[index] ;
       f_means[index] *= factors[index]/ (l1-l0);
    }

} 

// not needed anymore:
  //  maxdiff = max(abs(tempmag-fftmag[n]),maxdiff);
  //  meandiff += pow(tempmag-fftmag[n],2);
  //  fftmag[n] = tempmag;
  //  //line(n,tempmag*200,-10,n,0,-10);
  //}  
  //meanhighmag[1] /= (buffer-cutoff) ;
  //meandiff = sqrt(meandiff/(buffer-1));
  //maxdiff /= meanlowmag[0];
  //meanlowmag[0] = (meanlowmag[0]+meanlowmag[1])/2;
  //meanhighmag[1] = pow(meanhighmag[1]*highfak,2);

  //maxmag = max(maxlowmag,maxhighmag); 
