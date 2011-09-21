;;CSCC24 Assignment 1
;;The following is a group of functions that do a variety of operations 
;; to any given list items.
;; Some of them yield information about levels of lists, such as depth.
;; Others search for similar elements and report information, such as 
;; initial-run and find-similar.
;; It also contains a sorting algorithm, mergesort, that will sort
;; lists of numbers into order.

;;The following two functions are courtesy of the Professor.


;; define a function that calculates the number
;; of elements in its argument (the length of the list)
;; top-level arguments
(define (my-length lst)
  (cond ((null? lst) 0)  ;; if the list is empty return 0
        (else (+ 1 (my-length (cdr lst))))
        )
  )


;; define a function that returns the number of atoms
;; at all levels
(define (num-atoms lst)
  (cond ((null? lst) 0)
        ;; if the first element is not a list
        ;; add one to the num-atoms in the rest of the list
        ((not (list? (car lst))) (+ 1 (num-atoms (cdr lst))))
        ;; first element is a list
        (else (+ (num-atoms (car lst)) (num-atoms (cdr lst))))
        )
  )

;;A1b Assignment Code
;; delete-second takes in a list of more than two atoms
;; and returns the list sans the last element.
;; lst must have 2 or more elements, else it returns 0.
(define (delete-second lst)
  (cond ( (< (length lst) 2) 0)
        ;; if the list is more than 2 elements
        ;; create a list without the 2nd element
        (else (cons(car lst) (cddr lst)))
        )
  )

;;myfunction is a function that compares types of parametres.
;;If a is a number, multiply it by two and return it
;;If a is a list, return the first element of said list
;;And if a is neither of the above, return a.
(define (myfunction a)
  (cond ((number? a) (* a 2))
        ((list? a) (car a))
        (else a)
        )
  )

;;middle-position is a function that takes in a list of items,
;;and returns where the median, or middle index position for the
;;middle element.
;;This function floors lists that have even numbers as the total size.
;;If the list is empty, middle-position returns 0.
(define (middle-position lst)
  (cond ((null? lst) 0)
        ((even? (length lst)) (/ (length lst) 2))
        ((odd? (length lst)) (/ (- (length lst) 1) 2))
        )
  )

;; exclude-last takes a list, and returns that list without
;; the last element. 
;; This is a helper method to middle-element that is of
;; n bounds.
(define (exclude-last lst)
  (cond (( = (length lst) 2) (list (car lst)))
        (else (cons(car lst) (exclude-last(cdr lst)))
              )
        )
  )

;; get-last takes a list and simply returns the last element
;; of the list. Kind of like exclude-last, but with returning that
;; last element.
;; Takes O(n) time
(define (get-last lst)
  (cond (( = (length lst) 2) (car (cdr lst)))
        (else (get-last (cdr lst)))
        )
  )

;; middle-element takes in a list, and returns the middle
;; element of said list. Like middle-position, if a list of
;; even numbered elements is encountered it floors the result
;; and thus returns the element that is just before the 
;; numerical middle element.
;; Takes O(n) time to fnd that middle element
(define (middle-element lst)
  (cond ((null? lst) 0)
        ((<= (length lst) 2)(car lst))
        ;;If list isn't 2 or less elements, this takes the middle element of
        ;;the current list that has it's first and last element removed.
        (else(middle-element(cdr(exclude-last lst))))
        )
  )

;; initial-run works on a list passed in, and upon finding the first atom finds
;; the same atom in that top level list. It ignores all other atoms on any other
;; level of lists. It returns the number of atoms found in that top level list.
;;Takes O(n) time.
(define (initial-run lst)
  (cond ((null? lst) 0)
        ;; Is the next element a list? If so then focus only on that list.
        ((list? (car lst)) (initial-run(car lst)))
        ;; If not, then this is probably the top-level list. Start comparing...
        (else(find-similar lst (car lst)))
        )
  )

;; find-similar is a helper function that simply checks the passed element, a
;; on a valid single-level list (meaning, no nested lists alowed), 
;; and returns the number of similar elements.
;; Sorry for the box, I don't know how to get rid of it..
;;Takes O(n) tie
(define (find-similar lst a)
  (cond ((= (length lst) 0) 0)
        ;; Check first to see if the next element is equal to what we're
        ;; trying to find. If so, add one and keep looking.
        ((eq? (car lst) a)(+ 1 (find-similar(cdr lst)a)))
        ;; If not, don't add one and still keep looking.
        (else(find-similar(cdr lst) a))
        )
  )

;; depth returns the number of maximum levels inside the provided list.
;; Takes the same amount of time as dig-deep, which is O(n).
(define (depth lst)
  (cond ((null? lst) 0)
        ;; Add 1 for the base case depth (since list is not null, it must have
        ;; at least one level), then call the helper function that does all the 
        ;; recursion.
        (else (+ 1 (dig-deep lst)))
        )
  )

;; dig-deep is a helper function to depth that does all the rough work and recursion.
;; This was my original function, but since depths started at 1, I needed this helper
;; to simply add 1 to the base case of depth. Unfortunate but unavoidable.
(define (dig-deep lst)
  (cond ((null? lst) 0)
        ;; The following checks to see if the first element is a list. 
        ;; If so, add 1 to the depth counter, then check the depth
        ;; of both the found list and the rest of the list.
        ((list? (car lst)) (max-val(+ 1(dig-deep (car lst))) (dig-deep (cdr lst))))
        ;; If not a list, then this must be some ordinary element.
        ;; Ignore and keep going.
        (else (dig-deep (cdr lst)))
        )
  )
  

;; min-val simply returns the minimum value of two numbers. Replacement
;; for the disallowed min function in scheme. If both numbers are of
;; equal value, returns the value of them.
;; Obviously runs in O(1) time.
(define (min-val a b)
  (cond ((< a b) a)
        (else b)
        )
  )

;; max-val
;; Opposite of min-val, returns the larger of the two numbers.
;; Runs in O(1) time.
(define (max-val a b)
  (cond ((> a b) a)
        (else b)
        )
  )

;; rotate-right takes in a list of (possibly many levels and) elements
;; and shifts them right without carry. Meaning, the last element of 
;; the lists and their levels are shifted to the front, making the illusion
;; of the list being shifted. 
;; This implementation does not work with nested lists, sorry...
;; Takes O(n^2) time.
(define (rotate-right lst)
  (cond ((null? lst) 0)
        ((= (length lst) 1) lst)
        ;;((= (depth lst) 1) append(get-last lst)(exclude-last lst))
        ((list? (car lst)) cons(rotate-right(car lst) (rotate-right(cdr lst))))
        ;;(else(append(rotate-right(get-last lst))(rotate-right(exclude-last lst))))
        (else(search-and-turn(cons(get-last lst) (exclude-last lst))))
        )
  )

;; search-and-turn is a helper function to rotate-right that simply determines
;; if the current list holds more lists inside of it. If so, call rotate-right
;; for them and do their rotation.
;; This function is to primarily secure the results from the previous rotate-
;; right operation so that it does not rotate more than once.
;; Returns a list that meets the criteria of rotate-right.
;; Takes O(n) time.

(define (search-and-turn lst)
  (cond ((null? lst) 0)
        ((= (length lst) 1) lst)
        ((list? (car lst))cons(rotate-right(car lst))(search-and-turn(cdr lst)))
        (else(cons(car lst) (search-and-turn(cdr lst))))
        )
  )

;;linsearch searches for a specified item in a given list, and returns
;;the position of that item in the list. Items are counted starting at 1,
;;meaning that the first element is index 1. If the item is not found then
;;the function returns 0.
;; Takes O(n) time.
(define (linsearch lst item)
  (cond ((null? lst)0)
        ((= (find-similar lst item) 0) 0) 
        ((eq? item (car lst)) 1)
        (else(+ 1 (linsearch(cdr lst)item)))
        )
  )

;;mergesort recursively splits up a given list into many sub-lists, eventually
;;dividing it into single pieces. Then it puts it back together
;;and sorts out the smaller pieces when merged.
;; Takes O(n log n) time.
(define (mergesort lst)
  (cond ((null? lst) 0)
        ((and (eq? (length lst) 2) (> (car lst)(car(cdr lst))) (rotate-right lst)))
        ((and (eq? (length lst) 2) (< (car lst)(car(cdr lst))) lst))
        (else(merge(cons(mergesort(first-half lst))(mergesort(last-half lst)))))
        )
  )

;;Helper to mergesort, merge does the actual sorting bit of the lists.
;;Takes O(log n) time.
(define (merge lst)
  (cond ((null? lst) 0)
        ((and (eq? (length lst) 2) (> (car lst)(car(cdr lst))) (rotate-right lst)))
        ((and (eq? (length lst) 2) (< (car lst)(car(cdr lst))) lst))
        ((> (car lst)(car(cdr lst)))(append(append(list(caar lst)list(car lst))(merge(cdr lst)))))
        (else(append(list(car lst))(merge(cdr lst))))
        )
  )

;;first-half is a function that simply takes out the first half of a list.
;;Calls upon slice to do the actual, well, splicing.
;;Takes O(n) time.
(define (first-half lst)
  (cond ((null? lst) 0)
        ((eq? (length lst) 2) car lst)
        (else(slice lst (middle-position lst)))
        )
  )

;;last-half is a function that takes out the second half of a list.
;;Takes O(n^2) time.
(define (last-half lst)
  (cond ((null? lst) 0)
        ((eq? (length lst) 2) cdr lst)
        (else(dice lst (middle-position lst)))
        )
  )

;;slice and dice!
;;This function helps out first-half by actually splitting up the lists
;;given the middle position. It does this by car'ing the list until
;;it hits the middle element.
;;Takes O(n) time.
(define (slice lst position)
  (cond ((null? lst) 0)
        ((eq? position 1) (list(car lst)))
        (else(cons(car lst)(slice(cdr lst)(- position 1))))
        )
  )

;;slice and dice!
;;Opposite of slice, dice cdr's the list until it reaches the index
;;of the middle position, effectively leaving off the top half.
;;Takes O(n) time.
(define (dice lst position)
  (cond ((null? lst) 0)
        ((eq? position 1) (cdr lst))
        (else(dice(cdr lst)(- position 1)))
        )
  )

;;binsearch uses binary search on a given list to find a given item 
;;at it's highest position, if there are duplicates. It returns
;;that position if it is found, and 0 otherwise.
;;(define (binsearch lst item)
  ;;(cond ((null? lst) 0)
    ;;    ((and(eq? (length lst) 1) (eq? (car lst) item)) 
      ;;  ((< item (middle-element lst)) (binsearch (first-half lst)))

;;Unfortunately I ran out of time :( 
        