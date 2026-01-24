;; MilestoneTracker - Project Milestone Registry (Clarity v4)

(define-data-var project-nonce uint u0)
(define-data-var milestone-nonce uint u0)

(define-map projects
    uint
    {
        owner: principal,
        name: (string-utf8 128),
        milestone-count: uint,
        completed-count: uint
    }
)

(define-map milestones
    uint
    {
        project-id: uint,
        title: (string-utf8 128),
        description: (string-utf8 512),
        completed: bool,
        completed-at: uint
    }
)

(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-ALREADY-COMPLETED (err u101))

(define-public (create-project (name (string-utf8 128)))
    (let
        (
            (project-id (var-get project-nonce))
        )
        (map-set projects project-id {
            owner: tx-sender,
            name: name,
            milestone-count: u0,
            completed-count: u0
        })
        
        (var-set project-nonce (+ project-id u1))
        (ok project-id)
    )
)

(define-public (add-milestone (project-id uint) (title (string-utf8 128)) (description (string-utf8 512)))
    (let
        (
            (project (unwrap! (map-get? projects project-id) (err u102)))
            (milestone-id (var-get milestone-nonce))
        )
        (asserts! (is-eq tx-sender (get owner project)) ERR-UNAUTHORIZED)
        
        (map-set milestones milestone-id {
            project-id: project-id,
            title: title,
            description: description,
            completed: false,
            completed-at: u0
        })
        
        (map-set projects project-id (merge project {
            milestone-count: (+ (get milestone-count project) u1)
        }))
        
        (var-set milestone-nonce (+ milestone-id u1))
        (ok milestone-id)
    )
)

(define-public (complete-milestone (milestone-id uint))
    (let
        (
            (milestone (unwrap! (map-get? milestones milestone-id) (err u103)))
            (project (unwrap! (map-get? projects (get project-id milestone)) (err u104)))
        )
        (asserts! (is-eq tx-sender (get owner project)) ERR-UNAUTHORIZED)
        (asserts! (not (get completed milestone)) ERR-ALREADY-COMPLETED)
        
        (map-set milestones milestone-id (merge milestone {
            completed: true,
            completed-at: block-height
        }))
        
        (map-set projects (get project-id milestone) (merge project {
            completed-count: (+ (get completed-count project) u1)
        }))
        
        (ok true)
    )
)

(define-read-only (get-project (project-id uint))
    (ok (map-get? projects project-id))
)

(define-read-only (get-milestone (milestone-id uint))
    (ok (map-get? milestones milestone-id))
)
