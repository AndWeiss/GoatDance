PShape copyShape(PShape original){
 
  PShape copy_shape = createShape();
  int nOfVertexes = original.getVertexCount();      
  int nOfVertexesCodes = original.getVertexCodeCount();      
  int code_index = 0; // which vertex i'm reading?
  PVector pos[] = new PVector[nOfVertexes];
  int codes[] = new int[nOfVertexes];
 
  println("nOfVertexes: "+nOfVertexes);
  println("nOfVertexesCodes: "+nOfVertexesCodes);
 
  // creates the shape to be manipulated
  // and initiate the codes array
  beginShape();
    for (int i=0; i< nOfVertexes; i++){
      copy_shape.vertex(0,0);
      codes[i] = 666; //random number, different than 0 or 1
    }
  endShape();
 
  // GET THE CODES
  for (int i=0; i< nOfVertexesCodes; i++){
    int code = original.getVertexCode(i);
    codes[code_index] = code;
    if (code == 0) {
      code_index++;
    } else if( code == 1){
      code_index +=3;
    }
  }
  // GET THE POSITIONS
  for (int i=0; i< nOfVertexes; i++){
    pos[i] = original.getVertex(i);
  }
  //for debugging purposes
  println("==============POS==============");
  printArray(pos);
  println("==============CODES==============");
  printArray(codes);
 
  copy_shape = createShape();
  copy_shape.beginShape();
  for (int i=0; i< nOfVertexes; i++){
    if ( codes[i] == 0) {
      //if a regular vertex
      copy_shape.vertex(pos[i].x, pos[i].y);
 
    } else if ( codes[i]==1 ){
       //if a bezier vertex
       copy_shape.bezierVertex(pos[i].x, pos[i].y,
                               pos[i+1].x, pos[i+1].y,
                               pos[i+2].x, pos[i+2].y);
 
    } else {
     //this vertex will be used inside the bezierVertex, wich uses 3 vertexes at once
     println("skipping vertex "+i);
    }
  }
  copy_shape.endShape();
  return copy_shape;
}
