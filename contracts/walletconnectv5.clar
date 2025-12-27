;; --------------------------------------------------
;; Level 5 — WalletConnect AppKit (Final Fix)
;; --------------------------------------------------

;; Constantes
(define-constant ERR-NOT-OWNER (err u200))
(define-constant ERR-PAUSED (err u201))
(define-constant VIP-THRESHOLD u10000000) ;; 10 STX

;; Variables de Estado
(define-data-var contract-owner principal tx-sender)
(define-data-var is-paused bool false)
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
    ;; Validaciones
    (asserts! (not (var-get is-paused)) ERR-PAUSED)
    (asserts! (> amount u0) (err u100))

    ;; Transferencia
    (try! (stx-transfer? amount sender recipient))

    ;; Actualizar estadísticas
    (map-set user-stats sender {
      tips-count: (+ (get tips-count current-stats) u1),
      total-amount: new-total
    })

    ;; Lógica VIP: Solo actualizamos si llega al umbral
    (if (>= new-total VIP-THRESHOLD)
      (map-set vip-users sender true)
      false
    )

    ;; Globales
    (var-set total-stx-tipped (+ (var-get total-stx-tipped) amount))
    (ok new-total)
  )
)

(define-public (set-paused (value bool))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-OWNER)
    (ok (var-set is-paused value))
  )
)

;; --- Funciones de Lectura (Sin 'ok' para evitar errores de tipo) ---

(define-read-only (get-user-profile (user principal))
  {
    stats: (default-to { tips-count: u0, total-amount: u0 } (map-get? user-stats user)),
    is-vip: (default-to false (map-get? vip-users user))
  }
)

(define-read-only (get-contract-info)
  {
    owner: (var-get contract-owner),
    paused: (var-get is-paused),
    total-global: (var-get total-stx-tipped)
  }
)
