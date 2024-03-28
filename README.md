# Problem statement

> Proof or disproof of the mergeability of two arbitrary ShapeTrackers in Lean (see docs/reshape_without_symbolic.md)


# Formal problem statment

https://github.com/tinygrad/tinygrad/blob/master/docs/reshape_without_symbolic.md


# Approach

Define Shapes and Strides: We'll begin by defining ShapeTracker, shapes, and strides formally in Lean 4, capturing the essence of the tuples mentioned in the document.

Declare Mergeability Criteria: We shall state the conditions for mergeable shapes as predicates in Lean 4. This involves formalizing Case 1 and Case 2 conditions as logical statements.

Create Helper Functions/Lemmas: We will define functions or lemmas to represent reshaping operations and conditions, ensuring non-zero strides can merge (Case 1) and handling the special case of zero strides (Case 2).

Formulate Main Theorem: Based on the criteria from the document, we'll state the main theorem encapsulating the claim that under certain conditions, two arbitrary ShapeTrackers are mergeable.

Build Proof: With all the above in place, we will construct proof using Lean 4's theorem-proving capabilities, applying our predicates and lemmas.

Test by Counterexample: We can also test our theorem by trying to find cases where our conditions do not hold, which would provide a counterexample.


# /docs contain more information

- discord chat history discussing the problem
- relevant python modules (March 2024)
- GitHub issues and Pull Ruquests mentioning or attempting solutions
