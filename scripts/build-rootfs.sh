
#!/bin/bash
# FreeProMemOS Build Script
# This script is used during the ISO build process

set -e

echo "FreeProMemOS Build System"
echo "========================"

# Create basic directory structure
mkdir -p /rootfs/{boot,etc,home,var,usr,bin,sbin,lib,lib64,proc,sys,tmp,dev}

# Create basic /etc/passwd
cat > /rootfs/etc/passwd << 'EOF'
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
EOF

# Create basic /etc/group
cat > /rootfs/etc/group << 'EOF'
root:x:0:
daemon:x:1:
bin:x:2:
sys:x:3:
EOF

# Create basic /etc/shadow
cat > /rootfs/etc/shadow << 'EOF'
root:*:19110:0:99999:7:::
EOF

# Create basic hostname
echo "freepromemos" > /rootfs/etc/hostname

# Create basic hosts file
cat > /rootfs/etc/hosts << 'EOF'
127.0.0.1   localhost
127.0.1.1   freepromemos
::1         localhost ip6-localhost ip6-loopback
EOF

# Create basic fstab
cat > /rootfs/etc/fstab << 'EOF'
/dev/ram0  /          ext4   defaults         0 0
proc       /proc      proc   defaults         0 0
sysfs      /sys       sysfs  defaults         0 0
devpts     /dev/pts   devpts defaults         0 0
tmpfs      /tmp       tmpfs  defaults         0 0
EOF

# Create basic profile
cat > /rootfs/etc/profile << 'EOF'
# /etc/profile: system-wide .profile file for the Bourne shell (sh(1))
# and Bourne compatible shells (bash(1), ksh(1), ash(1), ...).

if [ "$PS1" ]; then
  if [ "$BASH" ] && [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
  fi
fi

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
EOF

# Create bash.bashrc
cat > /rootfs/etc/bash.bashrc << 'EOF'
# /etc/bash.bashrc: system-wide .bashrc file for bash(1).

if [ -z "$PS1" ]; then
   return
fi

# set a fancy prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
EOF

# Create basic inittab for sysvinit
cat > /rootfs/etc/inittab << 'EOF'
# /etc/inittab: init(8) configuration.
# 
# The default runlevel.
id:3:initdefault:

# Boot-time system configuration/initialization script.
# This is run first except when booting in emergency (-b) mode.
si::sysinit:/etc/init.d/rcS

# What to do in single-user mode.
~:S:wait:/sbin/sulogin

# /etc/init.d executes the S and K scripts upon change
# of runlevel.
l0:0:wait:/etc/init.d/rc 0
l1:1:wait:/etc/init.d/rc 1
l2:2:wait:/etc/init.d/rc 2
l3:3:wait:/etc/init.d/rc 3
l4:4:wait:/etc/init.d/rc 4
l5:5:wait:/etc/init.d/rc 5
l6:6:wait:/etc/init.d/rc 6

# Normally not reached, but fallthrough in case of emergency.
z6:6:respawn:/sbin/sulogin
EOF

# Create basic init.d directory
mkdir -p /rootfs/etc/init.d
cat > /rootfs/etc/init.d/rcS << 'EOF'
#!/bin/sh
# /etc/init.d/rcS: Runlevel Initialisation
set -e

echo "FreeProMemOS System Initialisation"
echo "=================================="

# Mount pseudo-filesystems
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts

# Set hostname
hostname -F /etc/hostname

# Configure network loopback
ip link set lo up
ip addr add 127.0.0.1/8 dev lo

# Clean up
rm -f /etc/mtab*
touch /etc/mtab

# Set permissions
chmod 755 /etc/profile
chmod 755 /etc/bash.bashrc

# Create device nodes
[ -c /dev/null ] || mknod -m 666 /dev/null c 1 3
[ -c /dev/zero ] || mknod -m 666 /dev/zero c 1 5
[ -c /dev/random ] || mknod -m 666 /dev/random c 1 8
[ -c /dev/urandom ] || mknod -m 666 /dev/urandom c 1 9
[ -c /dev/tty ] || mknod -m 666 /dev/tty c 5 0
[ -c /dev/console ] || mknod -m 666 /dev/console c 5 1

echo "System initialisation complete."
echo ""
echo "Welcome to FreeProMemOS!"
echo ""
EOF
chmod +x /rootfs/etc/init.d/rcS

# Create basic /bin/sh symlink to bash
[ -f /rootfs/bin/sh ] || ln -sf bash /rootfs/bin/sh

# Create basic login program stub
cat > /rootfs/sbin/getty << 'EOF'
#!/bin/sh
exec /bin/login
EOF
chmod +x /rootfs/sbin/getty

# Create login program
cat > /rootfs/bin/login << 'EOF'
#!/bin/sh
echo "FreeProMemOS Login"
echo -n "login: "
read username
echo "Password: "
stty -echo
read password
stty echo
echo ""
echo "Welcome, $username!"
exec /bin/bash
EOF
chmod +x /rootfs/bin/login

# Create init script that gets PID 1
cat > /rootfs/sbin/init << 'EOF'
#!/bin/sh
/bin/sh /etc/init.d/rcS

echo ""
echo "FreeProMemOS"
echo "============"
echo ""
echo "Kernel version: $(uname -r)"
echo "System architecture: $(uname -m)"
echo ""
echo "System is ready."
echo ""

# Start a shell
exec /bin/bash -l
EOF
chmod +x /rootfs/sbin/init

# Create basic bash shell
cat > /rootfs/bin/bash << 'EOF'
#!/bin/sh
echo "FreeProMemOS Shell"
echo "Type 'exit' to logout"
while true; do
    echo -n "$USER@$HOSTNAME:$PWD$ "
    read cmd
    if [ "$cmd" = "exit" ]; then
        echo "Goodbye!"
        break
    fi
    eval "$cmd" 2>/dev/null || echo "Command not found: $cmd"
done
EOF
chmod +x /rootfs/bin/bash

echo "Root filesystem created successfully!"
