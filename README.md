# GoatDance

Audio reactive 3-dimensional goat that transforms depneding on from sound input. 

A demonstration can be found here: [yoiutube](https://youtu.be/Fo4SG2BsSMw?si=YPOI_5VvwFycfGu5)

In the beginning there is only one sphere (or if you push key '1'),
when key '2' is pushed, all spheres from the vertexes of the goat appear,
when key '3' is pushed, the triangulation can be seen along with the spheres, 
when key '4' is pushed, the spheres disapear and the goat is reacting on the sound.
```
  switch (key) {
    case 'x':
    // low frequency factor +
    factors[0] *= 1.1;
    break;
    case 'y': 
     // low frequency factor -
     factors[0] *= 0.9;
     break;
    case 's':
      // mid frequency factor +
      factors[1] *= 1.1;
      break;  
    case 'a':
      // mid frequency factor -
      factors[1] *= 0.9;
      break;
    case 'w':
      // high frequency factor +
      factors[2] *= 1.1;
      break;
    case 'q':
      // high frequency factor -
      factors[2] *= 0.9;;
      break;
    case 'r':
      seedpara +=1;
      back *=-1;
      noiseSeed(seedpara);
      renewGoat();
      break;
    case 'b':
      // backward motion
      back *= -1;
      if (back==1){ println("forwards");  }
      else{ println("backwards"); }
      break;
    case 'm':
      // the stereo factor increase
      stereo_fac *= 1.1;
      break;
    case 'n':
      // the stereo factor decrease 
      stereo_fac *= 0.9;
      break;
    case 'k':
      clickstart *= 1.1;
      println("clickstart");
      println(clickstart);
      break;
    case 'j':
      clickstart *=0.9;
      println("clickstart");
      println(clickstart);
     break;
    case 'f':
      // superfactor scaling all other factors
      factors = Mat.multiply(factors,2-superfac);
      break;
     case 'd':
      // overall scaling of the factors lower
      factors = Mat.multiply(factors,superfac);
      break;
    case 'l':
      // logarithmic magnitude on / off
      log_on = !log_on;
      break;
    case '1':
      // show a single sphere
      show_one = true;
      break;
    case '2':
      // show all spheres
      show_all_spheres = true;
      show_one         = false;
      show_goat        = false;
      break;
    case '3':
      // show the goat shape
      show_goat        = true;
      show_one         = false;
      show_all_spheres = true;
      break;
    case '4':
      // don't show the spheres and only the goat shape and let the sound manipulate
      unlocked         = true;
      show_goat        = false;
      show_one         = false;
      show_all_spheres = false;
      break;
```
