function tiff_stack = tiffloader(filename,T)
%Simple function to load in the .TIF file into a matrix
%For excessively large file sizes it's probably better to pre-load the .TIF
%as a matrix and feed that directly into the program instead of calling
%this
    tiff_stack = imread(filename, 1);
    for i = 1 : T
         temp_tiff = imread(filename, i);
         tiff_stack = cat(3 , tiff_stack, temp_tiff);
    end
end

