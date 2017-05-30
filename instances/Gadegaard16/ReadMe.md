# Instance groups for bi-objective discrete cost-bottleneck location problems 

Three different classes of facility location problems are considered. The problem classes are 

* The uncapacitated facility location problem (UFLP).
* The capacitated facility location problem (CFLP) without single-source constraints.
* The single source capacitated facility location problem (SSCFLP).

The instances are based on previous instances from the literature extended to two objectives and
stored in the `instances` folder. Instances are named `Gadegaard16_<problem
class>_<origin>_<problem>_<cost structure>.raw`.

The instances for CFLP are a subset of the test bed created for the paper Klose and Görtz (2007)
consisting of 45 instances ranging from 100 customers and 100 facility sites to 200 customers and
200 facility sites (first 45 problems in subfolder `CFLP_UFLP`). 

The instances for UFLP we use a slightly larger subset of the instances created by Klose and Gôrtz
(2007) consisting of 60 instances ranging in size from 100 customers and 100 facilities to 100
customers and 500 facility sites (all 60 problems in subfolder `CFLP_UFLP`). .

The instances for SSCFLP are the instances proposed in Holmberg, Rônnqvist,
and Yuan (1999) that consists of 71 instances as well as 57 instances from the testbed used
in Díaz and Fernández (2002). All instances are in the subfolder `SSCFLP`.

For each testbed three cost structures for the $t_{i,j}$'s have been generated. For more details see
the paper.


## Raw format description

We use the following parameter names for the uncapacitated, capacitated,
and single source capacitated facility location facility location problems:

* $n$ = number of potential facility sites
* $m$ = number of customers
* $s_i$ = capacity of facility $i$
* $f_i$ = fixed cost of opening facility $i$
* $d_j$ = demand at customer $j$
* $c_{i,j}$ = cost of supplying all customer $j$'s demand from facility $i$
* $t_{i,j}$ = travel time between facility $i$ and customer $j$

The instances have the following format:

```
n 
m 
s_1 f_1
s_2 f_2
...
s_n f_n
d_1 d_2 ... d_m

c_{1,1}... c_{1,m}
c_{2,1}... c_{2,m}
...
c_{n,1}... c_{n,m}

t_{1,1}... t_{1,m}
t_{2,1}... t_{2,m}
...
t_{n,1}... t_{n,m}
```

If the instance is a uncapacitated facility location problem (UFLP), then the demand and capacity parameters in the input file is ignored and demand is set to $d_j = 1$ and each capacity is set to $s_i = m$. This provides a valid instance of the UFLP
