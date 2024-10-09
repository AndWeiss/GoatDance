void  drawspace(boolean filling){
    lights();
    if (filling){
      noStroke();
      fill(100);
      //  right side wall --------
      beginShape();
        vertex(corner_rub[0],corner_rub[1],corner_rub[2]);
        vertex(corner_rlb[0],corner_rlb[1],corner_rlb[2]);
        vertex(corner_ruf[0],corner_ruf[1],corner_ruf[2]);
      endShape();
      beginShape();
        vertex(corner_rlb[0],corner_rlb[1],corner_rlb[2]);
        vertex(corner_ruf[0],corner_ruf[1],corner_ruf[2]);
        vertex(corner_rlf[0],corner_rlf[1],corner_rlf[2]);
      endShape();
      //  left side wall --------
      beginShape();
        vertex(corner_lub[0],corner_lub[1],corner_lub[2]);
        vertex(corner_llb[0],corner_llb[1],corner_llb[2]);
        vertex(corner_luf[0],corner_luf[1],corner_luf[2]);
      endShape();
      beginShape();
        vertex(corner_llb[0],corner_llb[1],corner_llb[2]);
        vertex(corner_luf[0],corner_luf[1],corner_luf[2]);
        vertex(corner_llf[0],corner_llf[1],corner_llf[2]);
      endShape();
      //  bottom wall --------
      fill(50);
      beginShape();
        vertex(corner_llb[0],corner_llb[1],corner_llb[2]);
        vertex(corner_llf[0],corner_llf[1],corner_llf[2]);
        vertex(corner_rlf[0],corner_rlf[1],corner_rlf[2]);
      endShape();
      beginShape();
        vertex(corner_llb[0],corner_llb[1],corner_llb[2]);
        vertex(corner_rlb[0],corner_rlb[1],corner_rlb[2]);
        vertex(corner_rlf[0],corner_rlf[1],corner_rlf[2]);
      endShape();
      //  top wall --------
      fill(200);
      beginShape();
        vertex(corner_lub[0],corner_lub[1],corner_lub[2]);
        vertex(corner_luf[0],corner_luf[1],corner_luf[2]);
        vertex(corner_ruf[0],corner_ruf[1],corner_ruf[2]);
      endShape();
      beginShape();
        vertex(corner_lub[0],corner_lub[1],corner_lub[2]);
        vertex(corner_rub[0],corner_rub[1],corner_rub[2]);
        vertex(corner_ruf[0],corner_ruf[1],corner_ruf[2]);
      endShape();
      //  back wall --------
      fill(80);
      beginShape();
        vertex(corner_lub[0],corner_lub[1],corner_lub[2]);
        vertex(corner_llb[0],corner_llb[1],corner_llb[2]);
        vertex(corner_rub[0],corner_rub[1],corner_rub[2]);
      endShape();
      beginShape();
        vertex(corner_rlb[0],corner_rlb[1],corner_rlb[2]);
        vertex(corner_llb[0],corner_llb[1],corner_llb[2]);
        vertex(corner_rub[0],corner_rub[1],corner_rub[2]);
      endShape();
  }
  else{
    stroke(150);
    line(corner_rlb[0],corner_rlb[1],corner_rlb[2],corner_rlf[0],corner_rlf[1],corner_rlf[2]);
    line(corner_llb[0],corner_llb[1],corner_llb[2],corner_llf[0],corner_llf[1],corner_llf[2]);
    line(corner_rub[0],corner_rub[1],corner_rub[2],corner_ruf[0],corner_ruf[1],corner_ruf[2]);
    line(corner_lub[0],corner_lub[1],corner_lub[2],corner_luf[0],corner_luf[1],corner_luf[2]);
    //
    line(corner_lub[0],corner_lub[1],corner_lub[2],corner_rub[0],corner_rub[1],corner_rub[2]);
    line(corner_llb[0],corner_llb[1],corner_llb[2],corner_rlb[0],corner_rlb[1],corner_rlb[2]);
    line(corner_llb[0],corner_llb[1],corner_llb[2],corner_lub[0],corner_lub[1],corner_lub[2]);
    line(corner_rlb[0],corner_rlb[1],corner_rlb[2],corner_rub[0],corner_rub[1],corner_rub[2]);
  }
}
