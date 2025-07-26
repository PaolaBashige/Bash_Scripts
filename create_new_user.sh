#!/usr/bin/bash


# Let's check for root privileges
if [[ "$(id -u)" -ne 0 ]]
then
	echo "Please run this script as root or with sudo."
	exit 1
fi

# Prompt for the username
read -p "Please enter the username: " user_name

# Let's check if the user already exists
if id "$user_name" &>/dev/null
then
	echo "User '$user_name' already exists."
	exit 1
fi

# Prompt for the first and last name
read -p "Please enter the user's full name: " full_name


# Create the user with optional full name
if [[ -z "$full_name" ]]
then
	useradd -m "$user_name"
else
	useradd -m -c "$full_name" "$user_name"
fi

# Generate a random temporary password
temp_password=$(openssl rand -base64 12)

# Set the password
echo "$user_name:$temp_password" | chpasswd

# Let's force password change on first login
passwd --expire "$user_name"

# Output the account details
echo "The user '$user_name' has been created."
echo "The temporary password: $temp_password"
echo "The user will be required to change the password on first login."
