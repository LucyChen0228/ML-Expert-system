
% ===================================================================================
% Problem: Assessment of a mortgage application is normally based on evaluating the  
%          market value and location of the house, the applicant's assets and income,  
%          and the repayment plan, which is decided by the applicant's income and   
%          bank's interest charges.
% ===================================================================================

% Hit any key to load Rule Base 1: Home Evaluation.
pause

a1=readfis('mortgage_1.fis');

% Hit any key to display a fuzzy model of Home Evaluation as a block diagram.
pause

figure('name','Block diagram of a fuzzy model for Home Evaluation');
plotfis(a1);

% Hit any key to display fuzzy sets for the linguistic variable "Location".
pause

figure('name','Location');
plotmf(a1,'input',1);

% Hit any key to display fuzzy sets for the linguistic variable "Market value".
pause

figure('name','Market value, $');
plotmf(a1,'input',2);

% Hit any key to display fuzzy sets for the linguistic variable "House".
pause

figure('name','House');
plotmf(a1,'output',1);

% Hit any key to bring up the Rule Editor.
pause

ruleedit(a1);

% Hit any key to generate a three-dimensional surface for Rule Base 1.
pause

figure('name','Three-dimensional surface for Rule Base 1');
gensurf(a1,[1 2],1);

% Hit any key to load Rule Base 2: Applicant Evaluation.
pause

a2=readfis('mortgage_2.fis');

% Hit any key to display a fuzzy model of Applicant Evaluation as a block diagram.
pause

figure('name','Block diagram of a fuzzy model for Applicant Evaluation');
plotfis(a2);

% Hit any key to display fuzzy sets for the linguistic variable "Asset".
pause

figure('name','Asset, $');
plotmf(a2,'input',1);

% Hit any key to display fuzzy sets for the linguistic variable "Income".
pause

figure('name','Income, $');
plotmf(a2,'input',2);

% Hit any key to display fuzzy sets for the linguistic variable "Applicant".
pause

figure('name','Applicant');
plotmf(a2,'output',1);

% Hit any key to bring up the Rule Editor.
pause

ruleedit(a2);

% Hit any key to generate a three-dimensional surface for Rule Base 2.
pause

figure('name','Three-dimensional surface for Rule Base 2');
gensurf(a2,[1 2],1);

% Hit any key to load Rule Base 3: Credit Evaluation.
pause

a3=readfis('mortgage_3.fis');

% Hit any key to display a fuzzy model of Credit Evaluation as a block diagram.
pause

figure('name','Block diagram of a fuzzy model for Credit Evaluation');
plotfis(a3);

% Hit any key to display fuzzy sets for the linguistic variable "Interest".
pause

figure('name','Interest, %');
plotmf(a3,'input',2);

% Hit any key to display fuzzy sets for the linguistic variable "Credit".
pause

figure('name','Credit, $');
plotmf(a3,'output',1);

% Hit any key to bring up the Rule Editor.
pause

ruleedit(a3);

% Hit any key to generate three-dimensional plots for Rule Base 3.
pause

figure('name','Three-dimensional surface for Rule Base 3');
gensurf(a3,[3 4],1);

% Hit any key to continue.
pause

figure('name','Three-dimensional surface for Rule Base 3');
gensurf(a3,[2 3],1);

% Hit any key to bring up the Rule Viewer.
pause

ruleview(a3);

% Hit any key to continue.
pause

% CASE STUDY
% ====================================================================================
% Suppose, it is required to assess a mortgage application for a house with the market 
% value of $450,000 in a fair location.  The applicant's assets are $200,000 and his 
% income is $56,000 per year.  The bank's current interest rate is 4.6%. The applicant 
% requested a credit of $350,000.
% ====================================================================================

% Hit any key to obtain results of the home evaluation.
pause

home=evalfis([5.5 450],a1)

% Hit any key to obtain results of the applicant evaluation.
pause

applicant=evalfis([200 56],a2)

% Hit any key to obtain results of the credit evaluation.
pause

credit=evalfis([56 4.6 applicant home],a3)*1000

echo off
disp('End of fuzzy_mortgage.m')