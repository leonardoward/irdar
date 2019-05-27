/* ###################################################################
**     THIS COMPONENT MODULE IS GENERATED BY THE TOOL. DO NOT MODIFY IT.
**     Filename    : KB1.c
**     Project     : IRDAR
**     Processor   : MC9S08QE128CLK
**     Component   : KBI
**     Version     : Component 01.096, Driver 01.25, CPU db: 3.00.067
**     Compiler    : CodeWarrior HCS08 C Compiler
**     Date/Time   : 2016-02-22, 13:55, # CodeGen: 51
**     Abstract    :
**         This component "KBI" implements the Freescale Keyboard 
**         Interrupt Module (KBI/KBD) which allows to catch events 
**         on selected external pins. These pins share one KBI/KBD 
**         interrupt which can be caused by events on the pins.
**     Settings    :
**         Keyboard                    : KBI1 
**         Used pins           
**         Pin 0                       : PTA0_KBI1P0_TPM1CH0_ADP0_ACMP1PLUS
**         Pull resistor               : up
**         Generate interrupt on       : falling
**         Interrupt service           : Enabled
**         Interrupt                   : Vkeyboard
**         Interrupt Priority          : 
**         Enable in init. code        : Yes
**         Events enabled in init.     : Yes
**     Contents    :
**         GetVal  - byte KB1_GetVal(void);
**         SetEdge - byte KB1_SetEdge(byte edge);
**
**     Copyright : 1997 - 2014 Freescale Semiconductor, Inc. 
**     All Rights Reserved.
**     
**     Redistribution and use in source and binary forms, with or without modification,
**     are permitted provided that the following conditions are met:
**     
**     o Redistributions of source code must retain the above copyright notice, this list
**       of conditions and the following disclaimer.
**     
**     o Redistributions in binary form must reproduce the above copyright notice, this
**       list of conditions and the following disclaimer in the documentation and/or
**       other materials provided with the distribution.
**     
**     o Neither the name of Freescale Semiconductor, Inc. nor the names of its
**       contributors may be used to endorse or promote products derived from this
**       software without specific prior written permission.
**     
**     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
**     ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
**     WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
**     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
**     ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
**     (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
**     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
**     ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
**     (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
**     SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**     
**     http: www.freescale.com
**     mail: support@freescale.com
** ###################################################################*/
/*!
** @file KB1.c
** @version 01.25
** @brief
**         This component "KBI" implements the Freescale Keyboard 
**         Interrupt Module (KBI/KBD) which allows to catch events 
**         on selected external pins. These pins share one KBI/KBD 
**         interrupt which can be caused by events on the pins.
*/         
/*!
**  @addtogroup KB1_module KB1 module documentation
**  @{
*/         

/* MODULE KB1. */

#include "Events.h"
#include "KB1.h"

#pragma CODE_SEG KB1_CODE


/*
** ===================================================================
**     Event       :  KB1_OnInterrupt (module Events)
**
**     Component   :  KB1 [KBI]
**     Description :
**         This event is called when the active signal edge/level
**         occurs. This event is enabled only if <Interrupt
**         service/event> property is enabled.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
#pragma CODE_SEG __NEAR_SEG NON_BANKED
ISR(KB1_Interrupt)
{
  KBI1SC_KBACK = 0x01U;                /* Clear the interrupt flag */
  KB1_OnInterrupt();                   /* Invoke user event */
}
#pragma CODE_SEG KB1_CODE

/*
** ===================================================================
**     Method      :  KB1_GetVal (component KBI)
**     Description :
**         Returns the value of pins
**     Parameters  : None
**     Returns     :
**         ---             - The value of associated pins (bits ordered
**                           according to the component list of pins)
** ===================================================================
*/
/*
byte KB1_GetVal(void)

**      This method is implemented as macro. See KB1.h file.      **
*/

/*
** ===================================================================
**     Method      :  KB1_SetEdge (component KBI)
**     Description :
**         Sets the sensitive edge. If all selected pins don't have the
**         same edge setting possibility, the method allows to set only
**         those edges that are common (possible to set for all
**         selected pins).
**     Parameters  :
**         NAME            - DESCRIPTION
**         edge            - Edge type:
**                           0 - falling edge
**                           1 - rising edge
**                           2 - both edges
**                           3 - low level
**                           4 - high level
**     Returns     :
**         ---             - Error code, possible codes:
**                           ERR_OK - OK
**                           ERR_RANGE - Value is out of range
** ===================================================================
*/
byte KB1_SetEdge(byte edge)
{
  if ((edge > 4U) || (edge == 2U)) {   /* If parameter is out of range */
    return ERR_RANGE;                  /* ....then return error */
  }
  KBI1SC_KBIE = 0U;                    /* Disable device */
  if ((edge == 3U) || (edge == 4U)) {  /* Level selected */
    KBI1SC_KBIMOD = 0x01U;             /* Set the level */
    if (edge == 3U) {
    /* KBI1ES: KBEDG0=0 */
      KBI1ES &= (byte)(~(byte)0x01U);  /* The low level */
    }
    else {
    /* KBI1ES: KBEDG0=1 */
      KBI1ES |= 0x01U;                 /* The high level */
    }
  }
  else {                               /* Edge selected */
    KBI1SC_KBIMOD = 0U;                /* Set the edge */
    if (edge == 0U) {
    /* KBI1ES: KBEDG0=0 */
      KBI1ES &= (byte)(~(byte)0x01U);  /* The falling edge */
    }
    else {
    /* KBI1ES: KBEDG0=1 */
      KBI1ES |= 0x01U;                 /* The rising edge */
    }
  }
  KBI1SC_KBACK = 0x01U;                /* Clear the interrupt flag */
  KBI1SC_KBIE = 0x01U;                 /* Enable device */
  return ERR_OK;
}

/*
** ===================================================================
**     Method      :  KB1_Init (component KBI)
**
**     Description :
**         Initializes the associated peripheral(s) and the component 
**         internal variables. The method is called automatically as a 
**         part of the application initialization code.
**         This method is internal. It is used by Processor Expert only.
** ===================================================================
*/
void KB1_Init(void)
{
  /* KBI1ES: KBEDG7=0,KBEDG6=0,KBEDG5=0,KBEDG4=0,KBEDG3=0,KBEDG2=0,KBEDG1=0,KBEDG0=0 */
  setReg8(KBI1ES, 0x00U);               
  /* KBI1SC: ??=0,??=0,??=0,??=0,KBF=0,KBACK=0,KBIE=0,KBIMOD=0 */
  setReg8(KBI1SC, 0x00U);               
  /* KBI1PE: KBIPE0=1 */
  setReg8Bits(KBI1PE, 0x01U);          /* Enable appropriate interrupt pin(s) */ 
  /* KBI1SC: KBACK=1 */
  setReg8Bits(KBI1SC, 0x04U);          /* Clear the interrupt flag */ 
  /* KBI1SC: KBIE=1 */
  setReg8Bits(KBI1SC, 0x02U);          /* Enable interrupts */ 
}

/* END KB1. */

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
