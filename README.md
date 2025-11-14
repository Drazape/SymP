# Description
*SymP* (**Sym**link **P**opulate) is a program written in [`fish`](https://fishshell.com/) that *SymP*ly *SymP*link the files with fewest *SymP*links as possible  
[Wiki: Purpose](https://github.com/Dracape/SymP/wiki#purpose "The home-page of the wiki: 'Purpose' section")
## Additional functionality
- [**Resolution**](https://github.com/Dracape/SymP/wiki/Resolution "Wiki: single-Choice switch 'Resolution'"): Configure symlink resolution
    * **Absolute**: Point to the **absolute** path
    * **Relative**: Point to the **relative** path
- [**Overwrites**](https://github.com/Dracape/SymP/wiki/Overwrites "Wiki: single-choice switch 'Overwrites'"): Change behavior for performing overwrites
    * **Force**: Overwrite files without confirmation
    * **Interactive**: Confirm overwrites interactively
    * **Backup**: Create a backup before overwriting
- [**Blend**](https://github.com/Dracape/SymP/wiki/Blend "Wiki: dual-choice switch 'Blend'"): Symlinked files inherit access of their new parent directory
    * **Disable**: `none` `false` `0` `no` (default)
    * **Enable**
        - **Both**: `both` `true` `1` `yes` (default: empty flag)
        - **Individual**
            * **Permission**: DAC permissions
            * **Ownership**: User & Group ownerships
- [**Occurrence**](https://github.com/Dracape/SymP/wiki/Occurrence "Wiki: dual-choice switch 'Blend'"): Filter files based on their appearance in the target
    * **Common**: Present in the target
    * **Unique**: Absent in the target (avoid overwrites)

[Wiki: Switches](https://github.com/Dracape/SymP/wiki/Usage#switches "Wiki: Page Usage#switches")
# Demonstration
The commands  
- `ln --symbolic      --force --no-target-directory`  
- `cp --symbolic-link --force --no-target-directory --recursive`  
- `symp`  

will be used on the following file-hierarchy (since this program is an balance between the 2 standard utility commands):  
- **Source**: `📁 dir`  
- **Target**: `📁 link-dir`  

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
1. `ln -sfT`
	- **With link-dir**: `ln: Already exists`
	- **Without link-dir**: `🔗 link-dir → 📁 dir`

<details>
<summary>2. cp -sfTr</summary>

```
📁 same-dir
├── 📁 a
│   ├── 🔗 afile-1 → 📄 dir/same-dir/a/afile-1
│   └── 🔗 afile-2 → 📄 dir/same-dir/a/afile-2
└── 📁 b
    ├── 🔗 bfile-1 → 📄 dir/same-dir/b/bfile-1
    └── 🔗 bfile-2 → 📄 dir/same-dir/b/bfile-2
🔗 same-file → 📄 dir/same-file
📁 udir-d
└── 🔗 subfile → 📄 dir/udir-d/subfile
📁 udir-l
└── 📄 subfile
🔗 ufile-d → 📄 dir/ufile-d
📄 ufile-l
```
</details>

<details>
<summary>3. symp</summary>

```
📁 link-dir
├── 🔗 same-dir → 📁 dir/same-dir
├── 🔗 same-file → 📄 dir/same-file
├── 🔗 udir-d → 📁 dir/udir-d		# Directory not present in Target
├── 📁 udir-l
│   └── 📄 subfile
├── 🔗 ufile-d → 📄 dir/ufile-d		# File not present in Target
└── 📄 ufile-l
```
</details>

# Installation
`# curl -fsSL 'https://raw.githubusercontent.com/Dracape/symp/main/install.fish' | fish -NP`
