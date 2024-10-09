%Part 8
%% Part 8 Anayzes the image and determines categry
disp('Running part 8');
load('workspace7.mat')
RBRatio_Thresh=1.35
disp('Loaded!...');
[ASCBias, MappedIndex, GoodIndex, xcart, ycart, zcart,...
    CloseBIndex CloseBScreen, bxpix, bypix, bf_azel] = BFprerun; %Script to generate ASC bias
for S= 1:length(ScintData) %loop through each sheet(S)
    if ~isempty(ScintData{S})%only deal with nonempty types

[ScintData{S}] = ImageBatch(ScintData{S},NumScintEvents(S),...
    ASCBias, MappedIndex, GoodIndex, xcart, ycart, zcart,...
    CloseBIndex, CloseBScreen, bxpix, bypix, bf_azel, RBRatio_Thresh);
    end
end
clear ASCBias MappedIndex GoodIndex xcart ycart zcart CloseBIndex CloseBScreen bxpix bypix bf_azel
save('workspace8.mat',...
    'ScintData', 'NumScintEvents', 'SheetName', 'root_dir', ...
    '-v7.3','-nocompression')
disp('Finished Part 8');