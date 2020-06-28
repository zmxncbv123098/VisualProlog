
%cinema(ID, NAME, ADRESS, TELEPHONE)
cinema(1, "Иллюзион", "Котельническая наб., д.1/15", "(495) 915 43 39, 915 43 53").
cinema(2, "Пионер", "Кутузовский пр-т, д.21", "(499) 240 52 40").
cinema(3, "Формула Кино Сити", "Пресненская наб., д.2", "(495) 795 37 95").
cinema(4, "Синема Парк на Южной", "Днепропетровская, д.2", "(495) 644 41 11").
cinema(5, "Кинозал ГУМа", "Красная пл., д.3", "(495) 788 43 43, 620 30 62").
cinema(6, "Мир искусства", "Долгоруковская, д.33, стр. 3", "(499) 978 66 19, 978 69 89").
cinema(7, "Кино на Алтуфьевском", "Алтуфьевское ш., д.8", "(495) 287 32 17, 287 32 18").
cinema(8, "Кинозал Домжур", "Никитский б-р, д.8а", "(495) 691 56 98, 222 10 60").
cinema(9, "Kinostar De Lux Теплый Стан", "41-й км МКАД, ТРК «Мега»", "(495) 775 44 77, 775 44 99").
cinema(10, "35ММ", "ул. Покровка, д.47", "(495) 780 91 45").


%film(ID, NAME, RELEASED, DIRECTOR, GENRE)
film(1, "The Shawshank Redemption", "14 Oct 1994", "Frank Darabont", drama).
film(2, "The Dark Knight", "18 Jul 2008", "Christopher Nolan", action).
film(3, "Star Wars: Episode IV - A New Hope", "25 May 1977", "George Lucas", action).
film(4, "The Godfather", "24 Mar 1972", "Francis Ford Coppola", crime).
film(5, "The Matrix", "31 Mar 1999", "Lana Wachowski, Lilly Wachowski", sciFi).
film(6, "Forrest Gump", "06 Jul 1994", "Robert Zemeckis", drama).
film(7, "Inception", "16 Jul 2010", "Christopher Nolan", sciFi).
film(8, "Fight Club", "15 Oct 1999", "David Fincher", drama).
film(9, "The Good, the Bad and the Ugly", "29 Dec 1967", "Sergio Leone", western).
film(10, "Léon: The Professional", "18 Nov 1994", "Luc Besson", crime).

%showing(idCINEMA, idFILM, DATE, TIME) 
showing(1,1,"10.01", "10:00").
showing(3,1,"11.02", "11:01").
showing(5,1,"12.03", "12:24").
showing(7,1,"13.04", "13:21").
showing(1,2,"14.05", "14:07").
showing(2,2,"15.05", "15:17").
showing(3,2,"16.05", "16:30").
showing(4,3,"17.06", "17:45").
showing(5,3,"18.06", "18:00").
showing(9,3,"19.06", "19:04").
showing(9,4,"20.07", "20:23").
showing(6,4,"21.07", "21:08").
showing(8,5,"22.08", "22:34").
showing(6,5,"23.09", "23:01").


filmList(Name) :- film(_, Name, _,_,_). % All films
cinemaList(Name) :- cinema(_, Name, _,_). % All Cinemas

getFilmID(ID,FilmName) :- film(ID,FilmName,_,_,_). % Get filmID by filmName 
getCinemaID(ID,CinemaName) :- film(ID,CinemaName,_,_). % Get cinemaID by cinemaName

getCinemaAdress(Adress, CName) :- cinema(_, CName, Adress, _).

getFilmsByGenre(Name, Genre) :- film(_,Name, _,_,Genre).

getCinemaByFilm(CinemaName, FilmName) :- getFilmID(FID,FilmName), showing(CID, FID, _, _), cinema(CID, CinemaName, _,_).

getCinemaAdressByGenre(Adress,Genre) :- film(FID,_,_,_,Genre), showing(CID, FID, _, _), cinema(CID, _, Adress, _).


% Примеры Запросов 
% filmList(Name).
% cinemaList(Name).
% getFilmsByGenre(Name, drama).
% getFilmsByGenre(Name, Genre).
% getCinemaByFilm(CinemaName, "The Shawshank Redemption").
% getCinemaAdressByGenre(Adress, drama).

