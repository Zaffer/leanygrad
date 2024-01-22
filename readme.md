Define Shapes and Strides: We'll begin by defining ShapeTracker, shapes, and strides formally in Lean 4, capturing the essence of the tuples mentioned in the document.

Declare Mergeability Criteria: We shall state the conditions for mergeable shapes as predicates in Lean 4. This involves formalizing Case 1 and Case 2 conditions as logical statements.

Create Helper Functions/Lemmas: We will define functions or lemmas to represent reshaping operations and conditions, ensuring non-zero strides can merge (Case 1) and handling the special case of zero strides (Case 2).

Formulate Main Theorem: Based on the criteria from the document, we'll state the main theorem encapsulating the claim that under certain conditions, two arbitrary ShapeTrackers are mergeable.

Build Proof: With all the above in place, we will construct proof using Lean 4's theorem-proving capabilities, applying our predicates and lemmas.

Test by Counterexample: We can also test our theorem by trying to find cases where our conditions do not hold, which would provide a counterexample.


"
Iirc the thing that prompted this was: for a shape tracker with more than one view, the symbolic code in expr_idxs is very expensive. So we want to get the views of multiview shapetrackers merged to make a single view shapetrackers when we can
"

"
So the shape tracker needs to be able to define the view of a tensor with a shape outside of the data itself. This allows views without copy that are comparable. Then a flattening of the tensor is a canonical representation of any data which is how it is represented in memory. You can also define any shape not just 2d by defining exactly what an increase along a dimension like row or column means as a jump in continuous memory flattened memory. But they don't have to be complete views. You could define it with a starting and ending point within the array. Aka [[2,3], [4,5]] should be allowed to compare equal to [[1,2,3],[4,5,6]] since they are both a view of the underlying [1,2,3,4,5,6]. If you don't want it to be continuous and want faster flexible reshapes and moves or trims etc, you would probably want a set of partials in a linked list structure. That is how I understand the problem statement.
"


"
Guys, I have a dumb idea for fixing/removing multiview shapetrackers and symbolic.  Just brute force check if the function from the outer view to the buffer is affine (it's a simple composition of linear functions defined by strides and the canonical (nonlinear) map from a buffer back to each view).   Affine just means it's given by an offset and strides, so the shapetracker can be reduced to a single view.  The brute force check shouldn't be too bad since it's just O(size(shape)) which at the worst fits in memory. 
chenyu — Today at 01:07
i can see some version of that working, you might only need to test corners too and check for twists. that's why we have bounties for canonical shapetracker and prove the view merging criteria!
"
