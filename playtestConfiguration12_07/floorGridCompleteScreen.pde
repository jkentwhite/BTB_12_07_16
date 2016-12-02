void floorGridCompleteScreen(){
  background(0);
  
  if(countdownFive > 0){
    textSize(48);
    fill(255);
    text("FLOOR GRID COMPLETE!\n PREPARE FOR GAS ATTACK!\nLOCATE THE FOUR TABLETS \nTO BEGIN THE GAS ATTACK CHALLENGE", width/2, height/4);
    countdownFive--;
    delay(100);
    
  } else {
    background(0);
  }
}