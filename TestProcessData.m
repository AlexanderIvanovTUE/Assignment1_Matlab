classdef TestProcessData < matlab.unittest.TestCase
    properties
        TestFolder
        TestCSVFile
        OutputPlotFile
    end
    
    methods (TestMethodSetup)
        function createTestFiles(testCase)
            % Create a temporary folder for test files
            testCase.TestFolder = fullfile(tempdir, 'TestProcessData');
            mkdir(testCase.TestFolder);
            
            % File paths
            testCase.TestCSVFile = fullfile(testCase.TestFolder, 'testData.csv');
            testCase.OutputPlotFile = fullfile(testCase.TestFolder, 'output_plot.png');
        end
    end

     methods (TestMethodTeardown)
        function deleteTestFiles(testCase)
            % Remove the temporary test folder after the tests
            if exist(testCase.TestFolder, 'dir')
                rmdir(testCase.TestFolder, 's');
            end
        end
    end

    methods (Test)
        function testFileNotFound(testCase)
            % Test when input file does not exist
            % Ensure the file does not exist
            if isfile(testCase.TestCSVFile)
                delete(testCase.TestCSVFile);
            end
            
            % Verify that the processData function throws the expected error
            testCase.verifyError(@() processData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processData:FileNotFound');
        end

        function testValidData(testCase)
            % Test with valid data
            x = (1:10)';
            y = rand(10, 1);
            T = table(x, y, 'VariableNames', {'x', 'y'});
            writetable(T, testCase.TestCSVFile);
            
            testCase.verifyWarningFree(@() processData(testCase.TestCSVFile, testCase.OutputPlotFile));
            % Verify the line plot image was created
            testCase.verifyTrue(isfile(testCase.OutputPlotFile));

            % Verify the scatter plot image was created
            scatterPlotFile = strrep(testCase.OutputPlotFile, '.png', '_scatter.png');
            testCase.verifyTrue(isfile(scatterPlotFile));
        end
        
        function testMissingYColumn(testCase)
            % Test with missing y column
            x = (1:10)';
            T = table(x, 'VariableNames', {'x'});
            writetable(T, testCase.TestCSVFile);
            
            testCase.verifyError(@() processData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processData:MissingColumns');
        end

        function testMissingXColumn(testCase)
            % Test with missing c column
            y = rand(10, 1);
            T = table(y, 'VariableNames', {'y'});
            writetable(T, testCase.TestCSVFile);

            testCase.verifyError(@() processData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processData:MissingColumns');
        end

        function testNonNumericDataY(testCase)
            % Test with non-numeric y data
            x = (1:10)';
            y = [rand(5, 1); 'd'; rand(4, 1)];
            T = table(x, y, 'VariableNames', {'x', 'y'});
            writetable(T, testCase.TestCSVFile);

            testCase.verifyError(@() processData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processData:NonNumericData');
        end

        
        function testALLNonNumericDataY(testCase)
            % Test with all non-numeric y data
            x = (1:10)';
            y = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'}';
            T = table(x, y, 'VariableNames', {'x', 'y'});
            writetable(T, testCase.TestCSVFile);
            
            testCase.verifyError(@() processData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processData:NonNumericData');
        end


        function testALLNonNumericDataX(testCase)
            % Test with all non-numeric x data
            x = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'}';
            y = rand(10, 1);
            T = table(x, y, 'VariableNames', {'x', 'y'});
            writetable(T, testCase.TestCSVFile);
            testCase.verifyError(@() processData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processData:NonNumericData');
        end

        function testNonNumericDataX(testCase)
            % Test with non-numeric x data
            x = [rand(5, 1); 'd'; rand(4, 1)];
            y = rand(10, 1);
            T = table(x, y, 'VariableNames', {'x', 'y'});
            writetable(T, testCase.TestCSVFile);
            
            testCase.verifyError(@() processData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processData:NonNumericData');
        end
       
        
        function testMissingYs(testCase)
            % Test with missing y's
            x = (1:10)';
            y = [rand(5, 1); NaN; rand(4, 1)];
            T = table(x, y, 'VariableNames', {'x', 'y'});
            writetable(T, testCase.TestCSVFile);
            
            testCase.verifyError(@() processData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processData:unassignedOutputs');
        end

        function testMissingXs(testCase)
            % Test with missing x's
            x = [rand(5, 1); NaN; rand(4, 1)];
            y = rand(10,1);
            T = table(x, y, 'VariableNames', {'x', 'y'});
            writetable(T, testCase.TestCSVFile);

            testCase.verifyError(@() processData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processData:unassignedOutputs');
        end

        function testLinePlotConditionMet(testCase)
            % Test when x is non-decreasing (conditionLinePlot == 1)
            x = (1:10)'; % A non-decreasing sequence
            y = rand(10, 1);
            T = table(x, y, 'VariableNames', {'x', 'y'});
            writetable(T, testCase.TestCSVFile);
            
            % Run processData and capture the return value
            linePlotCreated = processData(testCase.TestCSVFile, testCase.OutputPlotFile);
            
            % Verify the condition was met
            testCase.verifyTrue(linePlotCreated);

            % Verify the line plot was created
            testCase.verifyTrue(linePlotCreated);
        end

        function testLinePlotConditionNotMet(testCase)
            % Test when x is not non-decreasing (conditionLinePlot == 0)
            x = [1, 2, 3, 4, 5, 4, 7, 8, 9, 10]'; % A sequence with a decrease
            y = rand(10, 1);
            T = table(x, y, 'VariableNames', {'x', 'y'});
            writetable(T, testCase.TestCSVFile);
            
            % Run processData and capture the return value
            linePlotCreated = processData(testCase.TestCSVFile, testCase.OutputPlotFile);
            
            % Verify the line plot was not created
            testCase.verifyFalse(linePlotCreated);

            % Verify the line plot image was not created
            testCase.verifyFalse(isfile(testCase.OutputPlotFile));
        end

        
    end
end
