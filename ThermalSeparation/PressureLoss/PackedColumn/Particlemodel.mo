within ThermalSeparation.PressureLoss.PackedColumn;
model Particlemodel
  "pressure loss using the particle model, for random packings"

  extends ThermalSeparation.PressureLoss.PackedColumn.BasicPressureLossPacked;

/*** fluid particle diameters ***/
  SI.Diameter d_L[n-1] "average d_L for the discrete elements";
  SI.Diameter d_L_in "d_L for the first half of the first discrete element";
  SI.Diameter d_L_out "d_L for the second half of the last discrete element";

  Real hu_dyn_av[n-1];
  SI.Density rho_v_av[n-1];

  parameter SI.Height h = geometry.H/n "height of one discreet element";

protected
  Real f[n-1] "dimensionless factor for the discreet elements";
  Real f_in "dimensionless factor for the inlet";
  Real f_out "dimensionless factor for the outlet";
Real test= 0.05;
equation
//Gleichung aus Engel: Fluiddynamik in F�llk�rper- und Packungskolonnen ..., Gl. (10); in der Gleichung (3.13b) von Forner ist wohl ein Fehler (h_j)
//Volker Engel: "Fluiddynamik in F�llk�rper- und Packungskolonnen f�r
//Gas/Fl�ssigsysteme", Chemie Ingenieur Technik (72), S. 700-703
// die max-Abfrage braucht man, f�r den Fall, da� man die Kolonne leer initialisiert und das Inertgas nicht mit abbildet: in dem Fall w�rde sonst ein Volumenstrom in die falsche Richtung entstehen

for j in 1:n-1 loop
  hu_dyn_av[j] = (hu_dyn[j]+hu_dyn[j+1])/2;
  rho_v_av[j] = (rho_v_calc[j]+rho_v_calc[j+1])/2;
  d_L[j] = geometry.C_L*sqrt(6*sigma_l[j]/(rho_l_calc[j]-rho_v_av[j])/Modelica.Constants.g_n);
  f[j] = 8/geometry.zeta* (geometry.eps - hu_dyn_av[j])^4.65;
Vdot[j] =  max(0,sign(p[j]-p[j+1])*sqrt(abs(p[j]-p[j+1]) * f[j]/ (6*hu_dyn_av[j] / d_L[j] + geometry.a)/ rho_v_av[j] * (geometry.A_free)^2/h));
end for;

/*** outlet: half of the n-th discreet element ***/
  d_L_out = geometry.C_L*sqrt(6*sigma_l[n]/(rho_l_calc[n]-rho_v_calc[n])/Modelica.Constants.g_n);
  f_out = 8/geometry.zeta* (geometry.eps - hu_dyn[n])^4.65;
Vdot[n] =  max(0,sign(p[n]-p[n+1])*sqrt(max(1e-5,abs(p[n]-p[n+1])) * f_out/ (6*hu_dyn[n] / d_L_out + geometry.a)/ rho_v_calc[n] * (geometry.A_free)^2/(h/2)));

/*** entry: half of the first discreet element ***/
  d_L_in = geometry.C_L*sqrt(6*sigma_l[1]/(rho_l_calc[1]-rho_v_calc[1])/Modelica.Constants.g_n);
  f_in = 8/geometry.zeta* (geometry.eps - hu_dyn[1])^4.65;
p_v_in = p[1]+sign(Vdot_in)*Vdot_in*Vdot_in/(max(1e-10,f_in/ (6*hu_dyn[1] / d_L_in + geometry.a)/ rho_v_calc[1] * (geometry.A_free)^2))*(h/2);

  annotation (Documentation(info="<html>
<p>Correlation equals equation 10 from publication [1].</p>
<pre> 
<font style=\"color: #006400; \">[1] Volker&nbsp;Engel:&nbsp;&QUOT;Fluiddynamik&nbsp;in&nbsp;F&uuml;llk&ouml;rper-&nbsp;und&nbsp;Packungskolonnen&nbsp;f&uuml;r Gas/Fl&uuml;ssigsysteme&QUOT;,&nbsp;Chemie&nbsp;Ingenieur&nbsp;Technik&nbsp;(72),&nbsp;S.&nbsp;700-703</font></pre>
</html>"));
end Particlemodel;
