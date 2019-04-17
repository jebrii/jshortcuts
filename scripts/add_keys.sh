#! /bin/bash

source "/Users/${USER}/.bash_profile"

config_vars=$(bash "$JSHOR/src/sanitize.sh" "$JSHOR/src/.jshor_config")
eval "$config_vars"

# local variables
error=""
keys=($(eval "ls -1A "$ssh_keys" | grep -v [*\.*]"))

for i in "${keys[@]}"; do
  ssh-add -K "$ssh_keys/$i" 2>/dev/null
  if [ $? -eq 0 ]; then
    echo -e "${CYAN}Added $i to keychain.${NC}"
  else
    echo -e "${RED}Failed to add $i.${NC}" >&2
    cat /dev/null
  fi
done
