// reads the original goat and save its coordinates as a float matrix
void getGoat(){
  PShape stemp;
  PVector temppos;
  int N_triangles = goat_shape.getChildCount();
  origoat = new float[N_triangles][3][3];
  velocity = new float[N_triangles][3][3];
   for(int i=0;i<N_triangles;i++){
      //pos.set(random(fwidth),random(fheight),random(-fwidth,300));
      stemp = goat_shape.getChild(i);
      //goat_shape.setVertex(i,pos);
      //println(temps.getVertexCount());
      for(int j =0;j<stemp.getVertexCount();j++){
          temppos=  stemp.getVertex(j);
          origoat[i][j][0] = temppos.x;
          origoat[i][j][1] = temppos.y;
          origoat[i][j][2] = temppos.z;
          // initialize velocity
          velocity[i][j][0] = 0;
          velocity[i][j][1] = 0;
          velocity[i][j][2] = 0;
      }// end inner forloop
   } // end outer forloop
}
