<img src="logo.png" alt="drawing" width="200"/>
A simple implementation of `git` using ruby.  Starting code and inspiration from ThoughtBot blog article [Rebuilding Git in Ruby](https://thoughtbot.com/blog/rebuilding-git-in-ruby)

## Supported Commands
- init
- add
- log
- commit
- checkout

## File Structure Overview
- `.grit/index`
  - contains the sha paths for the staged files
- `.grit/HEAD`
  - points to current branch path
- `.grit/refs/heads/BRANCH_NAME`
  - contains last commit sha
- `.grit/objects/COMMIT_SHA[0..2]/COMMIT_SHA[2..-1]`
  - contains commit information
- `.grit/objects/TREE_SHA[0..2]/TREE_SHA[2..-1]` 
  - contains next tree or blob sha
- `.grit/objects/BLOB_SHA[0..2]/BLOB_SHA[2..-1]` 
  - constains Zlib blob of file


 
🗒️ _committed file will have a tree hash for each folder in their path. for example `/lib/grit/object.rb` will be ⏬_
```mermaid
   graph LR;
   root:tree-->lib:tree;
   lib:tree-->grit:tree;
   grit:tree-->object.rb:blob;
```     
 
## Additional Resources
- Python implementation tutorial [link](https://www.leshenko.net/p/ugit/#) 
