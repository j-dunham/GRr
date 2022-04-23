# *GRr*
Simple implementation of `git` using ruby.  Starting code and inspiration from ThoughtBot blog article [Rebuilding Git in Ruby](https://thoughtbot.com/blog/rebuilding-git-in-ruby)

A simple implementation of __git__ using ruby.  Inspiration from ThoughtBot blog article [Rebuilding Git in Ruby](https://thoughtbot.com/blog/rebuilding-git-in-ruby)

## ⌨️ Supported Commands
- init
- add
- log
- commit
- checkout

## Files Overview
- `.grr/index`
  - contains the hash locations for staged files
- `.grr/HEAD`
  - points to current branch
- `.grr/refs/heads/BRANCH_NAME`
  - contains hash of commits
- `.grr/objects/COMMIT_HASH[0..2]/COMMIT_HASH[2..-1]`
  - contains commit message and hash for root tree
- `.grr/objects/TREE_HASH[0..2]/TREE_HASH[2..-1]` 
  - contains hash for next tree hash or file blob
 
🗒️ _committed file will have a tree hash for each folder in their path. for example `/lib/grr/object.rb` will be ⏬_
```mermaid
   graph LR;
   root:tree-->lib:tree;
   lib:tree-->grr:tree;
   grr:tree-->object.rb:blob;
```     
 
## 💭 Similar Projects
- Python implementation tutorial [link](https://www.leshenko.net/p/ugit/#) 
