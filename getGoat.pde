void getGoat(){
  PShape stemp;
  PVector temppos;
  origoat = new float[s.getChildCount()][3][3];
  velocity = new float[s.getChildCount()][3][3];
   for(int i=0;i<s.getChildCount();i++){
      //pos.set(random(fwidth),random(fheight),random(-fwidth,300));
      stemp = s.getChild(i);
      //s.setVertex(i,pos);
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
