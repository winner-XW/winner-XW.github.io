---
title: Git经典操作场景
date: 2021/11/24
tags: git
categories: GIT
description: 整理了日常用git合代码的经典操作场景，基本覆盖了工作中的需求。
keywords: git
cover: /img/md/git.jpg
---

# 我刚才提交了什么?

> 如果你用 git commit -a 提交了一次变化(changes)，而你又不确定到底这次提交了哪些内容。你就可以用下面的命令显示当前HEAD上的最近一次的提交(commit):

```bash
git show
git log -n1 -p
```

# 我的提交信息(commit message)写错了

> 如果你的提交信息(commit message)写错了且这次提交(commit)还没有推(push), 你可以通过下面的方法来修改提交信息(commit message):

```bash
git commit --amend --only #打开之后点击i键，进入编辑，最后:wq保存即可
git commit --amend --only -m 'xxxxxxx' #直接修改
```

# 我想从一个提交(commit)里移除一个文件

```bash
git checkout HEAD^ myfile
git add -A  
git commit --amend
```

# 我不小心删除了我的分支

> 如果你定期推送到远程, 多数情况下应该是安全的，但有些时候还是可能删除了还没有推到远程的分支。让我们先创建一个分支和一个新的文件:

```bash
git checkout -b my-branch  
git branch  
touch foo.txt  
ls  
README.md foo.txt
```

添加文件并做一次提交
```bash
git add .  
git commit -m 'foo.txt added'  
foo.txt added  
 1 files changed, 1 insertions(+)  
 create mode 100644 foo.txt  
git log  
  
commit 4e3cd85a670ced7cc17a2b5d8d3d809ac88d5012  
Author: siemiatj <siemiatj@example.com>  
Date:   Wed Jul 30 00:34:10 2014 +0200  
  
    foo.txt added  
  
commit 69204cdf0acbab201619d95ad8295928e7f411d5  
Author: Kate Hudson <katehudson@example.com>  
Date:   Tue Jul 29 13:14:46 2014 -0400  
  
    Fixes #6: Force pushing after amending commits
```

现在我们切回到主(main)分支，‘不小心的’删除my-branch分支
```bash
git checkout main  
Switched to branch 'main'  
Your branch is up-to-date with 'origin/main'.  
git branch -D my-branch  
Deleted branch my-branch (was 4e3cd85).  
echo oh noes, deleted my branch!  
oh noes, deleted my branch!
```

在这时候你应该想起了reflog, 一个升级版的日志，它存储了仓库(repo)里面所有动作的历史。
```bash
git reflog  
69204cd HEAD@{0}: checkout: moving from my-branch to main  
4e3cd85 HEAD@{1}: commit: foo.txt added  
69204cd HEAD@{2}: checkout: moving from main to my-branch
```

正如你所见，我们有一个来自删除分支的提交hash(commit hash)，接下来看看是否能恢复删除了的分支。
```bash
$ git checkout -b my-branch-help  
Switched to a new branch 'my-branch-help'  
git reset --hard 4e3cd85  
HEAD is now at 4e3cd85 foo.txt added  
ls  
README.md foo.txt
```

# 我想删除一个分支

删除一个远程分支:
```bash
git push origin --delete my-branch
```
你也可以:
```bash
git push origin :my-branch
```

删除一个本地分支:
```bash
git branch -D my-branch 
```

# 有冲突的情况
首先执行 git status 找出哪些文件有冲突:
```bash
git status  
On branch my-branch  
Changes not staged for commit:  
  (use "git add <file>..." to update what will be committed)  
  (use "git checkout -- <file>..." to discard changes in working directory)  
  
 modified:   README.md
 ```

 在你解决完所有冲突和测试过后, git add 变化了的(changed)文件, 然后用git rebase --continue 继续rebase。
```bash
git add README.md  
git rebase --continue
```
如果在解决完所有的冲突过后，得到了与提交前一样的结果, 可以执行git rebase --skip。