# Wykrywanie_posilkow
Projekt na kurs z Zaawansowanych technik przetwarzania sygnałów. Wykrywanie posiłków na podstawie przebiegów CGM. Prosty algorytm wykorzystujący tylko prędkość zmian poziomu glukozy. 

Projekt wykonany przy pomocy oprogramowania na licencji uczelnianej.

# Składniki

* Activity_for_plot.mat 
```
Dane tagów posiłków, etc. Richarda Sprague'a.
```
* Wykrywanie_Jedzenia.m
```
Program główny, wersja skryptowa. Generuje wykres.
```
* Zestaw_Danych.m
```
Skrypt opisujący i przeprowadzający uzyskanie potrzebnych danych w przestrzeni roboczej.
```
* czy_trafnie_wykrylo_posilek.m
```
Funkcja filtrująca zbiór danych zgodnie z określonymi w komentarzach warunkami oraz generująca dane dla statystyk opisowych (niektóre wskaźniki z macierzy pomyłek).
```
* detect_meals_and_glucose_drops.m
```
Funkcja odpowiedzialna za wskazywanie miejsc wzrostu i spadku poziomu glukozy na podstawie tempa jego zmian.
```
* kiedy_zjadlooo.fig
```
Plik okienka dla funkcji GUI.
```
* kiedy_zjadlooo.m
```
Skrypt GUI. Zawiera program główny przed podzieleniem na funkcje. Bardzo nieczytelny, raczej niezgodny z dobrą praktyką.
```
* only.mat
```
Dane CGM Richarda Sprague'a wprowadzone do przestrzeni roboczej Matlaba. Instrukcja uzyskania ich znajduje się odpowiednim skrypcie.
```
* plot_detected_points.m
```
Skrypt służący do rysowania wykrytych punktów.
```
* plot_glucose_and_divisions.m
```
Skrypt służący do rysowania przebiegu CGM oraz podziałek.
```
* plot_tags.m
```
Skrypt służący do nanoszenia tagów zawartych w pliku Activity_for_plot.m na wykres.
```
* raw_data.m
```
Jeden z plików danych używanych do uzyskania innych, zręcznie określone w skrypcie Zestaw_Danych.m.
```
* return_necessary_tags.m
```
Funkcja zwracająca tylko potrzebną ilość tagów dla danego wykresu.
```
* return_values_without_NaN_Nat.m
```
Funkcja pozbywa się wartości NaN, które zastępują błędne dane liczbowe oraz NaT, które natomiast zastępują błędne dane czasu.
```
* statystyki_zbiorcze.m
```
Skrypt zawierający program główny, dostosowany do wyciągania wniosków, dotyczących skuteczności algorytmu. Pracuje na całym zestawie danych, uruchomienie może pochłonąć nawet kilka minut.
```

# Źródło danych CGM
## [cool work done by Richard Sprague](https://github.com/richardsprague/cgm)
