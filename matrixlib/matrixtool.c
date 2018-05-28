#include <bcm2835.h>
#include <stdio.h>
#include <strings.h>
#include <stdlib.h>
#include <time.h>

#define MYBUFSIZ 2048


int main(int argc, char **argv)
{
    if (!bcm2835_init())
    {
      printf("bcm2835_init failed. Are you running as root??\n");
      return 1;
    }
    if (!bcm2835_spi_begin())
    {
      printf("bcm2835_spi_begin failed. Are you running as root??\n");
      return 1;
    }
    bcm2835_spi_setBitOrder(BCM2835_SPI_BIT_ORDER_MSBFIRST);      // The default
    bcm2835_spi_setClockDivider(BCM2835_SPI_CLOCK_DIVIDER_32); // The default
    bcm2835_spi_chipSelect(BCM2835_SPI_CS0);                      // The default
    bcm2835_spi_setChipSelectPolarity(BCM2835_SPI_CS0, LOW);      // the default

    char spi_send_buffer[MYBUFSIZ+1];
    char spi_recv_buffer[MYBUFSIZ+1];
    uint16_t i,j,k,l,cmp,finished=0,bytectr;
    uint8_t recv_byte,recv_bit,bitctr;
    struct timeval time; 

    if(strcmp(argv[1],"--hline") == 0)
     {
      bzero(&spi_send_buffer,MYBUFSIZ);
      k = 1;
      l = 0;

      for(j = 0; j < 32; j++)
       {
       if(k)
        {
         for(i = 0; i < 64; i++)
          {
            spi_send_buffer[l++] = 0;
            //printf("send_buffer[%d]=%d\n",l,0);
          }
         k = 0;
        }
       else
       {
        for(i = 0; i < 64; i++)
         {
          spi_send_buffer[l++] = 63;
          //printf("send_buffer[%d]=%d\n",l,7);
         }
        k = 1;
       }
      }
      spi_send_buffer[MYBUFSIZ] = atoi(argv[2]);
      bcm2835_spi_setDataMode(BCM2835_SPI_MODE1);
      bcm2835_spi_transfernb(&spi_send_buffer,&spi_recv_buffer,MYBUFSIZ+1);
     }

    if(strcmp(argv[1],"--vline") == 0)
     {
      j = 1;
      for(i = 0; i < MYBUFSIZ; i++)
       {
        if(j)
         {
          spi_send_buffer[i] = 63;
          j = 0;
         }
        else
         {
          spi_send_buffer[i] = 0;
          j = 1;
         }
        }
        bcm2835_spi_setDataMode(BCM2835_SPI_MODE1);
        bcm2835_spi_transfernb(&spi_send_buffer,&spi_recv_buffer,MYBUFSIZ);
      }
   
    if(strcmp(argv[1],"--transit") == 0) 
     {
      uint8_t color_transitions[55] = {1,2,3,7,11,15,31,47,63,62,61,60,56,52,48,49,50,51,51,35,39,23,27,11,15,14,13,12,12,13,14,15,11,27,23,39,35,51,50,49,48,52,56,60,61,62,63,47,31,15,11,7,3,2,1};
    
      bcm2835_spi_setDataMode(BCM2835_SPI_MODE1);

      while(1)
      for(j = 0; j < 55; j++)
       {
        for (i = 0; i < MYBUFSIZ; i++)
         spi_send_buffer[i] = color_transitions[j]; 
        bcm2835_spi_transfernb(&spi_send_buffer,&spi_recv_buffer,MYBUFSIZ);
        usleep(80000);
       }
     }

    if(strcmp(argv[1],"--checker") == 0)
     {
      j = 1;
      for(i = 0; i < MYBUFSIZ; i++)
       {
        if(j)
         {
          spi_send_buffer[i] = 63;
          j = 0;
         }
        else
         {
          spi_send_buffer[i] = 0;
          j = 1;
         }
        }
        bcm2835_spi_setDataMode(BCM2835_SPI_MODE1);
        bcm2835_spi_transfernb(&spi_send_buffer,&spi_recv_buffer,MYBUFSIZ);
      }
 
    if(strcmp(argv[1],"--clear") == 0)
     {
      bzero(&spi_send_buffer,MYBUFSIZ);
      bcm2835_spi_setDataMode(BCM2835_SPI_MODE1);
      bcm2835_spi_transfernb(&spi_send_buffer,&spi_recv_buffer,MYBUFSIZ);
     }
    if(strcmp(argv[1],"--fill") == 0)
     {
      uint8_t color;
      if(argc > 2)
       {
        color = atoi(argv[2]);
        if((color < 0) && (color > 64))
          color = 63;
       }
      else
        color = 63;

      bzero(&spi_send_buffer,MYBUFSIZ);

      for (i = 0; i < MYBUFSIZ; i++)
       spi_send_buffer[i] = color;

       bcm2835_spi_setDataMode(BCM2835_SPI_MODE1);
       bcm2835_spi_transfernb(&spi_send_buffer,&spi_recv_buffer,MYBUFSIZ);
     }
    if(strcmp(argv[1],"--random") == 0)
     while (1)
      { 
       bzero(&spi_send_buffer,MYBUFSIZ);
    
       gettimeofday(&time,NULL);
       srand((time.tv_sec * 1000) + (time.tv_usec / 1000));

       for (i = 0; i < MYBUFSIZ; i++)
        spi_send_buffer[i] = rand(); 
    
       // Send a byte to the slave and simultaneously read a byte back from the slave
       // If you tie MISO to MOSI, you should read back what was sent
       bcm2835_spi_setDataMode(BCM2835_SPI_MODE1);

       bcm2835_spi_transfernb(&spi_send_buffer,&spi_recv_buffer,MYBUFSIZ);

       //k = 0;
       //printf("Sent to SPI: \n");
       //for(i = 0; i < 10; i++)
       // {
       //   for(j=0; j < 10; j++)
       //    {
       //      printf ("0x%02X ",spi_send_buffer[k]);
       //      k++;
       //    }
       //  printf("\n");
       // }
       //printf("last bytes: 0x%02X 0x%02X\n",spi_send_buffer[MYBUFSIZ-2],spi_send_buffer[MYBUFSIZ-1]);

       // printf("\n\nRead back from SPI: \n");

       // k = 0;
       // for(i = 0; i < 10; i++)
       // {
       //   for(j=0; j < 10; j++)
       //    {
       //      printf ("0x%02X ",spi_recv_buffer[k]);
       //      k++;
       //    }
       //  printf("\n");
       // }
       // printf("last bytes: 0x%02X 0x%02X\n",spi_recv_buffer[MYBUFSIZ-2],spi_recv_buffer[MYBUFSIZ-1]);

       cmp = 0;
       cmp = memcmp(&spi_send_buffer,&spi_recv_buffer,MYBUFSIZ);

       printf("memcmp result: %d\n",cmp);

       uint32_t interval;

       if(argc > 2)
         {
           interval = atoi(argv[2]);
           if(interval > 0)
             usleep(interval);
           else
            {
             printf("invalid interval specified \n");
             usleep(40000);
            }
         }
       else       
         usleep(40000);

     }

    if(strcmp(argv[1],"--randomtransit") == 0)
     {

     gettimeofday(&time,NULL);
     srand((time.tv_sec * 1000) + (time.tv_usec / 1000));

     for (i = 0; i < MYBUFSIZ; i++)
      spi_send_buffer[i] = rand();

     while (1)
      {

       for (i = 0; i < MYBUFSIZ; i++)
        {
         spi_send_buffer[i]++;
        }

       // Send a byte to the slave and simultaneously read a byte back from the slave
       // If you tie MISO to MOSI, you should read back what was sent
       bcm2835_spi_setDataMode(BCM2835_SPI_MODE1);

       bcm2835_spi_transfernb(&spi_send_buffer,&spi_recv_buffer,MYBUFSIZ);

       cmp = 0;
       cmp = memcmp(&spi_send_buffer,&spi_recv_buffer,MYBUFSIZ);

       printf("memcmp result: %d\n",cmp);

       uint32_t interval;
       if(argc > 2)
         {
           interval = atoi(argv[2]);
           if(interval > 0)
             usleep(interval);
           else
            {
             printf("invalid interval specified \n");
             usleep(40000);
            }
         }
       else
         usleep(40000);

      }
    }

    bcm2835_spi_end();
    bcm2835_close();
    return 0;
}

