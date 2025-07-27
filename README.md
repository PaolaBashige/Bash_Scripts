# Bash Script: Create a Linux User with Temporary Password

This script helps Linux administrators **create a new user**, generate a **temporary password**, and **force the user to change the password on first login**. It's a beginner-friendly tool designed to streamline user account creation with clear steps and automation.

## Features

- Prompt for full name and username
- Check if user already exists
- Create the user with full name comment
- Generate a secure temporary password
- Set the password and expire it (forces user to reset it at login)
- Echo the temporary password for admin reference

## Prerequisites

- Linux system with Bash shell
- `openssl` command available
- Run as a user with `sudo` or root privileges

## Beginner-Friendly Breakdown

### What is a Shebang?

```bash
#!/usr/bin/bash
```

The first line is called the **shebang**. It tells your system to use the `bash` shell to execute this script. Without it, your system might not know how to interpret the commands in the file.

### Script Code and Explanation

```bash
#!/usr/bin/bash

# Check for root privileges
if [[ "$(id -u)" -ne 0 ]]
then
    echo "Please run this script as root or with sudo."
    exit 1
fi

# Prompt for the username
read -p "Please enter the new username: " user_name
 
# Check if the username already exists
if id "$user_name" &>/dev/null
then
    echo "User '$user_name' already exists."
    exit 1
fi
 
# Prompt for the full name
read -p "Please enter the full name of the user: " full_name
```

- `id -u` returns a user's ID if they exist.
- `>/dev/null 2>&1` hides output and errors.
- `read -p`: Prompts the user and stores input into a variable.
- `fullname` will be used as a comment, and `user_name` is the system username.

```bash
# Create the user (including optional full name)
if [[ -z "$full_name" ]]
then
    -m "$user_name"
else
    useradd -m -c "$full_name" "$user_name"
fi
```

- `-z` checks if the variable (full_name) is empty.
- **`-m`** creates a home directory for the user when the account is created.
- **`-c`** adds a comment. It can be anything of your choice, like a department name. In our script, it’s the full name.
- `useradd` Creates the user account.

```bash
# Generate a temporary password
temp_password=$(openssl rand -base64 12)
```

- `openssl rand -base64 12` generates a secure random 12-character password.
- Stored in `temp_password`.

```bash
# Set the password
echo "$user_name:$temp_password" | chpasswd
```

- `chpasswd` updates the user's password using the format `username:password`.

```bash
# Expire the password to force change on first login
passwd --expire "$user_name"
```

- This forces the user to set a new password the first time they log in.

```bash
# Output user info
echo "User '$user_name' created successfully!"
echo "Temporary password: $temp_password"
```

- Displays success message and the generated password.

## How to Use

1. **Make the script executable:**
    
    ```bash
    chmod +x create_user.sh
    ```
    
2. **Run the script with sudo:**
    
    ```bash
    sudo ./create_user.sh
    ```
    
3. **Follow the prompts**, and the script will create the user and show you a temporary password.

## Example Output

```bash
$ sudo ./create_user.sh
Enter full name: Alice Johnson
Enter username: alice

User 'alice' created successfully!
Temporary password: J7sd8Gkl1eQs
```

## What's in this Repo?

| File | Description |
| --- | --- |
| `create_user.sh` | Main script that creates users and sets temporary passwords |
| `README.md` | Instructions and explanation of the script |

You can find a more detailed explanation of the script in my blog post [here](https://paolalogs.wordpress.com/2025/07/27/create-a-new-user-in-linux-with-a-temporary-password-using-bash/).
