# config.sh

# Base URL to start crawling
BASE_URL="https://apple.ch"

# How deep wget should crawl (1 = homepage only, 2 = homepage + links, etc.)
CRAWL_DEPTH=3

# User agent for wget
USER_AGENT="LinkCheckerBot/1.0"

# Exclude URLs matching pattern (regex or string)
EXCLUDE_PATTERN="logout|wp-login"

# Output folder for reports
OUTPUT_DIR="output"

# Temp file for raw wget output
TEMP_LOG="temp.log"

# Path to files with manual URLs to include in the check
INCLUDE_MANUAL_LINKS=()  # or ("file1.txt" "file2.txt")