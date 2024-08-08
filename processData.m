function processData(inputFile, outputPlotFile)
% Function to process CSV data, generate a plot.

    % Check if file exists
    if ~isfile(inputFile)
        error('processData:FileNotFound', 'The specified input file does not exist.');
    end

    % Read data from CSV file
    data = readtable(inputFile);

    % Check if the expected columns 'x' and 'y' exist
    if ~all(ismember({'x', 'y'}, data.Properties.VariableNames))
        error('processData:MissingColumns','The CSV file must contain "x" and "y" columns.');
    end

    % Extract columns
    x = data.x;
    y = data.y;

    % Validate the data
    % Ensure the data is numeric
    if ~isnumeric(x) || ~isnumeric(y)
        error('processData:NonNumericData','The "x" and "y" columns must contain only numeric data.');
    end

    % Check for missing values (NaN)
    if any(isnan(x)) || any(isnan(y))
        error('processData:unassignedOutputs','The "x" and "y" columns contain missing values (NaN).');
    end


    % Generate the plot
    figure; % Create a new figure window
    plot(x, y, 'b-', 'LineWidth', 2); % Plot with a blue line
    xlabel('X'); % Label the x-axis
    ylabel('Y'); % Label the y-axis
    title('X vs Y'); % Title of the plot
    grid on; % Enable grid

    % Save the plot to a file
    saveas(gcf, outputPlotFile); % Save as a PNG file

end
