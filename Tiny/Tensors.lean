import Mathlib.Data.Matrix.Basic


def Tensor (D : ℕ) (s : Fin D → ℕ) (α : Type) : Type :=
  (Π k : Fin D, Fin (s k)) → α

def View (D : ℕ) (s : Fin D → ℕ) : Type :=
  Π k : Fin D, Fin (s k) × Fin (s k)

def Tensor.applyView {D : ℕ} {s : Fin D → ℕ} {α : Type}
    (A : Tensor D s α) (v : View D s) :
    Tensor (D : ℕ) (fun k : Fin D => 1 + (v k).snd - (v k).fst) α :=
  fun i => A (fun k : Fin D => ⟨(v k).fst.val + (i k).val, sorry⟩)

def compatible1D {n : ℕ} (x₁ x₂ y₁ y₂ : Fin n) : Prop := sorry

def compatibleViews {D : ℕ} {s : Fin D → ℕ} (v w : View D s) : Prop :=
  ∃ k : Fin D,
    compatible1D (v k).fst (w k).fst (v k).snd (w k).snd ∧
    ∀ j : Fin D, j ≠ k → v j = w j

-- 1D array ... Fin n -> Char
-- 2D array ... Fin m -> Fin n -> Char
-- 2D array ... Fin m -> (Fin n -> Char)
-- kD array ... (d : Fin k -> Fin (size d)) -> Char
-- view on the kD array ... d : Fin k -> (Fin (size d) x Fin (size d))
