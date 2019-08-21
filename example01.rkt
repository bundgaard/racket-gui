#lang racket
(require net/url)
(require racket/draw)
(require racket/gui/base)
(require json)

(define frame (new frame%
                   [label "Example"]
                   [width 640]
                   [height 480]))
(define msg (new message% [parent frame]
                 [label "No events so far..."]))
(new button% [parent frame]
     [label "Click"]
     ; Callback procedure
     [callback (lambda (button event)
                 (send msg set-label "Button click"))])

(define my-canvas%
  (class canvas% ; the base class is canvas%
    (define/override (on-event event)
      (send msg set-label "Canvas mouse"))
    ; Define overriding method to handle keyboard events
    (define/override (on-char event)
      (send msg set-label "Canvas keyboard"))
    ; Call the superclass init, passing over all args
    (super-new)))

(define text-x 0)
(define text-y 0)
(define canvas 
  (new my-canvas% [parent frame]
       [paint-callback
        (lambda (canvas dc)
          (send dc set-scale 3 3)
          (send dc set-text-foreground "blue")
          (send dc draw-text "Don't Panic!" text-x text-y))]))

(new button% [parent frame]
     [label "Pause"]
     [callback (lambda (button event) (sleep 5))])

; Gauge

(define gauge (new gauge% [label "Gauge"]
                   [parent frame]
                   [range 11]))

(send gauge set-value 5)

(define panel (new horizontal-panel% [parent frame]))
(new button% [parent panel]
     [label "Left"]
     [callback (lambda (button event)
                 (send msg set-label "Left click")
                 (set! text-x (- text-x 1))
                 
                 (send frame refresh))])
(new button% [parent panel]
     [label "Right"]
     [callback (lambda (button event)
                 (send msg set-label "Right click")
                 (set! text-x (+ 1 text-x))
                 (send frame refresh))])

(new button% [parent panel]
     [label "Up"]
     [callback (lambda (button event)
                 (send msg set-label "Up click")
                 (set! text-y (- text-y 1))
                 
                 (send frame refresh))])
(new button% [parent panel]
     [label "Down"]
     [callback (lambda (button event)
                 (send msg set-label "Down click")
                 (set! text-y (+ 1 text-y))
                 (send frame refresh))])

(new button% [parent frame]
     [label "Dialog"]
     [callback (lambda (button event)
                 (define dialog (instantiate dialog% ("Example")))
                 (define textfield (new text-field% [parent dialog] [label "Your name"]))
                 (define panel (new horizontal-panel% [parent dialog] [alignment '(center center)]))
                 (new button% [parent panel]
                      [label "Cancel"]
                      [callback (lambda (button event)
                                  (send dialog show #f))])
                 (new button% [parent panel]
                      [label "Ok"]
                      [callback (lambda (button event)
                                  (message-box "title"
                                               (format "message ~a" (send textfield get-value))))])
                 (when (system-position-ok-before-cancel?)
                   (send panel change-children reverse))
                 (send dialog show #t))])
                 
     

(hasheq)


(send frame show #t)


