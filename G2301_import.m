function G2301_file=G2301_import(G2301_FileName)
%% Import the data
[~, ~, raw] = xlsread(strcat(G2301_FileName),'GHG');
raw = raw(2:end,:);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
G2301_file = reshape([raw{:}],size(raw));

end