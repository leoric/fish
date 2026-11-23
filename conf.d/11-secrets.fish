# API secrets. install.sh COPIES this file (it never symlinks it) to
# ~/.config/fish/conf.d/ and never overwrites an existing copy, so fill in the
# values in the installed file, not in the repo. Keep it chmod 600.
set -gx GEMINI_API_KEY ""
set -gx ANTHROPIC_AUTH_TOKEN ""
set -gx HF_TOKEN ""
