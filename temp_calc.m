%% Setup
% Clean
clc
clear all 
close all

% Setup
myDir = 'C:\Users\Sirpimmon\Desktop\hackathon22s\plantbuddy';
cd(myDir);

disp('Setup done.')

%% Acceptable environmental conditions

% Read files
temps = readtable(strcat(myDir, '\datasets\avg_temps.csv'));
names = readtable(strcat(myDir, '\datasets\state_names.csv'));

% Join temperature ranges and states
temps_abbrev = join(temps, names);
st_abbrev = lower(temps_abbrev{:,4});

% Range for change from average temperature
temp_range = 20;
min_temp = temps_abbrev{:,2} - temp_range;
max_temp = temps_abbrev{:,2} + temp_range;
avg_temp = temps_abbrev{:,2};

% Average pressure ranges
max_press = 101320; % Sea level
min_press = 99221 - (101320 - 99221);

% Humidity for avg houseplants
max_humid = 75;% * ones(50,1);
min_humid = 60;% * ones(50,1);

% Amount of light based on 
min_recorded_light = 26;
max_recorded_light = 680;

med_light = (min_recorded_light + max_recorded_light)/2;
sections = (max_recorded_light - min_recorded_light)/4;

low_light_threshold = min_recorded_light + sections;
high_light_threshold = max_recorded_light - sections;


% Put together states and temperature
%temp_ranges = table(st_abbrev, min_temp, max_temp);
temp_ranges = table(st_abbrev, avg_temp);

% Put together light, humidity, pressure
conditions = table(max_press, min_press, max_humid, min_humid, low_light_threshold, high_light_threshold);

disp('Setup environmental conditions done')

%% Map from temp

temps = containers.Map;

table_size = height(temp_ranges); 
rows = table_size(1); 
for row = 1:rows 
    temps(temp_ranges{row, 1}{1}) = temp_ranges{row, 2};
end

disp('Map from temps done')

%% Reading plant states

% Read file
filename = '.\datasets\plant_states.data';
plant_opened = fopen(filename,'r');
if plant_opened < 3
    disp("Error reading file")
else
    disp("File read")
end

%% Making table

% Initialize table
% Can only read file line by line so no preallocating :(
titles = {'name' 'max_temp' 'min_temp'};
init_table = {"hello :)", 0, 0};
plant_temps = array2table(init_table);
plant_temps.Properties.VariableNames = titles;

% Read first line
tline = fgetl(plant_opened);

% While still reading file
while tline ~= -1
   
    % Split string by plant name and states
    each_line = strsplit(tline, ',');

    % Iterate through states
    table_size = width(each_line) ; 
    rows = table_size(1); 

    for row = 2:rows 

        % Find range of temperature averages
        max_temp_plant = 0;
        min_temp_plant = Inf;

        % If the plant is in the wild
        if isKey(temps, each_line(row))
            if temps(each_line{row}) > max_temp_plant
                max_temp_plant = temps(each_line{row});
            end
            if temps(each_line{row}) < min_temp_plant
                min_temp_plant = temps(each_line{row});
            end

        % If it's not found in the wild
        else
            max_temp_plant = 60;
            min_temp_plant = 80;                
        end                                                        
    end       
    
    % Modify table
    this_row = {each_line{1}, (max_temp_plant + temp_range) , (min_temp_plant - temp_range)};
    this_row_table = array2table(this_row);
    this_row_table.Properties.VariableNames = titles;
    plant_temps = vertcat(plant_temps, this_row_table);
      
    % Prepare for next iteration
    tline = fgetl(plant_opened);
end

disp('Plant by state done')

%% Cleanup

% Remove initial line
plant_temps([1],:) = [];

% Export
plant_temps;
conditions;

writetable(plant_temps, strcat(myDir, '\outputs\plant_temp_ranges.csv'))
writetable(conditions, strcat(myDir, '\outputs\conditions.csv'))

% Close files
fclose('all');
disp("Cleanup done")
