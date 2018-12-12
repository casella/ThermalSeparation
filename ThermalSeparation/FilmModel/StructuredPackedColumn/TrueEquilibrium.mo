within ThermalSeparation.FilmModel.StructuredPackedColumn;
model TrueEquilibrium "true equilibrium"
  import ThermalSeparation;

  extends BaseEquilibriumType; //for replaceability
  extends ThermalSeparation.FilmModel.BaseClasses.TrueEquilibrium(
       redeclare record BaseGeometry =           Geometry);
equation
    /***for equilibrium model of packed column: deviation from equilibrium calculated using HETP values***/

  for j in 1:n loop
    for i in 1:nSV loop
       x_v_star[j,i] =  x_v_star_eq[j,i];
    end for;
    end for;
end TrueEquilibrium;
