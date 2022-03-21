(defun inverseaza(lista  acumulator)
	(cond 
	   ((NULL lista) acumulator)
	   ((atom(CAR lista)) (inverseaza(CDR lista) (cons(CAR lista) acumulator)))
	   (T (inverseaza(CDR lista) (cons(inverseaza(CAR lista) NIL) acumulator)))
	   )
)

(defun  wrapper(lista)
	(inverseaza lista NIL)
)