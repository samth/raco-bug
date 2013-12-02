#lang racket

(require help/bug-report)
(define (go open)
  (define open* (and open (string->number open)))
  (when (and open (not open*))
    (raise-user-error '|raco bug| "expected a bug report number, but got ~a" open))
  (help-desk:report-bug open*))

(define (do-discard id)
  (define id* (and id (string->number id)))
  (unless id*
    (raise-user-error '|raco bug| "expected a bug report number, but got ~a" id))
  (unsave-bug-report id*))

(define (list-bugs)
  (printf "ID\t\tTitle\n")
  ;(printf "--------------------------------------------------------------------------------\n")
  (for ([i (in-list (saved-bug-report-titles/ids))])
    (printf "~a\t\t~a\n" (brinfo-id i) (brinfo-title i))))

(module+ main
  (require racket/cmdline)
  (define list #f)
  (define open #f)
  (define discard #f)
  (define discard-all #f)
  (command-line #:program "raco bug"
                #:once-any
                [("-l" "--list") "list saved bug reports" (set! list #t)]
                [("-d" "--discard") id "discard a saved bug report" (set! discard id)]
                ["--discard-all" "discard all saved bug reports" (set! discard-all #t)]
                [("-o" "--open") id "reopen a saved bug report" (set! open id)])
  
  (cond [list (list-bugs)]
        [discard-all (discard-all-saved-bug-reports)]
        [discard (do-discard discard)]
        [else (go open)]))