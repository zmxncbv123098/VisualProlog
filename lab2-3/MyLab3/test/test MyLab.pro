% Copyright
/*
Какие Фильмы показывает определенный кинотеатр
Какие у фильма жанры
В каком кинотеатре и какие фильмы сейчас в прокате определенного жанра
Сколько фильмов определенного режиссера в топе
*/

implement main
    open core, file, stdio

domains
    genres =
        crime; drama; action; thriller; biography; history; adventure; fantasy; western; romance; sci_fi; mystery; comedy; war; family; animation;
        musical; music; horror; film_noir; sport.

class facts - kinoDB
    genre : (integer GenreId, genres Genre).
    cinema : (integer Id, string Name, string Adress, string Telephone, real Latitude, real Longitude).
    film : (integer Id, string Name, string Released, string Director).
    filmGenre : (integer FilmId, integer GenreId).
    showing : (integer CinemaId, integer FilmId, string Date, string Time).

class facts
    s : (real Count) single.

clauses
    s(0).

class predicates
    filmInCinema : (string CinemaName) -> string* Films determ.
    getGenres : (string CinemaName) nondeterm.
    getStreamByGenre : (genres X) failure.
    numFilmsByDirector : (string Director).

clauses
    filmInCinema(X) :-
        cinema(Cid, X, _, _, _, _),
        write("Фильмы в ", X, ":\n"),
        showing(Cid, Fid, _, _),
        film(Fid, Name, _, _),
        write("  ", Name),
        nl,
        fail.
    filmInCinema(X) :-
        cinema(_, X, _, _, _, _),
        write("Конец списка"),
        nl,
        nl.

    getGenres(X) :-
        write("Жанры ", X, ":\n"),
        film(Cid, X, _, _),
        filmGenre(Cid, Gen),
        genre(Gen, Name),
        write("  ", Name),
        nl,
        fail.
    getGenres(X) :-
        film(_, X, _, _),
        write("Конец списка"),
        nl,
        nl.

    getStreamByGenre(X) :-
        write("Фильмы жанра ", X, " идут в кинотеатрах:\n\n"),
        showing(Cid, Fid, _, _),
        genre(Id, X),
        filmGenre(Fid, Id),
        film(Fid, Fname, _, _),
        cinema(Cid, Cname, _, _, _, _),
        write("Фильм ", Fname, " идёт в ", Cname),
        nl,
        fail.

    numFilmsByDirector(X) :-
        write("\nКоличество фильмов режиссера ", X),
        nl,
        assert(s(0)),
        film(_, Name, _, X),
        s(Count),
        asserta(s(Count + 1)),
        write(Count + 1, ". ", Name),
        nl,
        fail.
    numFilmsByDirector(X) :-
        write("Конец списка\n"),
        s(Count),
        write("Всего фильмов ", X, ": ", Count),
        nl,
        nl.

    run() :-
        console::init(),
        reconsult("..\\selection.txt", kinoDB),
        filmInCinema("Иллюзион"),
        fail.

    run() :-
        getGenres("The Dark Knight"),
        fail.
    run() :-
        getStreamByGenre(thriller).
    run() :-
        numFilmsByDirector("Christopher Nolan"),
        fail.

    run() :-
        succeed.

end implement main

goal
    console::run(main::run).
