# NETHON - Private Token Transfer ZK Proof (Noir)

This project demonstrates a simple Zero-Knowledge proof for a private token transfer system, named "NETHON," implemented using the Noir language. It's designed to showcase basic ZK concepts like private inputs, public inputs, and cryptographic commitments for a NoirHack event.

The circuit verifies the legitimacy of a token transfer by ensuring:
1.  **Sender Identity Verification**: The prover possesses a secret corresponding to a public identity hash.
2.  **Sufficient Balance**: The sender's old balance (private) is sufficient to cover the transfer amount.
3.  **Correct State Update**: The sender correctly computes their new balance, and its commitment (hash) is provided.
4.  **Privacy**:
    *   The sender's exact old and new balances remain private.
    *   The sender's secret identity key remains private.
    *   Only commitments (hashes) to balances are made public.

## Project Structure
