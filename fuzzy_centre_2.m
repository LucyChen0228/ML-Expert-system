% ==================================================================================
% Problem: A service centre keeps spare parts and repairs failed ones.  A customer  
%          brings a failed item and receives a spare of the same type. Failed parts 
%          are repaired and placed on the shelf. If the required spare is available, 
%          the customer takes it and leaves the centre. If there is no spare on the 
%          shelf, the customer has to wait until the needed item becomes available.   
%          The objective of the fuzzy system is to advise a manager of the service 
%          centre on how to keep the actual delay in service within the limits 
%          acceptable to customers.
% ==================================================================================

% Hit any key to load the fuzzy system.
pause

a=readfis('centre_2.fis');

% Hit any key to display the whole system as a block diagram.
pause

figure('name','Block diagram of the fuzzy system');
plotfis(a);

% Hit any key to display fuzzy sets for the linguistic variable "Mean delay".
pause

figure('name','Mean delay (normalised)');
plotmf(a,'input',1);

% Hit any key to display fuzzy sets for the linguistic variable "Number of servers".
pause

figure('name','Number of servers (normalised)');
plotmf(a,'input',2);

% Hit any key to display fuzzy sets for the linguistic variable "Repair utilisation 
% factor".
pause

figure('name','Repair utilisation factor');
plotmf(a,'input',3);

% Hit any key to display fuzzy sets for the linguistic variable "Number of spares".
pause

figure('name','Number of spares (normalised)');
plotmf(a,'output',1);

% Hit any key to bring up the Rule Editor.
pause

ruleedit(a);

% Hit any key to generate three-dimensional plots for Rule Base.
pause 

figure('name','Three-dimensional surface (a)');
gensurf(a,[1 2],1); view([49 36]);

% Hit any key to continue.
pause

figure('name','Three-dimensional surface (b)');
gensurf(a,[1 3],1); view([49 36]);

% Hit any key to bring up the Rule Viewer.
pause

ruleview(a);

% Hit any key to continue.
pause

% CASE STUDY
% =====================================================================================
% Suppose, a service centre is required to supply its customers with spare parts within
% 24 hours. The service centre employs 8 servers and the repair utilisation factor is 
% 60%. The inventory capacities of the centre are limited by 100 spares. The values for 
% the mean delay, number of servers and repair utilisation factor are 0.6, 0.8 and 0.6,
% respectively.
% =====================================================================================

% Hit any key to obtain the required number of spares.
pause

n=round((evalfis([0.7 0.8 0.6],a))*100)

% Hit any key to continue.
pause

% ===================================================================================
% Suppose, now a manager of the service centre wants to reduce the customer's average
% waiting time to 12 hours.
% ===================================================================================

% Hit any key to see how this will effect the required number of spares.
pause

n=round((evalfis([0.35 0.8 0.6],a))*100)
  
echo off
disp('End of fuzzy_centre_2.m')
