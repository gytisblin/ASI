function [hasData] = NCDataCheck(FileName)
%     disp(Filename)
try
    hasData=(length(ncread(FileName,'Time'))~=0);
catch
    hasdata = 0 ~= 0;
end
end