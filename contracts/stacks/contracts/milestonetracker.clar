;; MilestoneTracker Clarity Contract
;; Project milestone tracking with escrow payments.


(define-map projects
    uint
    {
        client: principal,
        provider: principal,
        total-amount: uint,
        released: uint
    }
)
(define-data-var project-nonce uint u0)

(define-public (create-project (provider principal) (amount uint))
    (let ((id (var-get project-nonce)))
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (map-set projects id {
            client: tx-sender,
            provider: provider,
            total-amount: amount,
            released: u0
        })
        (var-set project-nonce (+ id u1))
        (ok id)
    )
)

(define-public (release-milestone (id uint) (amount uint))
    (let ((p (unwrap! (map-get? projects id) (err u404))))
        (asserts! (is-eq tx-sender (get client p)) (err u401))
        (try! (as-contract (stx-transfer? amount tx-sender (get provider p))))
        (map-set projects id (merge p {released: (+ (get released p) amount)}))
        (ok true)
    )
)

