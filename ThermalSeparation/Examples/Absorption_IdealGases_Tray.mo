within ThermalSeparation.Examples;
model Absorption_IdealGases_Tray
  "absorption of ideal gases in water, using a packed column"
  //Lauftest: 1.2.
  //Lauftest: 25.1.
  //Lauftest: 12.1. (3s, Kevin)

ThermalSeparation.Components.SourcesSinks.SourceLiquid
                                              sourceLiquid(
    redeclare package MediumLiquid =
        ThermalSeparation.Media.WaterBasedLiquid.N2_O2_H2O,
    x={0,0,1},
    T=323.15)             annotation (Placement(transformation(extent={{-10,-10},
            {10,10}}, rotation=270,
        origin={8,88})));
ThermalSeparation.Components.SourcesSinks.SinkLiquid
                                            sinkLiquid(         redeclare
      package Medium = ThermalSeparation.Media.WaterBasedLiquid.N2_O2_H2O)
                      annotation (Placement(transformation(extent={{-10,-10},{10,
            10}},  rotation=270,
        origin={6,-30})));

ThermalSeparation.Components.SourcesSinks.SinkGas
                                         sinkGas(         redeclare package
      Medium = ThermalSeparation.Media.IdealGasMixtures.N2_H2O_O2, p=149910)
                annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=90,
        origin={-26,86})));

  ThermalSeparation.Components.SourcesSinks.SourceGas
                                             sourceGas_Vdot(
    redeclare package Medium =
        ThermalSeparation.Media.IdealGasMixtures.N2_H2O_O2,
    x={0.85,0.05,0.1},
    flowOption=ThermalSeparation.Components.SourcesSinks.Enumerations.FlowOption.FlowNdot,
    T=417.15)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},   rotation=90,
        origin={-26,-30})));

  Modelica.Blocks.Sources.Ramp ramp(
    duration=1,
    startTime=100,
    height=0,
    offset=450)
              annotation (Placement(transformation(extent={{-68,-64},{-48,-44}},
          rotation=0)));
  inner SystemTS systemTS
    annotation (Placement(transformation(extent={{-74,-8},{-54,12}})));

Components.Columns.TrayColumn                               column1(
    hasLiquidFeed=false,
    hasVapourFeed=false,
    redeclare package MediumVapour =
        ThermalSeparation.Media.IdealGasMixtures.N2_H2O_O2,
    nS=3,
    mapping={{1,1},{2,3},{3,2}},
    redeclare package MediumLiquid =
        ThermalSeparation.Media.WaterBasedLiquid.N2_O2_H2O,
    redeclare model Reaction = ThermalSeparation.Reaction.NoReaction,
    x_l_start_const={1e-5,1e-5,1 - 2e-5},
    x_v_start_const={0.96,0.02,0.02},
    redeclare model ThermoEquilibrium =
        ThermalSeparation.PhaseEquilibrium.RealGasActivityCoeffLiquid (factor_K=
           {0.8,0.8,0.8}),
    redeclare model PressureLoss =
        ThermalSeparation.PressureLoss.TrayColumn.DryHydrostatic,
    redeclare model HomotopyMethod =
        ThermalSeparation.Components.Columns.BaseClasses.Initialization.Homotopy.NoHomotopy,
    p_v_start_inlet=156000,
    p_v_start_outlet=152000,
    redeclare record Geometry = Geometry.PlateColumn.Geometry (d=2))
                         annotation (Placement(transformation(extent={{-34,18},
            {14,64}}, rotation=0)));

  ThermalSeparation.Components.SourcesSinks.AmbientHeatSink ambientHeatSink1
    annotation (Placement(transformation(extent={{32,30},{52,50}},rotation=0)));
equation
  connect(ramp.y, sourceGas_Vdot.Flow_in) annotation (Line(
      points={{-47,-54},{-44,-54},{-44,-40},{-30,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(column1.upStreamOut, sinkGas.gasPortIn) annotation (Line(
      points={{-26.8,61.7},{-26.8,68.85},{-26,68.85},{-26,76.4}},
      color={255,127,39},
      thickness=1,
      smooth=Smooth.None));
  connect(column1.downStreamIn, sourceLiquid.liquidPortOut) annotation (Line(
      points={{6.8,61.7},{6.8,68.85},{8,68.85},{8,76.6}},
      color={153,217,234},
      thickness=1,
      smooth=Smooth.None));
  connect(column1.heatPort, ambientHeatSink1.heatPort1) annotation (Line(
      points={{10.16,41},{20.08,41},{20.08,40},{30.4,40}},
      color={188,51,69},
      smooth=Smooth.None));
  connect(sinkLiquid.liquidPortIn, column1.downStreamOut) annotation (Line(
      points={{6,-20.4},{6.8,-20.4},{6.8,20.3}},
      color={153,217,234},
      thickness=1,
      smooth=Smooth.None));
  connect(sourceGas_Vdot.gasPortOut, column1.upStreamIn) annotation (Line(
      points={{-26,-18.6},{-26,20.3},{-26.8,20.3}},
      color={255,127,39},
      thickness=1,
      smooth=Smooth.None));
annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                    graphics),
    experiment(StopTime=60, Algorithm="Dassl"),
    experimentSetupOutput,
    Documentation(info="<html>
<p><ul>
<li> packed column</li>
<li> 3 components in vapour phase</li>
<li> 3 components in liquid phase</li>
<li> absorption</li>
</ul></p>
</html>"));
end Absorption_IdealGases_Tray;
