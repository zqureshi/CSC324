#lang racket

#| Core Principles of Class-based Objects.

   At an interview for AMD, a former student was asked:

    "C is often used for embedded systems, but sometimes a bit of OO
     is useful to structure a program. How does one (or would you)
     implement objects in C?" |#


#| (a) Classes as factory/template/blueprint for objects/instances with
        a private single named state and a single anonymous no-argument behaviour.

   Class: as declaration mechanism for classes.

   Implementation: preparation for efficient lookup of multiple instance variables.

   Review the first tutorial, Toggle, Caching and counter.

   Review classes vs objects, instance vs static, and a memory model for Java/Python.
   Students who said/found that our earlier work clarified 108/148/207 for them can wait
    with the OO review (unless they get stuck).

   Write Class, taking

     1. a pair of instance variable name as symbol, and initial value: (<var-id> <value>)
     2. a unary function, taking a hasheq-table mapping instance variable name to value

    and returning a "thunk" (zero arity function) that acts as a no-argument constructor.

   The constructor, when called, returns an instance as a thunk; that thunk, when called,
    'invokes' the unary function 'on' the thunk's copy of the instance variable.

   E.g. |#
#;
(define Counter
  (Class '(count -1)
         (λ (my)
           (hash-update! my 'count add1)
           (hash-ref my 'count))))
#|
(define o1 (Counter))
(o1) ; => 0
(o1) ; => 1
(define o2 (Counter))
(o2) ; => 0
(o1) ; => 2
(o2)) ; => 1
|#


#| (b) Classes for objects with multiple private instance variables,
        and multiple no-argument behviours/methods.

   Implementation: efficient lookup of multiple methods --- "dispatch" to a "dispatch table".

   Modify Class, taking

     1. a list of pairs of instance variable name and initial value: ((<var-id> <value>) ...)
     2. pairs of method name as symbol and corresponding unary function taking a hasheq-table
         of instance variables: (<method-id> <function-of-instance-variables>) ...

    and returning a constructor thunk.

   The constructor returns a unary function, let's call it 'o', callable with a method name, as
     (o <method-id>)
    to invoke the method('s function) on the instance's variables.
 
  Use a hasheq table to store and look up the methods; does each instance need its own (yet)?

  E.g. |#
#;
(define Counter
  (Class '((count -1) (step 1)) 
         `(count! ,(λ (my)
                     (hash-update! my 'count (λ (c) (+ c (hash-ref my 'step))))
                     (hash-ref my 'count)))
         `(step-up! ,(λ (my) (hash-update! my 'step add1)))))
#|
(define o1 (Counter))
(o1 'count!) ; => 0
(define o2 (Counter))
(o2 'count!) ; => 0
(o1 'count!) ; => 1
(o1 'step-up!)
(o1 'count!) ; => 3
|#


#| (c) Improved syntax: private instance variable setters and getters,
    and methods not paired.

   Modify Class so that methods can get and set instance variables more simply,
    and methods are not paired.

   E.g. |#
#;
(define Counter
  (Class '((count -1) (step 1)) 
         'count!   (λ (my)
                     (my 'count (+ (my 'count) (my 'step)))
                     (my 'count))
         'step-up! (λ (my)
                     (my 'step (add1 (my 'step))))))


#| (d) Methods with arguments.

   Modify Class so that methods can take arguments.

   E.g. |#
#;
(define Stack
  (Class '((stack ()))
         'empty? (λ (my) (empty? (my 'stack)))
         'push!  (λ (my o) (my 'stack (cons o (my 'stack))))
         'pop!   (λ (my) (begin0 (first (my 'stack)) (my 'stack (rest (my 'stack)))))))
#|
(define s1 (Stack))
(s1 'push! 'a)
(s1 'pop!) ; => a
|#


#| (e) Improved syntax: accessing methods from methods.

   Modify Class so that methods can call each other the same way they access instance variables.
    Instance variable access takes precedence over method name access, when the names clash.

   E.g. |#
#;
(define Stack
  (Class '((stack ()))
         'empty? (λ (my) (empty? (my 'stack)))
         'push!  (λ (my o) (my 'stack (cons o (my 'stack))))
         'pop!   (λ (my) (begin0 (my 'peek) (my 'stack (rest (my 'stack)))))
         'peek   (λ (my) (first (my 'stack)))))


#| HOF review exercise not to be handed in.

   User-defined Syntactic Forms (next Lecture) can clean up across-Class repetition.
   But even without them, *if* there's a lot of information hiding and/or mutation,
    you can implement ->, ->! and ! so the following works: |#
#;
(define Stack
  (Class '((stack ()))
         'empty? (->  empty? 'stack)
         'push!  (->! (fix-1st cons o) 'stack) 
         'pop!   (λ (my) (begin0 (my 'peek) (! my rest 'stack)))
         'peek   (->  first 'stack)))

#| OO review exercise not to be handed in.

   Compare and contrast with the Object Model (not syntax!) of Java, Python and any other
    OO language you know. Can you capture them, e.g. constructors?

   Also, review Design Patterns from (at least) 207: how would they each work in the above,
    Java, Python, etc? Could you implement some as *extensions* to Class, so you don't have to
    write boiler-plate every time you *use* the pattern? |#