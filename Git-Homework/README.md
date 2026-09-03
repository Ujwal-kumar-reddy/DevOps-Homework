# Git Homework

## Task 1 — `git commit -a -m` vs `git commit -m`

### `git commit -a -m`

Command used:

```bash
git commit -a -m "Practice git commit -a -m"
```

Output:

```text
[main 9f04620] Practice git commit -a -m
1 file changed, 1 insertion(+)
```

The `-a` option automatically stages modifications to already tracked files before committing.

### `git commit -m`

Commands used:

```bash
git add README.md
git commit -m "Practice git commit -m"
```

Output:

```text
[main 8f71fbc] Practice git commit -m
1 file changed, 1 insertion(+)
```

The `git commit -m` command requires changes to be staged first using `git add`.

### Difference

| Command | Description |
|---|---|
| `git commit -a -m "message"` | Automatically stages modified tracked files and commits them. |
| `git commit -m "message"` | Commits only staged changes, so `git add` is required for new or unstaged changes. |

---

# Task 2 — Git Cherry-Pick

## Commits on Main

Used:

```bash
git log --oneline -5
```

Output:

```text
8f71fbc (HEAD -> main) Practice git commit -m
9f04620 Practice git commit -a -m
8a5d001 Initialize Git homework
6fb5d99 (origin/main, origin/HEAD) Add Networking assignment
b1f3e72 Add Shell Scripting assignment
```

There were multiple commits on the `main` branch before creating the new branch.

## Create a New Branch

Command:

```bash
git checkout -b cherry-pick-demo
```

Output:

```text
Switched to a new branch 'cherry-pick-demo'
```

Verified using:

```bash
git branch
```

Output:

```text
* cherry-pick-demo
  main
```

## Commits Created on New Branch

### First commit

Command:

```bash
git add README.md
git commit -m "Add cherry-pick demo change"
```

Output:

```text
[cherry-pick-demo 7a4dbc6] Add cherry-pick demo change
1 file changed, 1 insertion(+)
```

### Second commit

Command:

```bash
git add README.md
git commit -m "Add second cherry-pick demo change"
```

Output:

```text
[cherry-pick-demo e6d3dad] Add second cherry-pick demo change
1 file changed, 1 insertion(+)
```

Verified using:

```bash
git log --oneline -5
```

Output:

```text
e6d3dad (HEAD -> cherry-pick-demo) Add second cherry-pick demo change
7a4dbc6 Add cherry-pick demo change
8f71fbc (main) Practice git commit -m
9f04620 Practice git commit -a -m
8a5d001 Initialize Git homework
```

## Cherry-Pick a Commit into Main

Switched back to `main`:

```bash
git checkout main
```

The commit selected from the `cherry-pick-demo` branch was:

```text
7a4dbc6 Add cherry-pick demo change
```

Cherry-pick command:

```bash
git cherry-pick 7a4dbc6
```

Output:

```text
[main d00995e] Add cherry-pick demo change
Date: Thu Sep 3 20:55:25 2026 +0000
1 file changed, 1 insertion(+)
```

## Verify Cherry-Pick

Command:

```bash
git log --oneline -6
```

Output:

```text
d00995e (HEAD -> main) Add cherry-pick demo change
8f71fbc Practice git commit -m
9f04620 Practice git commit -a -m
8a5d001 Initialize Git homework
6fb5d99 (origin/main, origin/HEAD) Add Networking assignment
b1f3e72 Add Shell Scripting assignment
```

The change from the `cherry-pick-demo` branch was successfully added to `main`.

Verified using:

```bash
cat README.md
```

Output:

```text
# Git Homework
Task 1: Practicing git commit -a -m
Task 1: git commit -m requires changes to be staged with git add.
This change was created on the cherry-pick-demo branch.
```

Finally:

```bash
git status
```

Output:

```text
On branch main
nothing to commit, working tree clean
```

## Conclusion

I practiced the difference between `git commit -a -m` and `git commit -m`, created a separate branch with multiple commits, identified a commit using `git log`, and successfully cherry-picked one commit from the branch into `main`.
