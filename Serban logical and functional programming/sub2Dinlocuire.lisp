(defun replace2(element elementcautat lista)
   (cond
       ((listp element) (mapcar (lambda(elem) (replace1 elem elementcautat lista)) element))
	   (T element)
   )
)


(defun replace1(element elementcautat lista)
    (cond
	 ((equal element elementcautat) lista)
	 ((listp element) (mapcar (lambda(elem) (replace2 elem elementcautat lista)) element))
	 (T element)
	)
)