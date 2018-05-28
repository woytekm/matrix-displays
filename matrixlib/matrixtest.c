#include <unistd.h>
#include "matrixlib.h"

void main()
 {
  uint8_t color;

  color = 34;

  m_init();
  m_set_brightness(2);


  m_putline(2,2,63,31,30);
  m_putline(63,2,2,31,30);
  
  m_putpixel(1,1,color);
  m_putpixel(64,1,color);
  m_putpixel(1,32,color);
  m_putpixel(64,32,color);
  
  m_putpixel(32,16,color);
  m_putpixel(33,16,color);
  m_putpixel(32,17,color);
  m_putpixel(33,17,color);

  m_putfillrect(2,10,10,13,12);
  m_putfillrect(54,10,10,13,24);

  m_display();

  sleep(20);

  m_clear();
  m_display();

 } 
