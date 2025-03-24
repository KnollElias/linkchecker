# Broken Link Checker

Crawls a website and optional manual URL lists to detect broken links.

## Usage

`bash  
./check.sh           # normal run  
./check.sh --dry-run # simulate without crawling or requests  
`

## Config

Edit `config.sh` to set:
- `BASE_URL`, `CRAWL_DEPTH`, `EXCLUDE_PATTERN`
- Optional: `INCLUDE_MANUAL_LINKS=("file.txt")`

## Output

Reports saved in the `output/` folder.
