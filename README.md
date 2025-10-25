I made this [`fish`](https://fishshell.com/) program for personal system configuration backup—and to showcase the shell's ease-of-use, which turned out be something outside a function's scope (Due to its technical limitations)

# Description
*SymP* (**Sym**link **P**opulate) *SymP*ly *Sy*ncs (overwrites) directories by symlinking the whole directories (unlike `cp -r --symbolic-link` that only symlinks the files), while conserving the unique parts of the target (unlike `ln -s`)

This means that if there are 2 directories that have the same name and child files (i.e., the directory is a *pure* subset), they will be symlinked as a whole  
Meaning that any changes to that directory (in either the source or target) after-wards would also appear in the other places  
This is just like doing `ln -s`, but recursively based on the rules above  
In other words, it tries to symlink the files with fewest symlinks as possible

## Additional functionality
- **`--blend`**: Symlinked files inherit the permissions and ownership of their new parent directory
- **`--occurrence`**: Filter files to symlink based on if the file with the same name is also present in the target
- **`--overwrites`**: Change behaviour for performing overwrites

# Demonstration
The commands  
- `ln --symbolic`  
- `cp --recursive --symbolic-link --force --dereference`  
- `symp`  

will be used on the following file-hierarchy (since this program is an balance between the 2 standard utility commands):  
- **Source**: `dir/`  
- **Target**: `link-dir/`  

<details>
<summary>File-hierarchy</summary>

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
</details>

## Results
1. ### `ln --symbolic`
	- **With link-dir**: `ln: Already exists`
	- **Without link-dir**: `🔗 link-dir → dir`
<details>
<summary>2. `cp --recursive --symbolic-link --force --dereference`</summary>

```
📁 link-dir
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
</details>

<details>
<summary>3. SymP</summary>

```
📁 link-dir
├── 🔗 same-dir → dir/same-dir
├── 🔗 udir-d → dir/udir-d			# Directory not present in Target
├── 📁 udir-l
│   └── 📄 subfile
├── 🔗 same-file → dir/same-file
├── 🔗 ufile-d → dir/ufile-d		# File not present in Target
└── 📄 ufile-l
```
</details>

# Installation
`curl -fsSL 'https://raw.githubusercontent.com/Dracape/symp/main/install.fish' | fish`
