function showMessage(obj,type,message)
    if strcmp(type,'error') == 1
        set(obj,'Background', [0.95 0.87 0.87]);
        set(obj,'ForegroundColor', [0.66 0.27 0.26]);        
    elseif strcmp(type,'warning') == 1
        set(obj,'Background', [0.99 0.97 0.89]);
        set(obj,'ForegroundColor', [0.54 0.43 0.23]);
    elseif strcmp(type,'info') == 1
        set(obj,'Background', [0.85 0.93 0.97]);
        set(obj,'ForegroundColor', [0.19 0.44 0.56]);
    elseif strcmp(type,'success') == 1
        set(obj,'Background', [0.87 0.94 0.85]);
        set(obj,'ForegroundColor', [0.24 0.46 0.24]);        
    end 
        set(obj, 'String', message);
end