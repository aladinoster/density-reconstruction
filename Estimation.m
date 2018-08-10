function [eRho,eFlow,err_Rho,err_F,Cost]=Estimation(...
    Param,Graph_Roads,R_Split,Rho,F_Out,eta)

% Road_Length=Param.Road_Length; %m
% Sampling_Time=Param.Sampling_Time; %s
Freeflow_Speed=Param.Freeflow_Speed; %m/s
Max_Density=Param.Max_Density; % veh/m
Max_Flow=Param.Max_Flow; %veh/s

Crit_Density=Max_Flow/Freeflow_Speed;
Congested_Speed=Max_Flow/(Max_Density-Crit_Density);
N=numnodes(Graph_Roads);

Input_Flows=find(1-sum(R_Split))';
Output_Flows=find(1-sum(R_Split,2)')';

% Get Speed

getSpeed=@(rho,rc,v,w,rmax) (rho<rc).*v+(rho>=rc).*w.*(rmax./rho-1);

SpeedMeasurements=getSpeed(Rho,Crit_Density,Freeflow_Speed,Congested_Speed,Max_Density);
SpeedMeasurements(isnan(SpeedMeasurements))=Freeflow_Speed;
% Speed measurement noise
SpeedMeasurements=SpeedMeasurements+eta(1)*randn(size(SpeedMeasurements));
SpeedMeasurements(SpeedMeasurements<0)=0;
%---------------------

FlowMeasurements=F_Out([Input_Flows;Output_Flows],:);
% Flow Measurement Noise
FlowMeasurements=FlowMeasurements+eta(2)*randn(size(FlowMeasurements));
FlowMeasurements(FlowMeasurements<0)=0;
%-----------------------
getDensity=@(v,rc,rmax,w) rmax./(1+v./w);
PseudoDensity=getDensity(SpeedMeasurements,Crit_Density,Max_Density,Congested_Speed);


% Optimization

aux=[Input_Flows;Output_Flows];
Sf=zeros(numel(aux),N);
Sf(sub2ind(size(Sf),(1:numel(aux))',aux))=1;
Hf=2*(Sf'*Sf+(eye(N)-R_Split')'*(eye(N)-R_Split'));



% beq=zeros(N,1);
lb=zeros(2*N,1);
ub=[Max_Density*ones(N,1);Max_Flow*ones(N,1)];
%%%
eRho=zeros(size(Rho));
eFlow=eRho;
Cost=zeros(1,size(Rho,2));
for t=1:size(Rho,2)

% Selection Matrix    
Sv=double(diag(SpeedMeasurements(:,t)<Freeflow_Speed));

% Cost Function
Hr=2*(Sv'*Sv);
cr=-2*Sv'*PseudoDensity(:,t);
Exogenous=zeros(N,1);
Exogenous(Input_Flows)=F_Out(Input_Flows,t);
cf=-2*(Sf'*FlowMeasurements(:,t)+(eye(N)-R_Split')'*Exogenous);

H=[Hr zeros(N); zeros(N) Hf];
c=[cr;cf];%-10*[zeros(N,1);ones(N,1)];

% Constraints

Aeq=[-Freeflow_Speed*(eye(N)-Sv) (eye(N)-Sv); Congested_Speed*Sv Sv];
beq=[zeros(N,1) ;Sv*ones(N,1)*Congested_Speed*Max_Density];
% A=[-Freeflow_Speed*Sv Sv;eye(N)*Congested_Speed R_Split'];
% Aeq=[-Freeflow_Speed*(eye(N)-Sv) eye(N)-Sv];


% Solver
sol=quadprog(H,c,[],[],Aeq,beq,lb,ub,[],optimoptions('quadprog','Display',...
    'none'));
Cost(t)=norm(Sv*sol(1:N)-PseudoDensity(:,t)).^2+...
    norm(Sf*sol(N+1:end)-FlowMeasurements(:,t)).^2+...
    norm((eye(N)-R_Split')*sol(N+1:end)-Exogenous).^2;
eRho(:,t)=sol(1:N);
eFlow(:,t)=sol(N+1:end);
% disp(t)
end

err_Rho=Rho-eRho;
err_F=F_Out-eFlow;

end