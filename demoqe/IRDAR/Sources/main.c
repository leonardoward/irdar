/* ###################################################################
**     Filename    : main.c
**     Project     : IRDAR
**     Processor   : MC9S08QE128CLK
**     Version     : Driver 01.12
**     Compiler    : CodeWarrior HCS08 C Compiler
**     Date/Time   : 2016-02-01, 13:16, # CodeGen: 0
**     Abstract    :
**         Main module.
**         This module contains user's application code.
**     Settings    :
**     Contents    :
**         No public methods
**
** ###################################################################*/
/*!
** @file main.c
** @version 01.12
** @brief
**         Main module.
**         This module contains user's application code.
*/         
/*!
**  @addtogroup main_module main module documentation
**  @{
*/         
/* MODULE main */

/* Including needed modules to compile this module/procedure */
#include "Cpu.h"
#include "Events.h"
#include "Bit1.h"
#include "AS1.h"
#include "TI1.h"
#include "AD1.h"
#include "Bit2.h"
#include "KB1.h"
#include "TI3.h"
#include "Bit3.h"
#include "PWM1.h"
#include "TI2.h"
/* Include shared modules, which are used for whole project */
#include "PE_Types.h"
#include "PE_Error.h"
#include "PE_Const.h"
#include "IO_Map.h"

/* User includes (#include below this line is not maintained by Processor Expert) */
typedef union{
	unsigned int u16;
	char u8[2];
}ADC_VALUE;

volatile ADC_VALUE sharp1;
volatile ADC_VALUE sharp2;
unsigned int ADC_error;
unsigned int AS1_error;
unsigned int num;
unsigned int estado;
unsigned int ancho_pulso;
unsigned int ancho_pulso_min;
unsigned int ancho_pulso_max;
unsigned int alineado;
unsigned char A_pulsos_1;
unsigned char A_pulsos_2;
char motor_Dir;


void main(void)
{
  /* Write your local variable definition here */

  /*** Processor Expert internal initialization. DON'T REMOVE THIS CODE!!! ***/
  PE_low_level_init();
  /*** End of Processor Expert internal initialization.                    ***/

  /* Write your code here */
  Bit1_PutVal(1);
  num=2;
  estado=0;
  alineado=0;
  A_pulsos_1=0;
  A_pulsos_2=0;
  motor_Dir=0;
  ancho_pulso=8;
  PWM1_SetDutyUS(100);
  /* For example:*/
  for(;;) {	  
	  switch(estado){
	  case ESPERAR:
		  break;
	  case ENVIAR:
		  AS1_error=AS1_SendChar('C');			//Encoder Counts
		  AS1_error=AS1_SendChar(A_pulsos_1);
		  AS1_error=AS1_SendChar(A_pulsos_2);
		  AS1_error=AS1_SendChar('D');			//Encoder Direction
		  AS1_error=AS1_SendChar(motor_Dir);
		  AS1_error=AS1_SendChar('A');			//Analog Value 1
		  AS1_error=AS1_SendChar(sharp1.u8[0]);
		  //AS1_SendChar(sharp.u8[1]);
		  AS1_error=AS1_SendChar(sharp2.u8[0]);
		  //AS1_SendChar(sharp.u8[1]);
		  AS1_error=AS1_SendChar('E');			//Analog Value 1
		  estado=ESPERAR;
		  break;
	  case MEDIR:
		  ADC_error=AD1_Measure(TRUE);
		  //ADC_error=AD1_GetValue16(&sharp1.u16);
		  ADC_error=AD1_GetChanValue16(0,&sharp1.u16);
		  ADC_error=AD1_GetChanValue16(1,&sharp2.u16);
		  estado=ENVIAR;
		  break;
	  default:
		  estado=ESPERAR;
	  } 
  } 
  /*** Don't write any code pass this line, or it will be deleted during code generation. ***/
  /*** RTOS startup code. Macro PEX_RTOS_START is defined by the RTOS component. DON'T MODIFY THIS CODE!!! ***/
  #ifdef PEX_RTOS_START
    PEX_RTOS_START();                  /* Startup of the selected RTOS. Macro is defined by the RTOS component. */
  #endif
  /*** End of RTOS startup code.  ***/
  /*** Processor Expert end of main routine. DON'T MODIFY THIS CODE!!! ***/
  for(;;){}
  /*** Processor Expert end of main routine. DON'T WRITE CODE BELOW!!! ***/
} /*** End of main routine. DO NOT MODIFY THIS TEXT!!! ***/

/* END main */
/*!
** @}
*/
/*
** ###################################################################
**
**     This file was created by Processor Expert 10.3 [05.09]
**     for the Freescale HCS08 series of microcontrollers.
**
** ###################################################################
*/
