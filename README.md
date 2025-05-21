# Problem statement

> Proof or disproof of the mergeability of two arbitrary ShapeTrackers in Lean (generic version of https://github.com/tinygrad/tinygrad/pull/2218/files)

# Simeple wording

A view is simply a rule that takes each coordinate in a tensor (like `(x, y, z)`) and tells you which position in the flat memory array to read or write. Common rules include reshaping (re‑grouping elements), transposing axes, broadcasting (expanding a 1‑size dimension), and slicing or striding (picking every k‑th element).

Tinygrad’s ShapeTracker keeps a list of these rules in the order they were applied:  
- **v1** might turn a flat array of length N into a 2D grid,  
- then **v2** might reshape or transpose that grid into a new shape.

To speed things up, we ask: can we replace both v1 and v2 with a single rule, **v3**, that goes straight from the flat array to the final shape? We say v1 and v2 are **mergeable** exactly when there exists a single view v3 that:

1. Has the **same final shape** as v2, and  
2. For every valid coordinate in that shape, gives **exactly the same memory index** as doing v1 followed by v2.

If those two conditions hold, ShapeTracker can drop v1 and v2 and just use v3—giving the same result with one faster indexing step.


# Mathy wording

A **view** is a function that, given a valid coordinate tuple $`(x_0,\dots,x_{n-1})`$ in some shape $`s=(s_0,\dots,s_{n-1})`$, computes a single linear memory index. Common view operations include **reshape**, **transpose**, **expand** (broadcast), and **strided slice**, each of which defines a new coordinate‑to‑index mapping (and a new shape).

A **ShapeTracker** maintains an ordered list of these view functions. If you start with a flat array of length $`N`$, applying view 1 ($`v_1`$) produces one shape, then applying view 2 ($`v_2`$) produces another. Concretely:

$$`
v_1 : (N)\;\to\;s_1,\quad
v_2 : s_1\;\to\;s_2.
`$$

To optimize indexing (and thus the compute graph), we look for a single view $`v_3 : (N)\to s_2`$ whose index function is **identical** to $`v_2\circ v_1`$. In other words, rather than computing

$$`
\text{idx} = v_2\bigl(v_1(x)\bigr)
`$$

in two steps, we want

$$`
\text{idx} = v_3(x)
`$$

in one step.

We call $`v_1`$ and $`v_2`$ **mergeable** if and only if there exists such a $`v_3`$ with:

1. **the same output shape** $`s_2`$, and  
2. for every valid coordinate $`x\in s_2`$,  
   $$`
     v_3(x) \;=\; v_2\bigl(v_1(x)\bigr).
   `$$

In that case, the ShapeTracker can replace the two-element chain `[v_1, v_2]` with the single view `[v_3]`, yielding identical semantics but simpler, faster index computation.


# Further reading:
- https://github.com/tinygrad/tinygrad/issues/8511
- https://github.com/Nielius/Tensorlayouts/blob/master/doc/problem-formalization.md
