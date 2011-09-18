;; The Scheme language, written in itself (self-hosted)
.
;; These are the procedures that the R5RS spec calls "library
;; procedures/library syntax", and are the parts of the language that
;; can be expressed in the language itself given the underlying
;; primitive procedures. 

;; CONDITIONALS
;; cond
;; case
;; and
;; or

;; BINDING CONSTRUCTS
;; let
;; let*
;; letrec

;; SEQUENCING
;; begin

;; ITERATION
;; do
;; let

;; DELAYED EVALUATION
;; delay

;; EQUIVALENCE OPERATORS
;; equal?

;; NUMBERS
;; zero?
;; positive?
;; negative?
;; odd?
;; even?
;; max
;; min
;; abs
;; gcd
;; lcm
;; rationalize

;; BOOLEANS
;; not
;; boolean?

;; PAIRS AND LISTS
;; caar
;; cadr
;; .
;; .
;; .
;; cdddar
;; cddddr
;; null?
;; list?
;; list
;; length
;; append
;; reverse
;; list-tail
;; list-ref
;; memq
;; memv
;; member
;; assq
;; assv
;; assoc

;; SYMBOLS
;; (only primitive procedures)
                                    
;; CHARACTERS
;; char-ci=?
;; char-ci<?
;; char-ci>?
;; char-ci<=?
;; char-ci>=?
;; char-alphabetic?
;; char-numeric?
;; char-whitespace?
;; char-upper-case?
;; char-lower-case?
;; char-upcase
;; char-downcase

;; STRINGS
;; string
;; string=?
;; string-ci=?
;; string<?
;; string>?
;; string<=?
;; string>=?
;; string-ci<?
;; string-ci>?
;; string-ci<=?
;; string-ci>=?
;; substring
;; string-append
;; string->list
;; list->string
;; string-copy
;; string-fill!

;; VECTORS
;; vector
;; vector->list
;; list->vector
;; vector-fill!

;; Current version of scheme (e.g. R5RS)
;; A primitive procedure according to spec, but placed here to test
;; that library procedure file loads and definitions show up in global env.
(define 'scheme-report-version 5)


;; CONTROL FEATURES
;; map
;; for-each
;; force

;; INPUT AND OUTPUT
;; call-with-input-file
;; call-with-output-file
;; read
;; read port
;; write
;; write port
;; display
;; display port
;; newline
;; newline port

