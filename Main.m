%% Parameter Setup

Parameters=struct;
Parameters.Road_Length=500; %m
Parameters.Sampling_Time=15; %s
Parameters.Freeflow_Speed=50/3.6; %m/s
Parameters.Max_Density=0.125; % veh/m
Parameters.Max_Flow=0.55; %veh/s

X_Intersections=4;
Y_Intersections=4;
N_Iterations=500;

%% Construct Graphs -  Traffic Network

[Graph_Inter,Graph_Roads,R_Split]=ManhattanGridConstruction(...
    X_Intersections,Y_Intersections);
Num_Roads=numnodes(Graph_Roads);
%% Create Model Noise
R_Noisy=R_Split;

for cont=find(sum(R_Split'))
    Model_Noise=0.03*randn;
    aux=find(R_Split(cont,:));
    R_Noisy(cont,aux)=R_Split(cont,aux)+[Model_Noise -Model_Noise];
end

%% Simulation initial conditions

Input_Flows=find(1-sum(R_Split))';
Output_Flows=find(1-sum(R_Split,2)')';
Net_Flows=find(~ismember((1:Num_Roads)',[Input_Flows;Output_Flows]));
Demand_Input=Parameters.Max_Flow*ones(size(Input_Flows));
rng(10)
Supply_Output=Parameters.Max_Flow*(1-0.25*rand(size(Output_Flows)));%*0.01;

Rho_In=Parameters.Max_Density*rand(size(R_Split,1),1);

% load Osc_4x4.mat
% load NonTrivialEq_4x4
%% Simulation 
[Rho,F_In,F_Out]=CellTransmissionModel(...
    Parameters,Graph_Roads,R_Split,Demand_Input,Supply_Output,Input_Flows,...
    Output_Flows,N_Iterations,Rho_In);

% Time_Plot_Links
%% Estimation
[eRho,eFlow,err_Rho,err_F,Cost]=Estimation(Parameters,Graph_Roads,R_Split,Rho,F_Out,[0,0]);

%% Simulation Noise
[Rho2,F_In,F_Out2]=CellTransmissionModel(...
    Parameters,Graph_Roads,R_Noisy,Demand_Input,Supply_Output,Input_Flows,...
    Output_Flows,N_Iterations,Rho_In);

% Time_Plot_Links
%% Estimation
[eRho2,eFlow2,err_Rho2,err_F2,Cost2]=Estimation(Parameters,Graph_Roads,R_Split,Rho2,F_Out2,[0,0]); 

%% Estimation noisy measurements 
[eRho3,eFlow3,err_Rho3,err_F3,Cost3]=Estimation(Parameters,Graph_Roads,R_Split,Rho,F_Out,[0.001,0.003]);

%% Estimation noisy measurements + split ratio
[eRho4,eFlow4,err_Rho4,err_F4,Cost4]=Estimation(Parameters,Graph_Roads,R_Split,Rho2,F_Out2,[0.001,0.003]);