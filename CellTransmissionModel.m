function [Rho,F_In,F_Out]=CellTransmissionModel(...
    Param,Graph_Roads,R_Split,Demand_Input,Supply_Output,Input_Flows,...
    Output_Flows,N_Iterations,Rho_In)

%Set Parameters

Road_Length=Param.Road_Length; %m
Sampling_Time=Param.Sampling_Time; %s
Freeflow_Speed=Param.Freeflow_Speed; %m/s
Max_Density=Param.Max_Density; % veh/m
Max_Flow=Param.Max_Flow; %veh/s

Crit_Density=Max_Flow/Freeflow_Speed;
Congested_Speed=Max_Flow/(Max_Density-Crit_Density);
N=numnodes(Graph_Roads);

% Set up initial conditions

F_In=zeros(N,N_Iterations);
F_Out=F_In;
Rho=F_In;
% f_in=zeros(N,1);
% f_out=f_in;
rho=Rho_In;

% Input_Flows=find(1-sum(R_Split))';
% Output_Flows=find(sum(R_Split,2)'==0)';

% cond=0;
% R_Split_Nominal=R_Split;
for t=1:N_Iterations
    
%     R_Split=R_Split_Nominal;
%     for cont=find(sum(R_Split_Nominal'))
%         Model_Noise=0.01*randn;
%         aux=find(R_Split_Nominal(cont,:));
%         R_Split(cont,aux)=R_Split_Nominal(cont,aux)+[Model_Noise -Model_Noise];
%     end
    
    Supply=min(Max_Flow,Congested_Speed*(Max_Density-rho));
%     if sum(Supply<0)>0
%         Supply(Supply<0)=0;
%     end
%     Supply(Supply>-1e-4)=abs(Supply(Supply>-1e-4));
    Demand=min(Max_Flow,Freeflow_Speed*rho);
    
    % Get Output flows
    
%     f_out=linprog(-ones(N,1),R_Split',Supply',[],[],zeros(N,1),Demand',...
%         optimoptions('linprog','Display','none'));
    f_out=linprog(-ones(N,1),R_Split',Supply',[],[],zeros(N,1),Demand',zeros(N,1),...
        optimoptions('linprog','Display','none'));    
    f_in=R_Split'*f_out;
    
    % Boundary conditions
    
    f_in(Input_Flows)=min(Supply(Input_Flows),Demand_Input);
    f_out(Output_Flows)=min(Demand(Output_Flows),Supply_Output);
    
  
    
    % Store Results
    Rho(:,t)=rho;
    F_In(:,t)=f_in;
    F_Out(:,t)=f_out;
    
    % Get Densities
    rho=rho+(f_in-f_out)*Sampling_Time/Road_Length;
    
    
    if t>2
        if (sum(abs(Rho(:,t)-Rho(:,t-1)))...
                +sum(abs(F_In(:,t)-F_In(:,t-1)))...
                +sum(abs(F_Out(:,t)-F_Out(:,t-1))))<eps
            Rho=Rho(:,1:t);
            F_In=F_In(:,1:t);
            F_Out=F_Out(:,1:t);
%             cond=1;
%             disp(t)
            break
        end
    end
    
    if t==N_Iterations
        disp('No Equilibrium Achieved')
    end
    
    
end
end
