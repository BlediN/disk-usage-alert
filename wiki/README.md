# Disk Usage Alert Wiki

This directory contains the wiki documentation for the Disk Usage Alert project.

## Wiki Pages

- **[Home](Home.md)** - Overview and introduction to the project
- **[Installation](Installation.md)** - Complete installation guide for Ubuntu servers
- **[Usage](Usage.md)** - How to use the tool effectively
- **[Configuration](Configuration.md)** - All configuration options explained
- **[Troubleshooting](Troubleshooting.md)** - Common issues and solutions
- **[Contributing](Contributing.md)** - Guide for contributors

## Uploading to GitHub Wiki

These markdown files are ready to be uploaded to the GitHub wiki. To populate the GitHub wiki:

### Option 1: Manual Upload

1. Go to the [Wiki tab](https://github.com/BlediN/disk-usage-alert/wiki) on GitHub
2. Create new pages with the same names (without .md extension)
3. Copy the content from each file

### Option 2: Using Git (Clone Wiki)

```bash
# Clone the wiki repository
git clone https://github.com/BlediN/disk-usage-alert.wiki.git

# Copy files
cp wiki/*.md disk-usage-alert.wiki/

# Commit and push
cd disk-usage-alert.wiki
git add .
git commit -m "Add comprehensive wiki documentation"
git push
```

### Option 3: Using the GitHub Web Interface

1. Navigate to the Wiki section of your repository
2. Click "Create the first page" or "New Page"
3. Use the file names as page titles (e.g., "Home", "Installation", etc.)
4. Paste the content from the corresponding .md files

## Structure

```
wiki/
├── README.md           # This file
├── Home.md            # Main landing page
├── Installation.md    # Installation guide
├── Usage.md           # Usage instructions
├── Configuration.md   # Configuration reference
├── Troubleshooting.md # Problem solving guide
└── Contributing.md    # Contribution guidelines
```

## Navigation

The wiki pages are interlinked for easy navigation. Each page contains relevant links to other pages in the following format:

```markdown
[Page Name](Page-Name.md)
```

When uploaded to GitHub Wiki, these links will work automatically.

## Maintenance

To update the wiki:

1. Edit the markdown files in this directory
2. Test locally (can use any markdown viewer)
3. Push changes to the repository
4. Update the GitHub wiki with new content

## Local Preview

You can preview the wiki locally using various markdown viewers:

```bash
# Using grip (GitHub-flavored markdown viewer)
pip install grip
grip wiki/Home.md

# Using markdown-preview-mode in Emacs
# Or any other markdown viewer
```

## Contributing to Wiki

See [Contributing.md](Contributing.md) for guidelines on improving the documentation.
