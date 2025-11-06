# ~/.config/fish/functions/fish_prompt.fish
function fish_prompt
    # Save the exit status of the last command
    set -l last_status $status

    # --- First Line: Status (User, Host, Pwd, Git) ---

    # 1. User (yellow)
    set_color $fish_color_user
    printf '%s' (whoami)
    set_color normal
    printf '@'

    # 2. Host (cyan)
    set_color $fish_color_host
    printf '%s' (hostname -s) # -s for short name
    set_color normal
    printf ' '

    # 3. PWD (blue)
    set_color $fish_color_cwd
    printf '%s' (prompt_pwd)
    set_color normal

    # 4. Git Status (green, in parentheses)
    # fish_git_prompt is a built-in helper
    set_color $fish_color_git
    printf '%s' (fish_git_prompt ' (%s)')
    set_color normal

    # --- Move to the next line ---
    # This is the key: print a newline character
    printf '\n'

    # --- Second Line: Prompt Symbol ---

    # Set color based on last command's exit status
    if test $last_status -eq 0
        # Green for success
        set_color green
    else
        # Red for error
        set_color red
    end

    # Print the prompt symbol and a space
    printf '> '

    # Reset color
    set_color normal
end
