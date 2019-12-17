do $$
declare
	bound_cursor_film  SCROLL 
	CURSOR (ano integer) FOR SELECT title, release_year FROM film WHERE release_year = ano;
	unbound_cursor_film refcursor;
	rate real := 3.0;
	linha record;
	rec record;
	contador integer := 0;
begin
	-- open a bound cursor
	OPEN bound_cursor_film (2006);
	-- open a unbound cursor
	OPEN unbound_cursor_film NO SCROLL FOR  SELECT title,rental_rate FROM film WHERE rental_rate >= rate;
	
	RAISE NOTICE '===--------- BOUND CURSOR -------------===';
	-- Usando o fetch com a direção padrão (NEXT)
	FETCH bound_cursor_film INTO linha;	
	IF NOT FOUND THEN
		RETURN;
	END IF;
	
	RAISE NOTICE 'NEXT: (%) - %', linha.release_year, linha.title;
	-- Usando o fetch com a direção NEXT
	FETCH NEXT FROM bound_cursor_film INTO linha;	
	RAISE NOTICE 'NEXT: (%) - %', linha.release_year, linha.title;
	-- Usando o fetch com a direção NEXT
	FETCH NEXT FROM bound_cursor_film INTO linha;	
	RAISE NOTICE 'NEXT: (%) - %', linha.release_year, linha.title;
	
	-- Usando o fetch com RELATIVE COUNT: a partir da posicao atual do cursor (SCROLL)
	FETCH RELATIVE -1 FROM bound_cursor_film INTO linha;	
	RAISE NOTICE 'RELATIVE: (%) - %', linha.release_year, linha.title;
	-- Usando o fetch com ABSOLUTE COUNT: a partir do inicio do conjunto ativo (SCROLL)
	FETCH RELATIVE 5 FROM bound_cursor_film INTO linha;	
	RAISE NOTICE 'RELATIVE: (%) - %', linha.release_year, linha.title;

	-- Usando o fetch com ABSOLUTE COUNT: a partir do inicio do conjunto ativo (SCROLL)
	FETCH ABSOLUTE 3 FROM bound_cursor_film INTO linha;	
	RAISE NOTICE 'ABSOLUTE: (%) - %', linha.release_year, linha.title;
	
	-- Usando o fetch com LAST: posiciona no ultimo
	FETCH LAST FROM bound_cursor_film INTO linha;	
	RAISE NOTICE 'LAST: (%) - %', linha.release_year, linha.title;	
	-- Usando o fetch com a direção FIRST: inicio do conjunto ativo
	FETCH FIRST FROM bound_cursor_film INTO linha;	
	RAISE NOTICE 'FIRST: (%) - %', linha.release_year, linha.title;
	-- Usando o fetch com a direção NEXT
	FETCH NEXT FROM bound_cursor_film INTO linha;	
	RAISE NOTICE 'NEXT: (%) - %', linha.release_year, linha.title;
	-- Usando o MOVE RELATIVE
	MOVE RELATIVE 5 FROM bound_cursor_film;
	FETCH NEXT FROM bound_cursor_film INTO linha;	
	RAISE NOTICE 'MOVE RELATIVE: (%) - %', linha.release_year, linha.title;
	
	
	RAISE NOTICE '';
	RAISE NOTICE '===-------- UNBOUND CURSOR ------------===';
	-- Usando o fetch com a direção NEXT
	FETCH NEXT FROM unbound_cursor_film INTO rec;	
	RAISE NOTICE 'NEXT: (%) - %', rec.title, rec.rental_rate;	

	-- Usando o fetch com RELATIVE: 
	FETCH relative 10 FROM unbound_cursor_film INTO rec;	
	RAISE NOTICE 'RELATIVE: (%) - %', rec.title, rec.rental_rate;	
	-- Usando o fetch com ABSOLUTE
	FETCH ABSOLUTE 5 FROM unbound_cursor_film INTO rec;	
	RAISE NOTICE 'ABSOLUTE: (%) - %', rec.title, rec.rental_rate;	
	-- Usando o MOVE RELATIVE
	MOVE RELATIVE 5 FROM unbound_cursor_film;

	FETCH NEXT FROM unbound_cursor_film INTO rec;	
	RAISE NOTICE 'MOVE RELATIVE: (%) - %', rec.title, rec.rental_rate;
	
	RAISE NOTICE '';
	RAISE NOTICE '::::  Varrendo o unbound cursor para os 10 primeiros registros ::::';
	MOVE absolute 0 FROM unbound_cursor_film;
	LOOP
		FETCH unbound_cursor_film INTO rec;	
		EXIT WHEN NOT FOUND;
		contador := contador + 1;
		IF contador <= 10 THEN
			RAISE NOTICE '(%) % : %', contador,rec.title, rec.rental_rate;	
		ELSE
			EXIT;
		END IF;
	END LOOP;

	RAISE NOTICE '';
	RAISE NOTICE '::::  Varrendo o bound cursor para os 10 primeiros registros ::::';
	contador := 0;
	MOVE absolute 0 FROM bound_cursor_film;
	LOOP
		FETCH bound_cursor_film INTO rec;	
		EXIT WHEN NOT FOUND;
		contador := contador + 1;
		IF contador <= 10 THEN
			RAISE NOTICE '(%) % : %', contador,rec.release_year, rec.title;	
		ELSE
			EXIT;
		END IF;
	END LOOP;
	
	CLOSE bound_cursor_film;
	CLOSE unbound_cursor_film;
end $$;


--SELECT title, release_year from film where release_year = 2006;
-- select * from film;

	
