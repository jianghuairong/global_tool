% clc;clear;
% load('cacd_img_feature_map.mat');
% load('cacdvs_img_feature_map.mat');
threshold = 0.4;
fout = fopen('needDeleteList.txt','wt');
allImgPaths = img_feature_map.keys();
all_class_labels = cell(length(allImgPaths), 1);
for i = 1:length(allImgPaths)
    path = allImgPaths{i};
    idx = strfind(path, '/');
    all_class_labels{i} = path(1:idx(1));
end

classIndexMap = {};
%% type 1 for computing classIndexMap
% tic
% u_class_labels = unique(all_class_labels);
% u_class_len = length(u_class_labels);
% for i_u = 1:u_class_len
%     i_u
%     classIndexMap{i_u} = find(strcmp(all_class_labels, u_class_labels{i_u}));
% end
% toc
%% type 2 for computing classIndexMap
tic
[all_class_labels, idx] = sortrows(all_class_labels);
allImgPaths = allImgPaths(idx);
last_label = '';
count = 0;

for i_u = 1:length(all_class_labels)
    label = all_class_labels{i_u};
    if strcmp(last_label, label) == 0
         count = count + 1;
         classIndexMap{count}= [];
         last_label = label;
    end
    classIndexMap{count} = [classIndexMap{count} i_u];
end
toc
feature_dim = length(img_feature_map(allImgPaths{1}));
for i_u = 1:length(classIndexMap)
    i_u
    allIndexPerClass = classIndexMap{i_u};
    allIndexLen = length(allIndexPerClass);
    all_class_features = zeros(allIndexLen, feature_dim);
    for i_a = 1:allIndexLen
        all_class_features(i_a, :) = img_feature_map(allImgPaths{allIndexPerClass(i_a)});
    end
    score_matrix = all_class_features * all_class_features';
    mean_score = mean(score_matrix, 1);
    all_idx = find(mean_score < threshold);
    for i_i = 1:length(all_idx)
        idx = all_idx(i_i);
        fprintf(fout, '%s\n', allImgPaths{allIndexPerClass(idx)});
    end
%     for i_a = 1:allIndexLen
%         testIndex = allIndexPerClass(i_a);
%         testIndexFeatures = img_feature_map(allImgPaths{testIndex});
%         score = [];
%         for i_b = 1:allIndexLen
%             tempFeatures = img_feature_map(allImgPaths{allIndexPerClass(i_b)});
%             score(i_b) = testIndexFeatures' * tempFeatures;
%         end
%         if mean(score) < threshold
%              fprintf(fout, '%s\n', allImgPaths{testIndex});
%         end
%     end
end
fclose(fout);