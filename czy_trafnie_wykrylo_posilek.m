function [meals_true_false, no_meal_detected, l_food, l_detect] = czy_trafnie_wykrylo_posilek(czas_jedzenia, meals_time, plus_minus)

meals_true_false = []; % czy wykryty posiłek ma tag? Czyli, czy jest TP?
no_meal_detected = []; % czy w pobliżu tagu nie ma żadnych detekcji? nie ma? więc FN.
% l_lood => ostateczna ilość tagów wziętych pod uwagę
% l_detect => ostateczna liczba detekcji wziętych pod uwagę

od = meals_time(1); do = meals_time(1); % inicjalizacja zakresu +/-45min

% Filtr detekcji w godzinach obiadowych, jeśli nie, można zakomentować,
% ponobnie następne modyfikatory zbioru wsadowego
m = meals_time(1);
for t = 1:length(meals_time)
    s = datetime(meals_time(t).Year, meals_time(t).Month, meals_time(t).Day, 11,0,0);
    e = datetime(meals_time(t).Year, meals_time(t).Month, meals_time(t).Day, 14,30,0);
    if(meals_time(t)>s && meals_time(t)<e)
        m(end+1,1) = meals_time(t);
    end
end
meals_time = m(2:end,1);    
% Filtr tagów w godzinach obiadowych
oo = czas_jedzenia(1);
for t = 1:length(czas_jedzenia)
    s = datetime(czas_jedzenia(t).Year, czas_jedzenia(t).Month, czas_jedzenia(t).Day, 11,0,0);
    e = datetime(czas_jedzenia(t).Year, czas_jedzenia(t).Month, czas_jedzenia(t).Day, 14,30,0);
    if(czas_jedzenia(t)>s && czas_jedzenia(t)<e)
        oo(end+1,1) = czas_jedzenia(t);
    end
end
czas_jedzenia = oo(2:end,1);  

%Czy w dniu detekcji znajduje się choć 1 tag z posiłkiem?
meals_with_tags = meals_time(1);
tag_inside = 0;% jeśli tak to dopuść tą detekcję do statystyk

for u = 1:length(meals_time)%dla każdego posiłku sprawdź czy w jego dniu jest choć 1 tag
    %jeśli jest choć 1 tag posiłku to dopuść go do statystyk
    day_start = datetime(meals_time(u).Year, meals_time(u).Month, meals_time(u).Day, 0,0,0);
    day_end = datetime(meals_time(u).Year, meals_time(u).Month, meals_time(u).Day, 23,59,59);
    for q = 1:length(czas_jedzenia)
        if(czas_jedzenia(q)>day_start && czas_jedzenia(q)<day_end)
            tag_inside=1;break;end
        if(czas_jedzenia(q)==day_start || czas_jedzenia(q)==day_end)
            tag_inside=1;break;end
    end
    if(tag_inside>0)
        meals_with_tags(end+1,1) = meals_time(u);
        tag_inside=0;
    end
end
meals_with_tags = meals_with_tags(2:end, 1);

znalazl = false;
for i = 1:length(meals_with_tags)%dla każdego posiłku w otagowanym dniu
    
    for k = 1:length(czas_jedzenia)%dla każdego z tagów
        
        od = czas_jedzenia(k) - minutes(plus_minus); 
        do = czas_jedzenia(k) + minutes(plus_minus);
%znajdź detekcję w otagowanym dniu, która do tego tagu pasuje
        if( (meals_with_tags(i) > od && meals_with_tags(i) < do) || (meals_with_tags(i) == od || meals_with_tags(i) == do) )
            meals_true_false(end + 1, 1) = true;% ta detekcja jest OK
            znalazl = true;
            break;
        end
    end
    if(znalazl)
        znalazl = false;
    else
        meals_true_false(end + 1, 1) = false; % a ta nie jest OK
    end  


end

znalazl = false;
for i = 1:length(czas_jedzenia) % tag jedzenia
    
    for k = 1:length(meals_with_tags) % wykryty posiłek
        
        od = meals_with_tags(k) - minutes(plus_minus); 
        do = meals_with_tags(k) + minutes(plus_minus);
        % czy ten tag znajduje się w jednej z okolic wykrytych posiłków? (nie pominięty posiłek)
        if( (czas_jedzenia(i) > od && czas_jedzenia(i) < do) || (czas_jedzenia(i) == od || czas_jedzenia(i) == do) )
            no_meal_detected(end + 1, 1) = true;
            znalazl = true;
            break;
        end
    end
    
    if(znalazl) % tak, nie został pominięty
        znalazl = false;
    else % nie, został jednak pominięty.
        no_meal_detected(end + 1, 1) = false;
    end
    
end

no_meal_detected = ~no_meal_detected;% false to poinięty a o nie nam chodzi więc negujemy i mamy jedynki za pominięty
l_food = length(czas_jedzenia);
l_detect = length(meals_with_tags);
end
