 
int irLaserBreak = 0;



void blackScreenIntro () {

    background(0);
  
//check to see if the infrared sensor has been broken and if so, trigger the laserScreen()    
    //if(laserStatus >= 1){
    //  //irLaserBreak++;
    //  //}
      
    //if(irLaserBreak >= 1){
    //    blackScreenIntro = false;
    //    laserScreen = true;    
    //}
    
  //override for triggering the laserScreen() by pressing the spacebar   
    if(keyPressed){
      if(key == ' '){
        blackScreenIntro = false;
        laserPuzzle = true;
      }
    }
   
   //console feedback to make sure that the experience is running and ready to trigger lasers
    println("ready");
}