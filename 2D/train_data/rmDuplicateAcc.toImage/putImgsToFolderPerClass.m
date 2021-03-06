allImgPaths = importdata('/home/brl/TRAIN/DataSet/CACD/DATA/AlignedCACD/cacd.txt');
dataDir = '/home/brl/TRAIN/DataSet/CACD/DATA/AlignedCACD/CACD2000CleanedDuplicateAndTestImages';
outDir = '/home/brl/TRAIN/DataSet/CACD/DATA/AlignedCACD/cleanedClassPerFolder';
newImgPaths = cell(length(allImgPaths), 1);
for i = 1:length(allImgPaths)
    path = allImgPaths{i};
    idx = strfind(path, '_');
    newImgPaths{i} = path(idx(1)+1:idx(end)-1);
end

uImgPaths = unique(newImgPaths);
uImgLen = length(uImgPaths);
for i_u = 1:uImgLen
    i_u
    allIndexPerClass = find(strcmp(newImgPaths, uImgPaths{i_u}));
    for i_a = 1:length(allIndexPerClass)
        index =  allIndexPerClass(i_a);
        path = allImgPaths{index};
        subDir = [fullfile(outDir, uImgPaths{i_u}) filesep];
        make_dir(subDir);
        imwrite(imread(fullfile(dataDir, path)), fullfile(subDir, allImgPaths{index}(1:end)));
    end
end
