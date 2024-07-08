# Proof of view merge validity
This is addapted from https://github.com/tinygrad/tinygrad for the purpose of understanding the original document there. Credit goes to the original author.

Given two views of any shape, stride, and mask, we want to know whether they can be validly merged.
The proof needs to show all requirements for views to be mergable, so that whenever two views are able to merged they will be merged.

<!-- 1. Dimension $d$ = represents the size of an array along a specific dimension
1. Stride $st$ -->
- $PrevShape$ = $(s_1, s_2, s_i, s_{(i+1)}, s_n)$
> Represents the original dimensions of the array.
- $PrevStride$ = $(t_1, t_2, t_i, t_{(i+1)}, t_n)$
> Corresponds to the "stride" of each dimension in the original array. A stride is the number of steps you need to take to move from one element to the next along a particular dimension.

- $PrevMerge = (m_1, m_2)$, where $m_1 = \prod_{j=1}^i s_j$ and $m_2 = \prod_{j=i+1}^n s_j$
> ie. $m_1 = (s_1 \times ... \times s_i), m_2 = (s_{i+1} \times ... \times s_n)$
> This describes a merged shape created by merging certain dimensions of the previous shape.

- $NewShape = (k_1, k_2, k_l, k_{(p+1)}, k_n)$
> This is the target shape that the original array should achieve after reshaping. $NewShape$ consists of a new set of dimensions that the array will have. This new configuration must still accommodate all the original data without loss, meaning the total number of elements (prod($NewShape$)) must equal the product of $m_1$ and $m_2$.

- $Prod(NewShape) = m_1 \times m_2$
> This simply states that the product of the dimensions in the new shape must equal the product of the merged old dimensions. This ensures data integrity is maintained during the reshape, meaning no data is lost or extra space created.

- $PrevMask$ and $NewMask$ represent valid indexes before & after reshape respectively.
> A mask is used to specify which parts of the array are valid data points. For example, in data processing, some elements might be padding or irrelevant, and masks can help identify the important elements. The new mask adapts this concept to the newly reshaped array, ensuring that the validity of data points is maintained even after structural changes.



## Assumption
$m_1$ and $m_2$ can each be merged individually but cannot be merged together.

This implies that while each of these two groups of dimensions can internally consolidate their respective dimensions without issues, combining all dimensions across $m_1$ and $m_2$ into a single dimension is not feasible.

## Claim
The claim states that if $ \text{prod}([k_1, \ldots, k_p]) < m_1 $ and $ \text{prod}([k_1, \ldots, k_{p+1}]) > m_1 $, then it's impossible to reshape the array as intended. This happens because $ k_{p+1} $ would need to incorporate elements from both $ m_1 $ and $ m_2 $. Since $ m_1 $ and $ m_2 $ are not mergeable, combining them in this way violates the reshaping rules. Thus, reshaping can only occur successfully if there is a clear point $ p $ where the dimensions precisely match $ p_1 $.

## Proof

k(p+1) will require some dimensions from p1 & some from p2, which means p1 & p2 should be mergeable, but they are not.

## Conclusion

Hence, reshape is only possible if ∃ a p, where prod([k1 .. kp]) = p1.


### Conditions for mergeability

**Case 1 - All non-zero strides**

They will merge **if st<sub>x</sub> = st<sub>(x+1)</sub> * s<sub>(x+1)</sub>, where x ∈ [1, ..., i-1, i+1, ..., n-1]**.

**Proof**

Lets consider merging of **(s<sub>1</sub> ... s<sub>i</sub>) -> p<sub>1</sub>**, here we have to get a single new stride corresponding to **p<sub>1</sub>**. For which it has to be contiguous. 

Definition: This condition deals with arrays where every dimension has a non-zero stride. A stride represents the memory step required to advance from one element to the next along a dimension.

Merge Requirement: Two dimensions can be merged if the stride of the first dimension equals the product of the stride of the next dimension and its size. This ensures that data layout in memory remains contiguous, meaning elements are stored sequentially without gaps, which is crucial for the merged dimension to be valid.

**Case 2 - Some stride is zero**

Let **st<sub>j</sub> = 0 & st<sub>(j+1)</sub> != 0 & s<sub>(j+1)</sub> > 1, where 1 < j < i**.

If **s<sub>j</sub> = 1** , reshape is trivial.

If **s<sub>j</sub> > 1**,
- If **mask<sub>j</sub>** has range > 1,
	reshape is not possible, because **s<sub>(j+1)</sub>** will need to be repeated at-least once and a single stride can't capture repetition.
- If **mask<sub>j</sub>** has range = 1,  reshape is possible, since it is virtually shape = 1, with some offset.

Definition: This involves scenarios where at least one dimension has a stride of zero, meaning multiple entries along this dimension may refer to the same memory location (common in broadcasting scenarios in numerical computing).

Conditions:
  - If the size of the dimension with zero stride is 1, the reshape is straightforward because the dimension effectively doesn't contribute to the array's shape and can be ignored or treated as a single unit.
  - If the size of this dimension is greater than 1, the reshape becomes complex:
    - If the "mask" for this dimension spans more than one value, reshaping is not possible because the non-zero size needs to be repeated, which cannot be accommodated by a single stride.
    - If the "mask" has a range of one, reshaping is possible since this effectively behaves like a dimension of size 1, possibly with an offset.


### Conditions for reshaping mask

**Case 1 - Splitting Dimension** - Mask shouldn't be cut for successful reshape.

- **Example** - 
[1,2,3,4,5,6,7,8] -> [[1,2,3,4], [5,6,7,8]] ; **mask** = ((2,6)) ; **new_mask[0]** = (0,2) (trivial split).

- **new_mask[1]** = not possible. It is only possible if **mask spans [1-8] or lies within a single dimension [1-4] or [5-8]**.


**Case 2 - Combining Dimension** - Mask should unfold continuously.

- **Example** - **[[1,2],[3,4],[5,6]] -> [1,2,3,4,5,6]**;  **mask** = ((0,2),(0,2)).

- **new_mask** = (0,4); only possible because **mask<sub>1</sub>** span the whole dimension.

- If **mask<sub>1</sub>** did not span the whole dimension, the only way combining would be possible is if **mask<sub>0</sub>** had range 1 as shown below.