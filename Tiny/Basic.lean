
structure Matrix' where
  shape : List Nat
  stride : List Nat
  mask : List (List Int)
  -- contiguous : Bool -- not needed for now implemented in the package but perhaps not needed here
  -- offset : Int
  -- min : List Nat
  -- max : List Nat




structure View where
  n : Nat
  m : Nat
  stride : Nat





-- CHECKS
def are_compatible_shapes (s1 s2 : List Nat) : Bool := -- shapes of two views are compatible, a prerequisite for merging them
  s1.length = s2.length && all2 (λ x y ↦ x ≤ y) s1 s2 -- two shapes have same length and each corresponding dimension is ≤


def can_merge_views (v1 v2 : View) : Bool := -- criteria for mergeability
  let shape1Prod := v1.shape.foldl Nat.mul 1
  let shape2Prod := v2.shape.foldl Nat.mul 1
  let stride1Prod := v1.stride.foldl Nat.mul 1
  let stride2Prod := v2.stride.foldl Nat.mul 1

  (shape1Prod = shape2Prod) && (stride1Prod = stride2Prod) && -- matching shape and stride products
  are_compatible_shapes v1.shape.as v2.shape.as && -- shape compatibility
  (v1.contiguous || v2.contiguous) -- at least one of the views must be contiguous for a straightforward merge

  -- Further conditions to implement based on the mergeability criteria

-- OBJECTIVE
def is_mergeable (shape1 shape2 : Shape) : Prop :=
  sorry





-- TESTING
def exampleView : View 2 := {
  shape := ⟨[2, 3], rfl⟩,
  stride := ⟨[3, 1], rfl⟩,
  offset := 0,
  mask := [[0, 1], [1, 2]],
  contiguous := true
}

-- TODO
-- logic for more complex operations and conditions are next steps.
-- functions to calculate the size of a view and to project indices
-- mergeable predicate that checks for both shape compatibility and mask alignment
-- definitions for reshaping a view, considerating stride adjustments and mask transformations
-- theorems to establish properties of views and their ops, including when reshaping and merging feasable
