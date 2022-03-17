%{
______     _ _                          
| ___ \   | (_)                         
| |_/ ___ | |_ ___ _ __   __ _  ___ ___ 
|  __/ _ \| | / __| '_ \ / _` |/ __/ _ \
| | | (_) | | \__ | |_) | (_| | (_|  __/
\_|  \___/|_|_|___| .__/ \__,_|\___\___|
                  | |                   
                  |_|       
%}
clc;
clear;

%<------------------------------------------------------------->

%Creation of the table with satellite and ground station positions
Import_Satellite_Positions

%<------------------------------------------------------------->




%<------------------------------------------------------------->
%Global variables

%This file contains the information of the ground stations
Ground_Stations_coordinates = 'GS_coordinates.csv';


Ground_Stations_observations = 'ISAR_GS_contact.csv';


% Starting number of ground stations
Number_of_Ground_Stations=0;
%<------------------------------------------------------------->




%<------------------------------------------------------------->
% Tables reading

% Reading of the observation table
GS_observations_table=readtable(Ground_Stations_observations,'ReadVariableNames',false,'Format','auto');

% Reading of the coordinates table
Ground_Station_coordinates_Table = readtable(Ground_Stations_coordinates,'ReadVariableNames',false,'Format','auto');
%<------------------------------------------------------------->



%<------------------------------------------------------------->
% Compute the total number of ground stations

for i=1:height(GS_observations_table)
    if(isequal(GS_observations_table.Var1(i),{'Observer:'}))
        Number_of_Ground_Stations=Number_of_Ground_Stations+1;
    end
end
%<------------------------------------------------------------->




%<------------------------------------------------------------->
%Calculation of the indices that delimit the set of observations of a ground station 

Start_indices=zeros(Number_of_Ground_Stations,1);
End_indices=zeros(Number_of_Ground_Stations,1);

j=1;
k=1;

for i=1:height(GS_observations_table)
    if(isequal(GS_observations_table.Var1(i),{'Observer:'}))
        Start_indices(j)=i+3;
        j=j+1;
    elseif (isequal(GS_observations_table.Var1(i),{'Number'}))
        End_indices(k)=i-3;
        k=k+1;
    end
end

%<------------------------------------------------------------->



%<------------------------------------------------------------->
%Extracting subtables

%Array memory preallocation
GS_observations=cell(1,Number_of_Ground_Stations);

%Creation of a cell array, each cell is a table
for i=1:Number_of_Ground_Stations
    GS_observations{i}=readtable(Ground_Stations_observations,'Range',strcat('A',num2str(Start_indices(i)),':I',num2str(End_indices(i))),'ReadVariableNames',false);
end
%<------------------------------------------------------------->




%<------------------------------------------------------------->
% Data cleaning
% The goal is to obtain a well formatted set of observations intervals

for i =1:Number_of_Ground_Stations
    StartTime = datetime(num2str(GS_observations{i}.Var1) + " " + string(GS_observations{i}.Var2) + " " + num2str(GS_observations{i}.Var3) + " " + datestr(GS_observations{i}.Var4,'HH:MM:SS'),'InputFormat','d MMM yyyy HH:mm:ss');
    StopTime = datetime(num2str(GS_observations{i}.Var5) + " " + string(GS_observations{i}.Var6) + " " + num2str(GS_observations{i}.Var7) + " " + datestr(GS_observations{i}.Var8,'HH:MM:SS'),'InputFormat','d MMM yyyy HH:mm:ss');
    GS_observations{i}.Var1 = StartTime;
    GS_observations{i}.Var2 = StopTime;
    GS_observations{i}.Var3 = [];
    GS_observations{i}.Var4 = [];
    GS_observations{i}.Var5 = [];
    GS_observations{i}.Var6 = [];
    GS_observations{i}.Var7 = [];
    GS_observations{i}.Var8 = [];
end
%<------------------------------------------------------------->



%<------------------------------------------------------------->
% Creation of an array in which each element is an object of type GS 


% creation of the empty array of ground stations
GS_array = GS.empty(Number_of_Ground_Stations,0);


% This variable specifies how many sub intervals we want to define for each interval of observation
number_of_points=20;

% Here we are filling GS_array with different ground station obects, each of which has its own attributes.
for i = 1:Number_of_Ground_Stations
    
    %This is the matrix containing the single time intervals
    observations_interval_matrix = compute_observations_interval_matrix(number_of_points,GS_observations{i}.Var1,GS_observations{i}.Var2);
    
    %Dimensions of the interval matrix 
    % (this will be used to allocate space for the telecommunication parameters matrix)
    d = size(observations_interval_matrix);

    GS_array(i)=GS(Ground_Station_coordinates_Table.Var1(i), ...
        Ground_Station_coordinates_Table.Var2(i), ...
        Ground_Station_coordinates_Table.Var3(i), ...
        Ground_Station_coordinates_Table.Var4(i),...
        GS_observations{i}, ...
        observations_interval_matrix, ...
        cell(d));
end
%<------------------------------------------------------------->




%<------------------------------------------------------------->

%Now at each ground station we assign the telecommunication parameters matrix
%That is a matrix containing specific parameters for each time instance defined before
for m = 1:Number_of_Ground_Stations
    for x = 1:get_element(size(GS_array(m).telecom_parameters_matrix),1)
        for y = 1:get_element(size(GS_array(m).telecom_parameters_matrix),2)
            GS_array(m).telecom_parameters_matrix(x,y)={
                Telecom_parameters(-21.3, ...
                compute_BER, ...
                compute_PER, ...
                compute_DTR, ...
                compute_HPW)};
        end
    end
end
%<------------------------------------------------------------->


%Workspace cleaning
clear d i m x y j k;

clear StartTime StopTime;

clear End_indices Start_indices;

clear Number_of_Ground_Stations number_of_points Ground_Station_coordinates_Table Ground_Stations_observations Ground_Stations_coordinates observations_interval_matrix GS_observations GS_observations_table