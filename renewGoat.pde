void renewGoat(){
  goat_shape = loadShape("Standing_Goat.obj");
  goat_shape.rotate(PI);
  goat_shape.scale(70);
  //
  goat_shape.translate(0,fheight/3);
  goat_shape.rotateY(PI/4);
}
