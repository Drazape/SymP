- `ln --symbolic`… but it overwrites
- `cp --recursive --symbolic-link`… but it links the whole-directories that are a *pure* subset

I made this [`fish`](https://fishshell.com/) script for personal system configuration backup use, which turned out be something outside a function's scope

# Description
This script smartly overwrites directories by symlinking the whole directories (unlike `cp -r --symbolic-link` that only symlinks the files), while conserving the unique parts of the target (unlike `ln -s`)

This means that if there are 2 directories that have the same name and child files, they will be symlinked as a whole, meaning that any changes to that directory (in either the source or target) after-wards would also appear in the other places  
This is just like doing `ln -s`, but recursively based on the rules above

Additionally, if `--blend` is used, symlinked files inherit the permissions and ownership of their new parent directory

# Demonstration
The commands  
- `ln --symbolic`  
- `cp --recursive --symbolic-link --force --dereference`  
- `smart-symlink`  

will be used on the following file-hierarchy:  
- **Source**: `dir/`  
- **Target**: `link-dir/`  

```
📁 dir					# Source
├── 📁 same-dir
│   ├── 📁a
│   │   ├── 📄 afile-1
│   │   └── 📄 afile-2
│   └── 📁b
│       ├── 📄 bfile-1
│       └── 📄 bfile-2
├── 📁 udir-d
│   └── 📄 subfile
├── 📄 same-file
└── 📄 ufile-d

📁 link-dir				# Target
├── 📁 same-dir
│   ├── 📁 a
│   │   ├── 📄 afile-1
│   │   └── 📄 afile-2
│   └── 📁 b
│       ├── 📄 bfile-1
│       └── 📄 bfile-2
├── 📁 udir-l
│   └── 📄 subfile
├── 📄 same-file
└── 📄 ufile-l
```
## Results
- ### `ln --symbolic`
	* #### With link-dir
	`ln: Already exists`
	* #### Without link-dir
(After removing `link-dir`)
```
📁 dir					# Source
├── 📁 same-dir
│   ├── 📁 a
│   │   ├── 📄 afile-1
│   │   └── 📄 afile-2
│   └── 📁 b
│       ├── 📄 bfile-1
│       └── 📄 bfile-2
├── 📁 udir-d
│   └── 📄 subfile
├── 📄 same-file
└── 📄 ufile-d

🔗 link-dir → dir		# Target
```
- ### `cp --recursive --symbolic-link --dereference`
```
📁 dir						# Source
└── 📁 link-dir
    ├── 📁 same-dir
    │   ├── 📁 a
    │   │   ├── 📄 afile-1
    │   │   └── 📄 afile-2
    │   └── 📁 b
    │       ├── 📄 bfile-1
    │       └── 📄 bfile-2
    ├── 📁 udir-d
    │   └── 📄 subfile
    ├── 📄 same-file
    └── 📄 ufile-d

📁 link-dir					# Target
├── 📁 dir
│   ├── 📁 same-dir
│   │   ├── 📁 a
│   │   │   ├── 📄 afile-1 → dir/same-dir/a/afile-1
│   │   │   └── 📄 afile-2 → dir/same-dir/a/afile-2
│   │   └── 📁 b
│   │       ├── 📄 bfile-1 → dir/same-dir/b/bfile-1
│   │       └── 📄 bfile-2 → dir/same-dir/b/bfile-2
│   ├── 📁 udir-d
│   │   └── 📄 subfile → dir/udir-d/subfile
│   ├── 📄 same-file → dir/same-file
│   └── 📄 ufile-d → dir/ufile-d
├── 📁 same-dir
│   ├── 📁 a
│   │   ├── 📄 afile-1
│   │   └── 📄 afile-2
│   └── 📁 b
│       ├── 📄 bfile-1
│       └── 📄 bfile-2
├── 📁 udir-l
│   └── 📄 subfile
├── 📄 same-file
└── 📄 ufile-l
```
- ### `smart-symlink`
```
📁 dir					# Source
├── 📁 same-dir
│   ├── 📁 a
│   │   ├── 📄 afile-1
│   │   └── 📄 afile-2
│   └── 📁 b
│       ├── 📄 bfile-1
│       └── 📄 bfile-2
├── 📁 udir-d
│   └── 📄 subfile
├── 📄 same-file
└── 📄 ufile-d

📁 link-dir				# Target
├── 🔗 same-dir → dir/same-dir
├── 🔗 udir-d → dir/udir-x
├── 📁 udir-l
│   └── 📄 subfile
├── 🔗 same-file → dir/same-file
├── 🔗 ufile-d → dir/ufile-x
└── 📄 ufile-l
```

# Installation
`fish -c "$(curl -fsSL https://raw.githubusercontent.com/Dracape/smart-symlink/main/install.fish)"`
