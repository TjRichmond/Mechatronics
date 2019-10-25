clear all;
close all;

% Filename: MES_Calculations.m
% Author: David Pierce Walker-Howell <piercedhowell@gmail.com>
% Date: 09/21/2019
% Description: This script contains the necessary calculations for the
% Motor Enable Switch (Power MOSFET based).

%----Calculation for Over Voltage Protection (OVP)----%
% The over-voltage protection on the LM5060 device detects if the input
% voltage to the MOSFET exceeds a desired voltage.

%Setting the maximum input voltage to the mosfet to be 18v.
%When the OVP pin exceeds 2v, then the GATE pin driving the MOSFET will be
%driven off. R3 and R4 are the resistors in the resistor divider.
MAX_VOLTAGE = 18; 

%2.0 = MAX_VOLTAGE * R4 / (R3 + R4);
%Set one of the Resistor values to calculate the other one (not R3 > R4)
R4 = 1.0E3; % 1k Ohm
R3 = ((MAX_VOLTAGE - 2.0)*R4) / 2.0;
%-------------------------------------------------------------------------%

%----Calculation for Under Volatage Proection (UVLO)----%
% The Under voltage protection is used to make sure the MOSFET does not
% turn on if the supply voltage is below a set threshold fed to the UVLO
% pin of the LM5060. Needs a voltage above 1.6V to let the gate voltage
% rise when the Enable pin is driven HIGH.

%Minimum voltage of 13v
MIN_VOLTAGE = 13; 

% 1.6 = MIN_VOLTAGE * R2 / (R1 + R2)
R2 = 1.0E3;
R1 = ((MIN_VOLTAGE - 1.6) * R2) / 1.6;
%-------------------------------------------------------------------------%

%----Calculation for SENSE pin resistor Rs--------------------------------%
%DATASHEET REFERNCE: Page 19
%The Sense pin is used to compare the drain voltage to the source voltage.
%If the voltage at the SENSE pin falls lower than the voltage at the OUT
%pin, then the Vds comparator will trip the nPGD to high imdedance.The
%SENSE pin is used to set the threshold for fault detection. It typically
%has a constant current sink of 16uA.
%
%Drain-Source Thresh = V_dsth = (Rs * I_sense) - V_offset
%I_sense = 16uA (typically)
%V_offset = 0V (typically)


%Set the V_dsth to some low voltage
V_dsth = 0.010; %10 mV
I_sense = 16E-6; %16uA
R_s = V_dsth / I_sense;

%--------------------------------------------------------------------------%

%----Calculation for nPGD pin---------------------------------------------%
%The nPGD pin is used to set a fault status for when the external MOSFET
%Vds decreases such that the voltage at the SENSE pin is lower than the OUT
%pin. If the fault is detected, the nPGD will be driven low. A pull-up
%resistor is used on the nPGD so it sources between 1mA - 5mA of current.

%Using the maximum voltage with a peak current of 3mA
I_nPGD_MAX = 3E-3;
R5 = MAX_VOLTAGE / I_nPGD_MAX;
%-------------------------------------------------------------------------%

