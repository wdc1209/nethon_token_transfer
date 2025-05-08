// src/main.nr
// NETHON Token - Private Transfer Verification Circuit

// Import pedersen_hash from noir_stdlib
use dep::std::hash::pedersen_hash;

// Main function for the NETHON transfer circuit.
// This function verifies the legitimacy of a transfer operation.
//
// Prover (sender) provides:
// - sender_secret: Private value for identity verification.
// - sender_balance_old: Private balance before transfer.
// - sender_balance_old_blinding: Private blinding factor for old balance commitment.
// - transfer_amount: Private transfer amount.
// - sender_balance_new_blinding: Private blinding factor for new balance commitment.
//
// Verifier (and the system) knows:
// - sender_id_hash: Public identity hash of the sender.
// - recipient_id_hash: Public identity hash of the recipient.
// - public_transfer_amount: Publicly declared transfer amount.
// - sender_balance_old_commitment: Public commitment to the sender's old balance.
// - sender_balance_new_commitment: Public commitment to the sender's new balance.

fn main(
    // === Private Inputs ===
    sender_secret: Field,                   // Sender's secret for identity verification.
    sender_balance_old: Field,              // Sender's balance before the transfer.
    sender_balance_old_blinding: Field,     // Blinding factor for the old balance commitment.
    transfer_amount: Field,                 // The actual amount to transfer (private, matches public_transfer_amount).
    sender_balance_new_blinding: Field,     // Blinding factor for the new balance commitment.

    // === Public Inputs ===
    sender_id_hash: pub Field,                // Sender's public identity hash.
    recipient_id_hash: pub Field,             // Recipient's public identity hash (for record-keeping).
    public_transfer_amount: pub Field,        // Publicly declared transfer amount.
    sender_balance_old_commitment: pub Field, // Commitment to the sender's old balance.
    sender_balance_new_commitment: pub Field  // Commitment to the sender's new balance.
) {
    // --- Constraints ---

    // 1. Verify sender's identity.
    //    sender_id_hash should be the hash of sender_secret.
    //    Pedersen hash takes an array of Fields as input.
    let computed_sender_id_hash = pedersen_hash([sender_secret]);
    constrain computed_sender_id_hash == sender_id_hash;

    // 2. Verify that the private transfer_amount matches the public_transfer_amount.
    //    This ensures the Prover uses the publicly declared amount for calculations.
    constrain transfer_amount == public_transfer_amount;

    // 3. Verify the sender's old balance commitment.
    //    sender_balance_old_commitment should be the hash of (sender_balance_old, sender_balance_old_blinding).
    //    The blinding factor prevents deducing the balance from the commitment.
    let computed_sender_balance_old_commitment = pedersen_hash([sender_balance_old, sender_balance_old_blinding]);
    constrain computed_sender_balance_old_commitment == sender_balance_old_commitment;

    // 4. Check if the sender has sufficient balance for the transfer.
    //    sender_balance_old must be greater than or equal to transfer_amount.
    constrain sender_balance_old >= transfer_amount; // Ensures no negative balance situation.

    // 5. Calculate the sender's new balance.
    let sender_balance_new = sender_balance_old - transfer_amount;

    // 6. Verify the sender's new balance commitment.
    //    sender_balance_new_commitment should be the hash of (sender_balance_new, sender_balance_new_blinding).
    let computed_sender_balance_new_commitment = pedersen_hash([sender_balance_new, sender_balance_new_blinding]);
    constrain computed_sender_balance_new_commitment == sender_balance_new_commitment;

    // Optional: Log outputs for debugging (does not affect the proof).
    // println("NETHON Transfer Verified:");
    // println("  Sender ID Hash (Public): {}", sender_id_hash);
    // println("  Recipient ID Hash (Public): {}", recipient_id_hash);
    // println("  Public Transfer Amount: {}", public_transfer_amount);
    // println("  Sender Old Balance Commitment (Public): {}", sender_balance_old_commitment);
    // println("  Sender New Balance Commitment (Public): {}", sender_balance_new_commitment);
}