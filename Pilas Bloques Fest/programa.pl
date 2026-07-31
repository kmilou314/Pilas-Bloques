/*Se viene la fiesta más esperada del año! La Pilas Bloques Fest. A esta fiesta van a atender algunos de los famosos
personajes para celebrar el éxito del lanzamiento de Pilas Bloques Desenchufados y nos pusieron a cargo de la 
organización. Para eso, necesitamos tener en cuenta las preferencias alimenticias de cada uno.

1) Tenemos la siguiente información de cada uno de los personajes y sus comidas preferidas:*/
% a)
leGusta(chuy, peces).
leGusta(duba, churrasco).
leGusta(lita, ensalada([tomate, lechuga])).
leGusta(coty, pasto).
leGusta(manic, pasto).
leGusta(duba, asado(entrania, limonada)).

esComida(Comida):-
    leGusta(_, Comida).

/*b) Sabemos que el churrasco y los peces son de tipo carne, mientras que el tomate, la lechuga, y el pasto son de 
tipo planta. Las ensaladas son de tipo planta si todos sus ingredientes son de planta. Los asados siempre son de 
tipo carne.*/
carne(churrasco).
planta(tomate).
planta(lechuga).
planta(pasto).
planta(ensalada(ListaIngredientes)):-
    forall(member(Ingrediente, ListaIngredientes), planta(Ingrediente)).
carne(asado(_, _)).

/*2) A su vez, existen distintos lugares de los que conseguir los ingredientes para la fiesta:*/
% a) Conocemos los siguientes biomas y los ingredientes que contiene
contiene(bosque, churrasco, 3).
contiene(desierto, tomate, 1).
contiene(desierto, lechuga, 1).
contiene(desierto, pasto, 1).
contiene(playaPatagonica, peces, 4).
contiene(playaPatagonica, lechuga, 3).

bioma(Bioma):-
    contiene(Bioma, _, _).

/*b) También sabemos que un bioma es nutritivo cuando el bioma cuenta con más de dos ingredientes 
y al menos uno de ellos es de tipo planta.*/
esNutritivo(Bioma):-
    bioma(Bioma),
    findall(Ingrediente, contiene(Bioma, Ingrediente, _ ), Lista1),
    findall(Ingrediente, (contiene(Bioma, Ingrediente, _), planta(Ingrediente)), Lista2),
    length(Lista1, Long1),
    length(Lista2, Long2),
    Long1 >= 2,
    Long2 > 0.

esNutritivo2(Bioma):-
    contiene(Bioma, Ingrediente, Cantidad),
    Cantidad > 2,
    planta(Ingrediente).

/*3) Si bien pepita no va a llegar a la fiesta, nos interesa saber el camino que va a recorrer desde
el norte hacia acá

a) Pepita nos compartió su camino, el cual es así: */

camino(norte, desierto).
camino(desierto, llanura).
camino(llanura, bosque).
camino(bosque, playaPatagonica).

/*b) Pepita necesita que la ayudemos a ubicarse (algo raro para una golondrina2), nos pide que consultemos si desde un 
lugar puede llegar a otro. Por ejemplo, desde el norte puede llegar al desierto, o desde el desierto puede llegar al
 bosque pasando primero por la llanura.*/

puedeLlegar(Partida, Destino):-
    camino(Partida, Destino).

puedeLlegar(Partida, Destino):-
    camino(Intermedio, Destino),
    puedeLlegar(Partida, Intermedio).

/*4)Queremos poder armar mesas para la fiesta, pero necesitamos que los personajes sientan comodidad y para eso 
queremos que se conozcan entre sí. Para ver como las armamos queremos saber todos los caminos posibles por los que 
un personaje conoce a otro. Sabemos entonces que:*/

seConocen(coty, lita).
seConocen(lita, duba).
seConocen(duba, manic).
seConocen(duba, capy).
seConocen(capy, manic).
seConocen(capy, lita).
seConocen(capy, coty).

conoce(Persona, OtraPersona):-
    seConocen(Persona, OtraPersona).

conoce(Persona, OtraPersona):-
    seConocen(OtraPersona, Persona).

conoceAux(Primera, Destino, _, [Primera, Destino]):-
    conoce(Primera, Destino).

conoceAux(Primera, Destino, ListaDeVisitados, [Primera | ListaCaminos]):-
    conoce(Primera, Intermedio),
    Intermedio \= Destino,
    not(member(Intermedio, ListaDeVisitados)),
    conoceAux(Intermedio, Destino, [Intermedio | ListaDeVisitados], ListaCaminos).

caminosPosibles(Origen, Destino, Camino):-
    conoceAux(Origen, Destino, [Origen], Camino).




