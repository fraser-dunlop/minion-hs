module Language.Minion.Definition.Constraint where

import Language.Minion.Definition.Prim

data Constraint

    -- | abs
    -- The constraint
    -- 
    --  abs(x,y)
    -- 
    -- makes sure that x=|y|, i.e. x is the absolute value of y.
    -- 
    -- 
    -- Reference-----------------------------------------------------------------------
    -- help constraints abs
    -- 
    -- 
     = Cabs Flat Flat

    -- | alldiff
    -- Forces the input vector of variables to take distinct values.
    -- 
    -- 
    -- Example-------------------------------------------------------------------------
    -- Suppose the input file had the following vector of variables defined:
    -- 
    -- DISCRETE myVec[9] {1..9}
    -- 
    -- To ensure that each variable takes a different value include the
    -- following constraint:
    -- 
    -- alldiff(myVec)
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- Enforces the same level of consistency as a clique of not equals
    -- constraints.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See
    -- 
    --  help constraints gacalldiff
    -- 
    -- for the same constraint that enforces GAC.
    -- 
    -- 
     | Calldiff [Flat]

    -- | alldiffmatrix
    -- For a latin square this constraint is placed on the whole matrix once for each value.
    -- It ensures there is a bipartite matching between rows and columns where the edges
    -- in the matching correspond to a pair (row, column) where the variable in position
    -- (row,column) in the matrix may be assigned to the given value.
    -- 
    -- 
    -- Example-------------------------------------------------------------------------
    -- 
    -- alldiffmatrix(myVec, Value)
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- This constraint adds some extra reasoning in addition to the GAC Alldifferents
    -- on the rows and columns.
    -- 
    -- 
     | Calldiffmatrix [Flat] Int

    -- | difference
    -- The constraint
    -- 
    --  difference(x,y,z)
    -- 
    -- ensures that z=|x-y| in any solution.
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- This constraint can be expressed in a much longer form, this form both avoids
    -- requiring an extra variable, and also gets better propagation. It gets bounds
    -- consistency.
    -- 
    -- 
     | Cdifference Flat Flat Flat

    -- | diseq
    -- Constrain two variables to take different values.
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- Achieves arc consistency.
    -- 
    -- 
    -- Example-------------------------------------------------------------------------
    -- diseq(v0,v1)
    -- 
    -- 
     | Cdiseq Flat Flat

    -- | div
    -- The constraint
    -- 
    --  div(x,y,z)
    -- 
    -- ensures that floor(x/y)=z.
    -- 
    -- For example:
    -- 
    -- 10/3 = 3
    -- (-10)/3 = -4
    -- 10/(-3) = -4
    -- (-10)/(-3) = 3
    -- 
    -- div and mod satisfy together the condition that:
    -- 
    -- y*(x/y) + x % y = x
    -- 
    -- The constraint is always false when y = 0
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- help constraints modulo
    -- 
    -- 
     | Cdiv Flat Flat Flat

    -- | element
    -- The constraint
    -- 
    --  element(vec, i, e)
    -- 
    -- specifies that, in any solution, vec[i] = e and i is in the range
    -- [0 .. |vec|-1].
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- 
    -- Warning: This constraint is not confluent. Depending on the order the
    -- propagators are called in Minion, the number of search nodes may vary when
    -- using element. To avoid this problem, use watchelement instead. More details
    -- below.
    -- 
    -- The level of propagation enforced by this constraint is not named, however it
    -- works as follows. For constraint vec[i]=e:
    -- 
    -- - After i is assigned, ensures that min(vec[i]) = min(e) and
    --  max(vec[i]) = max(e).
    -- 
    -- - When e is assigned, removes idx from the domain of i whenever e is not an
    --  element of the domain of vec[idx].
    -- 
    -- - When m[idx] is assigned, removes idx from i when m[idx] is not in the domain
    --  of e.
    -- 
    -- This level of consistency is designed to avoid the propagator having to scan
    -- through vec, except when e is assigned. It does a quantity of cheap propagation
    -- and may work well in practise on certain problems.
    -- 
    -- Element is not confluent, which may cause the number of search nodes to vary
    -- depending on the order in which constraints are listed in the input file, or
    -- the order they are called in Minion. For example, the following input causes
    -- Minion to search 41 nodes.
    -- 
    -- MINION 3
    -- **VARIABLES**
    -- DISCRETE x[5] {1..5}
    -- **CONSTRAINTS**
    -- element([x[0],x[1],x[2]], x[3], x[4])
    -- alldiff([x])
    -- **EOF**
    -- 
    -- However if the two constraints are swapped over, Minion explores 29 nodes.
    -- As a rule of thumb, to get a lower node count, move element constraints
    -- to the end of the list.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See the entry
    -- 
    --  constraints watchelement
    -- 
    -- for details of an identical constraint that enforces generalised arc
    -- consistency.
    -- 
    -- 
     | Celement [Flat] Flat Flat

    -- | element_one
    -- The constraint element one is identical to element, except that the
    -- vector is indexed from 1 rather than from 0.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See
    -- 
    --  help constraints element
    -- 
    -- for details of the element constraint which is almost identical to this
    -- one.
    -- 
    -- 
     | Celement_one [Flat] Flat Flat

    -- | eq
    -- Constrain two variables to take equal values.
    -- 
    -- 
    -- Example-------------------------------------------------------------------------
    -- eq(x0,x1)
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- Achieves bounds consistency.
    -- 
    -- 
    -- Reference-----------------------------------------------------------------------
    -- help constraints minuseq
    -- 
    -- 
     | Ceq Flat Flat

    -- | gacalldiff
    -- Forces the input vector of variables to take distinct values.
    -- 
    -- 
    -- Example-------------------------------------------------------------------------
    -- Suppose the input file had the following vector of variables defined:
    -- 
    -- DISCRETE myVec[9] {1..9}
    -- 
    -- To ensure that each variable takes a different value include the
    -- following constraint:
    -- 
    -- gacalldiff(myVec)
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- This constraint enforces generalized arc consistency.
    -- 
    -- 
     | Cgacalldiff [Flat]

    -- | gacschema
    -- An extensional constraint that enforces GAC. The constraint is
    -- specified via a list of tuples.
    -- 
    -- The format, and usage of gacschema, is identical to the 'table' constraint.
    -- It is difficult to predict which out of 'table' and 'gacschema' will be faster
    -- for any particular problem.
    -- 
    -- 
     | Cgacschema [Flat] [[Int]]

    -- | gcc
    -- The Generalized Cardinality Constraint (GCC) constrains the number of each value
    -- that a set of variables can take.
    -- 
    -- gcc([primary variables], [values of interest], [capacity variables])
    -- 
    -- For each value of interest, there must be a capacity variable, which specifies
    -- the number of occurrences of the value in the primary variables.
    -- 
    -- This constraint only restricts the number of occurrences of the values in
    -- the value list. There is no restriction on the occurrences of other values.
    -- Therefore the semantics of gcc are identical to a set of occurrence 
    -- constraints:
    -- 
    -- occurrence([primary variables], val1, cap1)
    -- occurrence([primary variables], val2, cap2)
    -- ...
    -- 
    -- 
    -- Example-------------------------------------------------------------------------
    -- Suppose the input file had the following vectors of variables defined:
    -- 
    -- DISCRETE myVec[9] {1..9}
    -- BOUND cap[9] {0..2}
    -- 
    -- The following constraint would restrict the occurrence of values 1..9 in myVec
    -- to be at most 2 each initially, and finally equal to the values of the cap
    -- vector.
    -- 
    -- gcc(myVec, [1,2,3,4,5,6,7,8,9], cap)
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- This constraint enforces a hybrid consistency. It reads the bounds of the
    -- capacity variables, then enforces GAC over the primary variables only. Then the
    -- bounds of the capacity variables are updated using flow algorithms similar to
    -- those proposed by Quimper et al, Improved Algorithms for the Global Cardinality
    -- Constraint (CP 2004).
    -- 
    -- This constraint provides stronger propagation to the capacity variables than the
    -- gccweak constraint.
    -- 
    -- 
     | Cgcc [Flat] [Int] [Flat]

    -- | gccweak
    -- The Generalized Cardinality Constraint (GCC) (weak variant) constrains the 
    -- number of each value that a set of variables can take.
    -- 
    -- gccweak([primary variables], [values of interest], [capacity variables])
    -- 
    -- For each value of interest, there must be a capacity variable, which specifies
    -- the number of occurrences of the value in the primary variables.
    -- 
    -- This constraint only restricts the number of occurrences of the values in
    -- the value list. There is no restriction on the occurrences of other values.
    -- Therefore the semantics of gccweak are identical to a set of occurrence 
    -- constraints:
    -- 
    -- occurrence([primary variables], val1, cap1)
    -- occurrence([primary variables], val2, cap2)
    -- ...
    -- 
    -- 
    -- Example-------------------------------------------------------------------------
    -- Suppose the input file had the following vectors of variables defined:
    -- 
    -- DISCRETE myVec[9] {1..9}
    -- BOUND cap[9] {0..2}
    -- 
    -- The following constraint would restrict the occurrence of values 1..9 in myVec
    -- to be at most 2 each initially, and finally equal to the values of the cap
    -- vector.
    -- 
    -- gccweak(myVec, [1,2,3,4,5,6,7,8,9], cap)
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- This constraint enforces a hybrid consistency. It reads the bounds of the
    -- capacity variables, then enforces GAC over the primary variables only. Then the
    -- bounds of the capacity variables are updated by counting values in the domains
    -- of the primary variables.
    -- 
    -- The consistency over the capacity variables is weaker than the gcc constraint, 
    -- hence the name gccweak.
    -- 
    -- 
     | Cgccweak [Flat] [Int] [Flat]

    -- | hamming
    -- The constraint
    -- 
    --  hamming(X,Y,c)
    -- 
    -- ensures that the hamming distance between X and Y is at least c. That is, that
    -- the size of the set {i | X[i] != y[i]} is greater than or equal to c.
    -- 
    -- 
     | Chamming [Flat] [Flat] Int

    -- | ineq
    -- The constraint
    -- 
    --  ineq(x, y, k)
    -- 
    -- ensures that 
    -- 
    --  x <= y + k 
    -- 
    -- in any solution.
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- Minion has no strict inequality (<) constraints. However x < y can be
    -- achieved by
    -- 
    --  ineq(x, y, -1)
    -- 
    -- 
     | Cineq Flat Flat Int

    -- | lexleq
    -- The constraint
    -- 
    --  lexleq(vec0, vec1)
    -- 
    -- takes two vectors vec0 and vec1 of the same length and ensures that
    -- vec0 is lexicographically less than or equal to vec1 in any solution.
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- This constraints achieves GAC.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See also
    -- 
    --  help constraints lexless
    -- 
    -- for a similar constraint with strict lexicographic inequality.
    -- 
    -- 
     | Clexleq [Flat] [Flat]

    -- | lexless
    -- The constraint
    -- 
    --  lexless(vec0, vec1)
    -- 
    -- takes two vectors vec0 and vec1 of the same length and ensures that
    -- vec0 is lexicographically less than vec1 in any solution.
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- This constraint maintains GAC.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See also
    -- 
    --  help constraints lexleq
    -- 
    -- for a similar constraint with non-strict lexicographic inequality.
    -- 
    -- 
     | Clexless [Flat] [Flat]

    -- | lighttable
    -- An extensional constraint that enforces GAC. The constraint is
    -- specified via a list of tuples. lighttable is a variant of the
    -- table constraint that is stateless and potentially faster
    -- for small constraints.
    -- 
    -- For full documentation, see the help for the table constraint.
    -- 
    -- 
     | Clighttable [Flat] [[Int]]

    -- | litsumgeq
    -- The constraint litsumgeq(vec1, vec2, c) ensures that there exists at least c
    -- distinct indices i such that vec1[i] = vec2[i].
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- A SAT clause {x,y,z} can be created using:
    -- 
    --  litsumgeq([x,y,z],[1,1,1],1)
    -- 
    -- Note also that this constraint is more efficient for smaller values of c. For
    -- large values consider using watchsumleq.
    -- 
    -- 
    -- Reifiability--------------------------------------------------------------------
    -- This constraint is not reifiable.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See also
    -- 
    --  help constraints watchsumleq
    --  help constraints watchsumgeq
    -- 
    -- 
     | Clitsumgeq [Flat] [Int] Int

    -- | max
    -- The constraint
    -- 
    --  max(vec, x)
    -- 
    -- ensures that x is equal to the maximum value of any variable in vec.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See
    -- 
    --  help constraints min
    -- 
    -- for the opposite constraint.
    -- 
    -- 
     | Cmax [Flat] Flat

    -- | mddc
    -- MDDC (mddc) is an implementation of MDDC(sp) by Cheng and Yap. It enforces GAC on a
    -- constraint using a multi-valued decision diagram (MDD).
    -- 
    -- The MDD required for the propagator is constructed from a set of satisfying
    -- tuples. The constraint has the same syntax as 'table' and can function
    -- as a drop-in replacement.
    -- 
    -- For examples on how to call it, see the help for 'table'. Substitute 'mddc' for
    -- 'table'.
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- This constraint enforces generalized arc consistency.
    -- 
    -- 
     | Cmddc [Flat] [[Int]]

    -- | min
    -- The constraint
    -- 
    --  min(vec, x)
    -- 
    -- ensures that x is equal to the minimum value of any variable in vec.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See
    -- 
    --  help constraints max
    -- 
    -- for the opposite constraint.
    -- 
    -- 
     | Cmin [Flat] Flat

    -- | minuseq
    -- Constraint
    -- 
    --  minuseq(x,y)
    -- 
    -- ensures that x=-y.
    -- 
    -- 
    -- Reference-----------------------------------------------------------------------
    -- help constraints eq
    -- 
    -- 
     | Cminuseq Flat Flat

    -- | modulo
    -- The constraint
    --  
    --  modulo(x,y,z)
    -- 
    -- ensures that x%y=z i.e. z is the remainder of dividing x by y.
    -- For negative values, we ensure that:
    -- 
    -- y(x/y) + x%y = x
    -- 
    -- To be fully concrete, here are some examples:
    -- 
    -- 3 % 5 = 3
    -- -3 % 5 = 2
    -- 3 % -5 = -2
    -- -3 % -5 = -3
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- help constraints div
    -- 
    -- 
     | Cmodulo Flat Flat Flat

    -- | negativemddc
    -- Negative MDDC (negativemddc) is an implementation of MDDC(sp) by Cheng and Yap.
    -- It enforces GAC on a constraint using a multi-valued decision diagram (MDD).
    -- 
    -- The MDD required for the propagator is constructed from a set of unsatisfying
    -- (negative) tuples. The constraint has the same syntax as 'negativetable' and
    -- can function as a drop-in replacement.
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- This constraint enforces generalized arc consistency.
    -- 
    -- 
     | Cnegativemddc [Flat] [[Int]]

    -- | negativetable
    -- An extensional constraint that enforces GAC. The constraint is
    -- specified via a list of disallowed tuples.
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- See entry
    -- 
    --  help input negativetable
    -- 
    -- for how to specify a table constraint in minion input. The only
    -- difference for negativetable is that the specified tuples are
    -- disallowed.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- help input table
    -- help input tuplelist
    -- 
    -- 
     | Cnegativetable [Flat] [[Int]]

    -- | occurrence
    -- The constraint
    -- 
    --  occurrence(vec, elem, count)
    -- 
    -- ensures that there are count occurrences of the value elem in the
    -- vector vec.
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- elem must be a constant, not a variable.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- help constraints occurrenceleq
    -- help constraints occurrencegeq
    -- 
    -- 
     | Coccurrence [Flat] Int Flat

    -- | occurrencegeq
    -- The constraint
    -- 
    --  occurrencegeq(vec, elem, count)
    -- 
    -- ensures that there are AT LEAST count occurrences of the value elem in
    -- the vector vec.
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- elem and count must be constants
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- help constraints occurrence
    -- help constraints occurrenceleq
    -- 
    -- 
     | Coccurrencegeq [Flat] Int Int

    -- | occurrenceleq
    -- The constraint
    -- 
    --  occurrenceleq(vec, elem, count)
    -- 
    -- ensures that there are AT MOST count occurrences of the value elem in
    -- the vector vec.
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- elem and count must be constants
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- help constraints occurrence
    -- help constraints occurrencegeq
    -- 
    -- 
     | Coccurrenceleq [Flat] Int Int

    -- | pow
    -- The constraint
    --  
    --  pow(x,y,z)
    -- 
    -- ensures that x^y=z.
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- This constraint is only available for positive domains x, y and z.
    -- 
    -- 
     | Cpow Flat Flat Flat

    -- | product
    -- The constraint
    -- 
    --  product(x,y,z)
    -- 
    -- ensures that z=xy in any solution.
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- This constraint can be used for (and, in fact, has a specialised
    -- implementation for) achieving boolean AND, i.e. x & y=z can be modelled
    -- as
    -- 
    --  product(x,y,z)
    -- 
    -- The general constraint achieves bounds generalised arc consistency for
    -- positive numbers.
    -- 
    -- 
     | Cproduct Flat Flat Flat

    -- | reify
    -- See
    --  help constraints reification
    -- 
    -- 
     | Creify Constraint Flat

    -- | reifyimply
    -- See
    --  help constraints reification
    -- 
    -- 
     | Creifyimply Constraint Flat

    -- | str2plus
    -- str2plus is an implementation of the STR2+ algorithm by Christophe Lecoutre.
    -- 
    -- 
    -- Example-------------------------------------------------------------------------
    -- 
    -- str2plus is invoked in the same way as all other table constraints, such
    -- as table and mddc.
    -- 
    -- str2plus([x,y,z], {<1,2,3>, <1,3,2>})
    -- 
    -- 
     | Cstr2plus [Flat] [[Int]]

    -- | sumgeq
    -- The constraint
    -- 
    --  sumgeq(vec, c)
    -- 
    -- ensures that sum(vec) >= c.
    -- 
    -- 
     | Csumgeq [Flat] Flat

    -- | sumleq
    -- The constraint
    -- 
    --  sumleq(vec, c)
    -- 
    -- ensures that sum(vec) <= c.
    -- 
    -- 
     | Csumleq [Flat] Flat

    -- | table
    -- help input tuplelist
    -- help input table
    -- help input haggisgac
    -- 
    -- 
    -- Description---------------------------------------------------------------------
    -- An extensional constraint that enforces GAC. The constraint is
    -- specified via a list of tuples.
    -- 
    -- The variables used in the constraint have to be BOOL or DISCRETE variables.
    -- Other types are not supported.
    -- 
    -- 
    -- Example-------------------------------------------------------------------------
    -- To specify a constraint over 3 variables that allows assignments
    -- (0,0,0), (1,0,0), (0,1,0) or (0,0,1) do the following.
    -- 
    -- 1) Add a tuplelist to the **TUPLELIST** section, e.g.:
    -- 
    -- **TUPLELIST**
    -- myext 4 3
    -- 0 0 0
    -- 1 0 0
    -- 0 1 0
    -- 0 0 1
    -- 
    -- N.B. the number 4 is the number of tuples in the constraint, the
    -- number 3 is the -arity.
    -- 
    -- 2) Add a table constraint to the **CONSTRAINTS** section, e.g.:
    -- 
    -- **CONSTRAINTS**
    -- table(myvec, myext)
    -- 
    -- and now the variables of myvec will satisfy the constraint myext.
    -- 
    -- 
    -- Example-------------------------------------------------------------------------
    -- The constraints extension can also be specified in the constraint
    -- definition, e.g.:
    -- 
    -- table(myvec, {<0,0,0>,<1,0,0>,<0,1,0>,<0,0,1>})
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- help input tuplelist
    -- help input gacschema
    -- help input negativetable
    -- help input haggisgac
    -- 
    -- 
     | Ctable [Flat] [[Int]]

    -- | w-inintervalset
    -- The constraint w-inintervalset(x, [a1,a2, b1,b2, ... ]) ensures that the value
    -- of x belongs to one of the intervals {a1,...,a2}, {b1,...,b2} etc. The list of
    -- intervals must be given in numerical order.
    -- 
    -- 
     | Cw_inintervalset Flat [Int]

    -- | w-inrange
    -- The constraint w-inrange(x, [a,b]) ensures that a <= x <= b.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See also
    -- 
    --  help constraints w-notinrange
    -- 
    -- 
     | Cw_inrange Flat [Int]

    -- | w-inset
    -- The constraint w-inset(x, [a1,...,an]) ensures that x belongs to the set
    -- {a1,..,an}.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See also
    -- 
    --  help constraints w-notinset
    -- 
    -- 
     | Cw_inset Flat [Int]

    -- | w-literal
    -- The constraint w-literal(x, a) ensures that x=a.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See also
    -- 
    --  help constraints w-notliteral
    -- 
    -- 
     | Cw_literal Flat Int

    -- | w-notinrange
    -- The constraint w-notinrange(x, [a,b]) ensures that x < a or b < x.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See also
    -- 
    --  help constraints w-inrange
    -- 
    -- 
     | Cw_notinrange Flat [Int]

    -- | w-notinset
    -- The constraint w-notinset(x, [a1,...,an]) ensures that x does not belong to the
    -- set {a1,..,an}.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See also
    -- 
    --  help constraints w-inset
    -- 
    -- 
     | Cw_notinset Flat [Int]

    -- | w-notliteral
    -- The constraint w-notliteral(x, a) ensures that x =/= a.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See also
    -- 
    --  help constraints w-literal
    -- 
    -- 
     | Cw_notliteral Flat Int

    -- | watched-and
    -- The constraint
    -- 
    --  watched-and({C1,...,Cn})
    -- 
    -- ensures that the constraints C1,...,Cn are all true.
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- pointless, bearing in mind that a CSP is simply a conjunction of constraints
    -- already! However sometimes it may be necessary to use a conjunction as a child
    -- of another constraint, for example in a reification:
    -- 
    --  reify(watched-and({...}),r)
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See also
    -- 
    --  help constraints watched-or
    -- 
    -- 
     | Cwatched_and [Constraint]

    -- | watched-or
    -- The constraint
    -- 
    --  watched-or({C1,...,Cn})
    -- 
    -- ensures that at least one of the constraints C1,...,Cn is true.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See also
    -- 
    --  help constraints watched-and
    -- 
    -- 
     | Cwatched_or [Constraint]

    -- | watchelement
    -- The constraint
    -- 
    --  watchelement(vec, i, e)
    -- 
    -- specifies that, in any solution, vec[i] = e and i is in the range
    -- [0 .. |vec|-1].
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- Enforces generalised arc consistency.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See entry
    -- 
    --  help constraints element
    -- 
    -- for details of an identical constraint that enforces a lower level of
    -- consistency.
    -- 
    -- 
     | Cwatchelement [Flat] Flat Flat

    -- | watchelement_one
    -- This constraint is identical to watchelement, except the vector
    -- is indexed from 1 rather than from 0.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See entry
    -- 
    --  help constraints watchelement
    -- 
    -- for details of watchelement which watchelement_one is based on.
    -- 
    -- 
     | Cwatchelement_one [Flat] Flat Flat

    -- | watchless
    -- The constraint watchless(x,y) ensures that x is less than y.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See also
    -- 
    --  help constraints ineq
    -- 
    -- 
     | Cwatchless Flat Flat

    -- | watchsumgeq
    -- The constraint watchsumgeq(vec, c) ensures that sum(vec) >= c.
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- For this constraint, small values of c are more efficient.
    -- 
    --  Equivalent to litsumgeq(vec, [1,...,1], c), but faster.
    -- 
    --  This constraint works on 0/1 variables only.
    -- 
    -- 
    -- Reifiability--------------------------------------------------------------------
    -- This constraint is not reifiable.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See also
    -- 
    --  help constraints watchsumleq
    --  help constraints litsumgeq
    -- 
    -- 
     | Cwatchsumgeq [Flat] Int

    -- | watchsumleq
    -- The constraint watchsumleq(vec, c) ensures that sum(vec) <= c.
    -- 
    -- 
    -- Notes---------------------------------------------------------------------------
    -- Equivalent to litsumgeq([vec1,...,vecn], [0,...,0], n-c) but faster.
    -- 
    --  This constraint works on binary variables only.
    -- 
    --  For this constraint, large values of c are more efficient.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- See also
    -- 
    --  help constraints watchsumgeq
    --  help constraints litsumgeq
    -- 
    -- 
     | Cwatchsumleq [Flat] Int

    -- | watchvecneq
    -- The constraint
    -- 
    --  watchvecneq(A, B)
    -- 
    -- ensures that A and B are not the same vector, i.e., there exists some index i
    -- such that A[i] != B[i].
    -- 
    -- 
     | Cwatchvecneq [Flat] [Flat]

    -- | weightedsumgeq
    -- The constraint
    -- 
    --  weightedsumgeq(constantVec, varVec, total)
    -- 
    -- ensures that constantVec.varVec >= total, where constantVec.varVec is
    -- the scalar dot product of constantVec and varVec.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- help constraints weightedsumleq
    -- help constraints sumleq
    -- help constraints sumgeq
    -- 
    -- 
     | Cweightedsumgeq [Int] [Flat] Flat

    -- | weightedsumleq
    -- The constraint
    -- 
    --  weightedsumleq(constantVec, varVec, total)
    -- 
    -- ensures that constantVec.varVec <= total, where constantVec.varVec is
    -- the scalar dot product of constantVec and varVec.
    -- 
    -- 
    -- References----------------------------------------------------------------------
    -- help constraints weightedsumgeq
    -- help constraints sumleq
    -- help constraints sumgeq
    -- 
    -- 
     | Cweightedsumleq [Int] [Flat] Flat


    deriving (Eq, Show)
