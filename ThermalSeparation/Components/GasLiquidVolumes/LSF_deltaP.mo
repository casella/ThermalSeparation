within ThermalSeparation.Components.GasLiquidVolumes;
model LSF_deltaP "model of lean solvent flash with pressure loss"
extends ThermalSeparation.Components.GasLiquidVolumes.BaseClasses.BaseLSF;

replaceable model PressureLoss = 
      ThermalSeparation.PressureLoss.Reboiler.TubeHX                                  constrainedby
    ThermalSeparation.PressureLoss.Reboiler.BasePressureLoss annotation (
      choicesAllMatching=true);
PressureLoss pressureLoss(zeta=zeta, p_in = p_hyd[1], p_out = p_hyd[2], eps_liq = eps_liq, rho_l = rho_l, rho_v = rho_v, d_HX = d_HX, length_HX = length_HX, d_tube=d_tube, Nw=Nw);
parameter Real zeta =  8.6;

SI.MolarMass MM_v_state(  stateSelect=StateSelect.prefer)=MM_v;
equation

/*** Der Gleichung f�r Druckverlust bei Umstr�mung von Rohrb�ndeln nachempfunden (VDI-W�rmeatlas), zeta wird allerdings als Parameter vorgegeben
     Sowieso alles nur m��ig gut, weil der Volumenstrom sich ja signifikant �ber die HX-H�he �ndert ***/
Vdot_v = pressureLoss.Vdot;

initial equation

end LSF_deltaP;
