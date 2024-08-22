function generateArraysAndPlot(table,distanceCol,altCol,minor,gap,major)
    bookMatrix = table2array(table);
    
    [rows,~] = size(bookMatrix);
    
    slopeColumn = zeros(rows,1);
    
    for i = 2:rows
        slopeColumn(i) = (bookMatrix(i,altCol)-bookMatrix(i-1,altCol))/(bookMatrix(i,distanceCol)-bookMatrix(i-1,distanceCol));
    end
    
    slopeColumn(isinf(slopeColumn)) = 0;
    
    randombook = addvars(table,slopeColumn, 'NewVariableNames', "Slope");
    
    %% Histogram storage and display
    
    randombook.Slope = round(randombook.Slope);
    
    edges = minor:gap:major;
    
    [counts,edges] = histcounts(randombook.Slope, edges);
    
    intervalos = edges(1:end-1);
    intervalo_superior = edges(2:end);
    
    finalMatrix = [intervalos', intervalo_superior', counts'];
    
    %% Final matrix to a exportable xlsx table
    
    finalMatrixExportable = array2table(finalMatrix, 'VariableNames', {'MinorLimit', 'MajorLimit', 'Counts'});
    
    timestamp = datetime('now');
    timestampStr = datestr(timestamp, 'yyyymmdd_HHMMSS'); 
    filename = sprintf('finalMatrix_%s.xlsx', timestampStr);


    writetable(finalMatrixExportable, filename);
    
    %% Displaying
    
    x = finalMatrix(:,2);
    y = finalMatrix(:,3);
    
    plot(x, y);
end

% ---------------------------------------------------------------------------
% HOW TO USE IT
%
% Based in the trucks' distance and altitude, this script calculates the slope
% increase or decrease percentage. The outputs are an hisogram based in the
% gaps given and a .xlsx file containg the results
%
% FUNCTION SYNTAX
% generateArraysAndPlot(NameOfTheImportedTable,distanceColumnIndex,AltitudeColumnIndex,gapMinorValue,Gap,MajorGapValue)
%----------------------------------------------------------------------------

