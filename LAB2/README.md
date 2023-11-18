# Natural Deduction Proof Checker

### A natural deduction proof checker in prolog that verifies that rows use correct formulas and rules

### Rules implemented are:
![image](https://github.com/AlexanderJarvheden/DD1351-Logic-for-Computer-Scientists/assets/131161901/9298e7a5-2898-4c24-97f2-e91034f5e123)

### Works for input formatted like this:
[t].                                 (Premises)

imp(p, imp(q, imp(r, imp(s, t)))).   (Goal to proof)

[                                    (Proof)
  [1, t, premise],
  [
    [2, p, assumption],
    [
      [3, q, assumption],
        [
          [4, r, assumption],
          [
              [5, s, assumption],
              [6, t, copy(1)]
          ],
          [7, imp(s,t), impint(5,6)]
        ],
      [8, imp(r, imp(s,t)), impint(4,7)]
    ],
    [9, imp(q, imp(r, imp(s,t))), impint(3,8)]
  ],
  [10, imp(p, imp(q, imp(r, imp(s,t)))), impint(2,9)]
].
