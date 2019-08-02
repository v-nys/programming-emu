feared(X) :- likes(X,battle).
part(primes,math).
part(triangles,math).
part(logic,math).
likes(eratosthenes,primes).
likes(pythagoras,triangles).
likes(athena,logic).
likes(X,Y) :- part(Z,Y), likes(X,Z).
likes(father(athena),lightning).
greek(X).
