// draws the balls at the corners of the triangulations
void draw_balls(int N_spheres){
   float scale_fac = 70;
   rotateX(PI);  
   translate(0,-fheight/3);
   rotateY(-PI/1.4);
   //translate(fwidth/2, fheight/2,-100);
   int N_triangles = origoat.length;
   int M = origoat[0].length ; //= 3;
   if (show_goat){
     N_spheres = N_triangles;
   }
   // show only one sphere
   if (show_one){
      pushMatrix();
      translate(scale_fac*origoat[600][1][0],scale_fac* origoat[600][1][1],scale_fac* origoat[600][1][2]);
      sphere(2);
      //box(5);
      //translate(-temppos.x, -temppos.y, -temppos.z);
      popMatrix();
   }
   else{
     int i_sphere = 0;
     for(int i=0;i<N_spheres;i++){
        i_sphere = floor(random(N_triangles));
        for(int j =0;j<M;j++){
            pushMatrix();
            translate(scale_fac*origoat[i_sphere][j][0],scale_fac* origoat[i_sphere][j][1],scale_fac* origoat[i_sphere][j][2]);
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
}
