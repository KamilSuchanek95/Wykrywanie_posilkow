function [nil] = plot_detected_points(g, meals_time, m_i, glucose_drops_time, g_i)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
%meals
plot(meals_time, g(m_i), 'or'); % rysuj posiłek
%drops
plot(glucose_drops_time, g(g_i), '<g');
end

