function F = testDart(theta,d)
imageColumns = 20;
imageRows = 20;
centerRow = theta(1);
centerColumn = theta(2);
radiusRow = theta(3);
radiusColumn = theta(4);
[columnsInImage rowsInImage] = meshgrid(1:imageColumns, 1:imageRows);
ellipsePixels = (rowsInImage - centerColumn).^2 ./ radiusColumn^2 ...
    + (columnsInImage - centerRow).^2 ./ radiusRow^2 <= 1;
dart = 20;
if ellipsePixels(d(1),d(2)) ==1
        dart = -20;
end
F = dart;
end
