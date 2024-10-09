void renewGoat(){
  s = loadShape("Standing_Goat.obj");
  s.rotate(PI);
  s.scale(70);
  //
  s.translate(0,fheight/3);
  s.rotateY(PI/4);
}
