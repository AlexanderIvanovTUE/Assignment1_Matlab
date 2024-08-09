function linePlotCreated = processData(inputFile, outputPlotFile)
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
    if ~isnumeric(x) || ~isnumeric(y)
        error('processData:NonNumericData','The "x" and "y" columns must contain only numeric data.');
    end

    if any(isnan(x)) || any(isnan(y))
        error('processData:unassignedOutputs','The "x" and "y" columns contain missing values (NaN).');
    end


    % Initialize the flag
    linePlotCreated = false;

    % Check if x is non-decreasing
    % If x is decreasing the line plot will look awful and there will
    % hardly be any purpose of it.
    conditionLinePlot = 1;
    for i = 2:length(x)
        if x(i) < x(i-1)
            conditionLinePlot = 0;
            break;
        end
    end

    % If the condition is met, create the line plot and set the flag
    if conditionLinePlot == 1
        linePlotCreated = true;
        figure(1);
        plot(x, y, 'b-', 'LineWidth', 2);
        xlabel('X');
        ylabel('Y');
        title('Line Plot');
        grid on;
        saveas(gcf, outputPlotFile); % Save as a PNG file
    else
        disp("Line plot was not created.")
    end

    % Create a scatter plot
    figure(2);
    scatter(x, y, 'filled');
    xlabel('X');
    ylabel('Y');
    title('Scatter Plot');
    grid on;
    saveas(gcf, strrep(outputPlotFile, '.png', '_scatter.png'));

end
