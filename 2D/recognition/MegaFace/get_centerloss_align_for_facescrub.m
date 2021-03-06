%%
% addpath(genpath('~/github/global_tool'));
% data =importdata('/home/brl/TRAIN/facescrub.txt');
% root_dir = '/home/brl/TRAIN/downloaded/';
% output_dir = '/home/brl/TRAIN/alignedFacescrub/';
failedDetect = importdata('/home/brl/github/global_tool/2D/detection/mtcnn/failedDecect.txt');
fid = fopen('/home/brl/TRAIN/downloaded/needDealMannual_list.txt','wt');
for i_d = 1:length(data)
    i_d
    img_name = data{i_d};
    try
        img = imread([root_dir img_name]);
    catch
        fprintf(fid, '%s\n', img_name);
        continue;
    end
    pts_name = [img_name '.5pt'];
    pts_file = [root_dir pts_name];
    
    if ~exist(pts_file,'file')
        fprintf(fid, '%s\n', img_name);
        continue;
    end
    
    img_name_split = regexp(img_name,filesep,'split');
    output_file_dir = [output_dir img_name_split{1}];
    output_file = [output_dir img_name];
    if ~exist(output_file_dir,'dir')
        mkdir(output_file_dir);
    end
    img = exceptionDeal(img);
    align_img = centerloss_align_single(img,pts_file, false);

    %     imshow(align_img);
    try
        imwrite(align_img,output_file);
    catch
        imwrite(align_img,output_file,'JPEG');
    end
end
fclose(fid);


function outImg = exceptionDeal(img)

if max(img(:)) > 255 || min(img(:))<0
    img = single(img);
    maxValue = max(img(:));
    minValue = min(img(:));
    img = (img - minValue)/(maxValue-minValue)*255;
    outImg = uint8(img);
else
    outImg=img;
end

end
