#!/usr/bin/env python

import sys

with open(sys.argv[2]) as f:
    try:
        sol = [int(x) for x in f.readline().split()]
        if sol == [0]:
            print("No satisfying valuation found")
            sys.exit(1)
        assert all(-x not in sol for x in sol)
    except (ValueError, AssertionError):
        print("Malformed solution")
        sys.exit(2)

with open(sys.argv[1]) as f:
    for l in f.xreadlines():
        if len(l) == 0 or l[0] == 'c':
            continue
        if l[0] == 'p':
            _, _, n, _ = l.split()
            try:
                n = int(n)
            except ValueError:
                print("Malformed formula")
                sys.exit(3)
            if len(sol) > 0 and (min(sol) < -n or max(sol) > n):
                print("The solution has too many atoms")
                sys.exit(2)
        else:
            try:
                if not any(int(x) in sol for x in l.split()):
                    print("The solution is incorrect")
                    sys.exit(1)
            except ValueError:
                print("Malformed formula")
                sys.exit(3)
print("The solution is correct")
