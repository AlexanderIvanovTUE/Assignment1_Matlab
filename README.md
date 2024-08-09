# MATLAB Data Processing Application

# Overview
This project is a MATLAB application designed to process data from a CSV file, generate a plot based on the processed data, and output the results to a file. The application is managed through a GitHub repository, with GitHub Actions set up to automatically run a suite of unit tests whenever updates are pushed to the repository.

# Functionality
1. CSV Data Processing: Reads data from a CSV file(inputData.csv), checks for the presence of required columns ('x' and 'y'), validates that the data is numeric, and ensures there are no missing values.
2. Plot Generation: Creates a plot of 'y' versus 'x' and saves it to a specified output file.
3. Error Handling: Robust error handling for various edge cases, such as missing files, non-numeric data, and missing values.
4. Automated Testing: Includes a variaty of unit tests that cover different scenarios, including missing columns, non-numeric data, and file handling.

# Dependencies
No reliance on external libraries outside of MATLAB's standard functions and toolboxes.

# Preconditions to using the application:
1. The file to be used needs to be named inputData.csv .
2. Columns need to be named x,y (lower case).
3. The values in the cells need to be numerical.
4. No missing values in the cells.

# Set up and run the apllication
1. Clone the repository.
2. Navigate to the cloned repository in MATLAB.
3. Run this command in matlab:
   
     processData('path/to/your/csvfile.csv', 'output_plot.png');
   
( Replace 'path/to/your/inputData.csv' with the path to your inputData CSV file and 'output_plot.png' with the desired output file name.)



