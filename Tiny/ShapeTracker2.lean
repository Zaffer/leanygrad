-- Step 1: Define Shapes and Strides
structure ShapeTracker :=
(old_shape : List ℕ)
(old_stride : List ℕ)
(merge_old_shape : List ℕ)
-- Here, we assume that Lists can represent tuples of arbitrary length.

-- Step 2: Declare Mergeability Criteria
def areMergeable (shape1 shape2 : ShapeTracker) : Prop :=
  -- This predicate will be properly defined later
  true

-- Step 3: Create Helper Functions/Lemmas
lemma non_zero_strides_mergeable {st1 st2 s1 : ℕ} (h_non_zero_strides : st1 = st2 * s1) :
  -- Complete this lemma based on the conditions provided
  true

lemma zero_strides_mergeable {st1 st2 : ℕ} (h_zero_strides : st1 = 0 ∨ st2 = 0) :
  -- Complete this lemma based on the conditions for zero strides
  true

-- Step 4: Formulate Main Theorem
theorem shapeTracker_mergeable_theorem (shape1 shape2 : ShapeTracker) :
  areMergeable shape1 shape2 :=
  -- Proof of the theorem using the lemmas
  sorry -- sorry is used in Lean to denote incomplete proofs

-- Step 5: Build Proof
-- We'd write the actual proofs of our predicates and lemmas here.

-- Step 6: Test by Counterexample
-- Optionally, we'd write code to generate counterexamples if there are any.
