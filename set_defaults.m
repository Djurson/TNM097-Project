
function s = set_defaults(s, varargin)
for i=1:2:numel(varargin)
    k = varargin{i};
    v = varargin{i+1};
    if ~isfield(s,k)
        s.(k) = v;
    end
end
end
