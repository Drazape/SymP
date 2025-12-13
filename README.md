# Description
*SymP* (**Sym**link **P**opulate) is a program written in [`fish`](https://fishshell.com/ "Official Fish home-page") that *SymP*ly *SymP*links files with fewest *SymP*links as possible  
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
- **Source**: `📁 original`  
- **Target**: `📁 link`  

<details>
<summary>File-hierarchy</summary>

```
📁 original		# Source
├── 📁 common
│	├── 📁 same
│	│	├── 📄 1
│	│	└── 📄 2
│	└── 📁 unique
│		 ├── 📄 same
│		 └── 📄 unique-d
├── 📄 same
├── 📁 uniqued-o
│	└── 📄 sub
└── 📄 uniquef-o

📁 link			# Target
├── 📁 common
│	├── 📁 same
│	│	├── 📄 1
│	│	└── 📄 2
│	└── 📁 unique
│		 ├── 📄 same
│		 └── 📄 unique-l
├── 📄 same
├── 📁 uniqued-l
│	└── 📄 sub
└── 📄 uniquef-l
```
</details>

## Results
1. `ln -sfT`
	- **With 📁 link**: `ln: Already exists`
	- **Without 📁 link**: `🔗 link → 📁 original`

<details>
<summary>2. cp -sfTr</summary>

```
📁 common
├── 📁 same
│	├── 🔗 1 → 📄 original/common/same/1
│	└── 🔗 2 → 📄 original/common/same/2
└── 📁 unique
	├── 🔗 same → 📄 original/common/unique/same
	├── 🔗 unique-d → 📄 original/common/unique/unique-d
	└── 📄 unique-l
🔗 same → 📄 original/same
📁 uniqued-l
└── 📄 sub
📁 uniqued-o
└── 📄 sub → original/uniqued-o/sub
📄 uniquef-l
📄 uniquef-o → original/uniquef-o
```
</details>

<details>
<summary>3. symp</summary>

```
📁 common
├── 🔗 same → 📁 original/common/same
└── 📁 unique
	 ├── 🔗 same → 📄 original/common/unique/same
	 ├── 🔗 unique-d → 📄 original/common/unique/unique-d
	 └── 📄 unique-l
🔗 same → 📄 original/same
📁 uniqued-l
└── 📄 sub
🔗 uniqued-o → 📁 original/uniqued-o		# Directory not present in Target
📄 uniquef-l
🔗 uniquef-o → 📄 original/uniquef-o		# File not present in Target
```
</details>

# Installation
`# curl -fsSL 'https://raw.githubusercontent.com/Dracape/symp/main/install.fish' | fish -NP`
