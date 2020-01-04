function [spanie, treningi, jedzenie, czas_jedzenia] = return_necessary_tags(A, t)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% Aby odciążyć wyświetlanie określonych wykresów należy pozbyć się znaczników, które nie dotyczą wybranego 
% przedziału czasu t(1=>end) + flagi posiłków zapychają szare pola obok
% wykresów... tak być nie powinno.
food_index = find( ( A.food_time>t(1) & A.food_time < t(end) ) | ( A.food_time == t(1) | A.food_time == t(end) ) );

sleep_index =...
find( cellfun (@ (x) ( ( x(1) >  t(1) | x(2) >  t(1)) & ( x(1)  < t(end) | x(2)  < t(end) ) )...
                   | ( ( x(1) == t(1) | x(2) == t(1)) | ( x(1) == t(end) | x(2) == t(end) ) ),...
                   A.sleep, 'UniformOutput' , 1) );
exercise_index =...
find( cellfun (@ (x) ( ( x(1) >  t(1) | x(2) >  t(1)) & ( x(1)  < t(end) | x(2)  < t(end) ) )...
                   | ( ( x(1) == t(1) | x(2) == t(1)) | ( x(1) == t(end) | x(2) == t(end) ) ),...
                   A.exercise_time, 'UniformOutput' , 1) );

spanie = A.sleep(sleep_index, 1);
treningi = A.exercise_time(exercise_index, 1);
jedzenie = A.food(food_index);
czas_jedzenia = A.food_time(food_index);
end

