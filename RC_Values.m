
% Load the capacitor and resistor data from CSV files
capacitors = readtable('capacitors.csv');
resistors = readtable('resistors.csv');

% Convert the value columns to numeric arrays for computation
capacitorValues = str2double(capacitors.Value);
resistorValues = str2double(resistors.Value);

% Get user input for the filter coefficient
filterCoefficient = input('Enter the filter coefficient value (e.g., 123e07): ');

% Initialize variables to store the minimum error and best combination
minError = inf;
bestCombination = struct('R', [], 'C', [], 'a', [], 'indexR', [], 'indexC', []);

% Loop through all possible combinations of resistors and capacitors
for i = 1:length(resistorValues)
    for j = 1:length(capacitorValues)
        R = resistorValues(i);
        C = capacitorValues(j);
        
        % Calculate the filter coefficient (example a = R / (R * C))
        a = R / (R * C);  % This is just an example formula, modify as needed
        
        % Calculate the error
        error = abs((a - filterCoefficient) / filterCoefficient) * 100;
        
        % Check if this is the best combination
        if error < minError
            minError = error;
            bestCombination.R = R;
            bestCombination.C = C;
            bestCombination.a = a;
            bestCombination.indexR = i;
            bestCombination.indexC = j;
        end
    end
end

% Display the results
fprintf('Best combination found:\n');
fprintf('Resistor (R) value: %f %s (index: %d)\n', bestCombination.R, resistors.Unit{bestCombination.indexR}, bestCombination.indexR);
fprintf('Capacitor (C) value: %f %s (index: %d)\n', bestCombination.C, capacitors.Unit{bestCombination.indexC}, bestCombination.indexC);
fprintf('Calculated coefficient: %e\n', bestCombination.a);
fprintf('Error: %.2f%%\n', minError);
