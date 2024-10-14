// draws the balls at the corners of the triangulations
void draw_balls(int reduceN){
   float scale_fac = 70;
   rotateX(PI);  
   translate(0,-fheight/3);
   rotateY(-PI/1.4);
   //translate(fwidth/2, fheight/2,-100);
   int N = origoat.length - reduceN;
   int M = origoat[0].length ; //- reduceM;
   for(int i=0;i<N;i++){
      for(int j =0;j<M;j++){
          pushMatrix();
          translate(scale_fac*origoat[i][j][0],scale_fac* origoat[i][j][1],scale_fac* origoat[i][j][2]);
          sphere(2);
          //box(5);
          //translate(-temppos.x, -temppos.y, -temppos.z);
          popMatrix();
          if (show_one){ break;}
      }// end inner forloop
      if (show_one){ break;}
   } // end outer forloop
   //pushMatrix();
}
