(defun replace1(element elementcautat lista)
    (cond
	 ((equal element elementcautat) lista)
	 ((listp element) (mapcar (lambda(elem) (replace1 elem elementcautat lista)) element))
	 (T element)
	)
	
)