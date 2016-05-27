function [F] = testEllipse(current)
global expRows
global expColumns
global noExperiments
%Build elliptical target
imageColumns = 20;
imageRows = 20;
[columnsInImage rowsInImage] = meshgrid(1:imageColumns, 1:imageRows);
% % Next create the ellipse in the image.
centerRow = current(1);
centerColumn = current(2);
radiusRow = current(3);
radiusColumn = current(4);

ellipsePixels = (rowsInImage - centerColumn).^2 ./ radiusColumn^2 ...
    + (columnsInImage - centerRow).^2 ./ radiusRow^2 <= 1;
for i=1:noExperiments
    if ellipsePixels(expRows(i),expColumns(i)) ==1
        modelGuess(i) = -20;
    else
        modelGuess(i) = 20;
    end
end
F = modelGuess;
