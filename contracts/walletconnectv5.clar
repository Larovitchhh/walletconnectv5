;; walletconnectv5.clar
;; --------------------------------------------------
;; Level 5 — WalletConnect AppKit (Optimized)
;; --------------------------------------------------

;; Constantes
(define-constant ERR_NOT_OWNER (err u200))
(define-constant ERR_PAUSED (err u201))
(define-constant ERR_INVALID_AMOUNT (err u100))
(define-constant VIP_THRESHOLD u10000000) ;; 10 STX

;; Variables de Estado
(define-data-var contract-owner principal tx-sender)
(define-data-var paused bool false)
(define-data-var total-stx-tipped uint u0)

;; Mapas
(define-map user-stats principal { tips-count: uint, total-amount: uint })
(define-map vip-users principal bool)

;; --- Funciones Públicas ---

(define-public (send-tip (recipient principal) (amount uint))
  (let (
    (sender tx-sender)
    (current-stats (default-to { tips-count: u0, total-amount: u0 } (map-get? user-stats sender)))
    (new-total (+ (get total-amount current-stats) amount))
  )
    ;; 1. Validaciones
    (asserts! (not (var-get paused)) ERR_PAUSED)
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)

    ;; 2. Transferencia
    (try! (stx-transfer? amount sender recipient))

    ;; 3. Actualizar estadísticas
    (map-set user-stats sender {
      tips-count: (+ (get tips-count current-stats) u1),
      total-amount: new-total
    })

    ;; 4. Lógica VIP (Actualización simple)
    (if (>= new-total VIP_THRESHOLD)
      (map-set vip-users sender true)
      false
    )

    ;; 5. Globales
    (var-set total-stx-tipped (+ (var-get total-stx-tipped) amount))

    (ok new-total)
  )
)

(define-public (set-paused (value bool))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR_NOT_OWNER)
    (var-set paused value)
    (ok value)
  )
)

;; --- Funciones de Lectura ---

(define-read-only (get-user-profile (user principal))
  {
    stats: (default-to { tips-count: u0, total-amount: u0 } (map-get? user-stats user)),
    is-vip: (default-to false (map-get? vip-users user))
  }
)

(define-read-only (get-contract-info)
  {
    owner: (var-get contract-owner),
    paused: (var-get paused),
    total-global: (var-get total-stx-tipped),
    threshold: VIP_THRESHOLD
  }
)
