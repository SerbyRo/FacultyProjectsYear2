(defun apartine(elem mul)
	(cond 
		 ((NULL mul) NIL)
		 ((equal(CAR mul) elem) T)
		 (T (apartine elem (CDR mul)))
	)
)



(defun diferenta(mulmare mulmica)
		(cond
		   ((NULL mulmare) NIL)
		   ((apartine (CAR mulmare) mulmica) (diferenta (CDR mulmare) mulmica))
		   (T (cons (CAR mulmare) (diferenta (CDR mulmare) mulmica)))
		)
)