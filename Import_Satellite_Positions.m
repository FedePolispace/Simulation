clc;
clear;

%This file contains the coordinates of the satellite and the ground station
Satellite_positions_file = 'ISAR_satellite_pos_GS_pos.csv';

%Importing the file as a table
Satellite_positions_table=readtable(Satellite_positions_file,'ReadVariableNames',false,'Format','auto');

%Removing the first row since it contains irrelevant data
Satellite_positions_table(1,:)=[];


%Formating observation date
observationDate = datetime(char(Satellite_positions_table.Var1) + " " + string(Satellite_positions_table.Var2) + " " + num2str(Satellite_positions_table.Var3) + " " + datestr(Satellite_positions_table.Var4,'HH:MM:SS'),'InputFormat','d MMM yyyy HH:mm:ss');
Satellite_positions_table.Var1=observationDate;

%Elimination of unnecessary columns
Satellite_positions_table.Var2=[];
Satellite_positions_table.Var3=[];
Satellite_positions_table.Var4=[];


%Changing columns name
Satellite_positions_table.Properties.VariableNames={'Date','Satellite_X','Satellite_Y','Satellite_Z','Ground_Station_X','Ground_Station_Y','Ground_Station_Z'};

clearvars observationDate Satellite_positions_file;

