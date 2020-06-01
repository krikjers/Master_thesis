function [ str ] = getActiveRulesString( rules )
%rules is on the from [0,1,0,0,1] value for rule13, 14, 15, 16, 17
str = "rules ";

rules = reshape(rules, 1,5);

if (rules(1) == 0 && rules(2) == 0 && rules(3) == 0 && rules(4) == 0 && rules(5) == 0)
    str = "[none]";
end

if(rules(1) == 1)
    str = str + " 13, ";
end
if(rules(2) == 1)
    str = str + "14, ";
end
if(rules(3) == 1)
    str = str + "15, ";
end
if(rules(4) == 1)
    str = str + "16, ";
end
if(rules(5) == 1)
    str = str + "17, ";
end

str = string(str);


end

