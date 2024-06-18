% Load the capacitor and resistor data from CSV files
capacitors = readtable('capacitors.csv');
resistors = readtable('resistors.csv');

% Convert the capacitor values to base units (Farads)
capacitorValues = zeros(height(capacitors), 1);
for i = 1:height(capacitors)
    value = str2double(capacitors.Value{i});
    unit = capacitors.Unit{i};
    switch unit
        case 'pF'
            capacitorValues(i) = value * 1e-12;
        case 'nF'
            capacitorValues(i) = value * 1e-9;
        case 'μF'
            capacitorValues(i) = value * 1e-6;
        case 'mF'
            capacitorValues(i) = value * 1e-3;
        case 'F'
            capacitorValues(i) = value;
    end
end

% Convert the resistor values to base units (Ohms)
resistorValues = zeros(height(resistors), 1);
for i = 1:height(resistors)
    value = str2double(resistors.Value{i});
    unit = resistors.Unit{i};
    switch unit
        case 'Ω'
            resistorValues(i) = value;
        case 'kΩ'
            resistorValues(i) = value * 1e3;
        case 'MΩ'
            resistorValues(i) = value * 1e6;
    end
end

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
fprintf('Resistor (R) value: %f %s (index: %d)\n', resistorValues(bestCombination.indexR), resistors.Unit{bestCombination.indexR}, bestCombination.indexR);
fprintf('Capacitor (C) value: %f %s (index: %d)\n', capacitorValues(bestCombination.indexC), capacitors.Unit{bestCombination.indexC}, bestCombination.indexC);
fprintf('Calculated coefficient: %e\n', bestCombination.a);
fprintf('Error: %.2f%%\n', minError);
