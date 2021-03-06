%% MSc Future Power Networks Thesis Code

% Name: Stefan Bajai
% Thesis Title: Impact of Domestic PV with Small Scale Storage Systems on the Distribution Network Operating Requirements and Performance
% Imperial College London 
% Department of Electrical & Electronics Engineering
% Date: August 2019

% Description of code: Simulates the IEEE European LV Test Feeder with 1-minute resolution PV profiles. The user is required to have OpenDSS installed to run this code and
% have all load and PV generation profiles available in the the same folder
% specified in the accompanying OpenDSS code. 

% Replicate Scenarios
% Step 1. Ensure OpenDSS & COM Engine is installed. 
% Step 2. Ensure all files in the repository
% (https://github.com/bajaiii/MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System.git)
% have been copied to the users hard drive. This repository also includes
% detailed steps on how to replicate scenarios. 
% Step 3. Execute this script. This script will prompt the user which
% Scenario they wish to replicate



% For full modelling methodology, please see Thesis report which can also
% be found on the repositiory listed above in PDF format. 

clear;
clc;
close all;

%% Personalised Matlab Colour Scheme
Colour1 = [0.2 0.8 1];
Colour2 = [0 .8 0];
Colour3 = [1 .5 1];
Colour4 = [1 .6 .4];
Colour5 = [1 0.35 0.35];
Colour6 = [153/255 51/255 1];
Colour7 = [25/255, 75/255, 1];
Colour8 = [51/255 1 51/255];
Colour9 = [1 .15 1];
Colour10 = [1 51/255 51/255];

%% Scenario ID - Used for tracking Scenario #

% Prompts the user to specify a scenario to simulate
UserPrompt = 'Which scenario do you want to simulate? Options are 1-10.  ';
UserAnswer = input(UserPrompt)

% Uses the users input to set up the simulation ID
if UserAnswer == 1

Scenario = 'Scenario 1 - %d.%d.%d %s';
ID1 = 4;
ID2 = 1;
ID3 = 1;
Season = 'Winter (No PV or Storage)';
NumberofPVSystems = 0;
NumberofBatterySystems = 0;

elseif UserAnswer == 2
    
Scenario = 'Scenario 2 - %d.%d.%d %s';
ID1 = 4;
ID2 = 1;
ID3 = 2;
Season = 'Summer (No PV or Storage)';
NumberofPVSystems =0;
NumberofBatterySystems =0;

elseif UserAnswer == 3
        
Scenario = 'Scenario 3 - %d.%d.%d %s';
ID1 = 4;
ID2 = 2;
ID3 = 1;
Season = 'Winter (50% PV, No Storage)';
NumberofPVSystems = length(1:2:55);
NumberofBatterySystems =0;

elseif UserAnswer == 4
        
Scenario = 'Scenario 4 - %d.%d.%d %s';
ID1 = 4;
ID2 = 2;
ID3 = 2;
Season = 'Summer (50% PV, No Storage)';
NumberofPVSystems = length(1:2:55);
NumberofBatterySystems =0;

elseif UserAnswer == 5
        
Scenario = 'Scenario 5 - %d.%d.%d %s';
ID1 = 4;
ID2 = 3;
ID3 = 1;
Season = 'Winter (100% PV, No Storage)';
NumberofPVSystems = 55;
NumberofBatterySystems = 0;

elseif UserAnswer == 6
        
Scenario = 'Scenario 6 - %d.%d.%d %s';
ID1 = 4;
ID2 = 3;
ID3 = 2;
Season = 'Summer (100% PV, No Storage)';
NumberofPVSystems = 55;
NumberofBatterySystems = 0;

elseif UserAnswer == 7
        
Scenario = 'Scenario 7 - %d.%d.%d %s';
ID1 = 4;
ID2 = 4;
ID3 = 1;
Season = 'Winter (50% PV, 50% Storage)';
NumberofPVSystems = length(1:2:55);
NumberofBatterySystems =length(1:2:55);

elseif UserAnswer == 8
        
Scenario = 'Scenario 8 - %d.%d.%d %s';
ID1 = 4;
ID2 = 4;
ID3 = 2;
Season = 'Summer (50% PV, 50% Storage)';
NumberofPVSystems = length(1:2:55);
NumberofBatterySystems =length(1:2:55);

elseif UserAnswer == 9
        
Scenario = 'Scenario 9 - %d.%d.%d %s';
ID1 = 4;
ID2 = 5;
ID3 = 1;
Season = 'Winter (100% PV, 100% Storage)';
NumberofPVSystems = 55;
NumberofBatterySystems = 55;

elseif UserAnswer == 10
        
Scenario = 'Scenario 10 - %d.%d.%d %s';
ID1 = 4;
ID2 = 5;
ID3 = 2;
Season = 'Summer (100% PV, 100% Storage)';
NumberofPVSystems = 55;
NumberofBatterySystems = 55;

else
        
ErrorMessage = 'Selection not valid. Please select a valid Scenario in integer format between 1-10.';

end

%%
% Starts OpenDSS Engine in MATLAB
[DSSStartOK, DSSObj, DSSText] = DSSStartup;

% Set up the interface variables
DSSCircuit = DSSObj.ActiveCircuit;
DSSSolution = DSSCircuit.Solution;

% % If an error appears saying dss files can't be found, uncomment the next
% % line and enter the path which the simulation files are in
% DSSText.command = 'Set DataPath = C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\OpenDSSScript'

%% Development of IEEE European LV Test Feeder Circuit in OpenDSS Using the COM interface

DSSText.command = 'clearall'; % Clears all variables in OpenDSS engine
DSSText.command = 'clear'; % Clears all variables in OpenDSS engine
DSSText.command = 'Set DefaultBaseFrequency = 50'; % Sets UK grid frequency

DSSText.command = 'New circuit.MastersThesis_StefanBajai_IEEE_TestFeeder'; %Gives circuit a name
% DSSText.command = 'set algorithm=newton';  % Changes solution method
% (default is fixed point iterative method)
DSSText.command = 'Edit Vsource.Source BasekV=11 pu=1 ISC3=3000  ISC1=1500'; % Defines source voltage (grid connection) 

DSSText.command = 'Redirect LineCodes.txt'; % gets cable definitions

% Defines different load shapes, PV shapes and battery shapes depending on
% user input previous input prompt. User input options are from 1-10 (in integer format)


if ID3 ==1 % If winter simulation use this load shape
DSSText.command = 'Redirect Winter_Load_Shapes.txt';
elseif ID3 ==2 % if summer simulation use this load shape
DSSText.command = 'Redirect Summer_Load_Shapes.txt';
else
ErrorMessage = 'ID3 is not correct.Check Code.';
end

% Defines all lines in the system
DSSText.command = 'Redirect Line_Definitions.txt.'; 

% Transformer definition
DSSText.command = 'New Transformer.TR1 Buses=[SourceBus 1] Conns=[Delta Wye] kVs=[11 0.416] kVAs=[800 800] XHL=4 sub=y';

% If Scenario 3 or 7 use these PV shapes
if (ID2 == 2 && ID3 ==1) ||(ID2 == 4 && ID3 ==1)
DSSText.command = 'Redirect Scenario_3_or_7_PV.txt';
end

% If Scenario 4 or 8 use these PV shapes
if (ID2 == 2 && ID3 ==2)||(ID2 == 4 && ID3 ==2)
DSSText.command = 'Redirect Scenario_4_or_8_PV.txt';
end

% If Scenario 5 or 9 use these PV shape
if (ID2 == 3 && ID3 ==1)||(ID2 == 5 && ID3 ==1)
DSSText.command = 'Redirect Scenario_5_or_9_PV.txt';
end

% If Scenario 6 or 10 use these PV shape
if (ID2 == 3 && ID3 ==2)||(ID2 == 5 && ID3 ==2)
DSSText.command = 'Redirect Scenario_6_or_10_PV.txt';
end

if (ID2 == 4 && ID3 ==1)
DSSText.command = 'Redirect Scenario_7_Battery_Loadshapes.txt';
end

%If Scenario 8 use this profile for the battery control mode
if (ID2 == 4 && ID3 ==2)
DSSText.command = 'Redirect Scenario_8_Battery_Loadshapes.txt';
end

%If Scenario 9 use this profile for the battery control mode
if (ID2 == 5 && ID3 ==1)
DSSText.command = 'Redirect Scenario_9_Battery_Loadshapes.txt';
end

%If Scenario 10 use this profile for the battery control mode
if (ID2 == 5 && ID3 ==2)
DSSText.command = 'Redirect Scenario_10_Battery_Loadshapes.txt';
end

% If scenario 3 or 7 use this PV Generator definition
if (ID2 == 2 && ID3 ==1) ||(ID2 == 4 && ID3 ==1)
DSSText.command = 'Redirect Scenario_3_or_7_PV_System_Definition_PV.txt';
end 

% If scenario 4 or 8 use this PV Generator definition
if (ID2 == 2 && ID3 ==2)||(ID2 == 4 && ID3 ==2)
DSSText.command = 'Redirect Scenario_4_or_8_PV_System_Definition_PV.txt';
end

% If scenario 5 or 9 use this PV Generator definition
if (ID2 == 3 && ID3 ==1)||(ID2 == 5 && ID3 ==1)
DSSText.command = 'Redirect Scenario_5_or_9_PV_System_Definition_PV.txt';
end

% If scenario 6 or 10 use this PV Generator definition
if (ID2 == 3 && ID3 ==2)||(ID2 == 5 && ID3 ==2)
DSSText.command = 'Redirect Scenario_6_or_10_PV_System_Definition_PV.txt';
end

% If scenario 7 or 8 use this Battery Storage Definition
if (ID2 == 4 && ID3 ==1)||(ID2 == 4 && ID3 ==2)
DSSText.command = 'Redirect Scenario_7_or_8_Battery_System_Definition.txt';
end

% If scenario 9 or 10 use this Battery Storage Definition
if (ID2 == 5 && ID3 ==1)||(ID2 == 5 && ID3 ==2)
DSSText.command = 'Redirect Scenario_9_or_10_Battery_System_Definition.txt';
end

%Load Definitions
DSSText.command = 'Redirect LoadDefinitions.txt'; 

%Used for checking TF primitive matrix calculations
%%DSSText.command = 'dump transformer.TR1 debug ';
                                                                        
% Sets voltage bases for system (Operational value for UK used...i.e
% 416 Three-phase)
DSSText.command = 'Set voltagebases=[11  .416]';
DSSText.command = 'Calcvoltagebases';
DSSText.command = 'buscoords buscoords.txt';

%%
% DSSText.command = 'batchedit Storage..* debugtrace=y'; %used for
% debugging storage elements (Not necessary)

% Sets min and max voltages before storage converts to constant impedance
% model (should be done for voltage studies) 
DSSText.command = 'batchedit storage..* Vmaxpu=1.15 Vminpu=0.85'; 

%%% User can manually change  the max rated energy storage capacity rating for all battery
%%% elements in the circuit by uncommenting the next line
% DSSText.command = 'batchedit storage..* kWhRated=50'; 
% 
%%% User can manually change  the maximum power rating for all battery
%%% elements in the circuit by uncommenting the next line
% DSSText.command = 'batchedit storage..* kWRated=20'; 

% No storage reserve (i.e does not begin charging when storage hits the
% reserve %) for any storage element and defines the intial state of charge for all storage elements
% as 50%
DSSText.command = 'batchedit storage..* %reserve=0 %stored=50';

% DSSText.command= 'set miniterations = 5'    %  Sets minimum iterations to solve at
% %each time step - Default is 2 but reduced to 1 in time sequential study to
% %improve speed

% DSSText.command= 'algortihm = newton'    % Changes solve method to Newton

% Sets simulation mode (quasi static one day simulation)
DSSText.command= 'set mode=yearly number= 1440 stepsize=1m';    % Sets up one day simulation

% sets the solve command to only solve for 1 time interval (1-minute)
DSSText.Command = 'Set number = 1';  

%%
NodeNames = DSSCircuit.AllNodeNames;        % Returns Node Names
BusNames = DSSCircuit.AllBusNames;          % Returns Bus Names
ElementNames = DSSCircuit.AllElementNames;  % Returns Circuit Element Names
NumberofCircuitElements = DSSCircuit.NumCktElements; % Counts number of elements in circuit
% DSSText.Command ='Buscoords Buscoords.dat   ! load in bus coordinates'; %Returns coordinates of buses


%% Preallocation of matrices for speed
V1 = zeros(1440,907); % (1440 minutes and 907 buses)
V2 = zeros(1440,907);
V3 = zeros(1440,907);
ComplexVolts = zeros(1440,5442);
CircuitLosses = zeros(1440,2);
TransformerLosses = zeros(1440,2);
GridPower = zeros(1440,2);
PVInjectedPowers = zeros(1440,NumberofPVSystems);
ActiveBatteryPowers = zeros(1440,NumberofBatterySystems);
ReactiveBatteryPowers = zeros(1440,NumberofBatterySystems);
ActiveLoadPowers = zeros(1440,55);
ReactiveLoadPowers = zeros(1440,55);
LineLosses = zeros(1440,2);
TransformerPower = zeros(1440,16);
ElementLosses = zeros(1440,2*NumberofCircuitElements);

% Loop to extract power flow solution at each time step
    for i=1:1440  %1440 mins in one day
        
        DSSSolution.Solve;  % solves the circuit at one time interval
       
        V1(i,:) = DSSCircuit.AllNodeVmagPUByPhase(1); % Gets P.U RMS voltage magnitudes
        V2(i,:) = DSSCircuit.AllNodeVmagPUByPhase(2);
        V3(i,:) = DSSCircuit.AllNodeVmagPUByPhase(3);
    
        ComplexVolts(i,:) = DSSCircuit.AllBusVolts;          % Stores all complex voltages at each bus fir this time step
        CircuitLosses(i,:) = DSSCircuit.Losses;              % Stores entire circuit losses (Watt and Var) 
        LineLosses(i,:) = DSSCircuit.LineLosses;             % Stores all losses in line elements line losses (Watt and Var)
        ElementLosses(i,:) = DSSCircuit.AllElementLosses;    % Stores all circuit element losses (Watt and Var)
    
        TransformerLosses(i,:) = DSSCircuit.SubstationLosses;% Stores all transformer losses at each time step
        GridPower(i,:) = DSSCircuit.TotalPower;              % Stores total Power supplied/injected from/to grid (kW and kVar) at each time step
        
        DSSCircuit.SetActiveElement(['Transformer.tr1']);    % Sets transformer to active element
        TransformerPower(i,:) = DSSCircuit.ActiveCktElement.Powers;% Stores all transformer powers at each time step
     
% Stores all injected PV powers, load and battery powers at each time step


% If scenario 3,4, 7 or 8 get pv powers like so
if (ID2 == 2 && ID3 ==1)||(ID2 == 2 && ID3 ==2)||(ID2 == 4 && ID3 ==1)||(ID2 == 4 && ID3 ==2)
    k=1;
    for count=1:2:55  
    DSSCircuit.SetActiveElement(['PVSystem.pv_sys_' num2str(count)]);
    PVInjectedPowers(i,count) = DSSCircuit.ActiveCktElement.Powers(:,1); % (no reactive power from PV i.e PF=1)
    k=k+1;
    end
end

% if scenario 5, 6, 9, 10 get pv powers like so
if (ID2 == 3 && ID3 ==1)||(ID2 == 3 && ID3 ==2)||(ID2 == 5 && ID3 ==1)||(ID2 == 5 && ID3 ==2)
    k=1;
    for count=1:55  
    DSSCircuit.SetActiveElement(['PVSystem.pv_sys_' num2str(count)]);
    PVInjectedPowers(i,k) = DSSCircuit.ActiveCktElement.Powers(:,1); % (no reactive power from PV i.e PF=1)
    k=k+1;
    end
end

%for all loads get powers
for count=1:55  
   
    DSSCircuit.SetActiveElement(['Load.load' num2str(count)]);
    ActiveLoadPowers(i,count) = DSSCircuit.ActiveCktElement.Powers(:,1);
    ReactiveLoadPowers(i,count) = DSSCircuit.ActiveCktElement.Powers(:,2);
    
end


 % If scenario 7 or 8 get Battery powers    
 if (ID2 == 4 && ID3 ==1)||(ID2 == 4 && ID3 ==2) 
    k=1;
    for count=1:2:55
    DSSCircuit.SetActiveElement(['Storage.battery' num2str(count)]);
    ActiveBatteryPowers(i,k) = DSSCircuit.ActiveCktElement.Powers(:,1);
    ReactiveBatteryPowers(i,k) = DSSCircuit.ActiveCktElement.Powers(:,2);
    k=k+1;
    end
 end
 
 %If scenario 9 or 10 get Battery powers
  if (ID2 == 5 && ID3 ==1)||(ID2 == 5 && ID3 ==2)    
    k=1;
    for count=1:55
    DSSCircuit.SetActiveElement(['Storage.battery' num2str(count)]);
    ActiveBatteryPowers(i,k) = DSSCircuit.ActiveCktElement.Powers(:,1);
    ReactiveBatteryPowers(i,k) = DSSCircuit.ActiveCktElement.Powers(:,2);
    k=k+1;
    end
  end

    end
  
    %% Organises Transformer Powers

TransformerActivePower = TransformerPower(:,1) + TransformerPower(:,3) + TransformerPower(:,5); %3-Phase Transformer Active Power
TransformerReactivePower = TransformerPower(:,2) + TransformerPower(:,4) + TransformerPower(:,6);%3-Phase Transformer Reactive Power
TransformerApparentPower = abs(TransformerActivePower + j*TransformerReactivePower);
    
% DSSText.command= 'Set Year=1 ';
    

%% PV POWERS VS BATTERY POWERS VS LOAD POWERS

% Preallocation of matrices for speed
AggregetedActiveLoadPowers = zeros(1440,1);
AggregatedActivePVPowers = zeros(1440,1);
AggregatedActiveBatteryPowers = zeros(1440,1);

[ROWS, COLS] = size(ActiveLoadPowers);

% Get aggragated powers
for i=1:ROWS
    
        AggregetedActiveLoadPowers(i,:) = sum(ActiveLoadPowers(i,:),'all');

        if (ID2 == 2) || (ID2 == 3) || (ID2 == 4) || (ID2 == 5)
        AggregatedActivePVPowers(i,:) = sum(PVInjectedPowers(i,:),'all');
        end

        if (ID2 == 4) || (ID2 == 5)
        AggregatedActiveBatteryPowers(i,:) = sum(ActiveBatteryPowers(i,:),'all');
        end
        
end
        

%AggragatedLoadPowers - abs(AggragatedPVPowers) +abs(AggragatedBatteryPowers); 

Aggragated_Powers_Figure = figure('Name', ['Aggragated Powers ', sprintf(Scenario,ID1,ID2,ID3,Season) ]);
plot((1:ROWS)/60,AggregetedActiveLoadPowers,'LineWidth',1,'color',Colour1);
hold on
plot((1:ROWS)/60,AggregatedActivePVPowers,'LineWidth',1,'color',Colour2);
plot((1:ROWS)/60,AggregatedActiveBatteryPowers,'LineWidth',1,'color',Colour3);
plot((1:ROWS)/60,TransformerActivePower,'LineWidth',1,'color',Colour4);

InSet = get(gca, 'TightInset');
set(gca, 'Position', [InSet(1)+0.08,InSet(2)+0.05, 1-InSet(1)-InSet(3)-0.14, 1-InSet(2)-InSet(4)-0.13]);

%%--%%--%%--PLOT STYLING--%%--%%--%%
set(gca, 'FontName', 'Times New Roman','FontSize',8,'TickLength', [.03 .03] ,'XMinorTick', 'on','YMinorTick'  , 'on')
grid on;
grid minor;
ylabel('Active Power (kW)','fontweight','bold','FontSize',8)
ylim([min(AggregatedActivePVPowers)-45, max(AggregetedActiveLoadPowers)+10])
xlabel('Hour','fontweight','bold','FontSize',8)
xlim([0 ROWS/60])
title({'Aggregated PV, Load, Transformer & Storage Powers' sprintf(Scenario,ID1,ID2,ID3,Season)},'FontSize',8)
legend({'Loads','PVs','Batteries','Transformer'},'location','southwest','AutoUpdate','off','NumColumns',2)
% %%--%%--%%--PLOT STYLING--%%--%%--%%

    
%% Plots Bar Chart of Circuit Losses

TotalActiveLineLosses = sum(LineLosses(:,1)/60,'all');
TotalReactiveLineLosses = sum(LineLosses(:,2)/60,'all');

TotalActiveTransformerLosses = sum(TransformerLosses(:,1)/60,'all');
TotalReactiveTransformerLosses = sum(TransformerLosses(:,2)/60,'all');

TotalActiveLossesPlot = TotalActiveLineLosses + TotalActiveTransformerLosses;
TotalReactiveLossesPlot = TotalReactiveLineLosses + TotalReactiveTransformerLosses;

%Sets up data for stacked plot
StackedTotalLossesPower = [TotalActiveLineLosses,        TotalReactiveLineLosses; 
                           TotalActiveTransformerLosses, TotalReactiveTransformerLosses;
                           TotalActiveLossesPlot         TotalReactiveLossesPlot];
                       
StackedBarLossesFigure = figure('Name', ['Stacked Bar Chart Losses ', sprintf(Scenario,ID1,ID2,ID3,Season) ]);
StackedBarLosses = bar(StackedTotalLossesPower,'stacked','LineWidth',2);
set(StackedBarLosses(1), 'FaceColor', Colour1,'LineWidth',2,'EdgeColor','none');
set(StackedBarLosses(2), 'FaceColor', Colour2,'LineWidth',2,'EdgeColor','none');
InSet = get(gca, 'TightInset');
set(gca, 'Position', [InSet(1)+0.05,InSet(2), 1-InSet(1)-InSet(3)-0.07, 1-InSet(2)-InSet(4)-0.1]);

%%--%%--%%--PLOT STYLING--%%--%%--%%
set(gca, 'FontName', 'Times New Roman','FontSize',8,'TickLength', [.03 .03] ,'XMinorTick', 'on','YMinorTick'  , 'on')
grid on;
grid minor;
ylabel('Apparent Energy Losses (kVA hours)','fontweight','bold','FontSize',8)
title({'Total Transformer & Line Energy Losses - ELVTF ' sprintf(Scenario,ID1,ID2,ID3,Season)},'FontSize',8)
legend({'Active Energy Losses (kWh)','Reactive Energy Losses (kVArh)'},'location','east','AutoUpdate','off')
set(gca,'XTickLabel',{'All Lines','Transformer', 'Total Losses'});
% %%--%%--%%--PLOT STYLING--%%--%%--%%



%% Plots Bar Chart of Transformer & Grid Energy

% Preallocation of matrices for speed
ActiveGridPower = zeros(1440,1);
ReactiveGridPower = zeros(1440,1);

% Takes only positive values of grid power (if injected into system) at
% each time step
for i=1:length(GridPower)
    
    % if positive active grid power then store it otherwise 0
    if - GridPower(i,1)>0
        ActiveGridPower(i) = abs(GridPower(i,1));
    else
        ActiveGridPower(i) = 0;
    end
    
    % if positive reactive grid power then store it otherwise 0
    if - GridPower(i,2)>0
        ReactiveGridPower(i) = abs(GridPower(i,2));
    else
        ReactiveGridPower(i) = 0;
    end
    
    if GridPower(i,1)>0
        ActiveReversePowerFlow(i) = abs(GridPower(i,1));
    else
        ActiveReversePowerFlow(i) = 0;
    end
end

ActiveReverseEnergy = sum(abs(ActiveReversePowerFlow)/60,'all')


PVActiveEnergyGeneration = abs(sum(AggregatedActivePVPowers/60,'all'))
PVReactiveEnergyGeneration = 0;

TotalActiveTransformerEnergy = sum(abs(TransformerActivePower/60),'all');
TotalReactiveTransformerEnergy = sum(abs(TransformerReactivePower)/60,'all');

TotalActiveGridEnergy = abs(sum(ActiveGridPower/60,'all'))
TotalReactiveGridEnergy = abs(sum(ReactiveGridPower/60,'all'));

ActiveLoadEnergy = abs(sum(ActiveLoadPowers/60,'all'))
ReactiveLoadEnergy = 0;

%Sets up data for stacked plot
StackedTotalEnergy = [TotalActiveTransformerEnergy,        TotalReactiveTransformerEnergy; 
                           TotalActiveGridEnergy,               TotalReactiveGridEnergy;
                           PVActiveEnergyGeneration,            PVReactiveEnergyGeneration
                           ActiveLoadEnergy                     ReactiveLoadEnergy];
                       
StackedBarENERGYFigure = figure('Name', ['Stacked Bar Chart Energy ', sprintf(Scenario,ID1,ID2,ID3,Season) ]);
StackedBarEnergy = bar(StackedTotalEnergy,'stacked','LineWidth',2);
set(StackedBarEnergy(1), 'FaceColor', Colour1,'LineWidth',2,'EdgeColor','none');
set(StackedBarEnergy(2), 'FaceColor', Colour2,'LineWidth',2,'EdgeColor','none');
InSet = get(gca, 'TightInset');
set(gca, 'Position', [InSet(1)+0.06,InSet(2), 1-InSet(1)-InSet(3)-0.08, 1-InSet(2)-InSet(4)-0.1]);

%%--%%--%%--PLOT STYLING--%%--%%--%%
set(gca, 'FontName', 'Times New Roman','FontSize',8,'TickLength', [.03 .03] ,'XMinorTick', 'on','YMinorTick'  , 'on')
grid on;
grid minor;
ylabel('Apparent Energy (kVA hours)','fontweight','bold','FontSize',8)
title({'Energy supplied by Grid, PVs & on Transformer' sprintf(Scenario,ID1,ID2,ID3,Season)},'FontSize',8)
legend({'Active Energy (kWh)','Reactive Energy (kVArh)'},'location','southwest','AutoUpdate','off')
set(gca,'XTickLabel',{'Transformer','Grid','PVs','Loads'});
% %%--%%--%%--PLOT STYLING--%%--%%--%%


%% Gets the phase to ground voltage magnitudes at every load

Load_Information = readtable('IEEE_LV_TEST_FEEDER_Load_Info.csv');
Loads_Connected_to_Bus_No = Load_Information(2,2:end);
Loads_Connected_to_Bus_No = table2array(Loads_Connected_to_Bus_No);

% Preallocation of matrices for speed
V1Loads =zeros(1440,55);
V2Loads =zeros(1440,55);
V3Loads =zeros(1440,55);

 i=1;
    for k = Loads_Connected_to_Bus_No
        %Gets the phase to ground voltage magnitudes at every load
        V1Loads(:,i) = V1(:,k);
        V2Loads(:,i) = V2(:,k);
        V3Loads(:,i) = V3(:,k);
        i=i+1;
    end
    
%% Calculates voltage unbalance at each node

% Preallocation of matrices for speed
V1XCoor = zeros(1440,907);
V1YCoor = zeros(1440,907);
V2XCoor = zeros(1440,907);
V2YCoor = zeros(1440,907);
V3XCoor = zeros(1440,907);
V3YCoor = zeros(1440,907);

%Sorts Complex Bus Voltages
[CMPLXROWS, CMPLXCOLS] = size(ComplexVolts);
count =1; %should be 907 
for i=1:6:CMPLXCOLS

    V1XCoor(:,count) = ComplexVolts(:,i);
    V1YCoor(:,count) = ComplexVolts(:,i+1);
    V2XCoor(:,count) = ComplexVolts(:,i+2);
    V2YCoor(:,count) = ComplexVolts(:,i+3);
    V3XCoor(:,count) = ComplexVolts(:,i+4);
    V3YCoor(:,count) = ComplexVolts(:,i+5);
    count = count+1;

end

V1COMPLEXBUS = V1XCoor+j*V1YCoor;
V2COMPLEXBUS = V2XCoor+j*V2YCoor;
V3COMPLEXBUS = V3XCoor+j*V3YCoor;

% Preallocation of matrices for speed
V1COMPLEXLoads = zeros(1440,55);
V2COMPLEXLoads = zeros(1440,55);
V3COMPLEXLoads = zeros(1440,55);

 i=1; %initialisation
    for k = Loads_Connected_to_Bus_No
        %Gets the phase to ground complexvoltage magnitudes at every load
        V1COMPLEXLoads(:,i) = V1COMPLEXBUS(:,k);
        V2COMPLEXLoads(:,i) = V2COMPLEXBUS(:,k);
        V3COMPLEXLoads(:,i) = V3COMPLEXBUS(:,k);
        i=i+1;
    end

a_Fortescue = -0.5 + j*(sqrt(3)/2); % Fortescue's operator

Numerator = abs(V1COMPLEXLoads + ((a_Fortescue^2).*V2COMPLEXLoads) + (a_Fortescue.*V3COMPLEXLoads));
Denominator = abs(V1COMPLEXLoads + (a_Fortescue.*V2COMPLEXLoads) +((a_Fortescue^2).*V3COMPLEXLoads));
Unbalance = (Numerator./Denominator)*100; %definition of Voltage Unbalance according to IEC 61000-3-14)

%%
%-%-%-%-%-%-----Unbalance (%) at each Load Plot-----%-%-%-%-%-%

% Gets size of V1 Mag Matrix
[ROWS, COLUMNS] = size(Unbalance);

% Sets x and y axis
Minutes = [(1:ROWS)/60]';
LoadNumbers = [1:COLUMNS]';

% Sets up meshgrid
[x, y] = meshgrid(Minutes,LoadNumbers);

%3D Surface Plot 
UnbalancePlotFigure = figure('Name', ['Unabalance(%) at all loads (IEC 61000) ', sprintf(Scenario,ID1,ID2,ID3,Season) ]);
UnbalancePlot = surf(x,y,(Unbalance)','EdgeColor','none','LineWidth',0.1);
hold on 

InSet = get(gca, 'TightInset');
set(gca, 'Position', [InSet(1)+0.08,InSet(2)+0.05, 1-InSet(1)-InSet(3)-0.13, 1-InSet(2)-InSet(4)-0.22]);

%%--%%--%%--PLOT STYLING--%%--%%--%%
set(gca, 'FontName', 'Times New Roman','FontSize',8,'TickLength', [.03 .03] ,'XMinorTick', 'on','YMinorTick'  , 'on')
% set(gca,'zscale','log')
% grid on;
colormap(jet)
shading interp
grid minor;
title({'Unbalance at all Loads', '(IEC 61000-3-14 Definition) (1-Min Resolution)' sprintf(Scenario,ID1,ID2,ID3,Season)})
xlabel('Hour')
xlim([0 ROWS/60])
ylabel('Load #')
ylim([0 COLUMNS])
zlabel('Unbalance (%)')
zlim([0, 1])

%%--%%--%%--PLOT STYLING--%%--%%--%%

%%
%-%-%-%-%-%-----Voltage-to-Ground Plot Phase A Vs. Loads-----%-%-%-%-%-%

% Gets size of V1 Mag Matrix
[ROWS, COLUMNS] = size(V1Loads);

% Sets x and y axis
Minutes = [(1:ROWS)/60]';
BusNumbers = [1:COLUMNS]';

% Sets up meshgrid
[x, y] = meshgrid(Minutes,BusNumbers);

%3D Surface Plot 
V1_3D_PLOTFigure = figure('Name', ['Phase A Voltage at all Loads ', sprintf(Scenario,ID1,ID2,ID3,Season) ]);
V1_3D_PLOT = surf(x,y,(V1Loads*240)','EdgeColor','none','LineWidth',0.1);
hold on 

view(-38,10)
InSet = get(gca, 'TightInset');
set(gca, 'Position', [InSet(1)+0.06,InSet(2)+0.08, 1-InSet(1)-InSet(3)-0.09, 1-InSet(2)-InSet(4)-0.25]);

%%--%%--%%--PLOT STYLING--%%--%%--%%
set(gca, 'FontName', 'Times New Roman','FontSize',8,'TickLength', [.03 .03] ,'XMinorTick', 'on','YMinorTick'  , 'on')
% grid on;
colormap(jet)
shading interp
grid minor;
title({'Phase A Voltage-to-Ground Magnitude', 'at all Loads (1-Min Resolution)' sprintf(Scenario,ID1,ID2,ID3,Season)})
xlabel('Hour')
xlim([0 ROWS/60])
ylabel('Load #')
ylim([0 COLUMNS])
zlabel('Voltage Magnitude Phase A to Ground (V)')
% zlim([0.95 1.01])
%%--%%--%%--PLOT STYLING--%%--%%--%%

%% X-Axis View of VA
%-%-%-%-%-%-----Voltage-to-Ground Plot Phase A Vs. Loads-----%-%-%-%-%-%

% Gets size of V1 Mag Matrix
[ROWS, COLUMNS] = size(V1Loads);

% Sets x and y axis
Minutes = [(1:ROWS)/60]';
BusNumbers = [1:COLUMNS]';

% Sets up meshgrid
[x, y] = meshgrid(Minutes,BusNumbers);

%3D Surface Plot 
V1_3D_PLOTFigure2 = figure('Name', ['Phase A Voltage at all Loads X-Axis', sprintf(Scenario,ID1,ID2,ID3,Season) ]);
V1_3D_PLOT2 = surf(x,y,(V1Loads*240)','EdgeColor','none','LineWidth',0.1);
hold on 

view(0,0)
InSet = get(gca, 'TightInset');
set(gca, 'Position', [InSet(1)+0.06,InSet(2)+0.08, 1-InSet(1)-InSet(3)-0.12, 1-InSet(2)-InSet(4)-0.25]);


%%--%%--%%--PLOT STYLING--%%--%%--%%
set(gca, 'FontName', 'Times New Roman','FontSize',8,'TickLength', [.03 .03] ,'XMinorTick', 'on','YMinorTick'  , 'on')
% grid on;
colormap(jet)
shading interp
grid minor;
title({'Phase A Voltage-to-Ground Magnitude', 'at all Loads (1-Min Resolution)' sprintf(Scenario,ID1,ID2,ID3,Season)})
xlabel('Hour')
xlim([0 ROWS/60])
ylabel('Load #')
ylim([0 COLUMNS])
zlabel('Voltage Magnitude Phase A to Ground (V)')
% zlim([0.95 1.01])
%%--%%--%%--PLOT STYLING--%%--%%--%%

%%
%-%-%-%-%-%-----Voltage-to-Ground Plot Phase B Vs. Loads-----%-%-%-%-%-%

% Gets size of V1 Mag Matrix
[ROWS, COLUMNS] = size(V2Loads);

% Sets x and y axis
Minutes = [(1:ROWS)/60]';
BusNumbers = [1:COLUMNS]';

% Sets up meshgrid
[x, y] = meshgrid(Minutes,BusNumbers);

%3D Surface Plot 
V2_3D_PLOTFigure = figure('Name', ['Phase B Voltage at all Loads ', sprintf(Scenario,ID1,ID2,ID3,Season) ]);
V2_3D_PLOT = surf(x,y,(V2Loads*240)','EdgeColor','none','LineWidth',0.1);
hold on 

view(-38,10)
InSet = get(gca, 'TightInset');
set(gca, 'Position', [InSet(1)+0.06,InSet(2)+0.08, 1-InSet(1)-InSet(3)-0.09, 1-InSet(2)-InSet(4)-0.25]);

%%--%%--%%--PLOT STYLING--%%--%%--%%
set(gca, 'FontName', 'Times New Roman','FontSize',8,'TickLength', [.03 .03] ,'XMinorTick', 'on','YMinorTick'  , 'on')
% grid on;
colormap(jet)
shading interp
grid minor;
title({'Phase B Voltage-to-Ground Magnitude', 'at all Loads (1-Min Resolution)' sprintf(Scenario,ID1,ID2,ID3,Season)})
xlabel('Hour')
xlim([0 ROWS/60])
ylabel('Load #')
ylim([0 COLUMNS])
zlabel('Voltage Magnitude Phase B to Ground (V)')
% zlim([0.95 1.01])
%%--%%--%%--PLOT STYLING--%%--%%--%%

%% X-Axis View of VB
%-%-%-%-%-%-----Voltage-to-Ground Plot Phase B Vs. Loads-----%-%-%-%-%-%

% Gets size of V2 Mag Matrix
[ROWS, COLUMNS] = size(V2Loads);

% Sets x and y axis
Minutes = [(1:ROWS)/60]';
BusNumbers = [1:COLUMNS]';

% Sets up meshgrid
[x, y] = meshgrid(Minutes,BusNumbers);

%3D Surface Plot 
V2_3D_PLOTFigure2 = figure('Name', ['Phase B Voltage at all Loads X-Axis', sprintf(Scenario,ID1,ID2,ID3,Season) ]);
V2_3D_PLOT2 = surf(x,y,(V2Loads*240)','EdgeColor','none','LineWidth',0.1);
hold on 

view(0,0)
InSet = get(gca, 'TightInset');
set(gca, 'Position', [InSet(1)+0.06,InSet(2)+0.08, 1-InSet(1)-InSet(3)-0.12, 1-InSet(2)-InSet(4)-0.25]);


%%--%%--%%--PLOT STYLING--%%--%%--%%
set(gca, 'FontName', 'Times New Roman','FontSize',8,'TickLength', [.03 .03] ,'XMinorTick', 'on','YMinorTick'  , 'on')
% grid on;
colormap(jet)
shading interp
grid minor;
title({'Phase B Voltage-to-Ground Magnitude', 'at all Loads (1-Min Resolution)' sprintf(Scenario,ID1,ID2,ID3,Season)})
xlabel('Hour')
xlim([0 ROWS/60])
ylabel('Load #')
ylim([0 COLUMNS])
zlabel('Voltage Magnitude Phase B to Ground (V)')
%%--%%--%%--PLOT STYLING--%%--%%--%%

%%
%-%-%-%-%-%-----Voltage-to-Ground Plot Phase C Vs. Loads-----%-%-%-%-%-%

% Gets size of V1 Mag Matrix
[ROWS, COLUMNS] = size(V3Loads);

% Sets x and y axis
Minutes = [(1:ROWS)/60]';
BusNumbers = [1:COLUMNS]';

% Sets up meshgrid
[x, y] = meshgrid(Minutes,BusNumbers);

%3D Surface Plot 
V3_3D_PLOTFigure = figure('Name', ['Phase C Voltage at all Loads ', sprintf(Scenario,ID1,ID2,ID3,Season) ]);
V3_3D_PLOT = surf(x,y,(V3Loads*240)','EdgeColor','none','LineWidth',0.1);
hold on 

view(-38,10)
InSet = get(gca, 'TightInset');
set(gca, 'Position', [InSet(1)+0.06,InSet(2)+0.08, 1-InSet(1)-InSet(3)-0.09, 1-InSet(2)-InSet(4)-0.25]);

%%--%%--%%--PLOT STYLING--%%--%%--%%
set(gca, 'FontName', 'Times New Roman','FontSize',8,'TickLength', [.03 .03] ,'XMinorTick', 'on','YMinorTick'  , 'on')
% grid on;
colormap(jet)
shading interp
grid minor;
title({'Phase C Voltage-to-Ground Magnitude', 'at all Loads (1-Min Resolution)' sprintf(Scenario,ID1,ID2,ID3,Season)})
xlabel('Hour')
xlim([0 ROWS/60])
ylabel('Load #')
ylim([0 COLUMNS])
zlabel('Voltage Magnitude Phase C to Ground (V)')
% zlim([0.95 1.01])
%%--%%--%%--PLOT STYLING--%%--%%--%%

%% X-Axis View of VC
%-%-%-%-%-%-----Voltage-to-Ground Plot Phase B Vs. Loads-----%-%-%-%-%-%

% Gets size of V2 Mag Matrix
[ROWS, COLUMNS] = size(V3Loads);

% Sets x and y axis
Minutes = [(1:ROWS)/60]';
BusNumbers = [1:COLUMNS]';

% Sets up meshgrid
[x, y] = meshgrid(Minutes,BusNumbers);

%3D Surface Plot 
V3_3D_PLOTFigure2 = figure('Name', ['Phase C Voltage at all Loads X-Axis', sprintf(Scenario,ID1,ID2,ID3,Season) ]);
V3_3D_PLOT2 = surf(x,y,(V3Loads*240)','EdgeColor','none','LineWidth',0.1);
hold on 

view(0,0)
InSet = get(gca, 'TightInset');
set(gca, 'Position', [InSet(1)+0.06,InSet(2)+0.08, 1-InSet(1)-InSet(3)-0.12, 1-InSet(2)-InSet(4)-0.25]);


%%--%%--%%--PLOT STYLING--%%--%%--%%
set(gca, 'FontName', 'Times New Roman','FontSize',8,'TickLength', [.03 .03] ,'XMinorTick', 'on','YMinorTick'  , 'on')
% grid on;
colormap(jet)
shading interp
grid minor;
title({'Phase C Voltage-to-Ground Magnitude', 'at all Loads (1-Min Resolution)' sprintf(Scenario,ID1,ID2,ID3,Season)})
xlabel('Hour')
xlim([0 ROWS/60])
ylabel('Load #')
ylim([0 COLUMNS])
zlabel('Voltage Magnitude Phase C to Ground (V)')
%%--%%--%%--PLOT STYLING--%%--%%--%%

%% True Transformer Loading Power Plot

TransformerLoadingFig = figure('Name', ['Transformer Loading ', sprintf(Scenario,ID1,ID2,ID3,Season) ]);
bar((1:ROWS)/60,TransformerApparentPower,'LineWidth',1,'Facecolor',Colour1)
hold on
bar((1:ROWS)/60,TransformerActivePower,'LineWidth',1,'FaceColor',Colour2)
bar((1:ROWS)/60,TransformerReactivePower,'LineWidth',1,'Facecolor',Colour3)

InSet = get(gca, 'TightInset');
set(gca, 'Position', [InSet(1)+0.07,InSet(2)+0.06, 1-InSet(1)-InSet(3)-0.15, 1-InSet(2)-InSet(4)-0.15]);

%%--%%--%%--PLOT STYLING--%%--%%--%%
set(gca, 'FontName', 'Times New Roman','FontSize',8,'TickLength', [.03 .03] ,'XMinorTick', 'on','YMinorTick'  , 'on')
grid on;
grid minor;
ylabel('Transformer Loading (Active & Reactive Power)','fontweight','bold','FontSize',8)
ylim([min(TransformerActivePower)-65, max(TransformerApparentPower)+10])
xlabel('Hour','fontweight','bold','FontSize',8)
xlim([0 ROWS/60])
title({'Transformer Loading (Active & Reactive Power) - ELVTF ' sprintf(Scenario,ID1,ID2,ID3,Season)},'FontSize',8)
legend({'Apparent Power (kVA) (Magnitude)','Active Power (kW)','Reactive Power (kVAr)'},'location','southwest','FontSize',8,'AutoUpdate','off')
% %%--%%--%%--PLOT STYLING--%%--%%--%%


%% Transformer Energy Plot

[ROWS, COLUMNS] = size(TransformerActivePower);

CumulativeTransformerEnergy_kWh =zeros(ROWS,1);

% Stores cumulative energy over the day
for c = 1:ROWS
    
    if c==1
    CumulativeTransformerEnergy_kWh(c) = abs(TransformerActivePower(c)/60);
    end
    
    if c >1
    CumulativeTransformerEnergy_kWh(c) = abs(TransformerActivePower(c)/60) + CumulativeTransformerEnergy_kWh(c-1);
    end
    
end

CumulativeEnergyFigure = figure('Name', ['Cumulative Transformer Energy ', sprintf(Scenario,ID1,ID2,ID3,Season) ]);
plot((1:ROWS)/60,CumulativeTransformerEnergy_kWh,'LineWidth',2,'color',Colour1);


%%--%%--%%--PLOT STYLING--%%--%%--%%
set(gca, 'FontName', 'Times New Roman','FontSize',8,'TickLength', [.03 .03] ,'XMinorTick', 'on','YMinorTick'  , 'on')
grid on;
grid minor;
ylabel('Transformer Cumulative Energy (kWh)','fontweight','bold','FontSize',8)
xlabel('Hour','fontweight','bold','FontSize',8)
xlim([0 ROWS/60])
title({'Transformer Cumulative Energy Vs. Time - ELVTF ' sprintf(Scenario,ID1,ID2,ID3,Season)},'FontSize',8)
% legend({'Active Power(kW)'},'location','northwest','AutoUpdate','off')
% %%--%%--%%--PLOT STYLING--%%--%%--%%


%% Transformer Energy BARCHART Plot

TransformerEnergyTimeFig = figure('Name', ['Transformer Energy Vs. Time ', sprintf(Scenario,ID1,ID2,ID3,Season) ]);
bar((1:ROWS)/60,abs(TransformerActivePower/60),'FaceColor',Colour1)

%%--%%--%%--PLOT STYLING--%%--%%--%%
set(gca, 'FontName', 'Times New Roman','FontSize',8,'TickLength', [.03 .03] ,'XMinorTick', 'on','YMinorTick'  , 'on')
grid on;
grid minor;
ylabel('Transformer Energy (kWh)','fontweight','bold','FontSize',8)
xlabel('Hour','fontweight','bold','FontSize',8)
xlim([0 ROWS/60])
title({'Transformer Energy Vs. Time - ELVTF ' sprintf(Scenario,ID1,ID2,ID3,Season)},'FontSize',8)
% legend({'Active Power(kW)'},'location','northwest','AutoUpdate','off')
% %%--%%--%%--PLOT STYLING--%%--%%--%%

%% Transformer & Line Losses Plot

LossesFigure = figure('Name', ['Transformer & Line Losses ', sprintf(Scenario,ID1,ID2,ID3,Season) ]);
bar((1:ROWS)/60,LineLosses(:,1),'LineWidth',1,'Facecolor',Colour1)
hold on
bar((1:ROWS)/60,TransformerLosses(:,2),'LineWidth',1,'Facecolor',Colour2)
bar((1:ROWS)/60,LineLosses(:,2),'LineWidth',1,'Facecolor',Colour4)
bar((1:ROWS)/60,TransformerLosses(:,1),'LineWidth',1,'Facecolor',Colour3)

InSet = get(gca, 'TightInset');
set(gca, 'Position', [InSet(1)+0.06,InSet(2)+0.06, 1-InSet(1)-InSet(3)-0.1, 1-InSet(2)-InSet(4)-0.15]);

%%--%%--%%--PLOT STYLING--%%--%%--%%
set(gca, 'FontName', 'Times New Roman','FontSize',8,'TickLength', [.03 .03] ,'XMinorTick', 'on','YMinorTick'  , 'on')
grid on;
grid minor;
ylabel('Power Losses','fontweight','bold','FontSize',8)
ylim([0 max(LineLosses(:,1))+0.7])
xlabel('Hour','fontweight','bold','FontSize',8)
xlim([0 ROWS/60])
title({'Transformer & Line Losses - ELVTF ' sprintf(Scenario,ID1,ID2,ID3,Season)},'FontSize',8)
legend({'Active Line Losses (kW)','Transformer Reactive Losses (kVAr)', 'Reactive Line Losses (kVAr)','Transformer Active Losses (kW)'},'location','northwest','AutoUpdate','off')
% %%--%%--%%--PLOT STYLING--%%--%%--%%


%% Interactive & Regular Plot Exports (Comment this section out if not exporting plots) 

% saveas(StackedBarLossesFigure, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Interactive (MATLAB) Plots\Stacked_Bar_Chart_Losses_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.fig'], 'fig');
% saveas(StackedBarENERGYFigure, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Interactive (MATLAB) Plots\Total_Grid_and_Transformer_Energy_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.fig'], 'fig');
% saveas(UnbalancePlotFigure, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Interactive (MATLAB) Plots\3_Phase_Unbalance_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.fig'], 'fig');
% saveas(V1_3D_PLOTFigure, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Interactive (MATLAB) Plots\Phase_A_3D_Voltage_Magnitude_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.fig'], 'fig');
% saveas(V2_3D_PLOTFigure, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Interactive (MATLAB) Plots\Phase_B_3D_Voltage_Magnitude_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.fig'], 'fig');
% saveas(V3_3D_PLOTFigure, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Interactive (MATLAB) Plots\Phase_C_3D_Voltage_Magnitude_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.fig'], 'fig');
% saveas(TransformerLoadingFig, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Interactive (MATLAB) Plots\Transformer_Loading_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.fig'], 'fig');
% saveas(CumulativeEnergyFigure, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Interactive (MATLAB) Plots\Transformer_Cumulative_Energy_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.fig'], 'fig');
% saveas(TransformerEnergyTimeFig, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Interactive (MATLAB) Plots\Transformer_Energy_VS_Time_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.fig'], 'fig');
% saveas(LossesFigure, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Interactive (MATLAB) Plots\Power_Losses_VS_Time_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.fig'], 'fig');
% saveas(Aggragated_Powers_Figure, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Interactive (MATLAB) Plots\Aggragated_Powers_VS_Time_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.fig'], 'fig');
% 
% Aggragated_Powers_Figure.PaperUnits = 'inches';
% Aggragated_Powers_Figure.PaperPosition = [0 0 3 2.5];
% print(Aggragated_Powers_Figure, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Non-interactive Plots (PNG)\Aggragated_Powers_VS_Time_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.png'], '-dpng','-r600');
% 
% StackedBarLossesFigure.PaperUnits = 'inches';
% StackedBarLossesFigure.PaperPosition = [0 0 3 2.5];
% print(StackedBarLossesFigure, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Non-interactive Plots (PNG)\Stacked_Bar_Chart_Losses_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.png'], '-dpng','-r600');
% 
% StackedBarENERGYFigure.PaperUnits = 'inches';
% StackedBarENERGYFigure.PaperPosition = [0 0 3 2.5];
% print(StackedBarENERGYFigure, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Non-interactive Plots (PNG)\Total_Grid_and_Transformer_Energy_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.png'], '-dpng','-r600');
% 
% UnbalancePlotFigure.PaperUnits = 'inches';
% UnbalancePlotFigure.PaperPosition = [0 0 3 2.5];
% print(UnbalancePlotFigure, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Non-interactive Plots (PNG)\3_Phase_Unbalance_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.png'], '-dpng','-r600');
% 
% V1_3D_PLOTFigure.PaperUnits = 'inches';
% V1_3D_PLOTFigure.PaperPosition = [0 0 3 2.5];
% print(V1_3D_PLOTFigure, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Non-interactive Plots (PNG)\Phase_A_3D_Voltage_Magnitude_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.png'], '-dpng','-r600');
% 
% V1_3D_PLOTFigure2.PaperUnits = 'inches';
% V1_3D_PLOTFigure2.PaperPosition = [0 0 3 2.5];
% print(V1_3D_PLOTFigure2, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Non-interactive Plots (PNG)\Phase_A_3D_Voltage_Magnitude_Plot_x_Axis_' sprintf(Scenario,ID1,ID2,ID3,Season) '.png'], '-dpng','-r600');
% 
% V2_3D_PLOTFigure.PaperUnits = 'inches';
% V2_3D_PLOTFigure.PaperPosition = [0 0 3 2.5];
% print(V2_3D_PLOTFigure, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Non-interactive Plots (PNG)\Phase_B_3D_Voltage_Magnitude_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.png'], '-dpng','-r600');
% 
% V2_3D_PLOTFigure2.PaperUnits = 'inches';
% V2_3D_PLOTFigure2.PaperPosition = [0 0 3 2.5];
% print(V2_3D_PLOTFigure2, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Non-interactive Plots (PNG)\Phase_B_3D_Voltage_Magnitude_Plot_x_Axis_' sprintf(Scenario,ID1,ID2,ID3,Season) '.png'], '-dpng','-r600');
% 
% V3_3D_PLOTFigure.PaperUnits = 'inches';
% V3_3D_PLOTFigure.PaperPosition = [0 0 3 2.5];
% print(V3_3D_PLOTFigure, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Non-interactive Plots (PNG)\Phase_C_3D_Voltage_Magnitude_Plot_' sprintf(Scenario,ID1,ID2,ID3,Season) '.png'], '-dpng','-r600');

% V3_3D_PLOTFigure2.PaperUnits = 'inches';
% V3_3D_PLOTFigure2.PaperPosition = [0 0 3 2.5];
% print(V3_3D_PLOTFigure2, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Non-interactive Plots (PNG)\Phase_C_3D_Voltage_Magnitude_Plot_x_Axis_' sprintf(Scenario,ID1,ID2,ID3,Season) '.png'], '-dpng','-r600');

% TransformerLoadingFig.PaperUnits = 'inches';
% TransformerLoadingFig.PaperPosition = [0 0 3 2.5];
% print(TransformerLoadingFig, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Non-interactive Plots (PNG)\Transformer_Loading_VS_Time_' sprintf(Scenario,ID1,ID2,ID3,Season) '.png'], '-dpng','-r600');

% LossesFigure.PaperUnits = 'inches';
% LossesFigure.PaperPosition = [0 0 3 2.5];
% print(LossesFigure, ['C:\Users\bajai\Documents\GitHub\MSc-Project---Impact-of-PV-and-Battery-Storage-on-Distribution-System\Plots\Non-interactive Plots (PNG)\Transformer_Line_Losses_VS_Time_' sprintf(Scenario,ID1,ID2,ID3,Season) '.png'], '-dpng','-r600');