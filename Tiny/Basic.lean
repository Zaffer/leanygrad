-- import Mathlib.Data.Matrix.Basic

-- variable (α : Type u) [Semiring α]
-- variable (m n : ℕ)

-- def linear_to_matrix_idx (linear_idx : ℕ) (num_cols : ℕ) : ℕ × ℕ :=
--   (linear_idx / num_cols, linear_idx % num_cols)

-- -- Define the reshape function using Matrix with finite sets
-- def reshape_matrix (A : Matrix (Fin m) (Fin n) α) (new_m new_n : ℕ) : Matrix (Fin new_m) (Fin new_n) α :=
--   if h : m * n = new_m * new_n then
--     let new_matrix_fn := λ (i : Fin new_m) (j : Fin new_n) =>
--       let linear_idx := (Fin.val i) * new_n + (Fin.val j);
--       let (orig_row, orig_col) := linear_to_matrix_idx linear_idx n;
--       A (Fin.mk orig_row (Nat.lt_of_mul_lt_mul_right (lt_of_le_of_lt (Nat.mul_le_mul_right _ (Fin.is_lt i)) (Nat.mul_lt_mul_of_pos_right (Nat.lt_succ_self _) (Nat.zero_lt_succ _)))))
--         (Fin.mk orig_col (if h2 : new_n = 0 then False.elim (Nat.pos_of_ne_zero h2) else Nat.mod_lt _ (Nat.pos_of_ne_zero h2)));
--     Matrix.of new_matrix_fn
--   else
--     -- Handle the error case
--     sorry
