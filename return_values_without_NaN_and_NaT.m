function [output_t, output_s, output_g] = return_index_without_NaN_and_NaT(only, column)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

s = only.interpolated_seconds(:, column);
t = only.interpolated_datatime(:, column);
g = only.interpolated_data(:, column);

limit = length(t(~isnat(t))); % indeksy dla tego co chcemy.
% pozostałe są NaT albo NaN

output_t = t(1:limit);
output_s = s(1:limit);
output_g = g(1:limit);
end

