structure View where
    shape : (List Int)
    strides : (List Int)
    offset : Int
    mask : List (List Int)
    contiguous : Bool

structure ShapeTracker where
    views : List View

def View.reshape (self : View) (new_shape : List Int) : View := 
    (new_shape, self.strides, self.offset, self.mask, self.contiguous)

theorem reshape_possible (view : Shape) (new_shape : List Int) : Prop :=
    -- if there exists an index i such that the split of the two subviews
    -- are mergeable and if there exists a p such that prod(new_shape[:p]) < p1
    true

theorem view_mergeable (view1 : View) : Prop :=
    --
    true

def View.mergeable (shape strides : List Int) : Prop :=
    ∀ x : Fin (strides, length - 1),
       match stirdes.get? x.val, strides.get? (x.val + 1), shape.get? (x.val + 1) with
        | some stₓ , some st₊ some s₊ => stₓ,= st₊ ∗ s₊
        | _, _, _, _ => false
