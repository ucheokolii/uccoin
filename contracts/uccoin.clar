;; uccoin - a simple fungible token example
;;
;; This contract implements a minimal fungible token with:
;; - total supply tracking
;; - minting restricted to the contract owner
;; - balance querying
;; - token transfers between principals

(define-constant CONTRACT-OWNER 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)

;; total number of tokens ever minted
(define-data-var total-supply uint u0)

;; balances of each principal
(define-map balances principal uint)

;; private helper: get balance of an account, defaults to u0
(define-private (get-balance (account principal))
  (default-to u0 (map-get? balances account)))

;; Read-only: get the total supply of uccoin
(define-read-only (get-total-supply)
  (ok (var-get total-supply)))

;; Read-only: get the balance of an account
(define-read-only (get-balance-of (account principal))
  (ok (get-balance account)))

;; Public: mint new tokens to a recipient.
;; Only the CONTRACT-OWNER may call this function.
;; Returns (ok true) on success or (err u100) if unauthorized.
(define-public (mint (amount uint) (recipient principal))
  (begin
    (if (is-eq tx-sender CONTRACT-OWNER)
        (let ((current-balance (get-balance recipient)))
          (map-set balances recipient (+ current-balance amount))
          (var-set total-supply (+ (var-get total-supply) amount))
          (ok true))
        (err u100))))

;; Public: transfer tokens from sender to recipient.
;; Fails with (err u101) if the sender has insufficient balance.
;; This function must be called by the sender themselves.
(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (if (is-eq tx-sender sender)
        (let ((sender-balance (get-balance sender)))
          (if (>= sender-balance amount)
              (let ((recipient-balance (get-balance recipient)))
                (map-set balances sender (- sender-balance amount))
                (map-set balances recipient (+ recipient-balance amount))
                (ok true))
              (err u101)))
        (err u100))))
