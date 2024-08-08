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
        function testValidData(testCase)
            % Test with valid data
            x = (1:10)';
            y = rand(10, 1);
            T = table(x, y, 'VariableNames', {'x', 'y'});
            writetable(T, testCase.TestCSVFile);
            
            testCase.verifyWarningFree(@() processData(testCase.TestCSVFile, testCase.OutputPlotFile));
            testCase.verifyTrue(isfile(testCase.OutputPlotFile));
        end
        
        function testMissingYColumn(testCase)
            % Test with missing y column
            x = (1:10)';
            T = table(x, 'VariableNames', {'x'});
            writetable(T, testCase.TestCSVFile);
            
            testCase.verifyError(@() processData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processData:MissingColumns');
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
       
        
        function testMissingYs(testCase)
            % Test with missing y's
            x = (1:10)';
            y = [rand(5, 1); NaN; rand(4, 1)];
            T = table(x, y, 'VariableNames', {'x', 'y'});
            writetable(T, testCase.TestCSVFile);
            
            testCase.verifyError(@() processData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processData:unassignedOutputs');
        end

        
    end
end
