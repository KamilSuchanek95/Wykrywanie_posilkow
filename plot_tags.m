function [nil] = plot_tags(spanie, treningi, jedzenie, czas_jedzenia)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% Plot posiłków i okresów snu oraz treningu.

%funkcje anonimowe łatek dla snu i treningu
spanko = @(x, y) fill(x, y, [.1 .1 .6], 'FaceAlpha', .21, 'EdgeColor', 'none');
trening = @(x, y) fill(x, y, [.9 .3 .1], 'FaceAlpha', .21, 'EdgeColor', 'none');

% rysowanie snu i treningu
for i = 1:length(spanie)
    spanko([(spanie{i, 1}(1)),(spanie{i, 1}(2)),(spanie{i, 1}(2)),(spanie{i, 1}(1))],...
    [0,0,200,200]);
    hold all
end
for i = 1:length(treningi)
    trening([(treningi{i, 1}(1)),(treningi{i, 1}(2)),(treningi{i, 1}(2)),(treningi{i, 1}(1))],...
    [0,0,200,200]);
    hold all
end

%  rysowanie jedzenia
food_value = 1:length(jedzenie); food_value(1:end) = 80;
h = text(czas_jedzenia, food_value, jedzenie);
plot(czas_jedzenia, food_value - 5, 'gs',...
    'MarkerSize',10,...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor',[0.5,0.5,0.5]);
set(h,'Rotation',90);

end

