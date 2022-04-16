% Clean
clc
clear all 
close all

% Setup
myDir = 'C:\Users\Sirpimmon\Desktop\hackathon22s\plantbuddy';
cd(myDir);

% Read file
filename = 'plant_states.data';
plant_opened = fopen(filename,'r');
if plant_opened < 3
    disp("Error reading file")
else
    disp("File read")
end

% 
while tline ~= -1
    tline = fgetl(plant_opened);    
end

fclose('all');
