import Mathlib.Data.List.Basic

structure Shape :=
  (dims : List Nat) -- Dimensions of the shape

structure Stride :=
  (steps : List Nat) -- Strides for each dimension

structure ShapeTracker :=
  (shape : Shape)
  (stride : Stride)
  -- Additional properties as required

-- Function to check if two shapes are mergeable
def areMergeable (shape1 shape2 : List Nat) : Bool :=
  if shape1.length = shape2.length then
    List.all (λ (d : ℕ × ℕ) ↦ decide (d.fst = d.snd)) (List.zip shape1 shape2)
  else
    false
