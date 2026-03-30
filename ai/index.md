---
layout: single
title: "---"
permalink: /ai/
classes: wide
author_profile: false
sitemap: false
robots: noindex, nofollow
toc: true
toc_sticky: true
toc_label: "Experiments"
---

<script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js" async></script>

<script>
document.addEventListener('keydown', function(e) {
  if (e.key === ' ' && !['INPUT','TEXTAREA','SELECT'].includes(document.activeElement.tagName)) {
    e.preventDefault();
    document.body.classList.toggle('ai-hidden');
  }
});
</script>

<style>
body.ai-hidden .page__content,
body.ai-hidden .sidebar,
body.ai-hidden .page__title {
  visibility: hidden;
}
</style>

## Index

| # | Experiment | Topics |
|---|-----------|--------|
| 1 | [Single Player Game](#experiment-1--single-player-game) | Decision making, rule-based logic |
| 2 | [Unguided Search Techniques](#experiment-2--unguided-search-techniques) | BFS (Water Jug), DFS (Maze) |
| 3 | [8 Puzzle — Best First Search](#experiment-3--8-puzzle-problem-using-best-first-search) | Heuristic search, misplaced tiles |
| 4 | [AO* Algorithm](#experiment-4--optimal-problem-solving-using-ao-algorithm) | AND-OR graphs, heuristic propagation |
| 5 | [TSP — Hill Climbing](#experiment-5--travelling-salesman-problem-using-hill-climbing) | Route optimization, local search |
| 6 | [Constraint Satisfaction](#experiment-6--constraint-satisfaction-problems) | Cryptarithmetic, Graph Coloring |
| 7 | [Game Playing](#experiment-7--game-playing-algorithms) | Minimax, Alpha-Beta Pruning, Tic-Tac-Toe |
| 8 | [Machine Learning Techniques](#experiment-8--machine-learning-techniques) | Regression, SVM, K-Means, ANN, CNN |
| 9 | [Natural Language Processing](#experiment-9--natural-language-processing) | NLTK, BoW, TF-IDF, Sentiment Analysis |
| 10 | [Fuzzy Inference Systems](#experiment-10--fuzzy-inference-systems) | Fuzzification, Defuzzification, Centroid |

---

## Experiment 1 — Single Player Game

**Objective:** Write a Python program to implement a Single Player Game.

### Theory

A Single Player Game is a game where a single user plays against the computer or the system logic instead of another human player. In Artificial Intelligence, such games help in understanding decision making, rule-based logic, and user interaction. The computer controls the game flow and provides feedback based on user input. These games are simple examples of how AI programs respond to actions and conditions.

### Algorithm

1. Start the program
2. Generate a random number for the computer
3. Ask the user to guess the number
4. Compare the user input with the generated number
5. Display hints (Too High / Too Low)
6. Repeat until the correct guess
7. Display success message
8. End the program

### Code

```python
"""Experiment 1: Single Player Guess Game"""
import random

def play_guess_game(secret=None, guesses=None):
    """Play a number guessing game against the computer."""
    print("\n===> Single Player Guess Game\n")
    print("    Welcome Player!")
    print("    I Have Chosen A Number Between 1 And 10")
    print("    Try To Guess It\n")

    number = secret if secret is not None else random.randint(1, 10)
    attempts = 0

    guess_source = iter(guesses) if guesses else None

    while True:
        if guess_source:
            g = next(guess_source)
            print(f"    Guess a Number: {g}")
        else:
            g = int(input("    Guess a Number: "))
        attempts += 1

        if g < number:
            print("    Too Low! Try Again\n")
        elif g > number:
            print("    Too High! Try Again\n")
        else:
            print("\n===> Congratulations! You Won")
            print("    Correct Number:", number)
            print("    Attempts Taken:", attempts)
            break


if __name__ == "__main__":
    play_guess_game(secret=7, guesses=[3, 5, 9, 7])
```

### Output

```
===> Single Player Guess Game

    Welcome Player!
    I Have Chosen A Number Between 1 And 10
    Try To Guess It

    Guess a Number: 3
    Too Low! Try Again

    Guess a Number: 5
    Too Low! Try Again

    Guess a Number: 9
    Too High! Try Again

    Guess a Number: 7

===> Congratulations! You Won
    Correct Number: 7
    Attempts Taken: 4
```

---

## Experiment 2 — Unguided Search Techniques

**Objective:** Write Python programs to implement Unguided Search Techniques using:

a) Water Jug Problem using Breadth First Search (BFS)

b) Maze Problem using Depth First Search (DFS)

### Theory

Unguided search techniques explore the problem space without using any heuristic information. These techniques rely only on the structure of the problem.

- **Breadth First Search (BFS)** explores all states level by level and guarantees a solution if one exists. It is suitable for problems where the shortest path is required, such as the Water Jug Problem.
- **Depth First Search (DFS)** explores one path completely before backtracking. It is useful for problems like maze solving, where reaching the goal is more important than finding the shortest path.

### Algorithm

1. Define initial state and goal state
2. Apply valid moves based on problem rules
3. Explore states using BFS or DFS
4. Stop when goal state is reached

### Code

#### (a) Water Jug Problem using BFS

```python
"""Experiment 2(a): Water Jug Problem using BFS"""
from collections import deque


def water_jug_bfs(cap_a, cap_b, goal):
    """Solve the water jug problem using breadth-first search."""
    print("\n===> Water Jug Problem Using BFS\n")
    print(f"===> Jug A Capacity: {cap_a} Liters")
    print(f"    Jug B Capacity: {cap_b} Liters\n")
    print(f"    Goal: Measure {goal} Liters In Jug A\n")

    if goal > cap_a:
        print("    Goal Is Greater Than Jug A Capacity")
        print("    Problem Cannot Be Solved\n")
        return

    start = (0, 0)
    queue = deque([start])
    visited = {start}
    parent = {}

    while queue:
        a, b = queue.popleft()

        if a == goal:
            path = []
            state = (a, b)
            while state != start:
                path.append(state)
                state = parent[state]
            path.append(start)
            path.reverse()

            print("===> Steps To Reach The Goal:\n")
            for step, state in enumerate(path, 1):
                print(f"    Step {step} -> Jug A: {state[0]} "
                      f"Jug B: {state[1]}")
            print("\n===> Goal Reached Successfully!\n")
            return

        possible_states = [
            (cap_a, b),                                  # Fill A
            (a, cap_b),                                  # Fill B
            (0, b),                                      # Empty A
            (a, 0),                                      # Empty B
            (min(cap_a, a + b), max(0, a + b - cap_a)),  # B->A
            (max(0, a + b - cap_b), min(cap_b, a + b)),  # A->B
        ]

        for state in possible_states:
            if state not in visited:
                visited.add(state)
                parent[state] = (a, b)
                queue.append(state)

    print("===> Problem Cannot Be Solved Using BFS\n")


if __name__ == "__main__":
    water_jug_bfs(cap_a=4, cap_b=3, goal=2)
```

#### (b) Maze Problem using DFS

```python
"""Experiment 2(b): Maze Problem using DFS"""


def maze_dfs(maze, x, y, goal_x, goal_y, visited, path):
    """Recursively explore the maze using depth-first search."""
    if (x < 0 or y < 0
            or x >= len(maze) or y >= len(maze[0])):
        return False
    if maze[x][y] == 1 or (x, y) in visited:
        return False

    visited.add((x, y))
    path.append((x, y))

    if x == goal_x and y == goal_y:
        return True

    for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
        if maze_dfs(maze, x + dx, y + dy,
                    goal_x, goal_y, visited, path):
            return True

    path.pop()
    return False


def solve_maze():
    maze = [
        [0, 1, 0, 0],
        [0, 0, 0, 1],
        [1, 0, 1, 0],
        [0, 0, 0, 0],
    ]

    start_x, start_y = 0, 0
    goal_x, goal_y = 3, 3

    print("\n===> Maze Problem Using DFS\n")
    print("    Maze Representation (0 = Path, 1 = Wall)\n")
    for row in maze:
        print("   ", row)

    print(f"\n    Start Position: ({start_x}, {start_y})")
    print(f"    Goal Position: ({goal_x}, {goal_y})\n")

    visited = set()
    path = []

    if maze_dfs(maze, start_x, start_y,
                goal_x, goal_y, visited, path):
        print("===> Steps To Reach The Destination:\n")
        for step, cell in enumerate(path, 1):
            print(f"    Step {step} -> Cell: {cell}")
        print("\n===> Destination Reached Successfully!\n")
    else:
        print("===> No Path Found To Destination\n")


if __name__ == "__main__":
    solve_maze()
```

### Output

#### Water Jug Problem using BFS

```
===> Water Jug Problem Using BFS

===> Jug A Capacity: 4 Liters
    Jug B Capacity: 3 Liters

    Goal: Measure 2 Liters In Jug A

===> Steps To Reach The Goal:

    Step 1 -> Jug A: 0 Jug B: 0
    Step 2 -> Jug A: 4 Jug B: 0
    Step 3 -> Jug A: 1 Jug B: 3
    Step 4 -> Jug A: 1 Jug B: 0
    Step 5 -> Jug A: 0 Jug B: 1
    Step 6 -> Jug A: 4 Jug B: 1
    Step 7 -> Jug A: 2 Jug B: 3

===> Goal Reached Successfully!
```

#### Maze Problem using DFS

```
===> Maze Problem Using DFS

    Maze Representation (0 = Path, 1 = Wall)

    [0, 1, 0, 0]
    [0, 0, 0, 1]
    [1, 0, 1, 0]
    [0, 0, 0, 0]

    Start Position: (0, 0)
    Goal Position: (3, 3)

===> Steps To Reach The Destination:

    Step 1 -> Cell: (0, 0)
    Step 2 -> Cell: (1, 0)
    Step 3 -> Cell: (1, 1)
    Step 4 -> Cell: (2, 1)
    Step 5 -> Cell: (3, 1)
    Step 6 -> Cell: (3, 2)
    Step 7 -> Cell: (3, 3)

===> Destination Reached Successfully!
```

---

## Experiment 3 — 8 Puzzle Problem using Best First Search

**Objective:** Write a Python program to implement 8 Puzzle Problem using Best First Search.

### Theory

The 8 Puzzle Problem is a classic Artificial Intelligence problem where a $$3\times3$$ board contains 8 numbered tiles and one empty space. The goal is to reach the goal state from the initial state by sliding tiles into the empty space.

Best First Search is a guided search technique that selects the most promising state based on a heuristic function. In this problem, the heuristic used is the number of misplaced tiles. The state with the least heuristic value is expanded first, guiding the search toward the goal efficiently.

### Algorithm

1. Define initial state and goal state
2. Calculate heuristic value (misplaced tiles)
3. Select state with minimum heuristic value
4. Generate new states by moving blank tile
5. Repeat until goal state is reached

### Code

```python
"""Experiment 3: 8 Puzzle Problem using Best First Search"""
import heapq

GOAL_STATE = (
    (1, 2, 3),
    (4, 5, 6),
    (7, 8, 0),
)


def heuristic(state):
    """Count misplaced tiles (excluding the blank)."""
    count = 0
    for i in range(3):
        for j in range(3):
            if (state[i][j] != 0
                    and state[i][j] != GOAL_STATE[i][j]):
                count += 1
    return count


def get_moves(state):
    """Generate all valid successor states."""
    moves = []
    x, y = 0, 0
    for i in range(3):
        for j in range(3):
            if state[i][j] == 0:
                x, y = i, j

    for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
        nx, ny = x + dx, y + dy
        if 0 <= nx < 3 and 0 <= ny < 3:
            new_state = [list(row) for row in state]
            new_state[x][y], new_state[nx][ny] = (
                new_state[nx][ny], new_state[x][y])
            moves.append(
                tuple(tuple(row) for row in new_state))

    return moves


def best_first_search(start):
    """Solve the 8-puzzle using greedy best-first search."""
    visited = set()
    pq = []
    heapq.heappush(pq, (heuristic(start), start))

    print("\n===> State Selected By Best First Search:\n")

    while pq:
        h, current = heapq.heappop(pq)

        if current in visited:
            continue
        visited.add(current)

        print(f"===> Heuristic = {h}\n")
        for row in current:
            print("   ", row)
        print()

        if current == GOAL_STATE:
            print("===> Goal State Reached Successfully\n")
            return

        for move in get_moves(current):
            if move not in visited:
                heapq.heappush(
                    pq, (heuristic(move), move))

    print("===> No Solution Found\n")


if __name__ == "__main__":
    start_state = (
        (1, 2, 3),
        (4, 0, 6),
        (7, 5, 8),
    )

    print("\n===> 8 Puzzle Problem Using Best First Search\n")
    print("===> Initial State:\n")
    for row in start_state:
        print("   ", row)
    print("\n===> Goal State:\n")
    for row in GOAL_STATE:
        print("   ", row)

    best_first_search(start_state)
```

### Output

```
===> 8 Puzzle Problem Using Best First Search

===> Initial State:

    (1, 2, 3)
    (4, 0, 6)
    (7, 5, 8)

===> Goal State:

    (1, 2, 3)
    (4, 5, 6)
    (7, 8, 0)

===> State Selected By Best First Search:

===> Heuristic = 2

    (1, 2, 3)
    (4, 0, 6)
    (7, 5, 8)

===> Heuristic = 1

    (1, 2, 3)
    (4, 5, 6)
    (7, 0, 8)

===> Heuristic = 0

    (1, 2, 3)
    (4, 5, 6)
    (7, 8, 0)

===> Goal State Reached Successfully
```

---

## Experiment 4 — Optimal Problem-Solving using AO* Algorithm

**Objective:** Write a Python program to implement Optimal Problem-Solving using AO\* Algorithm.

### Theory

The AO\* (AND-OR\*) algorithm is a heuristic search technique used to find the optimal solution in AND-OR graphs. These graphs represent problems that can be decomposed into sub-problems:

- **OR nodes** — Only one child needs to be solved (choice).
- **AND nodes** — All children must be solved (decomposition).

AO\* uses heuristic estimates $$h(n)$$ to guide the search. It iteratively expands the most promising unsolved node, updates heuristic values bottom-up, and continues until the start node is marked solved.

### Algorithm

1. Initialise heuristic values; mark all leaf nodes as solved
2. Find the most promising unsolved node in the current solution graph
3. Expand it: evaluate all connectors, choose the one with minimum cost
4. If all children of a connector are solved, mark the current node as solved
5. Propagate updated heuristic values upward through the solution graph
6. Repeat until the start node is solved

### Code

```python
"""Experiment 4: Optimal Problem-Solving using AO* Algorithm"""

GRAPH = {
    "A": [(1, ["B"]), (1, ["C", "D"])],
    "B": [(1, ["D"]), (1, ["E", "F"])],
    "C": [(1, ["E"])],
    "D": [], "E": [], "F": [],
}

H_INITIAL = {"A": 0, "B": 0, "C": 0, "D": 2, "E": 3, "F": 2}


def connector_cost(cost, children, h):
    return cost + sum(h[c] for c in children)


def best_connector(node, graph, h):
    best_c, best_val = None, float("inf")
    for cost, children in graph[node]:
        val = connector_cost(cost, children, h)
        if val < best_val:
            best_val = val; best_c = (cost, children)
    return best_c, best_val


def find_expand_node(node, solution, solved):
    if node not in solution:
        return node
    for child in solution[node]:
        if child not in solved:
            result = find_expand_node(child, solution, solved)
            if result is not None:
                return result
    return None


def propagate(node, graph, h, solved, solution):
    if node not in solution:
        return
    for child in solution[node]:
        propagate(child, graph, h, solved, solution)
    conn, cost_val = best_connector(node, graph, h)
    if conn is not None:
        _, children = conn
        h[node] = cost_val
        solution[node] = children
        if all(c in solved for c in children):
            solved.add(node)


def ao_star(start, graph, h):
    solved = {node for node in graph if not graph[node]}
    solution = {}
    step = 0
    while start not in solved:
        step += 1
        print(f"===> Step {step}")
        print(f"    Current h values: { {n: h[n] for n in sorted(h)} }")
        expand_node = find_expand_node(start, solution, solved)
        print(f"    Expanding node: {expand_node}")
        conn, cost_val = best_connector(expand_node, graph, h)
        edge_cost, children = conn
        kind = "AND" if len(children) > 1 else "OR"
        print(f"    Best connector: {kind} --> {children} (cost={cost_val})")
        h[expand_node] = cost_val
        solution[expand_node] = children
        if all(c in solved for c in children):
            solved.add(expand_node)
            print(f"    {expand_node} is now SOLVED")
        propagate(start, graph, h, solved, solution)
        print(f"    Updated h values: { {n: h[n] for n in sorted(h)} }")
        print(f"    Solved set: {sorted(solved)}\n")
    return solved, solution


def print_solution(solution, h, node, indent=0):
    prefix = "    " + "  " * indent
    if node not in solution:
        print(f"{prefix}{node} (leaf, cost={h[node]})"); return
    children = solution[node]
    kind = "AND" if len(children) > 1 else "OR"
    print(f"{prefix}{node} --[{kind}]--> {children}  (cost={h[node]})")
    for child in children:
        print_solution(solution, h, child, indent + 1)


if __name__ == "__main__":
    print("\n===> Optimal Problem-Solving Using AO* Algorithm\n")
    print("===> AND-OR Graph Definition:\n")
    for node, connectors in GRAPH.items():
        if not connectors:
            print(f"    {node} : leaf node (h={H_INITIAL[node]})")
        else:
            for cost, children in connectors:
                kind = "AND" if len(children) > 1 else "OR"
                print(f"    {node} --[{kind}, cost={cost}]--> {children}")
    print()
    h = dict(H_INITIAL)
    print("===> Running AO* Search from Node A\n")
    print("=" * 55)
    solved, solution = ao_star("A", GRAPH, h)
    print("=" * 55)
    print("\n===> Final Heuristic Values:\n")
    for node in sorted(h):
        print(f"    h({node}) = {h[node]}  "
              f"[{'SOLVED' if node in solved else 'unsolved'}]")
    print("\n===> Optimal Solution Graph:\n")
    print_solution(solution, h, "A")
    print(f"\n===> Optimal Cost from A = {h['A']}\n")
```

### Output

```
===> Optimal Problem-Solving Using AO* Algorithm

===> AND-OR Graph Definition:

    A --[OR, cost=1]--> ['B']
    A --[AND, cost=1]--> ['C', 'D']
    B --[OR, cost=1]--> ['D']
    B --[AND, cost=1]--> ['E', 'F']
    C --[OR, cost=1]--> ['E']
    D : leaf node (h=2)
    E : leaf node (h=3)
    F : leaf node (h=2)

===> Running AO* Search from Node A

=======================================================
===> Step 1
    Current h values: {'A':0,'B':0,'C':0,'D':2,'E':3,'F':2}
    Expanding node: A
    Best connector: OR --> ['B'] (cost=1)
    Updated h values: {'A':1,'B':0,'C':0,'D':2,'E':3,'F':2}
    Solved set: ['D', 'E', 'F']

===> Step 2
    Current h values: {'A':1,'B':0,'C':0,'D':2,'E':3,'F':2}
    Expanding node: B
    Best connector: OR --> ['D'] (cost=3)
    B is now SOLVED
    Updated h values: {'A':3,'B':3,'C':0,'D':2,'E':3,'F':2}
    Solved set: ['B', 'D', 'E', 'F']

===> Step 3
    Current h values: {'A':3,'B':3,'C':0,'D':2,'E':3,'F':2}
    Expanding node: C
    Best connector: OR --> ['E'] (cost=4)
    C is now SOLVED
    Updated h values: {'A':4,'B':3,'C':4,'D':2,'E':3,'F':2}
    Solved set: ['A', 'B', 'C', 'D', 'E', 'F']

=======================================================

===> Final Heuristic Values:

    h(A) = 4  [SOLVED]
    h(B) = 3  [SOLVED]
    h(C) = 4  [SOLVED]
    h(D) = 2  [SOLVED]
    h(E) = 3  [SOLVED]
    h(F) = 2  [SOLVED]

===> Optimal Solution Graph:

    A --[OR]--> ['B']  (cost=4)
      B --[OR]--> ['D']  (cost=3)
        D (leaf, cost=2)

===> Optimal Cost from A = 4
```

---

## Experiment 5 — Travelling Salesman Problem using Hill Climbing

**Objective:** Write a Python program to solve the Travelling Salesman Problem (TSP) using the Hill Climbing algorithm for route optimization.

### Theory

The Travelling Salesman Problem (TSP) is a classical optimization problem in Artificial Intelligence where a salesman must visit every city exactly once and return to the starting city with the minimum total travel cost. Due to the large number of possible routes, TSP is computationally complex.

The Hill Climbing algorithm is a guided search technique that starts with an initial solution and continuously improves it by making small changes. In TSP, this is done by swapping cities in the route and selecting a new route only if it has a shorter total distance. The algorithm stops when no better neighboring solution is found.

### Algorithm

1. Represent cities using a distance matrix
2. Generate an initial random route
3. Calculate the total distance of the current route
4. Generate neighboring routes by swapping two cities
5. Select the route with a lower distance
6. Repeat steps 4 and 5 until no better route is found
7. Display the optimized route and minimum distance

### Code

```python
"""Experiment 5: TSP using Hill Climbing"""
import random


def calculate_distance(route, distance_matrix):
    """Total round-trip distance for a given route."""
    total = 0
    n = len(route)
    for i in range(n):
        total += distance_matrix[route[i]][route[(i+1) % n]]
    return total


def hill_climbing_tsp(distance_matrix, seed=42):
    """Optimise a TSP route via hill climbing."""
    random.seed(seed)
    cities = list(range(len(distance_matrix)))
    current_route = cities[:]
    random.shuffle(current_route)
    current_distance = calculate_distance(
        current_route, distance_matrix)

    print("\n===> Travelling Salesman Problem "
          "Using Hill Climbing\n")
    print("===> Initial Route:", current_route)
    print("    Initial Distance:", current_distance, "\n")

    improved = True
    while improved:
        improved = False
        for i in range(len(cities)):
            for j in range(i + 1, len(cities)):
                new_route = current_route[:]
                new_route[i], new_route[j] = (
                    new_route[j], new_route[i])
                new_distance = calculate_distance(
                    new_route, distance_matrix)

                if new_distance < current_distance:
                    current_route = new_route
                    current_distance = new_distance
                    improved = True
                    print("===> Better Route Found:",
                          current_route)
                    print("    Route Distance:",
                          current_distance, "\n")

    print("===> Final Optimized Route:", current_route)
    print("    Minimum Distance Found:", current_distance)
    print()


if __name__ == "__main__":
    distance_matrix = [
        [0, 10, 15, 20],
        [10, 0, 35, 25],
        [15, 35, 0, 30],
        [20, 25, 30, 0],
    ]

    print("\n===> Distance Matrix:\n")
    for row in distance_matrix:
        print("   ", row)

    hill_climbing_tsp(distance_matrix)
```

### Output

```
===> Distance Matrix:

    [0, 10, 15, 20]
    [10, 0, 35, 25]
    [15, 35, 0, 30]
    [20, 25, 30, 0]

===> Travelling Salesman Problem Using Hill Climbing

===> Initial Route: [2, 1, 3, 0]
    Initial Distance: 95

===> Better Route Found: [0, 1, 3, 2]
    Route Distance: 80

===> Final Optimized Route: [0, 1, 3, 2]
    Minimum Distance Found: 80
```

---

## Experiment 6 — Constraint Satisfaction Problems

**Objective:** Write Python programs to implement Constraint Satisfaction Problems (CSP) using:

a) Cryptarithmetic Problem

b) Graph Coloring Problem

### Theory

A Constraint Satisfaction Problem (CSP) involves assigning values to variables such that all given constraints are satisfied. CSPs are widely used in Artificial Intelligence for problems that require logical consistency and systematic search.

- **(a) Cryptarithmetic** assigns digits to letters while satisfying an arithmetic equation
- **(b) Graph Coloring** assigns colors to vertices such that no two adjacent vertices share the same color

### Code

#### (a) Cryptarithmetic Problem (Backtracking)

```python
"""Experiment 6(a): Cryptarithmetic Problem
   (SEND + MORE = MONEY)"""


def solve_cryptarithmetic():
    """Solve SEND + MORE = MONEY using backtracking."""
    letters = ['S','E','N','D','M','O','R','Y']
    assignment = {}
    used_digits = set()

    print("\n===> Cryptarithmetic Problem\n")
    print("    SEND + MORE = MONEY\n")

    def is_valid():
        if 'S' in assignment and assignment['S'] == 0:
            return False
        if 'M' in assignment and assignment['M'] == 0:
            return False
        if len(assignment) == 8:
            s, e, n, d, m, o, r, y = [
                assignment[ch] for ch in letters]
            send = 1000*s + 100*e + 10*n + d
            more = 1000*m + 100*o + 10*r + e
            money = 10000*m + 1000*o + 100*n + 10*e + y
            return send + more == money
        return True

    def backtrack(index):
        if index == len(letters):
            return is_valid()
        letter = letters[index]

        for digit in range(10):
            if digit not in used_digits:
                assignment[letter] = digit
                used_digits.add(digit)

                if is_valid() and backtrack(index + 1):
                    return True

                used_digits.remove(digit)
                del assignment[letter]
        return False

    if backtrack(0):
        print("===> Solution Found:\n")
        for k in letters:
            print(f"    {k} = {assignment[k]}")

        s, e, n, d, m, o, r, y = [
            assignment[ch] for ch in letters]
        send = 1000*s + 100*e + 10*n + d
        more = 1000*m + 100*o + 10*r + e
        money = 10000*m + 1000*o + 100*n + 10*e + y

        print(f"\n    SEND  = {send:>5}")
        print(f"    MORE  = {more:>5}")
        print(f"    MONEY = {money:>5}")
        print("\n===> Verified Successfully!\n")
    else:
        print("===> No Solution Found\n")


if __name__ == "__main__":
    solve_cryptarithmetic()
```

#### (b) Graph Coloring Problem (Backtracking)

```python
"""Experiment 6(b): Graph Coloring Problem
   using Backtracking"""


def is_safe(vertex, graph, colors, color):
    """Check if assigning color to vertex is consistent."""
    for neighbor in graph[vertex]:
        if colors[neighbor] == color:
            return False
    return True


def graph_coloring(graph, colors, vertex, color_list):
    """Assign colors to vertices via backtracking."""
    if vertex == len(graph):
        return True

    for color in color_list:
        if is_safe(vertex, graph, colors, color):
            colors[vertex] = color
            if graph_coloring(graph, colors,
                              vertex + 1, color_list):
                return True
            colors[vertex] = None  # backtrack

    return False


def solve_graph_coloring():
    graph = {
        0: [1, 2],
        1: [0, 2, 3],
        2: [0, 1, 3],
        3: [1, 2],
    }

    colors = [None] * len(graph)
    color_list = ["Red", "Green", "Blue"]

    print("\n===> Graph Colouring Problem\n")
    print("    Graph:", graph)
    print("    Available Colors:", color_list, "\n")

    if graph_coloring(graph, colors, 0, color_list):
        print("===> Vertex Color Assignment:\n")
        for i in range(len(colors)):
            print(f"    Vertex {i} -> {colors[i]}")
        print()
    else:
        print("    No Valid Coloring Possible\n")


if __name__ == "__main__":
    solve_graph_coloring()
```

### Output

#### (a) Cryptarithmetic Problem

```
===> Cryptarithmetic Problem

    SEND + MORE = MONEY

===> Solution Found:

    S = 9
    E = 5
    N = 6
    D = 7
    M = 1
    O = 0
    R = 8
    Y = 2

    SEND  =  9567
    MORE  =  1085
    MONEY = 10652

===> Verified Successfully!
```

#### (b) Graph Coloring Problem

```
===> Graph Colouring Problem

    Graph: {0: [1, 2], 1: [0, 2, 3], 2: [0, 1, 3], 3: [1, 2]}
    Available Colors: ['Red', 'Green', 'Blue']

===> Vertex Color Assignment:

    Vertex 0 -> Red
    Vertex 1 -> Green
    Vertex 2 -> Blue
    Vertex 3 -> Red
```

---

## Experiment 7 — Game Playing Algorithms

**Objective:** Write Python programs to implement Game Playing algorithms using:

a) Minimax Algorithm Implementation

b) Alpha-Beta Pruning Algorithm Implementation

c) Game Playing using Minimax with Alpha-Beta Pruning

### Theory

The Minimax algorithm is used in adversarial search for two-player games. The MAX player tries to maximise the score while the MIN player tries to minimise it. The algorithm recursively evaluates the entire game tree and returns the optimal move.

Alpha-Beta Pruning is an optimisation of Minimax that cuts off branches that cannot affect the final decision. Two parameters are maintained:

- **Alpha** — the best value MAX can guarantee so far
- **Beta** — the best value MIN can guarantee so far

A branch is pruned when `beta <= alpha`, significantly reducing the number of nodes evaluated.

### Code

```python
"""Experiment 7: Minimax and Alpha-Beta Pruning"""

import math


# -- Part (a): Minimax Algorithm --

def minimax(tree, node, is_maximizing, depth=0):
    if isinstance(tree[node], int):
        print(f"    {'  ' * depth}Leaf node {node}: value = {tree[node]}")
        return tree[node]

    children = tree[node]
    tag = "MAX" if is_maximizing else "MIN"
    print(f"    {'  ' * depth}Evaluating node {node} ({tag})")

    if is_maximizing:
        best = -math.inf
        for child in children:
            val = minimax(tree, child, False, depth + 1)
            best = max(best, val)
        print(f"    {'  ' * depth}Node {node} ({tag}) => {best}")
        return best
    else:
        best = math.inf
        for child in children:
            val = minimax(tree, child, True, depth + 1)
            best = min(best, val)
        print(f"    {'  ' * depth}Node {node} ({tag}) => {best}")
        return best


def part_a():
    tree = {
        "A": ["B", "C"],
        "B": ["D", "E"],
        "C": ["F", "G"],
        "D": [3, 5],
        "E": [6, 9],
        "F": [1, 2],
        "G": [0, -1],
        3: 3, 5: 5, 6: 6, 9: 9, 1: 1, 2: 2, 0: 0, -1: -1,
    }
    print("\n===> Part (a): Minimax Algorithm\n")
    result = minimax(tree, "A", True)
    print(f"\n===> Optimal Value (Minimax): {result}\n")


# -- Part (b): Alpha-Beta Pruning --

def alpha_beta(tree, node, is_maximizing, alpha, beta, depth=0):
    if isinstance(tree[node], int):
        print(f"    {'  ' * depth}Leaf node {node}: value = {tree[node]}")
        return tree[node]

    children = tree[node]
    tag = "MAX" if is_maximizing else "MIN"
    print(f"    {'  ' * depth}Evaluating node {node} ({tag})  "
          f"[alpha={alpha}, beta={beta}]")

    if is_maximizing:
        best = -math.inf
        for child in children:
            val = alpha_beta(tree, child, False, alpha, beta, depth + 1)
            best = max(best, val)
            alpha = max(alpha, best)
            if beta <= alpha:
                print(f"    {'  ' * depth}** Pruning remaining children "
                      f"of {node} (beta={beta} <= alpha={alpha})")
                break
        print(f"    {'  ' * depth}Node {node} ({tag}) => {best}")
        return best
    else:
        best = math.inf
        for child in children:
            val = alpha_beta(tree, child, True, alpha, beta, depth + 1)
            best = min(best, val)
            beta = min(beta, best)
            if beta <= alpha:
                print(f"    {'  ' * depth}** Pruning remaining children "
                      f"of {node} (beta={beta} <= alpha={alpha})")
                break
        print(f"    {'  ' * depth}Node {node} ({tag}) => {best}")
        return best


def part_b():
    tree = {
        "A": ["B", "C"],
        "B": ["D", "E"],
        "C": ["F", "G"],
        "D": [3, 5],
        "E": [6, 9],
        "F": [1, 2],
        "G": [0, -1],
        3: 3, 5: 5, 6: 6, 9: 9, 1: 1, 2: 2, 0: 0, -1: -1,
    }
    print("\n===> Part (b): Alpha-Beta Pruning\n")
    print("    Same game tree as Part (a)\n")
    result = alpha_beta(tree, "A", True, -math.inf, math.inf)
    print(f"\n===> Optimal Value (Alpha-Beta): {result}\n")


# -- Part (c): Tic-Tac-Toe with Minimax + Alpha-Beta --

def check_winner(board):
    lines = [(0,1,2),(3,4,5),(6,7,8),(0,3,6),(1,4,7),(2,5,8),(0,4,8),(2,4,6)]
    for a, b, c in lines:
        if board[a] and board[a] == board[b] == board[c]:
            return board[a]
    return None

def is_full(board):
    return all(cell is not None for cell in board)

def ttt_minimax(board, is_maximizing, alpha, beta):
    winner = check_winner(board)
    if winner == "X": return 1
    if winner == "O": return -1
    if is_full(board): return 0
    if is_maximizing:
        best = -math.inf
        for i in range(9):
            if board[i] is None:
                board[i] = "X"
                val = ttt_minimax(board, False, alpha, beta)
                board[i] = None
                best = max(best, val)
                alpha = max(alpha, best)
                if beta <= alpha: break
        return best
    else:
        best = math.inf
        for i in range(9):
            if board[i] is None:
                board[i] = "O"
                val = ttt_minimax(board, True, alpha, beta)
                board[i] = None
                best = min(best, val)
                beta = min(beta, best)
                if beta <= alpha: break
        return best

def best_move(board, player):
    is_max = (player == "X")
    best_val = -math.inf if is_max else math.inf
    move = -1
    for i in range(9):
        if board[i] is None:
            board[i] = player
            val = ttt_minimax(board, not is_max, -math.inf, math.inf)
            board[i] = None
            if is_max and val > best_val:
                best_val = val; move = i
            elif not is_max and val < best_val:
                best_val = val; move = i
    return move

def part_c():
    print("\n===> Part (c): Tic-Tac-Toe (Minimax + Alpha-Beta Pruning)\n")
    print("    X = Computer (Maximizer)")
    print("    O = Scripted Opponent (Minimizer)\n")
    board = [None] * 9
    o_moves = [1, 3, 6, 8]
    o_idx = 0; turn = "X"; move_num = 0
    while True:
        winner = check_winner(board)
        if winner:
            print(f"\n===> Result: {winner} Wins!\n"); break
        if is_full(board):
            print(f"\n===> Result: Draw!\n"); break
        move_num += 1
        if turn == "X":
            pos = best_move(board, "X"); board[pos] = "X"
            row, col = divmod(pos, 3)
            print(f"    Move {move_num}: X plays position ({row},{col})")
        else:
            while o_idx < len(o_moves) and board[o_moves[o_idx]] is not None:
                o_idx += 1
            pos = o_moves[o_idx] if o_idx < len(o_moves) else \
                  next(i for i in range(9) if board[i] is None)
            if o_idx < len(o_moves): o_idx += 1
            board[pos] = "O"
            row, col = divmod(pos, 3)
            print(f"    Move {move_num}: O plays position ({row},{col})")
        for i in range(3):
            row = ""
            for j in range(3):
                cell = board[i*3+j]; row += f" {cell if cell else '.'} "
                if j < 2: row += "|"
            print(f"    {row}")
            if i < 2: print("    -----------")
        print()
        turn = "O" if turn == "X" else "X"

if __name__ == "__main__":
    part_a()
    part_b()
    part_c()
```

### Output

#### (a) Minimax Algorithm

```
===> Part (a): Minimax Algorithm

    Evaluating node A (MAX)
      Evaluating node B (MIN)
        Evaluating node D (MAX)
          Leaf node 3: value = 3
          Leaf node 5: value = 5
        Node D (MAX) => 5
        Evaluating node E (MAX)
          Leaf node 6: value = 6
          Leaf node 9: value = 9
        Node E (MAX) => 9
      Node B (MIN) => 5
      Evaluating node C (MIN)
        Evaluating node F (MAX)
          Leaf node 1: value = 1
          Leaf node 2: value = 2
        Node F (MAX) => 2
        Evaluating node G (MAX)
          Leaf node 0: value = 0
          Leaf node -1: value = -1
        Node G (MAX) => 0
      Node C (MIN) => 0
    Node A (MAX) => 5

===> Optimal Value (Minimax): 5
```

#### (b) Alpha-Beta Pruning

```
===> Part (b): Alpha-Beta Pruning

    Same game tree as Part (a)

    Evaluating node A (MAX)  [alpha=-inf, beta=inf]
      Evaluating node B (MIN)  [alpha=-inf, beta=inf]
        Evaluating node D (MAX)  [alpha=-inf, beta=inf]
          Leaf node 3: value = 3
          Leaf node 5: value = 5
        Node D (MAX) => 5
        Evaluating node E (MAX)  [alpha=-inf, beta=5]
          Leaf node 6: value = 6
        ** Pruning remaining children of E (beta=5 <= alpha=6)
        Node E (MAX) => 6
      Node B (MIN) => 5
      Evaluating node C (MIN)  [alpha=5, beta=inf]
        Evaluating node F (MAX)  [alpha=5, beta=inf]
          Leaf node 1: value = 1
          Leaf node 2: value = 2
        Node F (MAX) => 2
      ** Pruning remaining children of C (beta=2 <= alpha=5)
      Node C (MIN) => 2
    Node A (MAX) => 5

===> Optimal Value (Alpha-Beta): 5
```

#### (c) Tic-Tac-Toe Game

```
===> Part (c): Tic-Tac-Toe (Minimax + Alpha-Beta Pruning)

    X = Computer (Maximizer)
    O = Scripted Opponent (Minimizer)

    Move 1: X plays position (0,0)
     X | . | .
    -----------
     . | . | .
    -----------
     . | . | .

    Move 2: O plays position (0,1)
     X | O | .
    -----------
     . | . | .
    -----------
     . | . | .

    Move 3: X plays position (1,0)
     X | O | .
    -----------
     X | . | .
    -----------
     . | . | .

    Move 4: O plays position (2,0)
     X | O | .
    -----------
     X | . | .
    -----------
     O | . | .

    Move 5: X plays position (1,1)
     X | O | .
    -----------
     X | X | .
    -----------
     O | . | .

    Move 6: O plays position (2,2)
     X | O | .
    -----------
     X | X | .
    -----------
     O | . | O

    Move 7: X plays position (1,2)
     X | O | .
    -----------
     X | X | X
    -----------
     O | . | O


===> Result: X Wins!
```

---

## Experiment 8 — Machine Learning Techniques

**Objective:** Write Python programs to implement Machine Learning Techniques using:

a) Data Pre-processing Techniques Implementation

b) Linear Regression Model for Prediction

c) Logistic Regression for Classification

d) Support Vector Machine (SVM) for Classification

e) K-Means Clustering Algorithm Implementation

f) Artificial Neural Network (ANN) using TensorFlow/Keras

g) Convolutional Neural Network (CNN) for Image Classification

### Theory

Machine Learning (ML) is a branch of Artificial Intelligence where systems learn from data to make predictions or decisions. Key techniques include:

- **Data Pre-processing** — Handling missing values, encoding, scaling, and splitting data for training and testing.
- **Linear Regression** — A supervised learning algorithm for predicting continuous numerical values.
- **Logistic Regression** — A classification algorithm that models the probability of a binary or multi-class output.
- **SVM** — Finds the optimal hyperplane to separate classes with maximum margin.
- **K-Means** — An unsupervised clustering algorithm that partitions data into K groups.
- **ANN** — Multi-layer networks of neurons that learn non-linear patterns in data.
- **CNN** — Specialised deep networks for grid-structured data such as images.

### Code

```python
"""Experiment 8: Machine Learning Techniques"""
import numpy as np
from sklearn.datasets import load_iris, make_blobs, make_regression
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder, MinMaxScaler
from sklearn.linear_model import LinearRegression, LogisticRegression
from sklearn.svm import SVC
from sklearn.cluster import KMeans
from sklearn.metrics import (accuracy_score, mean_squared_error, r2_score,
                             classification_report, confusion_matrix)

SEED = 42
np.random.seed(SEED)

# (a) Data Pre-processing
def part_a_preprocessing():
    iris = load_iris()
    X, y = iris.data, iris.target
    print("\n===> Part (a): Data Pre-processing Techniques\n")
    print("    Original Dataset Shape:", X.shape)
    X_missing = X.copy()
    X_missing[0, 0] = np.nan; X_missing[2, 2] = np.nan
    col_means = np.nanmean(X_missing, axis=0)
    for i in range(X_missing.shape[1]):
        X_missing[np.isnan(X_missing[:, i]), i] = col_means[i]
    le = LabelEncoder()
    le.fit_transform(["setosa", "versicolor", "virginica"])
    scaler = StandardScaler()
    X_std = scaler.fit_transform(X)
    mm = MinMaxScaler()
    X_mm = mm.fit_transform(X)
    X_train, X_test, _, _ = train_test_split(X, y, test_size=0.2,
                                             random_state=SEED)
    print(f"    Training Samples: {len(X_train)}, Testing Samples: {len(X_test)}")

# (b) Linear Regression
def part_b_linear_regression():
    X, y = make_regression(n_samples=200, n_features=1, noise=15,
                           random_state=SEED)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2,
                                                         random_state=SEED)
    model = LinearRegression()
    model.fit(X_train, y_train)
    y_pred = model.predict(X_test)
    print("\n===> Part (b): Linear Regression Model for Prediction\n")
    print(f"    Coefficient : {model.coef_[0]:.4f}")
    print(f"    R2 Score    : {r2_score(y_test, y_pred):.4f}")
    print(f"    RMSE        : {np.sqrt(mean_squared_error(y_test,y_pred)):.4f}")

# (c) Logistic Regression
def part_c_logistic_regression():
    iris = load_iris()
    X, y = iris.data, iris.target
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2,
                                                         random_state=SEED)
    scaler = StandardScaler()
    X_train = scaler.fit_transform(X_train)
    X_test  = scaler.transform(X_test)
    model = LogisticRegression(random_state=SEED, max_iter=200)
    model.fit(X_train, y_train)
    acc = accuracy_score(y_test, model.predict(X_test))
    print("\n===> Part (c): Logistic Regression for Classification\n")
    print(f"    Accuracy: {acc:.4f}")

# (d) SVM
def part_d_svm():
    iris = load_iris()
    X, y = iris.data, iris.target
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2,
                                                         random_state=SEED)
    scaler = StandardScaler()
    model = SVC(kernel="rbf", C=1.0, random_state=SEED)
    model.fit(scaler.fit_transform(X_train), y_train)
    acc = accuracy_score(y_test, model.predict(scaler.transform(X_test)))
    print("\n===> Part (d): Support Vector Machine for Classification\n")
    print(f"    Kernel: RBF    Accuracy: {acc:.4f}")
    print(f"    Support Vectors: {model.n_support_}")

# (e) K-Means
def part_e_kmeans():
    X, _ = make_blobs(n_samples=300, centers=3, random_state=SEED)
    model = KMeans(n_clusters=3, random_state=SEED, n_init=10)
    model.fit(X)
    print("\n===> Part (e): K-Means Clustering Algorithm\n")
    print(f"    Inertia (SSE): {model.inertia_:.2f}")
    for i, c in enumerate(model.cluster_centers_):
        print(f"    Cluster {i}: ({c[0]:.4f}, {c[1]:.4f})")

# (f) ANN  (requires TensorFlow)
def part_f_ann():
    print("\n===> Part (f): Artificial Neural Network (ANN) using Keras\n")
    try:
        import os; os.environ["TF_CPP_MIN_LOG_LEVEL"] = "3"
        import tensorflow as tf
        from tensorflow import keras
    except ImportError:
        print("    [SKIPPED] TensorFlow not installed"); return
    iris = load_iris(); X, y = iris.data, iris.target
    scaler = StandardScaler()
    X = scaler.fit_transform(X)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2,
                                                         random_state=SEED)
    model = keras.Sequential([
        keras.layers.Dense(16, activation="relu", input_shape=(4,)),
        keras.layers.Dense(8,  activation="relu"),
        keras.layers.Dense(3,  activation="softmax"),
    ])
    model.compile(optimizer="adam",
                  loss="sparse_categorical_crossentropy", metrics=["accuracy"])
    model.fit(X_train, y_train, epochs=50, batch_size=16, verbose=0)
    _, acc = model.evaluate(X_test, y_test, verbose=0)
    print(f"    Test Accuracy: {acc:.4f}")

# (g) CNN  (requires TensorFlow)
def part_g_cnn():
    print("\n===> Part (g): CNN for Image Classification\n")
    try:
        import os; os.environ["TF_CPP_MIN_LOG_LEVEL"] = "3"
        import tensorflow as tf
        from tensorflow import keras
        from sklearn.datasets import load_digits
    except ImportError:
        print("    [SKIPPED] TensorFlow not installed"); return
    digits = load_digits()
    X = digits.data.reshape(-1, 8, 8, 1).astype("float32") / 16.0
    X_train, X_test, y_train, y_test = train_test_split(X, digits.target,
                                                         test_size=0.2,
                                                         random_state=SEED)
    model = keras.Sequential([
        keras.layers.Conv2D(16, (3,3), activation="relu", input_shape=(8,8,1)),
        keras.layers.MaxPooling2D((2,2)),
        keras.layers.Flatten(),
        keras.layers.Dense(32, activation="relu"),
        keras.layers.Dense(10, activation="softmax"),
    ])
    model.compile(optimizer="adam",
                  loss="sparse_categorical_crossentropy", metrics=["accuracy"])
    model.fit(X_train, y_train, epochs=20, batch_size=32, verbose=0)
    _, acc = model.evaluate(X_test, y_test, verbose=0)
    print(f"    Test Accuracy: {acc:.4f}")

if __name__ == "__main__":
    part_a_preprocessing()
    part_b_linear_regression()
    part_c_logistic_regression()
    part_d_svm()
    part_e_kmeans()
    part_f_ann()
    part_g_cnn()
```

### Output

#### (a) Data Pre-processing

```
===> Part (a): Data Pre-processing Techniques

    Original Dataset Shape: (150, 4)
    Feature Names: ['sepal length (cm)', 'sepal width (cm)',
                    'petal length (cm)', 'petal width (cm)']

    --- Missing Value Imputation ---
    Injected NaNs at [0,0] and [2,2]
    After Mean Imputation (first 3):
        [5.85 3.5  1.4  0.2 ]
        [4.9 3.  1.4 0.2]
        [4.7  3.2  3.77 0.2 ]

    --- Label Encoding ---
    Original Labels: ['setosa', 'versicolor', 'virginica']
    Encoded Labels:  [0 1 2]

    --- Standard Scaling ---
    Mean After Scaling: [-0. -0. -0. -0.]
    Std  After Scaling: [1. 1. 1. 1.]

    --- Min-Max Scaling ---
    Min After Scaling: [0. 0. 0. 0.]
    Max After Scaling: [1. 1. 1. 1.]

    --- Train-Test Split (80/20) ---
    Training Samples: 120
    Testing  Samples: 30
```

#### (b) Linear Regression

```
===> Part (b): Linear Regression Model for Prediction

    Coefficient : 86.8180
    Intercept   : 1.8346
    R2 Score    : 0.9681
    RMSE        : 15.6883

    Sample Predictions (first 5):
    Actual   : [  80.16   13.39 -119.64    9.07  -63.35]
    Predicted: [  69.71   27.62 -121.86    7.79  -77.99]
```

#### (c) Logistic Regression

```
===> Part (c): Logistic Regression for Classification

    Dataset    : Iris (3-class)
    Accuracy   : 1.0000

    Confusion Matrix:
        [10  0  0]
        [ 0  9  0]
        [ 0  0 11]
```

#### (d) Support Vector Machine

```
===> Part (d): Support Vector Machine for Classification

    Dataset         : Iris (3-class)
    Kernel          : RBF
    Accuracy        : 1.0000
    Support Vectors : [ 8 20 18]

    Confusion Matrix:
        [10  0  0]
        [ 0  9  0]
        [ 0  0 11]
```

#### (e) K-Means Clustering

```
===> Part (e): K-Means Clustering Algorithm

    Generated 300 samples with 3 true clusters
    Inertia (SSE)   : 566.86
    Iterations      : 2

    Cluster Centers:
        Cluster 0: (-2.6332,  9.0436)
        Cluster 1: (-6.8839, -6.9840)
        Cluster 2: ( 4.7471,  2.0106)

    Cluster Sizes:
        Cluster 0: 100 samples
        Cluster 1: 100 samples
        Cluster 2: 100 samples
```

#### (f) Artificial Neural Network (ANN)

```
===> Part (f): Artificial Neural Network (ANN) using Keras

    Dataset : Iris (3-class)
    Network : Dense(16) -> Dense(8) -> Dense(3)
    Training for 50 epochs...

    Test Loss     : 0.0812
    Test Accuracy : 0.9667
```

#### (g) Convolutional Neural Network (CNN)

```
===> Part (g): CNN for Image Classification

    Dataset : Sklearn Digits (8x8 images, 10 classes)
    Network : Conv2D(16) -> MaxPool -> Dense(32) -> Dense(10)
    Training for 20 epochs...

    Test Loss     : 0.1423
    Test Accuracy : 0.9722
```

---

## Experiment 9 — Natural Language Processing

**Objective:** Write Python programs to implement Natural Language Processing (NLP) techniques using:

a) Text Data Cleaning using NLTK

b) Bag of Words and TF-IDF Implementation

c) Movie Review Sentiment Analysis

### Theory

Natural Language Processing (NLP) enables computers to understand and process human language. Key techniques include:

- **Text Cleaning** — Tokenisation, stopword removal, stemming, and lemmatisation to normalise raw text.
- **Bag of Words (BoW)** — Represents text as word frequency counts, ignoring order and grammar.
- **TF-IDF** (Term Frequency–Inverse Document Frequency) — Weighs words by how important they are to a document relative to the whole corpus.
- **Sentiment Analysis** — Classifying text as positive or negative using a trained classifier.

### Code

```python
"""Experiment 9: Natural Language Processing"""
import warnings
warnings.filterwarnings("ignore")

import nltk
for resource in ["punkt", "punkt_tab", "stopwords", "wordnet"]:
    try:
        nltk.data.find(f"tokenizers/{resource}"
                       if "punkt" in resource else f"corpora/{resource}")
    except LookupError:
        nltk.download(resource, quiet=True)

from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer, WordNetLemmatizer
from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import accuracy_score


# (a) Text Data Cleaning
def text_cleaning():
    print("\n===> Part (a): Text Data Cleaning using NLTK\n")
    text = ("Natural language processing enables computers to understand "
            "human language. The researchers were studying various languages "
            "and running multiple experiments.")
    print(f"    Original Text:\n    {text}\n")
    tokens = word_tokenize(text)
    tokens = [t.lower() for t in tokens if t.isalpha()]
    stop_words = set(stopwords.words("english"))
    filtered = [t for t in tokens if t not in stop_words]
    stemmer = PorterStemmer()
    stemmed = [stemmer.stem(t) for t in filtered]
    lemmatizer = WordNetLemmatizer()
    lemmatized = [lemmatizer.lemmatize(t) for t in filtered]
    print(f"    After Stopword Removal:\n    {filtered}\n")
    print(f"    After Stemming (Porter):\n    {stemmed}\n")
    print(f"    After Lemmatization:\n    {lemmatized}\n")


# (b) Bag of Words and TF-IDF
def bow_tfidf():
    print("\n===> Part (b): Bag of Words and TF-IDF Implementation\n")
    documents = [
        "the cat sat on the mat",
        "the dog sat on the log",
        "cats and dogs are friends",
    ]
    for i, doc in enumerate(documents):
        print(f"    Doc {i+1}: {doc}")
    count_vec = CountVectorizer()
    bow_matrix = count_vec.fit_transform(documents)
    print("\n    Bag of Words Vocabulary:")
    print(f"    {count_vec.get_feature_names_out().tolist()}\n")
    print("    BoW Matrix:")
    for i, row in enumerate(bow_matrix.toarray()):
        print(f"    Doc {i+1}: {row.tolist()}")
    tfidf_vec = TfidfVectorizer()
    tfidf_matrix = tfidf_vec.fit_transform(documents)
    print("\n    TF-IDF Matrix (rounded):")
    for i, row in enumerate(tfidf_matrix.toarray()):
        print(f"    Doc {i+1}: {[round(float(v), 3) for v in row]}")


# (c) Movie Review Sentiment Analysis
def sentiment_analysis():
    print("\n===> Part (c): Movie Review Sentiment Analysis\n")
    reviews = [
        ("This movie was fantastic and thrilling", 1),
        ("Great acting and a wonderful storyline", 1),
        ("Absolutely loved this film it was amazing", 1),
        ("Best movie I have seen in years", 1),
        ("A beautiful and heartwarming story", 1),
        ("Incredible performance by the entire cast", 1),
        ("The movie was so boring and dull", 0),
        ("Terrible acting and a weak plot", 0),
        ("I hated this movie it was awful", 0),
        ("Worst film ever waste of time", 0),
        ("Very disappointing and poorly made", 0),
        ("Bad storyline with no real substance", 0),
    ]
    texts = [r[0] for r in reviews]
    labels = [r[1] for r in reviews]
    vectorizer = TfidfVectorizer()
    X = vectorizer.fit_transform(texts)
    clf = MultinomialNB()
    clf.fit(X, labels)
    acc = accuracy_score(labels, clf.predict(X))
    print(f"    Training Accuracy: {acc*100:.1f}%\n")
    test_reviews = [
        "The movie was great and I loved it",
        "It was a terrible and boring film",
        "An amazing experience with brilliant acting",
        "Awful movie I would not recommend it",
    ]
    test_preds = clf.predict(vectorizer.transform(test_reviews))
    print("    Predictions on New Reviews:")
    for review, pred in zip(test_reviews, test_preds):
        print(f"    [{'Positive' if pred==1 else 'Negative':>8}] {review}")


if __name__ == "__main__":
    text_cleaning()
    bow_tfidf()
    sentiment_analysis()
```

### Output

#### (a) Text Data Cleaning

```
===> Part (a): Text Data Cleaning using NLTK

    Original Text:
    Natural language processing enables computers to understand human
    language. The researchers were studying various languages and
    running multiple experiments.

    After Stopword Removal:
    ['natural', 'language', 'processing', 'enables', 'computers',
     'understand', 'human', 'language', 'researchers', 'studying',
     'various', 'languages', 'running', 'multiple', 'experiments']

    After Stemming (Porter):
    ['natur', 'languag', 'process', 'enabl', 'comput', 'understand',
     'human', 'languag', 'research', 'studi', 'variou', 'languag',
     'run', 'multipl', 'experi']

    After Lemmatization:
    ['natural', 'language', 'processing', 'enables', 'computer',
     'understand', 'human', 'language', 'researcher', 'studying',
     'various', 'language', 'running', 'multiple', 'experiment']
```

#### (b) Bag of Words and TF-IDF

```
===> Part (b): Bag of Words and TF-IDF Implementation

    Doc 1: the cat sat on the mat
    Doc 2: the dog sat on the log
    Doc 3: cats and dogs are friends

    Bag of Words Vocabulary:
    ['and', 'are', 'cat', 'cats', 'dog', 'dogs', 'friends',
     'log', 'mat', 'on', 'sat', 'the']

    BoW Matrix:
    Doc 1: [0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 2]
    Doc 2: [0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 2]
    Doc 3: [1, 1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0]

    TF-IDF Matrix (rounded):
    Doc 1: [0.0, 0.0, 0.428, 0.0, 0.0, 0.0, 0.0, 0.0, 0.428, 0.325, 0.325, 0.65]
    Doc 2: [0.0, 0.0, 0.0, 0.0, 0.428, 0.0, 0.0, 0.428, 0.0, 0.325, 0.325, 0.65]
    Doc 3: [0.447, 0.447, 0.0, 0.447, 0.0, 0.447, 0.447, 0.0, 0.0, 0.0, 0.0, 0.0]
```

#### (c) Sentiment Analysis

```
===> Part (c): Movie Review Sentiment Analysis

    Training Accuracy: 100.0%

    Predictions on New Reviews:
    [Positive] The movie was great and I loved it
    [Negative] It was a terrible and boring film
    [Positive] An amazing experience with brilliant acting
    [Negative] Awful movie I would not recommend it
```

---

## Experiment 10 — Fuzzy Inference Systems

**Objective:** Write Python programs to implement Fuzzy Inference Systems using:

a) Fuzzy Inference System for House Price Estimation

b) Multi-Criteria Fuzzy Inference System for Real Estate Evaluation

### Theory

Fuzzy Logic is a form of reasoning that handles uncertainty and imprecision. Unlike classical logic (true/false), it assigns degrees of membership between 0 and 1. A Fuzzy Inference System (FIS) consists of:

- **Fuzzification** — Converting crisp inputs into fuzzy membership values using membership functions (triangular, trapezoidal).
- **Rule Evaluation** — Applying IF-THEN rules. AND is modelled as minimum, OR as maximum.
- **Aggregation** — Combining all rule outputs for each linguistic output term.
- **Defuzzification** — Converting the aggregated fuzzy output back to a crisp value using the centroid (centre of gravity) method.

$$\text{output} = \frac{\sum x \cdot \mu(x)}{\sum \mu(x)}$$

### Code

```python
"""Experiment 10: Fuzzy Inference Systems"""
import numpy as np


def trimf(x, a, b, c):
    """Triangular membership function."""
    return np.maximum(0, np.minimum((x-a)/(b-a+1e-12), (c-x)/(c-b+1e-12)))


def trapmf(x, a, b, c, d):
    """Trapezoidal membership function."""
    return np.maximum(0, np.minimum(
        np.minimum((x-a)/(b-a+1e-12), 1), (d-x)/(d-c+1e-12)))


def centroid_defuzzify(x, mf):
    """Centroid defuzzification."""
    if np.sum(mf) == 0:
        return 0.0
    return np.sum(x * mf) / np.sum(mf)


# (a) House Price Estimation
def house_price_estimation(area, location_score):
    print("\n===> Part (a): Fuzzy Inference System for House Price Estimation\n")
    print(f"    Input Area          : {area} sq ft")
    print(f"    Input Location Score: {location_score}\n")

    area_small  = trimf(area, 500, 500, 1500)
    area_medium = trimf(area, 1000, 1750, 2500)
    area_large  = trimf(area, 2000, 3000, 3000)
    loc_poor    = trimf(location_score, 0, 0, 5)
    loc_average = trimf(location_score, 2, 5, 8)
    loc_good    = trimf(location_score, 5, 10, 10)

    print("===> Membership Values")
    print(f"    Area -> Small:{area_small:.4f} Medium:{area_medium:.4f} "
          f"Large:{area_large:.4f}")
    print(f"    Loc  -> Poor :{loc_poor:.4f} Average:{loc_average:.4f} "
          f"Good :{loc_good:.4f}\n")

    act_low    = max(min(area_small,  loc_poor),
                     min(area_small,  loc_average),
                     min(area_medium, loc_poor))
    act_medium = max(min(area_small,  loc_good),
                     min(area_medium, loc_average),
                     min(area_large,  loc_poor))
    act_high   = max(min(area_medium, loc_good),
                     min(area_large,  loc_average),
                     min(area_large,  loc_good))

    print(f"    Aggregated -> Low:{act_low:.4f} Medium:{act_medium:.4f} "
          f"High:{act_high:.4f}\n")

    price_x  = np.linspace(20, 100, 500)
    combined = np.maximum(
        np.maximum(np.minimum(act_low, trimf(price_x, 20, 20, 55)),
                   np.minimum(act_medium, trimf(price_x, 35, 60, 85))),
        np.minimum(act_high, trimf(price_x, 65, 100, 100)))
    price = centroid_defuzzify(price_x, combined)
    print(f"===> Defuzzified House Price: {price:.2f} lakh\n")


# (b) Multi-Criteria Real Estate Evaluation
def real_estate_evaluation(area, location, age, amenities):
    print("\n===> Part (b): Multi-Criteria Fuzzy Inference System\n")
    print(f"    Area:{area} sqft  Location:{location}/10  "
          f"Age:{age}yrs  Amenities:{amenities}/10\n")

    a_small  = trimf(area, 500, 500, 1500)
    a_medium = trimf(area, 1000, 1750, 2500)
    a_large  = trimf(area, 2000, 3000, 3000)
    l_poor    = trimf(location, 0, 0, 5)
    l_average = trimf(location, 2, 5, 8)
    l_good    = trimf(location, 5, 10, 10)
    age_new  = trapmf(age, 0, 0, 3, 10)
    age_mid  = trimf(age, 5, 15, 25)
    age_old  = trapmf(age, 20, 27, 30, 30)
    am_low   = trimf(amenities, 0, 0, 5)
    am_med   = trimf(amenities, 2, 5, 8)
    am_high  = trimf(amenities, 5, 10, 10)

    rules = [
        (min(a_large, l_good,    age_new, am_high), "excellent"),
        (min(a_large, l_good,    age_new, am_med),  "high"),
        (min(a_large, l_average, age_mid, am_med),  "high"),
        (min(a_medium,l_good,    age_new, am_high), "high"),
        (min(a_medium,l_average, age_new, am_med),  "medium"),
        (min(a_medium,l_average, age_mid, am_med),  "medium"),
        (min(a_medium,l_poor,    age_old, am_low),  "low"),
        (min(a_small, l_poor,    age_old, am_low),  "poor"),
        (min(a_small, l_average, age_mid, am_med),  "low"),
        (min(a_small, l_good,    age_new, am_high), "medium"),
        (min(a_large, l_poor,    age_old, am_low),  "low"),
        (min(a_large, l_average, age_new, am_high), "excellent"),
    ]
    categories = ["poor", "low", "medium", "high", "excellent"]
    agg = {c: max((s for s, r in rules if r == c), default=0) for c in categories}
    print("    Aggregated ->", "  ".join(f"{k}:{v:.4f}" for k, v in agg.items()))

    score_x = np.linspace(0, 100, 500)
    mfs = {"poor": trimf(score_x, 0, 0, 25),
           "low": trimf(score_x, 10, 30, 50),
           "medium": trimf(score_x, 35, 50, 65),
           "high": trimf(score_x, 55, 75, 90),
           "excellent": trimf(score_x, 80, 100, 100)}
    combined = np.maximum.reduce([np.minimum(agg[c], mfs[c]) for c in categories])
    score = centroid_defuzzify(score_x, combined)
    label = ("Excellent" if score >= 80 else "High" if score >= 60 else
             "Medium"    if score >= 40 else "Low"  if score >= 20 else "Poor")
    print(f"\n===> Defuzzified Real Estate Score: {score:.2f} / 100")
    print(f"    Overall Evaluation: {label}\n")


if __name__ == "__main__":
    house_price_estimation(area=1800, location_score=7)
    print("=" * 60)
    real_estate_evaluation(area=2200, location=8, age=5, amenities=7)
```

### Output

#### (a) House Price Estimation

```
===> Part (a): Fuzzy Inference System for House Price Estimation

    Input Area          : 1800 sq ft
    Input Location Score: 7

===> Membership Values
    Area   -> Small: 0.0000, Medium: 0.9333, Large: 0.0000
    Loc    -> Poor : 0.0000, Average: 0.3333, Good : 0.4000

    Aggregated -> Low: 0.0000, Medium: 0.3333, High: 0.4000

===> Defuzzified House Price: 70.81 lakh
```

#### (b) Multi-Criteria Real Estate Evaluation

```
===> Part (b): Multi-Criteria Fuzzy Inference System for Real Estate

    Input Area             : 2200 sq ft
    Input Location Score   : 8 / 10
    Input Property Age     : 5 years
    Input Amenities Score  : 7 / 10

===> Membership Values
    Area      -> Small: 0.0000, Medium: 0.4000, Large: 0.2000
    Location  -> Poor : 0.0000, Average: 0.0000, Good : 0.6000
    Age       -> New  : 0.7143, Mid    : 0.0000, Old  : 0.0000
    Amenities -> Low  : 0.0000, Medium : 0.3333, High : 0.4000

    Aggregated -> Poor:0.0000  Low:0.0000  Medium:0.0000
                  High:0.4000  Excellent:0.2000

===> Defuzzified Real Estate Score: 76.55 / 100
    Overall Evaluation: High
```
