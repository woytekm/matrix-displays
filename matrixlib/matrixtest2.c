/* digital clock on 32x64 matrix */

#include "matrixlib.h"
#include <time.h>

main()
 {
  uint8_t color;

  color = 34;

  m_init();
  m_set_brightness(5);

  uint8_t i,j,k;

  i=0;

  struct tm *tm_struct;
  time_t rawtime;
  int hour,min;
  char timestr[10];

  while (1)
   {
     
     time(&rawtime);
     tm_struct = localtime(&rawtime);
     hour = tm_struct->tm_hour;
     min = tm_struct->tm_min;

     if(i == 1)
      {
       sprintf(timestr,"%02d:%02d",hour,min);
       i = 0;
      }
     else
      {
       i = 1;
       sprintf(timestr,"%02d %02d",hour,min);
      }

     m_clear();
     m_setcursor(10,15);
     m_writechar(timestr[0],1,24,0);
     m_writechar(timestr[1],1,24,0);
     m_writechar(timestr[2],1,24,0);
     m_setcursor(34,15);
     m_writechar(timestr[3],1,24,0);
     m_writechar(timestr[4],1,24,0);
     m_display();
     sleep(1);
   }

  sleep(20);

  m_clear();
  m_display();

 } 
